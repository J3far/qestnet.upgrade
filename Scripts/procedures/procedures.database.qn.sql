	
----------------------------------------------
-- qest_SetDefault procedure
----------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_SetDefault' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
    EXEC('CREATE PROCEDURE dbo.qest_SetDefault AS RETURN 0');
END
GO

alter procedure dbo.qest_SetDefault(@TableName nvarchar(128), @ColumnName nvarchar(128), @DefaultValue nvarchar(128))
as
set nocount on;
declare @existingDefaultName sysname, @existingDefaultValue nvarchar(max), @defaultName sysname, @sql_to_execute nvarchar(max);

select @existingDefaultName = d.name, @existingDefaultValue = d.definition
  from sys.default_constraints d
  inner join sys.columns c on c.object_id = d.parent_object_id and c.column_id = d.parent_column_id
  where parent_object_id = object_id('[dbo].' + QUOTENAME(@tableName), N'U') and c.name = @columnName

set @defaultName = 'DF_' + @tableName + '_' + @columnName;

if @existingDefaultName = @defaultName and @existingDefaultValue = coalesce(@defaultValue, '')
begin
  --nothing to do
  return 0;
end

set @sql_to_execute = '';
if @existingDefaultName is not null
begin
  set @sql_to_execute = @sql_to_execute + 'alter table [dbo].' + quotename(@tableName) + ' drop constraint ' + quotename(@existingDefaultName) + ';' + CHAR(13) + CHAR(10);
end
if @defaultValue is not null
begin
  set @sql_to_execute = @sql_to_execute + 'alter table [dbo].' + quotename(@tableName) + ' add constraint ' + quotename(@defaultName) + ' default ' + @defaultValue + ' for ' + quotename(@columnName) + ';' + CHAR(13) + CHAR(10);
end

if @sql_to_execute <> ''
begin
  exec sp_executesql @sql_to_execute;
end
GO


-------------------------------------------------
-- qest_InsertUpdateColumn function
-------------------------------------------------	
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_InsertUpdateColumn' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
    DROP PROCEDURE [dbo].[qest_InsertUpdateColumn]
END
GO

CREATE PROCEDURE [dbo].[qest_InsertUpdateColumn] 
	@TableName nvarchar(128), 
	@ColumnName nvarchar(128), 
	@TypeName nvarchar(128), 
	@Length int, 
	@IsNullable varchar(3),
	@DefaultValue nvarchar(128)
