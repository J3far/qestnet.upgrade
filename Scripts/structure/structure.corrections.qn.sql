
-- Changes that need to occur prior to table structure updates to deal with existing databases
-- NOTE:  All queries in this file must handle being run on a completely empty database

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SessionConnections' AND COLUMN_NAME = 'UserID' AND IS_NULLABLE = 'YES')
BEGIN 
	EXEC qest_DropIndex 'SessionConnections', 'IX_SessionConnections_UserID'
	ALTER TABLE SessionConnections ALTER COLUMN UserID int NOT NULL
END
GO

-- Set SessionLocks.SessionConnectionsUniqueID non-nullable
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SessionLocks' AND COLUMN_NAME = 'SessionConnectionsUniqueID' AND IS_NULLABLE = 'YES')
BEGIN 
	EXEC qest_DropIndex 'SessionLocks', 'IX_SessionLocks_SessionConnectionsUniqueID'
	ALTER TABLE SessionLocks ALTER COLUMN SessionConnectionsUniqueID int NOT NULL
END
GO

-- Set ListLanguageTranslations.QestID non-nullable
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ListLanguageTranslations' AND COLUMN_NAME = 'QestID' AND IS_NULLABLE = 'YES')
BEGIN 
	DELETE FROM ListLanguageTranslations WHERE QestID IS NULL
	ALTER TABLE ListLanguageTranslations ALTER COLUMN QestID int NOT NULL
END
GO

-- Set ListLanguageTranslations.BaseText non-nullable
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ListLanguageTranslations' AND COLUMN_NAME = 'BaseText' AND IS_NULLABLE = 'YES')
BEGIN 
	DELETE FROM ListLanguageTranslations WHERE BaseText IS NULL
	ALTER TABLE ListLanguageTranslations ALTER COLUMN BaseText nvarchar(440) NOT NULL
END
GO

-- Set PeopleRolesMapping.PersonID non-nullable
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PeopleRolesMapping' AND COLUMN_NAME = 'PersonID' AND IS_NULLABLE = 'YES')
BEGIN 
	EXEC qest_DropIndex 'PeopleRolesMapping', 'IX_PeopleRolesMapping_PersonID'
	DELETE FROM PeopleRolesMapping WHERE PersonID IS NULL
	ALTER TABLE PeopleRolesMapping ALTER COLUMN PersonID int NOT NULL
END
GO

-- Set PeopleRolesMapping.RoleID non-nullable
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PeopleRolesMapping' AND COLUMN_NAME = 'RoleID' AND IS_NULLABLE = 'YES')
BEGIN 
	EXEC qest_DropIndex 'PeopleRolesMapping', 'IX_PeopleRolesMapping_RoleID'
	DELETE FROM PeopleRolesMapping WHERE RoleID IS NULL
	ALTER TABLE PeopleRolesMapping ALTER COLUMN RoleID int NOT NULL
END
GO

-- Set PeopleRolesMapping.WorkflowUUID non-nullable
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'qestWorkflowLocationMapping' AND COLUMN_NAME = 'WorkflowUUID' AND IS_NULLABLE = 'YES')
BEGIN 
	DELETE FROM dbo.qestWorkflowLocationMapping WHERE WorkflowUUID IS NULL
	ALTER TABLE dbo.qestWorkflowLocationMapping ALTER COLUMN WorkflowUUID uniqueidentifier NOT NULL
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'qestWorkflowLocationMapping' AND COLUMN_NAME = 'LocationID' AND IS_NULLABLE = 'YES')
BEGIN 
	DELETE FROM dbo.qestWorkflowLocationMapping WHERE LocationID IS NULL
	ALTER TABLE dbo.qestWorkflowLocationMapping ALTER COLUMN LocationID int NOT NULL
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TestConditionFieldListValue' AND COLUMN_NAME = 'TestConditionFieldID' AND IS_NULLABLE = 'YES')
BEGIN 
	DELETE FROM dbo.TestConditionFieldListValue WHERE TestConditionFieldID IS NULL
	ALTER TABLE dbo.TestConditionFieldListValue ALTER COLUMN TestConditionFieldID int NOT NULL
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TestConditionFieldListValue' AND COLUMN_NAME = 'Order' AND IS_NULLABLE = 'YES')
BEGIN 
	DELETE FROM dbo.TestConditionFieldListValue WHERE [Order] IS NULL
	ALTER TABLE dbo.TestConditionFieldListValue ALTER COLUMN [Order] int NOT NULL
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TestConditionMapping' AND COLUMN_NAME = 'QestObjectTypeID' AND IS_NULLABLE = 'YES')
BEGIN 
	DELETE FROM dbo.TestConditionMapping WHERE QestObjectTypeID IS NULL
	ALTER TABLE dbo.TestConditionMapping ALTER COLUMN QestObjectTypeID int NOT NULL
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TestConditionMapping' AND COLUMN_NAME = 'TestConditionUUID' AND IS_NULLABLE = 'YES')
BEGIN 
	DELETE FROM dbo.TestConditionMapping WHERE TestConditionUUID IS NULL
	ALTER TABLE dbo.TestConditionMapping ALTER COLUMN TestConditionUUID uniqueidentifier NOT NULL
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'LTP_TriaxialSet' AND COLUMN_NAME = 'QestUUID' AND IS_NULLABLE = 'YES')
BEGIN 
	ALTER TABLE dbo.LTP_TriaxialSet ALTER COLUMN QestUUID uniqueidentifier NOT NULL
