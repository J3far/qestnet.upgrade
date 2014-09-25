
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'qestReverseLookup')
BEGIN

	-- MAKE THIS A REPAIR THING? 
	--BEGIN TRANSACTION
	--	SELECT DISTINCT QestID, QestUniqueID, QestParentID, QestUniqueParentID INTO RL_TEMP
	--	FROM qestReverseLookup GROUP BY QestUniqueID, QestID, QestParentID, QestUniqueParentID HAVING COUNT(*) > 1

	--	DELETE qestReverseLookup FROM qestReverseLookup RL JOIN RL_TEMP TT ON RL.QestID = TT.QestID AND RL.QestUniqueID = TT.QestUniqueID

	--	INSERT INTO qestReverseLookup (QestUniqueID, QestID, QestParentID, QestUniqueParentID)
	--	SELECT QestUniqueID, QestID, QestParentID, QestUniqueParentID FROM RL_TEMP

	--	DROP TABLE RL_TEMP
	--COMMIT TRANSACTION
	--GO

	-- VALIDATION: Check for zero QestUniqueIDs
	IF EXISTS(SELECT 1 FROM qestReverseLookup WHERE QestUniqueID = 0)
	BEGIN
	  declare @list_of_tables nvarchar(4000)
    select @list_of_tables = substring((select ', ' + convert(nvarchar(8), rl.QestID) + coalesce(' - ' + tn.Value, '')
      from (select distinct QestID from qestReverseLookup where QestUniqueID = 0) rl
      left join qestObjects tn on rl.QestID = tn.QestID and tn.Property = 'tablename'
      for xml path ('') ), 3, 4000)

		RAISERROR ('qestReverseLookup corruption detected. Zero-value QestUniqueIDs exist for the following object types: %s
  For each document table, check that QestUniqueID column marked as the identity column and the *_Insert_UniqueID trigger is operational.', 16, 0, @list_of_tables)
	END

	-- VALIDATION: Check for duplicate QestID, QestUniqueID pairs
	IF EXISTS(SELECT 1 FROM qestReverseLookup GROUP BY QestUniqueID, QestID HAVING COUNT(*) > 1)
	BEGIN
	  declare @number_of_duplicates int;
	  select @number_of_duplicates = count(*) from (SELECT 1 X FROM qestReverseLookup GROUP BY QestUniqueID, QestID HAVING COUNT(*) > 1) X
		RAISERROR ('qestReverseLookup corruption detected. %d Duplicate QestID/QestUniqueID pairs found.
	You can list them using:
	  select QestID, QestUniqueID, count(*)
	  from qestReverseLookup
	  having count(*) > 1
	', 16, 0, @number_of_duplicates)
	END

	EXEC qest_GenerateQestUUID 'qestReverseLookup'
	
	EXEC [dbo].[qest_InsertUpdateColumn] 'qestReverseLookup', 'QestParentUUID', 'uniqueidentifier', NULL, 'YES', NULL
	EXEC [dbo].[qest_InsertUpdateColumn] 'qestReverseLookup', 'SampleArticleUUID', 'uniqueidentifier', NULL, 'YES', NULL
	EXEC [dbo].[qest_InsertUpdateColumn] 'qestReverseLookup', 'TestPlanUUID', 'uniqueidentifier', NULL, 'YES', NULL
	EXEC [dbo].[qest_InsertUpdateColumn] 'qestReverseLookup', 'QestOwnerLabNo', 'int', NULL, 'NO', '((0))'
	EXEC [dbo].[qest_InsertUpdateColumn] 'qestReverseLookup', 'QestCreatedBy', 'int', NULL, 'YES', NULL
	EXEC [dbo].[qest_InsertUpdateColumn] 'qestReverseLookup', 'QestCreatedDate', 'datetime', NULL, 'YES', NULL
	EXEC [dbo].[qest_InsertUpdateColumn] 'qestReverseLookup', 'QestModifiedBy', 'int', NULL, 'YES', NULL
	EXEC [dbo].[qest_InsertUpdateColumn] 'qestReverseLookup', 'QestModifiedDate', 'datetime', NULL, 'YES', NULL
	EXEC [dbo].[qest_InsertUpdateColumn] 'qestReverseLookup', 'QestStatusFlags', 'int', NULL, 'YES', NULL
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Laboratory') 
BEGIN
	EXEC qest_GenerateQestUUID 'Laboratory'
END
GO

EXEC qest_EnableActivityForQestnet 'Users'
GO
EXEC qest_EnableActivityForQestnet 'People'
GO
EXEC qest_EnableActivityForQestnet 'SpecificationRecords'
GO
EXEC qest_EnableActivityForQestnet 'Specifications'
GO

-- PATCH: Establish Users.PersonUUID using Users.PersonID
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Users')
BEGIN
	IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Users' AND COLUMN_NAME = 'PersonUUID')
	BEGIN 
		ALTER TABLE Users ADD PersonUUID uniqueidentifier NULL 
	END
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'People' AND COLUMN_NAME = 'QestUniqueID') AND
	EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Users' AND COLUMN_NAME = 'PersonUUID')
BEGIN 
 	-- Populate PersonUUID
	UPDATE U SET PersonUUID = P.QestUUID
	FROM People P INNER JOIN Users U ON P.QestUniqueID = U.PersonID
	WHERE U.PersonUUID IS NULL

	-- Turn PersonUUID non-nullable
	ALTER TABLE Users ALTER COLUMN PersonUUID uniqueidentifier NOT NULL
END
GO

-- PATCH: Establish LaboratoryMapping.LocationUUID using LaboratoryMapping.LocationID
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'LaboratoryMapping')
BEGIN
	IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'LaboratoryMapping' AND COLUMN_NAME = 'LocationUUID')
	BEGIN 
		ALTER TABLE LaboratoryMapping ADD LocationUUID uniqueidentifier NULL 
	END	
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Laboratory' AND COLUMN_NAME = 'QestUniqueID')
	AND EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'LaboratoryMapping' AND COLUMN_NAME = 'LocationUUID')
BEGIN 
	UPDATE LaboratoryMapping SET LocationUUID = L.QestUUID
	FROM Laboratory L 
	INNER JOIN LaboratoryMapping M ON L.QestID = M.LocationQestID AND L.QestUniqueID = M.LocationID 
	WHERE M.LocationUUID IS NULL 

	ALTER TABLE LaboratoryMapping ALTER COLUMN LocationUUID uniqueidentifier NOT NULL
END
GO

-- PATCH: Establish SpecificationRecords.QestParentUUID using SpecificationRecords.SpecificationID
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'SpecificationRecords')
BEGIN
	IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SpecificationRecords' AND COLUMN_NAME = 'QestParentUUID')
	BEGIN 
		ALTER TABLE SpecificationRecords ADD QestParentUUID uniqueidentifier NULL 
	END
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Specifications' AND COLUMN_NAME = 'QestUniqueID')
	AND EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SpecificationRecords' AND COLUMN_NAME = 'QestParentUUID')
BEGIN 
	UPDATE SpecificationRecords SET QestParentUUID = S.QestUUID
	FROM Specifications S 
	INNER JOIN SpecificationRecords R ON S.QestUniqueID = R.SpecificationID 
	WHERE R.QestParentUUID IS NULL

	ALTER TABLE SpecificationRecords ALTER COLUMN QestParentUUID uniqueidentifier NOT NULL
END
GO