AS
BEGIN
	DECLARE @COL nvarchar(1000)
	SET @COL = '[' + @ColumnName + '] ' + @TypeName 	
	IF(@TypeName IN ('varbinary', 'varchar', 'binary', 'char', 'nvarchar', 'nchar'))
	BEGIN
		IF(ISNULL(@Length,0) = -1)
		BEGIN
			SET @COL = @COL + '(max)'
		END ELSE BEGIN
			SET @COL = @COL + '(' + CAST(@Length As nvarchar(12)) + ')'
		END
	END
				
	DECLARE @SQL nvarchar(max)	
	IF EXISTS
	(
		SELECT 1 FROM INFORMATION_SCHEMA.TABLES T
		INNER JOIN INFORMATION_SCHEMA.COLUMNS C ON T.TABLE_NAME = C.TABLE_NAME
		WHERE T.TABLE_NAME = @TableName AND C.COLUMN_NAME = @ColumnName
	)
	BEGIN
	
		-- UPDATE
		DECLARE @PrevLength int
		DECLARE @PrevTypeName nvarchar(128)	
		DECLARE @PrevNullable nvarchar(12)	
		
		SELECT @PrevLength = CHARACTER_MAXIMUM_LENGTH, @PrevTypeName = DATA_TYPE,
		@PrevNullable = CASE IS_NULLABLE WHEN 'YES' THEN 'NULL' ELSE 'NOT NULL' END
		FROM INFORMATION_SCHEMA.TABLES T
		INNER JOIN INFORMATION_SCHEMA.COLUMNS C ON T.TABLE_NAME = C.TABLE_NAME
		WHERE T.TABLE_NAME = @TableName AND C.COLUMN_NAME = @ColumnName
		
		-- Only includes length extensions and changes TO nullable
		IF (@TypeName = @PrevTypeName AND (ISNULL(@Length,0) > ISNULL(@PrevLength,0) OR (ISNULL(@Length,0) = -1 AND ISNULL(@Length,0) != ISNULL(@PrevLength,0))))
		BEGIN
			IF(@IsNullable = 'YES')
			BEGIN
				SET @SQL = 'ALTER TABLE [dbo].[' + @TableName + '] ALTER COLUMN ' + @COL + ' NULL'	
			END ELSE BEGIN
				SET @SQL = 'ALTER TABLE [dbo].[' + @TableName + '] ALTER COLUMN ' + @COL + ' ' + @PrevNullable	
			END						
		END

		EXEC(@SQL)
		
		-- Cannot set identity on existing column and counts as no default
		IF (@DefaultValue = 'IDENTITY')
		BEGIN
			EXEC qest_SetDefault @TableName, @ColumnName, NULL
		END ELSE BEGIN
			EXEC qest_SetDefault @TableName, @ColumnName, @DefaultValue
		END
			
	END ELSE BEGIN
		-- INSERT	
		IF(@IsNullable = 'YES')
		BEGIN
			SET @SQL = 'ALTER TABLE [dbo].[' + @TableName + '] ADD ' + @COL + ' NULL'	
		END ELSE BEGIN
			SET @SQL = 'ALTER TABLE [dbo].[' + @TableName + '] ADD ' + @COL + ' NOT NULL'	
		END	
		
		IF (NOT @DefaultValue IS NULL)
		BEGIN
			IF (@DefaultValue = 'IDENTITY')
			BEGIN
				SET @SQL = @SQL + ' IDENTITY(1,1)'
			END ELSE BEGIN		
				SET @SQL = @SQL + ' CONSTRAINT DF_' + @TableName + '_' + @ColumnName + ' DEFAULT ' + @DefaultValue
			END
		END

		-- QestUUID
		-- special case... we want to generate new values using the 'guid.comb' algorithm to avoid index fragmentation
		-- if the table already has a non-nullable qestuniqueid column, we can easily update it in batches using that column.
		-- otherwise we'll do the whole table in a single batch. Note that portion of script replaces the entire alter table statement.
		-- TODO -- if there is a non-null qestcreated date, we could even consider using that as the 'time' component'... probably unneccessary.
		if @columnName = 'QestUUID' and @TypeName = 'uniqueidentifier' and @IsNullable = 'NO'
		begin
			set nocount on;
			set @SQL = 'alter table dbo.' + quotename(@tableName) + ' add QestUUID uniqueidentifier null;'
			EXEC(@SQL)

			-- Determine how to generate UUID
			DECLARE @UUIDGenerator nvarchar(4000)
			SET @UUIDGenerator = CASE WHEN EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @TableName AND COLUMN_NAME = 'QestCreatedDate')
									  AND EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @TableName AND COLUMN_NAME = 'QestUniqueID')
									THEN
										-- To have a natural order, the trailing part of QestUUID is based on qestCreateDate + QestUniqueID*4 in milliseconds.
										-- We add QestUniqueID as many records only have qestCreatedDate to nearest second (and we multiply by 4 as SQL dates are only precise to 1/300 s). 
										N'CASE WHEN QestCreatedDate IS NOT NULL AND QestUniqueID IS NOT NULL 
											THEN CAST(CAST(NEWID() AS BINARY(10)) + CAST(DATEADD(MILLISECOND, QestUniqueID * 4, QestCreatedDate) as BINARY(6)) AS UNIQUEIDENTIFIER)
											ELSE CAST(CAST(NEWID() AS BINARY(10)) + cast(getutcdate() as BINARY(6)) AS UNIQUEIDENTIFIER) END'
									ELSE
										-- No created date, base on current time
										N'CAST(CAST(NEWID() AS BINARY(10)) + cast(getutcdate() as BINARY(6)) AS UNIQUEIDENTIFIER)'
									END

			if exists (select * from information_schema.columns where table_schema = 'dbo' and table_name = @tableName and column_name = 'qestuniqueid' and data_type = 'int' and is_nullable = 'no')
			begin
				--use batches, based on qestuniqueid
				set @SQL = 'declare @min int, @i int, @batchSize int, @max int;
				select @min = min(qestUniqueID), @max = max(qestUniqueID) + 1, @batchSize = 10000 from [dbo].' + quotename(@tableName) + '
				set @i = @min;
				while @i < @max
				begin
					--display progress
					if (@i - @min) % (@batchSize * 100) = 0
					begin
						declare @num int, @total int;
						set @num = @i-@min; set @total = @max-@min;
						raiserror(''%i of %i'', 10, 1, @num, @total) with nowait;
					end
					update [dbo].' + quotename(@tableName) + '
					set QestUUID = ' + @UUIDGenerator + '
					where QestUniqueID >= @i and QestUniqueID < @i + @batchSize
					set @i = @i + @batchSize
				end
				raiserror(''%i of %i'', 10, 1, @max, @max) with nowait;
				alter table dbo.' + quotename(@tableName) + ' alter column QestUUID uniqueidentifier not null;'
			end
			else
			begin
				--no qestuniqueid, we'll go with a single batch instead.
				set @SQL = 'update [dbo].' + quotename(@tableName) + ' set QestUUID = ' + @UUIDGenerator + ';'
			end
			EXEC(@SQL)
			if @DefaultValue is not null
			begin
				set @SQL = 'alter table [dbo].' + quotename(@tableName) + ' add constraint ' + quotename('DF_' + @tableName + '_' + @columnName) + ' default ' + @defaultValue + ' for ' + quotename(@columnName) + ';'
				EXEC(@SQL)
			end
			RETURN
		end

		EXEC(@SQL)
	END