END
GO

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'LTP' AND COLUMN_NAME = 'LTPUUID' AND IS_NULLABLE = 'YES')
BEGIN
  EXEC qest_DropDefault @TableName = 'LTP', @ColumnName = 'LTPUUID'
  ALTER TABLE dbo.LTP ALTER COLUMN LTPUUID uniqueidentifier not null
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'LTP_PlannedTest' AND COLUMN_NAME = 'PlannedTestUUID' AND IS_NULLABLE = 'YES')
BEGIN
  EXEC qest_DropDefault @TableName = 'LTP_PlannedTest', @ColumnName = 'PlannedTestUUID'
  ALTER TABLE dbo.LTP_PlannedTest ALTER COLUMN PlannedTestUUID uniqueidentifier not null
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'LTP_PlannedTestConditions' AND COLUMN_NAME = 'PlannedTestUUID' AND IS_NULLABLE = 'YES')
BEGIN
  ALTER TABLE dbo.LTP_PlannedTestConditions ALTER COLUMN PlannedTestUUID uniqueidentifier not null
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'LTP_PlannedTestConditions' AND COLUMN_NAME = 'TestConditionUUID' AND IS_NULLABLE = 'YES')
BEGIN
  ALTER TABLE dbo.LTP_PlannedTestConditions ALTER COLUMN TestConditionUUID uniqueidentifier not null
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'LTP_PlannedTestConditions')
BEGIN 
	IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'LTP_PlannedTestConditions' AND COLUMN_NAME = 'QestUUID')
	BEGIN 
		ALTER TABLE dbo.LTP_PlannedTestConditions ADD QestUUID uniqueidentifier NOT NULL CONSTRAINT DF_LTP_PlannedTestConditions_QestUUID DEFAULT NEWID()
		ALTER TABLE dbo.LTP_PlannedTestConditions DROP CONSTRAINT DF_LTP_PlannedTestConditions_QestUUID
	END 
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'LTP_PlannedTestConditions' AND COLUMN_NAME = 'QestUUID' AND IS_NULLABLE = 'YES')
BEGIN 
	UPDATE dbo.LTP_PlannedTestConditions SET QestUUID = NEWID() WHERE QestUUID IS NULL
	ALTER TABLE dbo.LTP_PlannedTestConditions ALTER COLUMN QestUUID uniqueidentifier NOT NULL
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'LTP_PlannedTestConditions')
BEGIN 
	IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'LTP_PlannedTestConditions' AND COLUMN_NAME = 'Index')
	BEGIN 
		ALTER TABLE dbo.LTP_PlannedTestConditions ADD [Index] int NOT NULL CONSTRAINT DF_LTP_PlannedTestConditions_Index DEFAULT 0
		ALTER TABLE dbo.LTP_PlannedTestConditions DROP CONSTRAINT DF_LTP_PlannedTestConditions_Index
	END
