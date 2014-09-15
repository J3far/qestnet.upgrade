
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
		RAISERROR ('qestReverseLookup corruption detected. Zero-value QestUniqueIDs exist: for the relevant document tables check 
					that QestUniqueID is set identity and the *_Insert_UniqueID trigger is operational.', 16, 0)
	END

	-- VALIDATION: Check for duplicate QestID, QestUniqueID pairs
	IF EXISTS(SELECT 1 FROM qestReverseLookup GROUP BY QestUniqueID, QestID HAVING COUNT(*) > 1)
	BEGIN
		RAISERROR ('qestReverseLookup corruption detected. Duplicate QestID/QestUniqueID pairs found.', 16, 0)
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







