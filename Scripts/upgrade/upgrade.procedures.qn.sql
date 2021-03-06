
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

	IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @TableName AND COLUMN_NAME = 'QestUUID' AND IS_NULLABLE = 'YES')
	BEGIN
		BEGIN TRANSACTION
			-- Drop any existing indexing or default
			DECLARE @IndexName varchar(255)
			SET @IndexName = 'IX_' + @TableName + '_QestUUID'
			EXEC qest_DropIndex @TableName = @TableName, @IndexName = @IndexName
			EXEC qest_DropDefault @TableName = @TableName, @ColumnName = 'QestUUID'
			
			EXEC('UPDATE ' + @TableName + ' SET QestUUID = NEWID() WHERE QestUUID IS NULL') -- set a value for each null
			EXEC('ALTER TABLE ' + @TableName + ' ALTER COLUMN QestUUID uniqueidentifier NOT NULL') -- make non-nullable
			EXEC('ALTER TABLE ' + @TableName + ' ADD  CONSTRAINT DF_' + @TableName + '_QestUUID DEFAULT (newsequentialid()) FOR QestUUID') -- reapply default
			PRINT 'QestUUID made not nullable for ' + @TableName 
		COMMIT
	END
	
	-- Add QestUUID if it is not present
	IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @TableName AND COLUMN_NAME = 'QestUUID')
	BEGIN
		EXEC('ALTER TABLE ' + @TableName + ' ADD QestUUID uniqueidentifier NOT NULL CONSTRAINT DF_' + @TableName + '_QestUUID DEFAULT newsequentialid()')
		PRINT 'QestUUID column added to ' + @TableName 
	END

	-- Set as primary key
	DECLARE @KEYNAME varchar(1000)
	SET @KEYNAME = 'PK_' + @TableName
	EXEC qest_SetPrimaryKey @TableName = @TableName, @KeyName = @KEYNAME, @Columns = 'QestUUID'	
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
	EXEC('ALTER TABLE ' + @TableName + ' DISABLE TRIGGER ALL')
	
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
	EXEC('INSERT INTO qestReverseLookup (QestUUID, QestID, QestUniqueID, QestParentID, QestUniqueParentID, QestOwnerLabNo)
	SELECT ISNULL(D.QestUUID,NEWID()), D.QestID, D.QestUniqueID, NULLIF(D.QestParentID,0), NULLIF(D.QestUniqueParentID,0), D.QestOwnerLabNo FROM ' + @TableName + ' D 
	LEFT JOIN qestReverseLookup RL ON D.QestID = RL.QestID AND D.QestUniqueID = RL.QestUniqueID WHERE RL.QestUUID IS NULL')

	-- Set the QestUUIDs to match ReverseLookups
	EXEC('UPDATE ' + @TableName + ' SET QestUUID = R.QestUUID FROM ' + @TableName + ' D INNER JOIN qestReverseLookup R 
		ON D.QestID = R.QestID AND D.QestUniqueID = R.QestUniqueID WHERE D.QestUUID IS NULL OR NOT D.QestUUID = R.QestUUID')

	-- Mark deleted any ReverseLookups where the source row is missing
	EXEC('DELETE qestReverseLookup FROM qestReverseLookup R LEFT JOIN ' + @TableName + ' D
	ON R.QestUUID = D.QestUUID WHERE D.QestUUID IS NULL AND R.QestID IN (SELECT DISTINCT QestID FROM ' + @TableName + ')')
		
	-- Make QestUUID non-nullable (will fail if anything was not in RL)
	IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @TableName AND COLUMN_NAME = 'QestUUID' AND IS_NULLABLE = 'YES')
	BEGIN
		EXEC('EXEC qest_DropSingleColumnIndexes @TableName = ''' + @TableName + ''', @ColumnName = ''QestUUID''')
		EXEC('ALTER TABLE ' + @TableName + ' ALTER COLUMN QestUUID uniqueidentifier NOT NULL')
	END
		
	-- Set QestUUID Primary Key
	DECLARE @PKNAME varchar(255)
	SET @PKNAME = 'PK_' + @TableName	
	EXEC qest_SetPrimaryKey @TableName = @TableName, @KeyName = @PKNAME, @Columns = 'QestUUID'
	
	-- Add FK to ReverseLookups
	EXEC('IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS WHERE CONSTRAINT_NAME = ''FK_' + @TableName + '_qestReverseLookup'')
		BEGIN ALTER TABLE ' + @TableName + ' ADD CONSTRAINT FK_' + @TableName + '_qestReverseLookup FOREIGN KEY (QestUUID) REFERENCES qestReverseLookup(QestUUID) END')

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
	
	EXEC('ALTER TABLE ' + @TableName + ' ENABLE TRIGGER ALL')
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
	
	EXEC qest_DropReferencingForeignKeys @TableName
	
	-- Add QestID column if it does not exist (as for Record tables) and set the default QestID
	IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @TableName AND COLUMN_NAME = 'QestID')
	BEGIN 	
		DECLARE @QID int
		SELECT @QID = QestID FROM qestObjects WHERE Property = 'TableName' AND [Value] = @TableName
	
		IF (@QID IS NULL) 
		BEGIN 
			RAISERROR ('No QestID could be found for the table.', 16, 0) 
			RETURN
		END	
		
		EXEC('ALTER TABLE ' + @TableName + ' ADD QestID int NULL')
		EXEC('UPDATE ' + @TableName + ' SET QestID = ' + @QID)
	END

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
		
	IF ISNULL(@Repair,0) = 1 OR NOT EXISTS(SELECT 1 FROM sys.foreign_keys K
		INNER JOIN sys.foreign_key_columns KC ON K.object_id = KC.constraint_object_id
		INNER JOIN sys.columns C ON C.object_id = KC.parent_object_id AND C.column_id = KC.parent_column_id
		WHERE K.object_id = OBJECT_ID('FK_' + @TableName + '_qestReverseLookup', 'F') AND C.name = 'QestUUID')
	BEGIN
		PRINT 'Connecting document table to reverse lookups'
		EXEC qest_ConnectDocumentToReverseLookups @TableName
	END
	
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

	EXEC sp_executesql @Trigger
	
	-- Ensure QestUniqueID has a nonclustered index
	IF ISNULL(dbo.qest_IndexExists(@TableName, 'IX_' + @TableName + '_QestUniqueID'),0) = 0
	BEGIN
		EXEC('CREATE NONCLUSTERED INDEX IX_' + @TableName + '_QestUniqueID ON ' + @TableName + ' (QestUniqueID)')
	END

	EXEC('ALTER INDEX ALL ON ' + @TableName + ' REBUILD')
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
		AND NOT name IN ('DocumentGroups', 'DocumentReportingBodyMap', 'UserDocuments') ORDER BY name

	OPEN tableCursor
	FETCH NEXT FROM tableCursor INTO @DocumentTableName
	WHILE @@FETCH_STATUS = 0 BEGIN
		EXEC qest_EnableDocumentForQestnet @DocumentTableName	
		FETCH NEXT FROM tableCursor INTO @DocumentTableName
	END
	CLOSE tableCursor
	DEALLOCATE tableCursor
END
GO

