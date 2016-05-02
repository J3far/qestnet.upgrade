
-- Fix this at some point...
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_SetIntegerColumnNullable' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
    DROP PROCEDURE [dbo].[qest_SetIntegerColumnNullable]
END
GO

CREATE PROCEDURE [dbo].[qest_SetIntegerColumnNullable](@TableName nvarchar(255), @ColumnName nvarchar(255), @Nullable bit)
AS
BEGIN
	DECLARE @NAME varchar(255)
	DECLARE @SETTO varchar(10)
	
	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE object_id = object_id(@TableName) AND name = @ColumnName AND is_nullable = @Nullable)
	BEGIN
		SET @SETTO = CASE @Nullable WHEN 1 THEN 'NULL' ELSE 'NOT NULL' END
		SET @NAME = 'IX_' + @TableName + '_' + @ColumnName
				
		EXEC qest_DropDefault @TableName = @TableName, @ColumnName = @ColumnName -- Remove any default value which may prevent column alter - FIXME: replace this?	

		IF EXISTS(SELECT 1 FROM dbo.qest_SingleColumnIndexNames(@TableName, @ColumnName))
		BEGIN
			EXEC qest_DropSingleColumnIndexes @TableName = @TableName, @ColumnName = @ColumnName -- Remove all single column indexes
			EXEC('ALTER TABLE ' + @TableName + ' ALTER COLUMN ' + @ColumnName + ' int ' + @SETTO)
			EXEC qest_SetIndex @TableName = @TableName, @IndexName = @NAME, @OrdinalColumns = @ColumnName -- Replace with single default index
		END ELSE BEGIN
			EXEC('ALTER TABLE ' + @TableName + ' ALTER COLUMN ' + @ColumnName + ' int ' + @SETTO)
		END
	END
END
GO

-- Procedure for ensuring keys for documents
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_GenerateQestUUID' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
    DROP PROCEDURE [dbo].[qest_GenerateQestUUID]
END
GO