END
GO
	
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'LTP_PlannedTestConditions' AND COLUMN_NAME = 'Index' AND IS_NULLABLE = 'YES')
BEGIN 
	EXEC qest_DropIndex 'LTP_PlannedTestConditions', 'IX_LTP_PlannedTestConditions_PlannedTestUUID_TestConditionUUID'
	UPDATE dbo.LTP_PlannedTestConditions SET [Index] = 0 WHERE [Index] IS NULL
	ALTER TABLE dbo.LTP_PlannedTestConditions ALTER COLUMN [Index] int NOT NULL
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS WHERE CONSTRAINT_NAME = 'FK_LTP_PlannedTestConditions_TestCondition')
BEGIN 
	ALTER TABLE LTP_PlannedTestConditions DROP CONSTRAINT FK_LTP_PlannedTestConditions_TestCondition
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS WHERE CONSTRAINT_NAME = 'FK_ListSampleLocation')
BEGIN 
	ALTER TABLE ListSampleLocation DROP CONSTRAINT FK_ListSampleLocation
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'qestPlateReportMapping' AND COLUMN_NAME = 'QestUUID' AND IS_NULLABLE = 'YES')
BEGIN 
	DELETE FROM dbo.qestPlateReportMapping WHERE QestUUID IS NULL
	ALTER TABLE dbo.qestPlateReportMapping ALTER COLUMN QestUUID uniqueidentifier NOT NULL
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'qestPlateReportMapping' AND COLUMN_NAME = 'ReportUUID' AND IS_NULLABLE = 'YES')
BEGIN 
	DELETE FROM dbo.qestPlateReportMapping WHERE ReportUUID IS NULL
	ALTER TABLE dbo.qestPlateReportMapping ALTER COLUMN ReportUUID uniqueidentifier NOT NULL
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'qestPlateReportMapping' AND COLUMN_NAME = 'TestUUID' AND IS_NULLABLE = 'YES')
BEGIN 
	DELETE FROM dbo.qestPlateReportMapping WHERE TestUUID IS NULL
	ALTER TABLE dbo.qestPlateReportMapping ALTER COLUMN TestUUID uniqueidentifier NOT NULL
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'qestPlateReportNotes' AND COLUMN_NAME = 'ReportUUID' AND IS_NULLABLE = 'YES')
BEGIN 
	DELETE FROM dbo.qestPlateReportNotes WHERE ReportUUID IS NULL
	ALTER TABLE dbo.qestPlateReportNotes ALTER COLUMN ReportUUID uniqueidentifier NOT NULL
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'qestPlateReportNotes' AND COLUMN_NAME = 'LocationUUID' AND IS_NULLABLE = 'YES')
BEGIN 
	DELETE FROM dbo.qestPlateReportNotes WHERE LocationUUID IS NULL
	ALTER TABLE dbo.qestPlateReportNotes ALTER COLUMN LocationUUID uniqueidentifier NOT NULL
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'qestPlateReportOptionMapping' AND COLUMN_NAME = 'PlateReportQestID' AND IS_NULLABLE = 'YES')
BEGIN 
	DELETE FROM dbo.qestPlateReportOptionMapping WHERE PlateReportQestID IS NULL
	ALTER TABLE dbo.qestPlateReportOptionMapping ALTER COLUMN PlateReportQestID int NOT NULL
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'qestPlateReportOptionMapping' AND COLUMN_NAME = 'PlateReportOptionUUID' AND IS_NULLABLE = 'YES')
BEGIN 
	DELETE FROM dbo.qestPlateReportOptionMapping WHERE PlateReportOptionUUID IS NULL
	ALTER TABLE dbo.qestPlateReportOptionMapping ALTER COLUMN PlateReportOptionUUID uniqueidentifier NOT NULL
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'qestPlateReportOptions' AND COLUMN_NAME = 'QestUUID' AND IS_NULLABLE = 'YES')
BEGIN 
	DELETE FROM dbo.qestPlateReportOptions WHERE QestUUID IS NULL
	ALTER TABLE dbo.qestPlateReportOptions ALTER COLUMN QestUUID uniqueidentifier NOT NULL
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'qestPlateReportOptionValues' AND COLUMN_NAME = 'QestUUID' AND IS_NULLABLE = 'YES')
BEGIN 
	DELETE FROM dbo.qestPlateReportOptionValues WHERE QestUUID IS NULL
	ALTER TABLE dbo.qestPlateReportOptionValues ALTER COLUMN QestUUID uniqueidentifier NOT NULL
END
GO

-- Set qestEntity.QestEntityUUID non-nullable
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'qestEntity' and COLUMN_NAME = 'QestEntityUUID' AND IS_NULLABLE = 'YES')
BEGIN 
	ALTER TABLE dbo.qestEntity ALTER COLUMN QestEntityUUID uniqueidentifier NOT NULL 
END
GO

-- Cleanup of a badly named default
IF EXISTS(SELECT 1 FROM sys.default_constraints WHERE Name = 'DF_TEMP')	
BEGIN 
	ALTER TABLE Defaults DROP CONSTRAINT DF_TEMP END
GO

-- WorkTemplates - correct null QestIDs
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'WorkTemplates' and COLUMN_NAME = 'QestID')
BEGIN 
	UPDATE WorkTemplates SET QestID = 90045 WHERE ISNULL(QestID, 0) <> 90045
END
GO

-- Set SpecificationRecords.SpecificationID non-nullable
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SpecificationRecords' AND COLUMN_NAME = 'SpecificationID' AND IS_NULLABLE = 'YES')
BEGIN 
	EXEC qest_DropIndex 'PeopleRolesMapping', 'IX_SpecificationRecords_SpecificationID'
	ALTER TABLE dbo.SpecificationRecords ALTER COLUMN SpecificationID int NOT NULL