END
GO





-------------------------------------------------
-- INDEX INFO VIEW
-------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.VIEWS WHERE TABLE_NAME = 'qest_IndexInfo') BEGIN
    EXEC('CREATE VIEW [dbo].[qest_IndexInfo] AS SELECT 1 AS TMP')
END
GO

ALTER VIEW [dbo].[qest_IndexInfo]
AS
	SELECT T.[name] AS TableName, I.[name] AS IndexName, I.[type_desc] As IndexType, C.[name] AS ColumnName, IC.[index_column_id] As IndexColID , IC.[key_ordinal] AS Ordinal, IC.[is_included_column] As Included
	FROM sys.tables T 
	INNER JOIN sys.indexes I ON I.[object_id] = T.[object_id] 
	INNER JOIN sys.index_columns IC ON IC.[object_id] = T.[object_id] AND IC.[index_id] = I.[index_id]
	INNER JOIN sys.columns C ON C.[object_id] = T.[object_id] AND C.[column_id] = IC.[column_id]
GO

-------------------------------------------------
-- qest_IndexExists function
-------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_IndexExists' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'FUNCTION')
BEGIN
    EXEC('CREATE FUNCTION dbo.qest_IndexExists() RETURNS bit AS BEGIN RETURN NULL END')
END
GO

ALTER FUNCTION dbo.qest_IndexExists (@TableName nvarchar(255), @IndexName nvarchar(255))
RETURNS bit
AS
BEGIN
	DECLARE @Result bit
    SELECT @Result = 1 FROM sys.tables T INNER JOIN sys.indexes I ON T.[object_id] = I.[object_id] WHERE T.[name] = @TableName AND I.[name] = @IndexName
	RETURN @Result
END
GO

-------------------------------------------------
-- qest_IndexColumnExists function
-------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_IndexColumnExists' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'FUNCTION')
BEGIN
    EXEC('CREATE FUNCTION dbo.qest_IndexColumnExists() RETURNS bit AS BEGIN RETURN NULL END')
END
GO

ALTER FUNCTION dbo.qest_IndexColumnExists (@TableName nvarchar(255), @IndexName nvarchar(255), @ColumnName nvarchar(255), @Ordinal int, @Included bit)
RETURNS bit
AS
BEGIN
	DECLARE @Result bit = 0
    SELECT @Result = 1 FROM [dbo].[qest_IndexInfo] WHERE TableName = @TableName AND IndexName = @IndexName AND ColumnName = @ColumnName AND Ordinal = @Ordinal AND Included = @Included
	RETURN @Result
