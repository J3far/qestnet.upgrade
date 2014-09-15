
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EquipmentTestMapping')
BEGIN
	EXEC qest_GenerateQestUUID 'EquipmentTestMapping'
	
	-- Ensure TestQestUUID
	IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EquipmentTestMapping' AND COLUMN_NAME = 'TestQestUUID')
	BEGIN 
		ALTER TABLE EquipmentTestMapping ADD TestQestUUID uniqueidentifier NULL 
	END

	-- Ensure EquipmentQestUUID
	IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EquipmentTestMapping' AND COLUMN_NAME = 'EquipmentQestUUID')
	BEGIN 
		ALTER TABLE EquipmentTestMapping ADD EquipmentQestUUID uniqueidentifier NULL 
	END
END
GO

-- Set EquipmentQestUUID if there is a qestReverseLookup match
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EquipmentTestMapping' AND COLUMN_NAME = 'EquipmentQestUUID')
BEGIN 
	UPDATE EquipmentTestMapping SET EquipmentQestUUID = R.QestUUID FROM EquipmentTestMapping M
	INNER JOIN qestReverseLookup R ON M.EquipmentQestID = R.QestID AND M.EquipmentQestUniqueID = R.QestUniqueID
	WHERE M.EquipmentQestUUID IS NULL
	
	EXEC qest_DropIndex 'EquipmentTestMapping', 'IX_EquipmentTestMapping_Equipment'
	DELETE FROM EquipmentTestMapping WHERE EquipmentQestUUID IS NULL
	ALTER TABLE EquipmentTestMapping ALTER COLUMN EquipmentQestUUID uniqueidentifier NOT NULL 
END
GO

-- Set TestQestUUID if there is a qestReverseLookup match
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EquipmentTestMapping' AND COLUMN_NAME = 'TestQestUUID')
BEGIN 
	UPDATE EquipmentTestMapping SET TestQestUUID = R.QestUUID FROM EquipmentTestMapping M
	INNER JOIN qestReverseLookup R ON M.TestQestID = R.QestID AND M.TestQestUniqueID = R.QestUniqueID
	WHERE M.TestQestUUID IS NULL
	
	EXEC qest_DropIndex 'EquipmentTestMapping', 'IX_EquipmentTestMapping_Test'
	DELETE FROM EquipmentTestMapping WHERE TestQestUUID IS NULL
	ALTER TABLE EquipmentTestMapping ALTER COLUMN TestQestUUID uniqueidentifier NOT NULL 
END
GO