END
GO

-- Set SpecificationRecords.ObjectID non-nullable
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SpecificationRecords' AND COLUMN_NAME = 'ObjectID' AND IS_NULLABLE = 'YES')
BEGIN 
	ALTER TABLE dbo.SpecificationRecords ALTER COLUMN ObjectID int NOT NULL
END
GO

-- Set Users.PersonID non-nullable
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Users' AND COLUMN_NAME = 'PersonID' AND IS_NULLABLE = 'YES')
BEGIN 
	EXEC qest_DropIndex 'Users', 'IX_Users_PersonID'
	ALTER TABLE dbo.Users ALTER COLUMN PersonID int NOT NULL
END
GO

-- Users - correct QestIDs
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Users' AND COLUMN_NAME = 'QestID')
BEGIN 
	UPDATE Users SET QestID = 20999 WHERE ISNULL(QestID, 0) <> 20999
END
GO

-- Users - correct QestOwnerLabNo
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Users' AND COLUMN_NAME = 'QestOwnerLabNo')
BEGIN 
	UPDATE Users SET QestOwnerLabNo = 0 WHERE QestOwnerLabNo IS NULL
END
GO

-- Set qestTestStage.TestStageQestID non-nullable
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'qestTestStage' AND COLUMN_NAME = 'TestStageQestID' AND IS_NULLABLE = 'YES')
BEGIN 
	EXEC qest_DropIndex 'qestTestStage', 'IX_qestTestStage_TestStageQestID' 
	ALTER TABLE dbo.qestTestStage ALTER COLUMN TestStageQestID int NOT NULL
END
GO

-- Set qestTestStage.TestQestID non-nullable
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'qestTestStage' AND COLUMN_NAME = 'TestQestID' AND IS_NULLABLE = 'YES')
BEGIN
	EXEC qest_DropIndex 'qestTestStage', 'IX_qestTestStage_TestQestID' 
	ALTER TABLE dbo.qestTestStage ALTER COLUMN TestQestID int NOT NULL
END
GO

-- Set TestStageData.QestParentID non-nullable
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TestStageData' AND COLUMN_NAME = 'QestParentID' AND IS_NULLABLE = 'YES')
BEGIN
	EXEC qest_DropIndex 'TestStageData', 'IX_TestStageData_QestParentID' 
	ALTER TABLE dbo.TestStageData ALTER COLUMN QestParentID int NOT NULL
END
GO

-- Set TestStageData.QestParentID non-nullable
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TestStageData' AND COLUMN_NAME = 'QestParentUUID' AND IS_NULLABLE = 'YES')
BEGIN
	EXEC qest_DropIndex 'TestStageData', 'IX_TestStageData_QestParentUUID_Idx' 
	ALTER TABLE dbo.TestStageData ALTER COLUMN QestParentUUID uniqueidentifier NOT NULL
END
GO

-- Set TestStageData.QestUUID non-nullable
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TestStageData' AND COLUMN_NAME = 'QestUUID' AND IS_NULLABLE = 'YES')
BEGIN
	ALTER TABLE dbo.TestStageData ALTER COLUMN QestUUID uniqueidentifier NOT NULL
END
GO

-- Remove bad default name: DF_Table_1_QestUUID1
IF EXISTS(SELECT 1 FROM sys.default_constraints WHERE parent_object_id = OBJECT_ID('SamplePhotos') AND name = 'DF_Table_1_QestUUID1')
BEGIN
	ALTER TABLE dbo.SamplePhotos DROP CONSTRAINT DF_Table_1_QestUUID1
END
GO

-- Remove bad default name: DF_Samples_QestGUID
IF EXISTS(SELECT 1 FROM sys.default_constraints WHERE parent_object_id = OBJECT_ID('Samples') AND name = 'DF_Samples_QestGUID')
BEGIN
	ALTER TABLE dbo.Samples DROP CONSTRAINT DF_Samples_QestGUID
END
GO

-- Remove bad default name: DF_SessionCon_UserID_1__86
IF EXISTS(SELECT 1 FROM sys.default_constraints WHERE parent_object_id = OBJECT_ID('SessionConnections') AND name = 'DF_SessionCon_UserID_1__86')
BEGIN
	ALTER TABLE dbo.SessionConnections DROP CONSTRAINT DF_SessionCon_UserID_1__86
END
GO