END
GO

-------------------------------------------------
-- qest_IndexCompare function
-------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_IndexCompare' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'FUNCTION')
BEGIN
    EXEC('CREATE FUNCTION dbo.qest_IndexCompare() RETURNS bit AS BEGIN RETURN NULL END')
END
GO

ALTER FUNCTION dbo.qest_IndexCompare (@TableName nvarchar(255), @IndexName nvarchar(255), @OrdinalList nvarchar(512), @IncludeList nvarchar(512) = NULL)
RETURNS int
BEGIN
	DECLARE @List nvarchar(512)
	DECLARE @Col nvarchar(100)
	DECLARE @Pos int
	DECLARE @Ord int
	DECLARE @Count int
	
	-- Check Ordinal Columns --
	SET @List = @OrdinalList
	SET @List = LTRIM(RTRIM(@List))+ ','
	SET @Pos = CHARINDEX(',', @List, 1)
	SET @Ord = 0

	WHILE @Pos > 0
	BEGIN
		SET @Col = LTRIM(RTRIM(LEFT(@List, @Pos - 1)))
		
		IF @Col <> ''
		BEGIN
			SET @Ord = @Ord + 1
			IF [dbo].[qest_IndexColumnExists](@TableName,@IndexName,@Col,@Ord,0) <> 1
			BEGIN
				RETURN 1 -- Index in database does not match
			END
		END
		
		SET @List = RIGHT(@List, LEN(@List) - @Pos)
		SET @Pos = CHARINDEX(',', @List, 1)
	END

	SELECT @Count = COUNT(*) FROM [dbo].[qest_IndexInfo] WHERE TableName = @TableName AND IndexName = @IndexName AND Included = 0
	IF @Count <> @Ord
	BEGIN
		RETURN 1 -- Index in database has a different number of columns
	END
	
	-- Check Include Columns (if any are given) --
	IF NOT @IncludeList IS NULL
	BEGIN
		
		SET @List = @IncludeList
		SET @List = LTRIM(RTRIM(@List))+ ','
		SET @Pos = CHARINDEX(',', @List, 1)
		SET @Ord = 0

		WHILE @Pos > 0
		BEGIN
			SET @Col = LTRIM(RTRIM(LEFT(@List, @Pos - 1)))
			
			IF @Col <> ''
			BEGIN
				SET @Ord = @Ord + 1
				IF [dbo].[qest_IndexColumnExists](@TableName,@IndexName,@Col,0,1) <> 1
				BEGIN
					RETURN 1 -- Index in database does not match
				END
			END
			
			SET @List = RIGHT(@List, LEN(@List) - @Pos)
			SET @Pos = CHARINDEX(',', @List, 1)
		END

		SELECT @Count = COUNT(*) FROM [dbo].[qest_IndexInfo] WHERE TableName = @TableName AND IndexName = @IndexName AND Included = 1
		IF @Count <> @Ord
		BEGIN
			RETURN 1 -- Index in database has a different number of columns
		END
	
	END
	
	RETURN 0 -- Index in database matches
END
GO


----------------------------------------------
-- qest_DropIndex procedure
----------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_DropIndex' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
    EXEC('CREATE PROCEDURE dbo.qest_DropIndex AS RETURN 0');
END
GO

ALTER PROCEDURE dbo.qest_DropIndex(@TableName nvarchar(255), @IndexName nvarchar(255))
AS
BEGIN
  set nocount on;
  --If the index is associated with a unique constraint, you need to use 'DROP CONSTRAINT' instead of 'DROP INDEX'.
  declare @is_unique_constraint bit, @index_exists bit;

  SELECT @index_exists = 1, @is_unique_constraint = is_unique_constraint
    FROM sys.schemas S
    INNER JOIN sys.tables T ON T.[schema_id] = S.[schema_id]
    INNER JOIN sys.indexes I ON T.[object_id] = I.[object_id]
    WHERE S.name = 'dbo' AND T.[name] = @TableName AND I.[name] = @IndexName

  declare @sql_to_execute nvarchar(max);
  if @is_unique_constraint = 1
  BEGIN
    set @sql_to_execute = 'ALTER TABLE [dbo].' + quotename(@TableName) + ' DROP CONSTRAINT ' + quotename(@IndexName);
    EXEC sp_executesql @sql_to_execute
	END
	else IF [dbo].[qest_IndexExists](@TableName, @IndexName) = 1
	BEGIN
	  set @sql_to_execute = 'DROP INDEX '+ quotename(@IndexName) +' ON [dbo].'+ quotename(@TableName);
		EXEC sp_executesql @sql_to_execute
	END
