

-- TestQestUniqueID & ReportQestUniqueID to no longer be populated
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'qestReportMapping' AND COLUMN_NAME = 'TestQestUniqueID' AND IS_NULLABLE = 'NO')
BEGIN 
	ALTER TABLE qestReportMapping ALTER COLUMN TestQestUniqueID int NULL
END
GO

-- QestUniqueID to no longer be populated
-- Review their usage and eliminate when satisfied it wont be missed
-- Also abandon QestParentID, QestUniqueParentID
-- Remove trigger also?

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WorkProgress' AND COLUMN_NAME = 'QestUniqueID' AND IS_NULLABLE = 'NO')
BEGIN 
	ALTER TABLE WorkProgress ALTER COLUMN QestUniqueID int NULL
END
GO


-- Ensure EquipmentTestMapping meets requirements for IQestOwnedData
IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EquipmentTestMapping' AND COLUMN_NAME = 'QestID')
BEGIN 
	ALTER TABLE EquipmentTestMapping ADD QestID int NOT NULL DEFAULT (32)
END
GO

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EquipmentTestMapping' AND COLUMN_NAME = 'QestOwnerLabNo')
BEGIN 
	ALTER TABLE EquipmentTestMapping ADD QestOwnerLabNo int NULL
	EXEC('UPDATE M SET QestOwnerLabNo = E.QestOwnerLabNo FROM Equipment E INNER JOIN EquipmentTestMapping M ON E.QestUUID = M.EquipmentQestUUID')
	ALTER TABLE EquipmentTestMapping ALTER COLUMN QestOwnerLabNo int NOT NULL
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EquipmentTestMapping' AND COLUMN_NAME = 'EquipmentQestUniqueID')
BEGIN 
	EXEC qest_DropIndex 'EquipmentTestMapping', 'IX_EquipmentTestMapping_Equipment'
	ALTER TABLE EquipmentTestMapping DROP COLUMN EquipmentQestUniqueID
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EquipmentTestMapping' AND COLUMN_NAME = 'TestQestUniqueID')
BEGIN 
	EXEC qest_DropIndex 'EquipmentTestMapping', 'IX_EquipmentTestMapping_Test'
	ALTER TABLE EquipmentTestMapping DROP COLUMN TestQestUniqueID
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EquipmentTestMapping' AND COLUMN_NAME = 'QestUniqueID')
BEGIN 
	EXEC qest_SetPrimaryKey 'EquipmentTestMapping', 'PK_EquipmentTestMapping', 'QestUUID'
	ALTER TABLE EquipmentTestMapping DROP COLUMN QestUniqueID
END
GO

-- Remove redundant UniqueID fields from TestStageData
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TestStageData' AND COLUMN_NAME = 'QestUniqueID')
BEGIN 
	EXEC qest_DropIndex 'TestStageData', 'IX_TestStageData_QestUniqueID'
	ALTER TABLE TestStageData DROP COLUMN QestUniqueID
END
GO

-- Remove redundant UniqueID fields from TestStageData
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TestStageData' AND COLUMN_NAME = 'QestUniqueParentID')
BEGIN 
	EXEC qest_DropIndex 'TestStageData', 'IX_TestStageData_QestParentUniqueID'
	ALTER TABLE TestStageData DROP COLUMN QestUniqueParentID
END
GO

-- Remove redundant FK_qestView_qestEntity
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS WHERE CONSTRAINT_NAME = 'FK_qestView_qestEntity')
BEGIN
	ALTER TABLE dbo.qestView DROP CONSTRAINT FK_qestView_qestEntity
END
GO

-- Remove redundant FK_qestWorkflow_qestEntity
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS WHERE CONSTRAINT_NAME = 'FK_qestWorkflow_qestEntity')
BEGIN
	ALTER TABLE dbo.qestWorkflow DROP CONSTRAINT FK_qestWorkflow_qestEntity
END
GO

-- Remove UserDocumentBase as it is no longer required
IF EXISTS(SELECT 1 FROM sys.tables WHERE name = 'UserDocumentBase' AND type_desc = 'USER_TABLE')
BEGIN
	DROP TABLE dbo.UserDocumentBase
END
GO

-- Change DocumentConcreteDockets.Fc to real
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DocumentConcreteDockets' AND COLUMN_NAME = 'Fc' AND DATA_TYPE = 'smallint')
BEGIN
	IF EXISTS(SELECT 1 FROM sys.default_constraints WHERE name = 'DF_DocumentConcreteDockets_Fc')
	BEGIN
		ALTER TABLE dbo.DocumentConcreteDockets DROP DF_DocumentConcreteDockets_Fc
	END
	ALTER TABLE dbo.DocumentConcreteDockets ALTER COLUMN Fc real
	ALTER TABLE dbo.DocumentConcreteDockets ADD CONSTRAINT DF_DocumentConcreteDockets_Fc default 0 for Fc
END
GO

-- Change DocumentConcreteDockets.MaximumAggSize to real
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DocumentConcreteDockets' AND COLUMN_NAME = 'MaximumAggSize' AND DATA_TYPE = 'smallint')
BEGIN
	ALTER TABLE dbo.DocumentConcreteDockets ALTER COLUMN MaximumAggSize real
END
GO

-- Change DocumentConcreteDestructive smallint to int
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DocumentConcreteDestructive' AND COLUMN_NAME = 'AcceptanceAge' AND DATA_TYPE = 'smallint')
BEGIN
	ALTER TABLE dbo.DocumentConcreteDestructive ALTER COLUMN AcceptanceAge int
	ALTER TABLE dbo.DocumentConcreteDestructive ALTER COLUMN MaterialType1 int
	ALTER TABLE dbo.DocumentConcreteDestructive ALTER COLUMN MaterialType2 int
	ALTER TABLE dbo.DocumentConcreteDestructive ALTER COLUMN MaterialType3 int
	ALTER TABLE dbo.DocumentConcreteDestructive ALTER COLUMN MaterialType4 int
	ALTER TABLE dbo.DocumentConcreteDestructive ALTER COLUMN MaterialType5 int
	ALTER TABLE dbo.DocumentConcreteDestructive ALTER COLUMN MaterialType6 int
	ALTER TABLE dbo.DocumentConcreteDestructive ALTER COLUMN MaterialType7 int
	ALTER TABLE dbo.DocumentConcreteDestructive ALTER COLUMN MaterialType8 int
	ALTER TABLE dbo.DocumentConcreteDestructive ALTER COLUMN MaterialType9 int
	ALTER TABLE dbo.DocumentConcreteDestructive ALTER COLUMN MaterialType10 int
	ALTER TABLE dbo.DocumentConcreteDestructive ALTER COLUMN MaterialType11 int
	ALTER TABLE dbo.DocumentConcreteDestructive ALTER COLUMN MaterialType12 int
END
GO