-- Remove bad default name: DF__SessionCo__UserI__7C8480AE
IF EXISTS(SELECT 1 FROM sys.default_constraints WHERE parent_object_id = OBJECT_ID('SessionConnections') AND name = 'DF__SessionCo__UserI__7C8480AE')
BEGIN
	ALTER TABLE dbo.SessionConnections DROP CONSTRAINT DF__SessionCo__UserI__7C8480AE
END
GO

-- Remove bad default name: DF__DocumentT__QestU__140D5F3C
IF EXISTS(SELECT 1 FROM sys.default_constraints WHERE parent_object_id = OBJECT_ID('DocumentTimekeeping') AND name = 'DF__DocumentT__QestU__140D5F3C')
BEGIN
	ALTER TABLE dbo.DocumentTimekeeping DROP CONSTRAINT DF__DocumentT__QestU__140D5F3C
END
GO

-- Remove bad default name: DF__DocumentT__QestU__686C721B
IF EXISTS(SELECT 1 FROM sys.default_constraints WHERE parent_object_id = OBJECT_ID('DocumentTimekeeping') AND name = 'DF__DocumentT__QestU__686C721B')
BEGIN
	ALTER TABLE dbo.DocumentTimekeeping DROP CONSTRAINT DF__DocumentT__QestU__686C721B
END
GO

-- Remove bad default name: DF__DocumentT__QestU__69609654
IF EXISTS(SELECT 1 FROM sys.default_constraints WHERE parent_object_id = OBJECT_ID('DocumentTimekeepingRecords') AND name = 'DF__DocumentT__QestU__69609654')
BEGIN
	ALTER TABLE dbo.DocumentTimekeepingRecords DROP CONSTRAINT DF__DocumentT__QestU__69609654
END
GO

-- Remove bad default name: DF__DocumentT__QestU__15F5A7AE
IF EXISTS(SELECT 1 FROM sys.default_constraints WHERE parent_object_id = OBJECT_ID('DocumentTimekeepingRecords') AND name = 'DF__DocumentT__QestU__15F5A7AE')
BEGIN
	ALTER TABLE dbo.DocumentTimekeepingRecords DROP CONSTRAINT DF__DocumentT__QestU__15F5A7AE
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'MaterialCategoryTestTypeSuitability' AND COLUMN_NAME = 'QestUniqueID' AND IS_NULLABLE = 'YES')
BEGIN 
	ALTER TABLE dbo.MaterialCategoryTestTypeSuitability ALTER COLUMN QestUniqueID int NOT NULL
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SuitabilityRuleConfiguration' AND COLUMN_NAME = 'QestUUID' AND IS_NULLABLE = 'YES')
BEGIN 
	ALTER TABLE dbo.SuitabilityRuleConfiguration ALTER COLUMN QestUUID uniqueidentifier NOT NULL
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SuitabilityRuleConfigurationTestCondition' AND COLUMN_NAME = 'QestUniqueParentID' AND IS_NULLABLE = 'YES')
BEGIN 
	ALTER TABLE dbo.SuitabilityRuleConfigurationTestCondition ALTER COLUMN QestUniqueParentID int NOT NULL
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SuitabilityRuleConfigurationTestCondition' AND COLUMN_NAME = 'TestConditionFieldID' AND IS_NULLABLE = 'YES')
BEGIN 
	ALTER TABLE dbo.SuitabilityRuleConfigurationTestCondition ALTER COLUMN TestConditionFieldID int NOT NULL
END
GO

-- Set qestWorkflowStage.WorkflowUUID non-nullable
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'qestWorkflowStage' AND COLUMN_NAME = 'WorkflowUUID' AND IS_NULLABLE = 'YES')
BEGIN 
	ALTER TABLE dbo.qestWorkflowStage ALTER COLUMN WorkflowUUID uniqueidentifier NOT NULL
END
GO

-- Set qestWorkflowStage.Stage non-nullable
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'qestWorkflowStage' AND COLUMN_NAME = 'Stage' AND IS_NULLABLE = 'YES')
BEGIN 
	ALTER TABLE dbo.qestWorkflowStage ALTER COLUMN Stage int NOT NULL
END
GO

-- Set qestWorkflowStage.ReadOnly non-nullable
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'qestWorkflowStage' AND COLUMN_NAME = 'ReadOnly' AND IS_NULLABLE = 'YES')
BEGIN 
	ALTER TABLE dbo.qestWorkflowStage ALTER COLUMN [ReadOnly] bit NOT NULL
END
GO

-- Set qestWorkflowSettings.ViewConfigurationUniqueID non-nullable
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'qestWorkflowSettings' AND COLUMN_NAME = 'ViewConfigurationUniqueID' AND IS_NULLABLE = 'YES')
BEGIN 
	ALTER TABLE dbo.qestWorkflowSettings ALTER COLUMN ViewConfigurationUniqueID int NOT NULL