END
GO

-----------------------------------------------------------------------------------------------------------------------------------------------
-- qest_DropClusteredIndex procedure
-----------------------------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_DropClusteredIndex' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
    EXEC('CREATE PROCEDURE dbo.qest_DropClusteredIndex AS RETURN 0');
END
GO

ALTER PROCEDURE dbo.qest_DropClusteredIndex(@TableName nvarchar(255))
AS
BEGIN

	DECLARE @CLUST_NAME nvarchar(255)
	
	-- Drop any clustered index found on the table
	SELECT @CLUST_NAME = I.[name] FROM sys.tables T INNER JOIN sys.indexes I ON T.[object_id] = I.[object_id] WHERE T.[name] = @TableName AND I.[type_desc] = 'CLUSTERED' AND I.[is_primary_key] = 0
	IF NOT @CLUST_NAME IS NULL
	BEGIN
		EXEC qest_DropIndex @TableName = @TableName, @IndexName = @CLUST_NAME
	END
END
GO

-------------------------------------------------------------------------------------------------------------------------
-- qest_ColumnInPrimaryKey function
-- True when the given column name is in any PRIMARY KEY constraint for the given table
-------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_ColumnInPrimaryKey' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'FUNCTION')
BEGIN
    EXEC('CREATE FUNCTION dbo.qest_ColumnInPrimaryKey() RETURNS bit AS BEGIN RETURN NULL END')
END
GO

ALTER FUNCTION dbo.qest_ColumnInPrimaryKey (@TableName nvarchar(255), @ColumnName nvarchar(255))
RETURNS bit
AS
BEGIN
	DECLARE @Result bit
	
	SELECT @Result = 1 FROM [dbo].[qest_IndexInfo] II
	INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS TC
	ON II.TableName = TC.TABLE_NAME AND II.IndexName = TC.CONSTRAINT_NAME
	WHERE TC.CONSTRAINT_TYPE = 'PRIMARY KEY' AND II.TableName = @TableName AND II.ColumnName = @ColumnName
	RETURN @Result
END
GO


----------------------------------------------
-- qest_SetIndex procedure
----------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_SetIndex' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
    EXEC('CREATE PROCEDURE dbo.qest_SetIndex AS RETURN 0');
END
GO

