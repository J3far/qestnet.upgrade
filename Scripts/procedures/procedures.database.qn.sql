	
----------------------------------------------
-- qest_SetDefault procedure
----------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_SetDefault' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
    EXEC('CREATE PROCEDURE dbo.qest_SetDefault AS RETURN 0');
END
GO

ALTER PROCEDURE dbo.qest_SetDefault(@TableName nvarchar(128), @ColumnName nvarchar(128), @DefaultValue nvarchar(128))
AS
BEGIN
	DECLARE @DefaultName nvarchar(300)
	SET @DefaultName = 'DF_' + @TableName + '_' + @ColumnName
	
	-- Remove existing
	IF EXISTS(SELECT 1 FROM sys.default_constraints WHERE Name = @DefaultName)	
	BEGIN 
		EXEC('ALTER TABLE [' + @TableName + '] DROP CONSTRAINT [' + @DefaultName +']')
	END 
	
	-- Add if non-null value
	IF (NOT @DefaultValue IS NULL)
	BEGIN
		EXEC('ALTER TABLE [' + @TableName + '] ADD CONSTRAINT [' + @DefaultName + '] DEFAULT ' + @DefaultValue + ' FOR [' + @ColumnName + ']')
	END	
END
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
		SET @COL = @COL + '(' + CAST(@Length As nvarchar(12)) + ')'
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
		SELECT @PrevLength = CHARACTER_MAXIMUM_LENGTH, @PrevTypeName = DATA_TYPE
		FROM INFORMATION_SCHEMA.TABLES T
		INNER JOIN INFORMATION_SCHEMA.COLUMNS C ON T.TABLE_NAME = C.TABLE_NAME
		WHERE T.TABLE_NAME = @TableName AND C.COLUMN_NAME = @ColumnName

		-- Only includes length extensions and changes TO nullable
		IF (@TypeName = @PrevTypeName AND ISNULL(@Length,0) > ISNULL(@PrevLength,0))
		BEGIN
			IF(@IsNullable = 'YES')
			BEGIN
				SET @SQL = 'ALTER TABLE [dbo].[' + @TableName + '] ALTER COLUMN ' + @COL + ' NULL'	
			END ELSE BEGIN
				SET @SQL = 'ALTER TABLE [dbo].[' + @TableName + '] ALTER COLUMN ' + @COL	
			END						
		END
			
		EXEC(@SQL)
		EXEC qest_SetDefault @TableName, @ColumnName, @DefaultValue
			
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
			SET @SQL = @SQL + ' CONSTRAINT DF_' + @TableName + '_' + @ColumnName + ' DEFAULT ' + @DefaultValue
		END

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
	IF [dbo].[qest_IndexExists](@TableName, @IndexName) = 1
	BEGIN
		EXEC('DROP INDEX ['+ @IndexName +'] ON ['+ @TableName +']')
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

ALTER PROCEDURE dbo.qest_SetIndex(@TableName nvarchar(255), @IndexName nvarchar(255), @OrdinalColumns nvarchar(512), @IncludeColumns nvarchar(512) = NULL)
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
		IF NOT @IncludeColumns IS NULL
		BEGIN
			SET @CreateSQL = 'CREATE NONCLUSTERED INDEX [' + @IndexName + '] ON [' + @TableName + '] ([' + REPLACE(@OrdinalColumns,',','] ASC, [') + '] ASC) INCLUDE ([' + REPLACE(@IncludeColumns,',','], [') + '])'
		END ELSE BEGIN
			SET @CreateSQL = 'CREATE NONCLUSTERED INDEX [' + @IndexName + '] ON [' + @TableName + '] ([' + REPLACE(@OrdinalColumns,',','] ASC, [') + '] ASC)'
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