END
GO

-- Set qestWorkflowSettings.WorkflowUUID non-nullable
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'qestWorkflowSettings' AND COLUMN_NAME = 'WorkflowUUID' AND IS_NULLABLE = 'YES')
BEGIN 
	ALTER TABLE dbo.qestWorkflowSettings ALTER COLUMN WorkflowUUID uniqueidentifier NOT NULL
END
GO

-- Set SampleRelationships.QestParentUUID non-nullable
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SampleRelationships' and COLUMN_NAME = 'QestParentUUID' AND IS_NULLABLE = 'YES')
BEGIN
  ALTER TABLE dbo.SampleRelationships ALTER COLUMN QestParentUUID uniqueidentifier NOT NULL
END
GO

-- Set SampleRelationships.QestChildUUID non-nullable
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SampleRelationships' and COLUMN_NAME = 'QestChildUUID' AND IS_NULLABLE = 'YES')
BEGIN
  ALTER TABLE dbo.SampleRelationships ALTER COLUMN QestChildUUID uniqueidentifier NOT NULL
END
GO

-- Remove incorrectly named foreign key
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS WHERE CONSTRAINT_NAME = 'FK_TestConditionField_TestCondition')
BEGIN
	ALTER TABLE dbo.TestConditionField DROP CONSTRAINT FK_TestConditionField_TestCondition
END
GO

-- Set TestConditions.QestUUID non-nullable (requires default early for population)
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS C where C.TABLE_NAME = 'TestConditions' and C.COLUMN_NAME = 'QestUUID' and C.IS_NULLABLE = 'YES')
BEGIN
	IF NOT EXISTS(SELECT 1 FROM sys.default_constraints WHERE Name = 'DF_TestConditions_QestUUID')	
	BEGIN 
		ALTER TABLE dbo.TestConditions ADD CONSTRAINT DF_TestConditions_QestUUID DEFAULT (newsequentialid()) FOR QestUUID
	END

	ALTER TABLE dbo.TestConditions ALTER COLUMN QestUUID uniqueidentifier NOT NULL
END
GO

-- Remove erroneous field: SampleRelationships.QestParentGUID
IF  EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SampleRelationships' AND COLUMN_NAME = 'QestParentGUID')
BEGIN 
	ALTER TABLE dbo.SampleRelationships DROP COLUMN QestParentGUID END
GO

-- Remove erroneous field: SampleRelationships.QestChildGUID
IF  EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SampleRelationships' AND COLUMN_NAME = 'QestChildGUID')
BEGIN 
	ALTER TABLE dbo.SampleRelationships DROP COLUMN QestChildGUID END
GO

-- Remove erroneous field: qestReverseLookup.QestGUID
IF  EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'qestReverseLookup' AND COLUMN_NAME = 'QestGUID')
BEGIN 
	ALTER TABLE dbo.qestReverseLookup DROP CONSTRAINT DF_qestReverseLookup_QestGUID 
	ALTER TABLE dbo.qestReverseLookup DROP COLUMN QestGUID 
END
GO

-- Remove erroneous field: qestReverseLookup.QestParentGUID
IF  EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'qestReverseLookup' AND COLUMN_NAME = 'QestParentGUID')
BEGIN 
	ALTER TABLE dbo.qestReverseLookup DROP COLUMN QestParentGUID 
END
GO

-- Remove erroneous field: qestReverseLookup.QestChildGUID
IF  EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'qestReverseLookup' AND COLUMN_NAME = 'QestChildGUID')
BEGIN 
	ALTER TABLE dbo.qestReverseLookup DROP COLUMN QestChildGUID 
END
GO

-- Remove erroneous field: qestReverseLookup.TestPlanGUID
IF  EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'qestReverseLookup' AND COLUMN_NAME = 'TestPlanGUID')
BEGIN 
	ALTER TABLE dbo.qestReverseLookup DROP COLUMN TestPlanGUID 
END
GO

-- Remove erroneous field: qestReverseLookup.SampleGUID
IF  EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'qestReverseLookup' AND COLUMN_NAME = 'SampleGUID')
BEGIN 
	ALTER TABLE dbo.qestReverseLookup DROP COLUMN SampleGUID 
END
GO

-- Set qestReverseLookup.QestID non-nullable
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'qestReverseLookup' and COLUMN_NAME = 'QestID' AND IS_NULLABLE = 'YES')
BEGIN
	EXEC qest_DropIndex 'qestReverseLookup', 'IX_qestReverseLookup_QestUniqueID_QestID'
	EXEC qest_DropIndex 'qestReverseLookup', 'IX_qestReverseLookup_QestID' 
	ALTER TABLE dbo.qestReverseLookup ALTER COLUMN QestID int NOT NULL