ALTER PROCEDURE dbo.qest_SetIndex(@TableName nvarchar(255), @IndexName nvarchar(255), @OrdinalColumns nvarchar(512), @IncludeColumns nvarchar(512) = NULL, @IsUnique bit = 0)
AS
BEGIN
	DECLARE @CreateSQL nvarchar(MAX)

	-- Only run this check for QestUniqueID/QestID indexes atm
	IF (@OrdinalColumns IN ('QestID', 'QestUniqueID') AND dbo.qest_ColumnInPrimaryKey(@TableName,@OrdinalColumns) = 1)
	BEGIN
		PRINT 'Index ''' + @IndexName + ''' on table ''' + @TableName + ''' is unecessary due to the existing primary key (ignored).' 
	END
	ELSE
	BEGIN
		SET @CreateSQL = 'CREATE '
		IF ISNULL(@IsUnique, 0) = 1
		BEGIN
			SET @CreateSQL = @CreateSQL + 'UNIQUE ' 
		END
				
		IF NOT @IncludeColumns IS NULL
		BEGIN
			SET @CreateSQL = @CreateSQL + 'NONCLUSTERED INDEX [' + @IndexName + '] ON [' + @TableName + '] ([' + REPLACE(@OrdinalColumns,',','] ASC, [') + '] ASC) INCLUDE ([' + REPLACE(@IncludeColumns,',','], [') + '])'
		END ELSE BEGIN
			SET @CreateSQL = @CreateSQL + 'NONCLUSTERED INDEX [' + @IndexName + '] ON [' + @TableName + '] ([' + REPLACE(@OrdinalColumns,',','] ASC, [') + '] ASC)'
		END

		IF NOT EXISTS(SELECT 1 FROM [dbo].[qest_IndexInfo] WHERE TableName = @TableName AND IndexName = @IndexName)
		BEGIN
			PRINT 'Creating Index ''' + @IndexName + ''' on Table ''' + @TableName + ''''
			EXEC (@CreateSQL) -- Index does not exist, create it
		END ELSE BEGIN
			-- Index exists, check for differences
			IF [dbo].[qest_IndexCompare](@TableName,@IndexName,@OrdinalColumns,@IncludeColumns) <> 0
			BEGIN
				PRINT 'Receating Index ''' + @IndexName + ''' on Table ''' + @TableName + ''''
				EXEC qest_DropIndex @TableName = @TableName, @IndexName = @IndexName -- Drop old index
				EXEC (@CreateSQL) -- Create new version
			END
		END
	END	
END
GO

-----------------------------------------------------------------------------------------------------------------------------------------------
-- qest_SetPrimaryKey procedure
-- Assuming a constraint name clash does not occur the proc will remove any existing PK constraint and create a new one on the given field
-----------------------------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_SetPrimaryKey' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
    EXEC('CREATE PROCEDURE dbo.qest_SetPrimaryKey AS RETURN 0');
END
GO

ALTER PROCEDURE dbo.qest_SetPrimaryKey(@TableName nvarchar(255), @KeyName nvarchar(255), @Columns nvarchar(512))
AS
BEGIN
	DECLARE @CreateSQL nvarchar(MAX)
	DECLARE @OldName nvarchar(255)
	DECLARE @ConstraintType nvarchar(50)
	
	SET @CreateSQL = 'ALTER TABLE ['+ @TableName +'] ADD CONSTRAINT [' + @KeyName + '] PRIMARY KEY CLUSTERED ([' + REPLACE(@Columns,',','] ASC, [') + '] ASC)'			
	
	-- Do nothing if any other constraint is using this name
	SELECT @ConstraintType = CONSTRAINT_TYPE FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = @TableName AND CONSTRAINT_NAME = @KeyName

	-- Primary Key with this name found
	IF @ConstraintType = 'PRIMARY KEY'
	BEGIN
		-- Check index details with the same name
		IF [dbo].[qest_IndexCompare](@TableName,@KeyName,@Columns,NULL) <> 0
		BEGIN
			IF (@Columns IN ('QestID', 'QestUniqueID') AND dbo.qest_ColumnInPrimaryKey(@TableName,@Columns) = 1)
			BEGIN
				PRINT 'Primary Key ''' + @KeyName + ''' on table ''' + @TableName + ''' is unecessary due to the existing primary key (ignored).' 
			END ELSE BEGIN
				-- Drop any other clustered index that may be on the table
				EXEC qest_DropClusteredIndex @TableName = @TableName

				PRINT 'Receating Primary Key ''' + @KeyName + ''' on Table ''' + @TableName + ''''
				EXEC ('ALTER TABLE [' + @TableName +'] DROP CONSTRAINT [' + @KeyName + ']') -- Drop old version
				EXEC(@CreateSQL)
			END
		END	ELSE BEGIN
			PRINT 'Primary Key ''' + @KeyName + ''' already exists on Table ''' + @TableName + ''''
		END
	END 
	
	 -- No constraint with this name found
	ELSE IF @ConstraintType IS NULL
	BEGIN

		-- If a primary key constraint with a different name exists, remove it
		SELECT @OldName = CONSTRAINT_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = @TableName AND CONSTRAINT_TYPE = 'PRIMARY KEY'
		IF NOT @OldName IS NULL
		BEGIN
			PRINT 'Removing previous Primary Key ''' + @OldName + ''' on Table ''' + @TableName + ''''
			EXEC('ALTER TABLE [' + @TableName +'] DROP CONSTRAINT [' + @OldName + ']')		
		END
		
		-- Drop any other clustered index that may be on the table
		EXEC qest_DropClusteredIndex @TableName = @TableName

		-- Add the new primary key
		PRINT 'Creating Primary Key ''' + @KeyName + ''' on Table ''' + @TableName + ''''		
		EXEC(@CreateSQL)
		
	END
	
END
GO


-- Procedure for removing default values
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_DropDefault' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
    DROP PROCEDURE dbo.qest_DropDefault
END
GO

CREATE PROCEDURE [dbo].[qest_DropDefault](@TableName nvarchar(255), @ColumnName nvarchar(255))
AS
BEGIN
	DECLARE @CON nvarchar(255)
	
	SELECT TOP 1 @CON = D.name FROM sys.tables T 
	INNER JOIN sys.columns C ON C.object_id = T.object_id 
	INNER JOIN sys.default_constraints D ON D.parent_object_id = T.object_id AND D.parent_column_id = C.column_id
	WHERE D.[type] = 'D' AND C.name = @ColumnName AND T.name = @TableName

	IF @CON <> ''
	BEGIN
		EXEC('ALTER TABLE ['+ @TableName +'] DROP CONSTRAINT ['+ @CON +']')
	END
END
GO

-- For a given table and column name, returns the index names of any non-clustered index which includes only that column
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_SingleColumnIndexNames' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'FUNCTION')
BEGIN
    DROP FUNCTION dbo.qest_SingleColumnIndexNames
END
GO

CREATE FUNCTION dbo.qest_SingleColumnIndexNames (@TableName nvarchar(255), @ColumnName nvarchar(255))
RETURNS @rtnTable TABLE 
(
    IndexName nvarchar(255) NOT NULL
)
AS
BEGIN
	INSERT INTO @rtnTable 
	SELECT IndexName FROM qest_IndexInfo 
	WHERE TableName = @TableName AND IndexType = 'NONCLUSTERED' GROUP BY IndexName 
	HAVING COUNT(IndexName) = 1 AND MAX(ColumnName) = @ColumnName
	RETURN
END
GO


IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_DropSingleColumnIndexes' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
    DROP PROCEDURE [dbo].[qest_DropSingleColumnIndexes]
END
GO

CREATE PROCEDURE [dbo].[qest_DropSingleColumnIndexes](@TableName nvarchar(255), @ColumnName nvarchar(255))
AS
BEGIN
	DECLARE @IndexName varchar(255)
	DECLARE indexCursor CURSOR LOCAL for
		SELECT IndexName FROM dbo.qest_SingleColumnIndexNames(@TableName, @ColumnName)

	OPEN indexCursor

	FETCH NEXT FROM indexCursor INTO @IndexName
	WHILE @@FETCH_STATUS = 0 BEGIN

		PRINT 'Dropping index: ''' + @IndexName + ''''
		EXEC qest_DropIndex @TableName = @TableName, @IndexName = @IndexName
		
		FETCH NEXT FROM indexCursor INTO @IndexName
	END

	CLOSE indexCursor
	DEALLOCATE indexCursor
END
GO


-- Drop all foreign keys referencing the given table
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_DropReferencingForeignKeys' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
    DROP PROCEDURE [dbo].[qest_DropReferencingForeignKeys]
END
GO

CREATE PROCEDURE [dbo].[qest_DropReferencingForeignKeys] (@TableName nvarchar(255))
AS
BEGIN
	DECLARE @SQL nvarchar(MAX) = ''
	
	SELECT @SQL = @SQL + 'ALTER TABLE ' + T.name + ' DROP CONSTRAINT ' + RTRIM(F.name) +';' + CHAR(13)
	FROM sys.foreign_keys F
	INNER JOIN sys.tables T ON F.parent_object_id = T.object_id
	INNER JOIN sys.tables RT ON F.referenced_object_id = RT.object_id
	WHERE RT.name = @TableName
	
	IF (LEN(@SQL) > 0)
	BEGIN 
		EXEC sp_executesql @SQL 
		PRINT 'Dropped all foreign key constraints which reference: ' + @TableName
	END
END
GO
