

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

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EquipmentTestMapping' AND COLUMN_NAME = 'QestUniqueID')
BEGIN 
	EXEC qest_SetPrimaryKey 'EquipmentTestMapping', 'PK_EquipmentTestMapping', 'QestUUID'
	ALTER TABLE EquipmentTestMapping DROP COLUMN QestUniqueID
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