END
GO

-- Set qestReverseLookup.QestUniqueID non-nullable
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'qestReverseLookup' and COLUMN_NAME = 'QestUniqueID' AND IS_NULLABLE = 'YES')
BEGIN
	EXEC qest_DropIndex 'qestReverseLookup', 'IX_qestReverseLookup_QestUniqueID_QestID'
	EXEC qest_DropIndex 'qestReverseLookup', 'IX_qestReverseLookup_QestUniqueID'
	ALTER TABLE dbo.qestReverseLookup ALTER COLUMN QestUniqueID int NOT NULL
END
GO

-- Set qestReportMapping.TestQestID non-nullable
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'qestReportMapping' and COLUMN_NAME = 'TestQestID' AND IS_NULLABLE = 'YES')
BEGIN
	EXEC qest_DropIndex 'qestReportMapping', 'IX_qestReportMapping_TestQestID'
	ALTER TABLE dbo.qestReportMapping ALTER COLUMN TestQestID int NOT NULL
END
GO

-- Set qestReportMapping.TestQestUniqueID non-nullable
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'qestReportMapping' and COLUMN_NAME = 'TestQestUniqueID' AND IS_NULLABLE = 'YES')
BEGIN
	EXEC qest_DropIndex 'qestReportMapping', 'IX_qestReportMapping_TestQestUniqueID'
	ALTER TABLE dbo.qestReportMapping ALTER COLUMN TestQestUniqueID int NOT NULL
END
GO

-- Set Laboratory.QestID non-nullable
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Laboratory' and COLUMN_NAME = 'QestID' AND IS_NULLABLE = 'YES')
BEGIN
	EXEC qest_DropIndex 'Laboratory', 'IX_Laboratory_QestID'
	ALTER TABLE dbo.Laboratory ALTER COLUMN QestID int NOT NULL
END
GO

-- Set CounterMaps.ObjectID non-nullable
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CounterMaps' and COLUMN_NAME = 'ObjectID' AND IS_NULLABLE = 'YES')
BEGIN
	EXEC qest_DropIndex 'CounterMaps', 'IX_CounterMaps_ObjectID'
	ALTER TABLE dbo.CounterMaps ALTER COLUMN ObjectID int NOT NULL
END
GO

-- Set CounterMaps.CounterID non-nullable
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CounterMaps' and COLUMN_NAME = 'CounterID' AND IS_NULLABLE = 'YES')
BEGIN
	EXEC qest_DropIndex 'CounterMaps', 'IX_CounterMaps_CounterID'
	ALTER TABLE dbo.CounterMaps ALTER COLUMN CounterID int NOT NULL
END
GO

-- Set CounterValues.QestUniqueParentID non-nullable
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CounterValues' and COLUMN_NAME = 'QestUniqueParentID' AND IS_NULLABLE = 'YES')
BEGIN
	EXEC qest_DropIndex 'CounterValues', 'IX_CounterValues_QestUniqueParentID'
	ALTER TABLE dbo.CounterValues ALTER COLUMN QestUniqueParentID int NOT NULL
END
GO

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'DocumentSampleTransferRequestSingle')
BEGIN
	UPDATE DocumentSampleTransferRequestSingle SET QestID = 42001 WHERE ISNULL(QestID, 0) = 0
END

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'DocumentHveemStabilitySingle')
BEGIN
	UPDATE DocumentHveemStabilitySingle SET QestID = 111230 WHERE ISNULL(QestID, 0) = 0
END
GO

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'DocumentSodiumSulphateSUSASingle')
BEGIN
	UPDATE DocumentSodiumSulphateSUSASingle SET QestID = 111231 WHERE ISNULL(QestID, 0) = 0
END
GO

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'DocumentConcreteVaporEmissionSpecimen')
BEGIN
	UPDATE DocumentConcreteVaporEmissionSpecimen SET QestID = 111232 WHERE ISNULL(QestID, 0) = 0
END
GO

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'DocumentConcreteDiameterAverage')
BEGIN
	UPDATE DocumentConcreteDiameterAverage SET QestOwnerLabNo = 0 WHERE QestOwnerLabNo = 998
END
GO

-- Shrinkage QestID
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'DocumentConcreteShrinkageSpecimen')
BEGIN 
	IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DocumentConcreteShrinkageSpecimen' AND COLUMN_NAME = 'QestID')
	BEGIN 
		ALTER TABLE DocumentConcreteShrinkageSpecimen ADD QestID int NULL DEFAULT 111100 
	END
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DocumentConcreteShrinkageSpecimen' AND COLUMN_NAME = 'QestID')
BEGIN 
	UPDATE DocumentConcreteShrinkageSpecimen SET QestID = 111100 WHERE ISNULL(QestID, 0) = 0	