CREATE PROCEDURE [dbo].[qest_GenerateQestUUID](@TableName nvarchar(255))
AS
BEGIN
	BEGIN TRANSACTION
	BEGIN TRY

	-- Add QestUUID if it is not present -- we initially add it as a nullable column so that we can do batch-updates
	-- to set the 'default' value.
	IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @TableName AND COLUMN_NAME = 'QestUUID')
	BEGIN
		EXEC('ALTER TABLE ' + @TableName + ' ADD QestUUID uniqueidentifier NULL;');
	END

	IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @TableName AND COLUMN_NAME = 'QestUUID' AND IS_NULLABLE = 'YES')
	BEGIN
		-- Drop any existing indexing or default
	  DECLARE @IndexName varchar(255)
	  SET @IndexName = 'IX_' + @TableName + '_QestUUID'
	  EXEC qest_DropIndex @TableName = @TableName, @IndexName = @IndexName
		EXEC qest_DropDefault @TableName = @TableName, @ColumnName = 'QestUUID'

		--if there is a qestuniqueid column, use that to run a batch process to set the QestUUID column
		if exists (select 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @TableName AND COLUMN_NAME = 'QestUniqueID')
		BEGIN
		  declare @sql_to_execute nvarchar(max);
		  set @sql_to_execute = 'declare @i int, @max int;
		  select @i = min(qestUniqueID), @max = max(qestUniqueID) + 1 from [dbo].' + quotename(@tableName) + '
		  while @i<@max
		  begin
		    update [dbo].' + quotename(@tableName) + '
		    set QestUUID = CAST(CAST(NEWID() AS BINARY(10)) + cast(getutcdate() as BINARY(6)) AS UNIQUEIDENTIFIER)
		    where QestUUID IS NULL and qestUniqueID >= @i and qestUniqueID < @i + @batchSize;
		    set @i = @i + @batchSize
		  end'
		  exec sp_executesql @sql_to_execute, N'@batchSize int', 10000
		END
		ELSE
		BEGIN
		  --otherwise just update the whole lot in one batch
		  EXEC('update ' + @TableName + ' set QestUUID = CAST(CAST(NEWID() AS BINARY(10)) + cast(getutcdate() as BINARY(6)) AS UNIQUEIDENTIFIER) where QestUUID IS NULL');
		END

		EXEC('ALTER TABLE ' + @TableName + ' ALTER COLUMN QestUUID uniqueidentifier NOT NULL') -- make non-nullable
		EXEC('ALTER TABLE ' + @TableName + ' ADD  CONSTRAINT DF_' + @TableName + '_QestUUID DEFAULT (CAST(CAST(NEWID() AS BINARY(10)) + cast(getutcdate() as BINARY(6)) AS UNIQUEIDENTIFIER)) FOR QestUUID')
		PRINT 'QestUUID made not nullable for ' + @TableName
	END

	-- Set as primary key
	DECLARE @KEYNAME varchar(1000)
	SET @KEYNAME = 'PK_' + @TableName
	EXEC qest_SetPrimaryKey @TableName = @TableName, @KeyName = @KEYNAME, @Columns = 'QestUUID'	

	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		declare @ERR_LINE int, @ERR_MESSAGE nvarchar(max), @ERR_NUMBER int,@ERR_SEVERITY int,@ERR_STATE int;
		select @ERR_LINE = ERROR_LINE(), @ERR_MESSAGE = ERROR_MESSAGE(), @ERR_NUMBER = ERROR_NUMBER(), @ERR_SEVERITY = ERROR_SEVERITY(), @ERR_STATE = ERROR_STATE();
		rollback transaction;
		raiserror('qest_GenerateQestUUID [%s] - Failed - transaction rolled back.
  Error number:  %d
  Error message: %s
  Error line:    %d', @ERR_SEVERITY, @ERR_STATE, @TableName, @ERR_NUMBER, @ERR_MESSAGE, @ERR_LINE);
	END CATCH
END
GO


-- Procedure for ensuring keys for documents
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_ConnectDocumentToReverseLookups' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
    DROP PROCEDURE [dbo].[qest_ConnectDocumentToReverseLookups]
END
GO

CREATE PROCEDURE [dbo].[qest_ConnectDocumentToReverseLookups](@TableName nvarchar(255))
AS
BEGIN
	-- Add QestUUID if it is not present
	IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @TableName AND COLUMN_NAME = 'QestUUID')
	BEGIN
		EXEC('ALTER TABLE ' + @TableName + ' ADD QestUUID uniqueidentifier NULL')
	END ELSE BEGIN
		EXEC qest_DropDefault @TableName = @TableName, @ColumnName = 'QestUUID'	
	END
	
	-- Repair any unset QestID/QestUniqueID where UUID match already exists
	EXEC('UPDATE RL SET QestID = D.QestID, QestUniqueID = D.QestUniqueID
	FROM ' + @TableName + ' D INNER JOIN qestReverseLookup RL ON D.QestUUID = RL.QestUUID 
	WHERE RL.QestID = 0 OR RL.QestUniqueID = 0')
	
	-- Create ReverseLookups where any are missing - use the documents QestUUID if it has one, else create one
	-- To have a natural order, the trailing part of QestUUID is based on qestCreateDate + QestUniqueID*4 in milliseconds.
	-- We add QestUniqueID as many records only have qestCreatedDate to nearest second (and we multiply by 4 as SQL dates are only precise to 1/300 s). 
	declare @sql_to_execute nvarchar(max);
	set @sql_to_execute = 'declare @i int, @max int;
	  select @i = min(QestUniqueID), @max = max(QestUniqueID) + 1 from [dbo].' + quotename(@tableName) + ';
	  while @i < @max
	  begin
	    insert into qestReverseLookup (QestUUID, QestID, QestUniqueID, QestParentID, QestUniqueParentID, QestOwnerLabNo)
	    select  ISNULL(D.QestUUID,CAST(CAST(NEWID() AS BINARY(10)) + CAST(DATEADD(MILLISECOND, D.QestUniqueID * 4, D.QestCreatedDate) as BINARY(6)) AS UNIQUEIDENTIFIER)), D.QestID, D.QestUniqueID, NULLIF(D.QestParentID,0), NULLIF(D.QestUniqueParentID,0), D.QestOwnerLabNo
	    from [dbo].' + quotename(@tableName) + ' D
	    where D.qestUniqueID >= @i and D.qestUniqueID < @i + @batchSize
	      and not exists (select * from [dbo].[qestReverseLookup] RL where D.QestID = RL.QestID AND D.QestUniqueID = RL.QestUniqueID)
	    set @i = @i + @batchSize
	  end'
	PRINT 'Batch-updating QestUUID'  
	exec sp_executesql @sql_to_execute, N'@batchSize int', 10000;
  
  print 'Updating Document QestUUIDs...'
	-- Set the QestUUIDs to match ReverseLookups
	EXEC('UPDATE ' + @TableName + ' SET QestUUID = R.QestUUID FROM ' + @TableName + ' D INNER JOIN qestReverseLookup R 
		ON D.QestID = R.QestID AND D.QestUniqueID = R.QestUniqueID WHERE D.QestUUID IS NULL OR NOT D.QestUUID = R.QestUUID')
		
  print ' Make QestUUID non-nullable (will fail if anything was not in RL)'
	-- Make QestUUID non-nullable (will fail if anything was not in RL)
	IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @TableName AND COLUMN_NAME = 'QestUUID' AND IS_NULLABLE = 'YES')
	BEGIN
		EXEC('EXEC qest_DropSingleColumnIndexes @TableName = ''' + @TableName + ''', @ColumnName = ''QestUUID''')
		EXEC('ALTER TABLE ' + @TableName + ' ALTER COLUMN QestUUID uniqueidentifier NOT NULL')
	END
	
	-- Set QestUUID Primary Key
	PRINT 'Setting QestUUID as primary key'
	DECLARE @PKNAME varchar(255)
	SET @PKNAME = 'PK_' + @TableName	
	EXEC qest_SetPrimaryKey @TableName = @TableName, @KeyName = @PKNAME, @Columns = 'QestUUID'
  
  PRINT 'Updating QestReverseLookup columns...'
	-- Set qestReverseLookup.QestOwnerLabNo
	EXEC('UPDATE R SET QestOwnerLabNo = D.QestOwnerLabNo FROM qestReverseLookup R INNER JOIN ' + @TableName + ' D 
	ON D.QestUUID = R.QestUUID WHERE D.QestOwnerLabNo <> R.QestOwnerLabNo')
	
	-- Set qestReverseLookup.QestStatusFlags
	EXEC('UPDATE R SET QestStatusFlags = D.QestStatusFlags FROM qestReverseLookup R INNER JOIN ' + @TableName + ' D 
	ON D.QestUUID = R.QestUUID WHERE R.QestStatusFlags IS NULL')

	-- Set qestReverseLookup.QestCreatedBy
	EXEC('UPDATE R SET QestCreatedBy = D.QestCreatedBy FROM qestReverseLookup R INNER JOIN ' + @TableName + ' D 
	ON D.QestUUID = R.QestUUID WHERE R.QestCreatedBy IS NULL')
	
	-- Set qestReverseLookup.QestCreatedDate
	EXEC('UPDATE R SET QestCreatedDate = D.QestCreatedDate FROM qestReverseLookup R INNER JOIN ' + @TableName + ' D 
	ON D.QestUUID = R.QestUUID WHERE R.QestCreatedDate IS NULL')
	
	-- Set qestReverseLookup.QestModifiedBy
	EXEC('UPDATE R SET QestModifiedBy = D.QestModifiedBy FROM qestReverseLookup R INNER JOIN ' + @TableName + ' D 
	ON D.QestUUID = R.QestUUID WHERE R.QestModifiedBy IS NULL')

	-- Set qestReverseLookup.QestModifiedDate
	EXEC('UPDATE R SET QestModifiedDate = D.QestModifiedDate FROM qestReverseLookup R INNER JOIN ' + @TableName + ' D 
	ON D.QestUUID = R.QestUUID WHERE R.QestModifiedDate IS NULL')	
	
	-- Delete any ReverseLookups where the source row is now missing
	EXEC('DELETE qestReverseLookup FROM qestReverseLookup R LEFT JOIN ' + @TableName + ' D
	ON R.QestUUID = D.QestUUID WHERE D.QestUUID IS NULL AND R.QestID IN (SELECT DISTINCT QestID FROM ' + @TableName + ')')

	-- Enable Triggers
	EXEC('ALTER TABLE ' + @TableName + ' ENABLE TRIGGER ALL')

	-- Rebuild indexes
	EXEC('ALTER INDEX ALL ON ' + @TableName + ' REBUILD')
END
GO


-- Procedure for ensuring keys for activities
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_EnableActivityForQestnet' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
    DROP PROCEDURE [dbo].[qest_EnableActivityForQestnet]
END
GO

CREATE PROCEDURE [dbo].[qest_EnableActivityForQestnet](@TableName nvarchar(255))
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = @TableName)
	BEGIN
		PRINT 'Cannot perform QestUUID upgrade for table ''' + @TableName + ''' as it does not exist.'
		RETURN
	END

	EXEC qest_GenerateQestUUID @TableName
	
	EXEC qest_SetIntegerColumnNullable @TableName = @TableName, @ColumnName = 'QestID', @Nullable = 0
	EXEC qest_SetIntegerColumnNullable @TableName = @TableName, @ColumnName = 'QestOwnerLabNo', @Nullable = 0

	EXEC('ALTER INDEX ALL ON ' + @TableName + ' REBUILD')
END
GO


IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_EnableDocumentForQestnet' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
    DROP PROCEDURE [dbo].[qest_EnableDocumentForQestnet]
END
GO

CREATE PROCEDURE [dbo].[qest_EnableDocumentForQestnet](@TableName nvarchar(255))
AS
BEGIN	
	IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = @TableName)
	BEGIN
		PRINT 'Cannot perform QestUUID upgrade for table ''' + @TableName + ''' as it does not exist.'
		RETURN
	END
	
	PRINT 'Executing qest_EnableDocumentForQestnet for table: ' + @TableName

	-- Get repair option
	DECLARE @Repair bit	
	SELECT @Repair = [Value] FROM qestSystemValues WHERE Name = 'QestnetUpgradeOption_Repair'
	
	BEGIN TRANSACTION
	BEGIN TRY
	
		EXEC qest_DropReferencingForeignKeys @TableName
		
		-- Add QestID column if it does not exist (as for Record tables) and set the default QestID
		IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @TableName AND COLUMN_NAME = 'QestID')
		BEGIN 	
			DECLARE @QID int
			SELECT @QID = QestID FROM qestObjects WHERE Property = 'TableName' AND [Value] = @TableName
		
			IF (@QID IS NULL) 
			BEGIN 
				RAISERROR ('Table upgrade failed: No QestID could be found for the table in qestObjects.', 16, 0) 
				RETURN
			END	
			
			EXEC('ALTER TABLE ' + @TableName + ' ADD QestID int NULL')
			EXEC('UPDATE ' + @TableName + ' SET QestID = ' + @QID)
		END
		
		-- Validate that QestID is all values greater than zero
		EXEC('IF EXISTS(SELECT 1 FROM ' + @TableName + ' WHERE QestID <= 0) 
			BEGIN 
				RAISERROR (''Table upgrade failed: table contains QestIDs with values less than or equal to zero.'', 16, 0) 
				RETURN
			END	
		')

		EXEC qest_SetIntegerColumnNullable @TableName = @TableName, @ColumnName = 'QestID', @Nullable = 0
		EXEC qest_SetIntegerColumnNullable @TableName = @TableName, @ColumnName = 'QestOwnerLabNo', @Nullable = 0
		
		IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @TableName AND COLUMN_NAME = 'QestSpecification')
		BEGIN
			EXEC('ALTER TABLE ' + @TableName + ' ADD QestSpecification [nvarchar](50) NULL')
		END
		
		IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @TableName AND COLUMN_NAME = 'QestStatusFlags')
		BEGIN
			EXEC('ALTER TABLE ' + @TableName + ' ADD QestStatusFlags int NULL')
		END
		
		---- Remove FK to ReverseLookups if it exists
		EXEC('IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS WHERE CONSTRAINT_NAME = ''FK_' + @TableName + '_qestReverseLookup'')
			BEGIN ALTER TABLE ' + @TableName + ' DROP CONSTRAINT FK_' + @TableName + '_qestReverseLookup END')
			
		-- Use the presence of the trigger to delineate what has been converted so far (for performance reasons)
		IF (ISNULL(@Repair,0) = 1 OR OBJECT_ID('TR_' + @TableName + '_Insert_UniqueIDs', 'TR') IS NULL)
		BEGIN
			PRINT 'Connecting document table to reverse lookups'
			EXEC qest_ConnectDocumentToReverseLookups @TableName

			-- Create/update the trigger to maintain unique ids
			DECLARE @Trigger nvarchar(MAX)
			SET @Trigger = CASE WHEN OBJECT_ID('TR_' + @TableName + '_Insert_UniqueIDs', 'TR') IS NULL THEN 'CREATE' ELSE 'ALTER' END
			+ ' TRIGGER TR_' + @TableName + '_Insert_UniqueIDs
			ON ' + @TableName + ' AFTER INSERT
			AS
				-- Set QestUniqueID in qestReverseLookup from document
				UPDATE RL SET QestUniqueID = I.QestUniqueID
				FROM qestReverseLookup RL 
				INNER JOIN inserted I ON I.QestUUID = RL.QestUUID

				-- Set QestUniqueParentID in qestReverseLookup from parent qestReverseLookup
				UPDATE RL SET QestUniqueParentID = P.QestUniqueID, QestParentID = P.QestID
				FROM qestReverseLookup RL 
				INNER JOIN qestReverseLookup P ON P.QestUUID = RL.QestParentUUID
				INNER JOIN inserted I ON I.QestUUID = RL.QestUUID
				
				-- Set QestUniqueParentID in document from qestReverseLookup
				UPDATE D SET QestUniqueParentID = RL.QestUniqueParentID, QestParentID = RL.QestParentID
				FROM qestReverseLookup RL 
				INNER JOIN inserted I ON I.QestUUID = RL.QestUUID 
				INNER JOIN ' + @TableName + ' D ON D.QestUUID = RL.QestUUID'
			
			PRINT 'Creating Trigger: TR_' + @TableName + '_Insert_UniqueIDs'
			EXEC sp_executesql @Trigger
		END
					
		-- Ensure QestUniqueID has a nonclustered index
		IF ISNULL(dbo.qest_IndexExists(@TableName, 'IX_' + @TableName + '_QestUniqueID'),0) = 0
		BEGIN
			EXEC('CREATE NONCLUSTERED INDEX IX_' + @TableName + '_QestUniqueID ON ' + @TableName + ' (QestUniqueID)')
		END

		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		DECLARE @ErrorSeverity int, @ErrorState int, @ErrorMessage as nvarchar(max)
		SELECT @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorMessage = ERROR_MESSAGE();
		IF (@@TRANCOUNT > 0)
			ROLLBACK TRANSACTION
		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
	END CATCH
END
GO


IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_EnableDocumentForQestnet_TableNameLike' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
    DROP PROCEDURE [dbo].[qest_EnableDocumentForQestnet_TableNameLike]
END
GO

CREATE PROCEDURE [dbo].[qest_EnableDocumentForQestnet_TableNameLike](@TableLike nvarchar(255))
AS
BEGIN
	DECLARE @DocumentTableName varchar(255)
	DECLARE tableCursor CURSOR LOCAL for
		SELECT name FROM sys.tables WHERE type_desc = 'USER_TABLE' AND name LIKE @TableLike 
		AND NOT name IN ('DocumentGroups', 'DocumentReportingBodyMap', 'UserDocuments', 'DocumentConcreteDockets') ORDER BY name
  
	OPEN tableCursor
	FETCH NEXT FROM tableCursor INTO @DocumentTableName
	BEGIN TRY
		WHILE @@FETCH_STATUS = 0 BEGIN
			EXEC qest_EnableDocumentForQestnet @DocumentTableName	
			FETCH NEXT FROM tableCursor INTO @DocumentTableName
		END
		CLOSE tableCursor
		DEALLOCATE tableCursor
	END TRY
	BEGIN CATCH
    declare @ERR_LINE int, @ERR_MESSAGE nvarchar(max), @ERR_NUMBER int,@ERR_SEVERITY int,@ERR_STATE int;
    select @ERR_LINE = ERROR_LINE(), @ERR_MESSAGE = ERROR_MESSAGE(), @ERR_NUMBER = ERROR_NUMBER(), @ERR_SEVERITY = ERROR_SEVERITY(), @ERR_STATE = ERROR_STATE();
		CLOSE tableCursor
		DEALLOCATE tableCursor
    raiserror('%s', @ERR_SEVERITY, @ERR_STATE, @ERR_MESSAGE);
	END CATCH
END
GO