END
GO

-- Set SampleRegister.ManualSampleNotSuitable non-nullable
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SampleRegister' AND COLUMN_NAME = 'ManualSampleNotSuitable' AND IS_NULLABLE = 'YES')
BEGIN
	UPDATE SampleRegister SET ManualSampleNotSuitable = 0 WHERE ManualSampleNotSuitable IS NULL
	ALTER TABLE dbo.SampleRegister ALTER COLUMN ManualSampleNotSuitable bit NOT NULL
END
GO

-- Ensure DocumentCertificatesPictures.QestID is 90201
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DocumentCertificatesPictures' AND COLUMN_NAME = 'QestID')
BEGIN 
	UPDATE DocumentCertificatesPictures SET QestID = 90201 WHERE ISNULL(QestID, 0) <> 90201
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'DocumentAtterbergLimitsSpecimen')
BEGIN
	IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DocumentAtterbergLimitsSpecimen' AND COLUMN_NAME = 'QestID')
	BEGIN 
		ALTER TABLE DocumentAtterbergLimitsSpecimen ADD QestID int NULL 
		PRINT 'Added column QestID to table DocumentAtterbergLimitsSpecimen'
	END
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DocumentAtterbergLimitsSpecimen' AND COLUMN_NAME = 'QestID')
BEGIN
	UPDATE DocumentAtterbergLimitsSpecimen SET QestID = 111000 WHERE QestID IS NULL AND LiquidLimitSpecimen = 1
	UPDATE DocumentAtterbergLimitsSpecimen SET QestID = 111001 WHERE QestID IS NULL AND ISNULL(LiquidLimitSpecimen, 0) = 0
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'DocumentAtterbergLimitsCPSpecimens')
BEGIN 
	IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DocumentAtterbergLimitsCPSpecimens' AND COLUMN_NAME = 'QestID')
	BEGIN 
		ALTER TABLE DocumentAtterbergLimitsCPSpecimens ADD QestID int NULL 
		PRINT 'Added column QestID to table DocumentAtterbergLimitsCPSpecimens'
	END
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DocumentAtterbergLimitsCPSpecimens' AND COLUMN_NAME = 'QestID')
BEGIN	
	UPDATE DocumentAtterbergLimitsCPSpecimens SET QestID = 111002 WHERE ISNULL(QestID, 0) = 0 AND ISNULL(Flag, 0) = 0
	UPDATE DocumentAtterbergLimitsCPSpecimens SET QestID = 111003 WHERE ISNULL(QestID, 0) = 0 AND Flag = 1
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EquipmentTestMapping' AND COLUMN_NAME = 'EquipmentQestID' AND IS_NULLABLE = 'YES')
BEGIN 
	EXEC qest_DropIndex 'EquipmentTestMapping', 'IX_EquipmentTestMapping_Equipment'
	DELETE FROM EquipmentTestMapping WHERE EquipmentQestID IS NULL
	ALTER TABLE EquipmentTestMapping ALTER COLUMN EquipmentQestID int NOT NULL  
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EquipmentTestMapping' AND COLUMN_NAME = 'TestQestID' AND IS_NULLABLE = 'YES')
BEGIN 
	EXEC qest_DropIndex 'EquipmentTestMapping', 'IX_EquipmentTestMapping_Test'
	DELETE FROM EquipmentTestMapping WHERE TestQestID IS NULL
	ALTER TABLE EquipmentTestMapping ALTER COLUMN TestQestID int NOT NULL 
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS WHERE CONSTRAINT_NAME = 'FK_DocumentCalibration_Equipment')
BEGIN
	ALTER TABLE DocumentCalibration DROP CONSTRAINT FK_DocumentCalibration_Equipment
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS WHERE CONSTRAINT_NAME = 'FK_DocumentRelativeCompaction_SampleRegister')
BEGIN
	ALTER TABLE DocumentRelativeCompaction DROP CONSTRAINT FK_DocumentRelativeCompaction_SampleRegister
END
GO

-- Cleanup of a badly named default
IF EXISTS(SELECT 1 FROM sys.default_constraints WHERE Name = 'DF__qestRever__QestO__486B4D8B')	
BEGIN 
	ALTER TABLE qestReverseLookup DROP CONSTRAINT DF__qestRever__QestO__486B4D8B END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS WHERE CONSTRAINT_NAME = 'FK_qestReverseLookup_qestReportMapping')
BEGIN
	ALTER TABLE qestReportMapping DROP CONSTRAINT FK_qestReverseLookup_qestReportMapping
END
GO