
-- Changes that need to occur prior to table structure updates to deal with existing databases
-- NOTE:  All queries in this file must handle being run on a completely empty database


-- Create QestObjects table early if it does not exists as it is required for qestObjects which are required for document upgrade
IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE' AND TABLE_NAME = 'qestObjects')
BEGIN
	CREATE TABLE [dbo].[qestObjects](
		[QestUniqueID] [int] IDENTITY(1,1) NOT NULL,
		[QestID] [int] NULL,
		[QestActive] [bit] NULL,
		[QestExtra] [bit] NULL,
		[Property] [nvarchar](32) NULL,
		[Value] [nvarchar](4000) NULL,
		[ValueText] [ntext] NULL,
		CONSTRAINT [PK_qestObjects] PRIMARY KEY CLUSTERED ([QestUniqueID] ASC)
	)
	CREATE NONCLUSTERED INDEX [IX_qestObjects_Property] ON [dbo].[qestObjects] ([Property] ASC )
	CREATE NONCLUSTERED INDEX [IX_qestObjects_QestID] ON [dbo].[qestObjects]([QestID] ASC, [Property] ASC )
	ALTER TABLE [dbo].[qestObjects] ADD  CONSTRAINT [DF_qestObjects_QestActive]  DEFAULT (0) FOR [QestActive]
	ALTER TABLE [dbo].[qestObjects] ADD  CONSTRAINT [DF_qestObjects_QestExtra]  DEFAULT (0) FOR [QestExtra]
	PRINT 'Table created: qestObjects'
END
GO

-- Create LTP_PlannedTestStages table early if it does not exists as it is required for document upgrade
IF NOT EXISTS(Select 1 from sys.tables where name = N'LTP_PlannedTestStages')
BEGIN
	CREATE TABLE [dbo].[LTP_PlannedTestStages](
		[QestUUID] [uniqueidentifier] NOT NULL,
		[PlannedTestUUID] [uniqueidentifier] NOT NULL,
		[TestStageQestID] [int] NOT NULL,
		[Index] [int] NOT NULL,
	 CONSTRAINT [PK_LTP_PlannedTestStages] PRIMARY KEY CLUSTERED 
	(
		[QestUUID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
	PRINT 'Table created: LTP_PlannedTestStages'
END
GO


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

-- Set qestWorkflow.WorkflowUUID non-nullable
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'qestWorkflow' AND COLUMN_NAME = 'WorkflowUUID' AND IS_NULLABLE = 'YES')
BEGIN 
	DELETE FROM dbo.qestWorkflow WHERE WorkflowUUID IS NULL
	ALTER TABLE dbo.qestWorkflow ALTER COLUMN WorkflowUUID uniqueidentifier NOT NULL
END
GO

-- Set qestWorkflowLocationMapping.WorkflowUUID non-nullable
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

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'LTP_PlannedTest' AND COLUMN_NAME = 'QestID' AND IS_NULLABLE = 'YES')
BEGIN
  ALTER TABLE dbo.LTP_PlannedTest ALTER COLUMN QestID int not null
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

-- Add QestOwnerLabNo column to Defaults, set to 0 where null
IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE [name] = N'QestOwnerLabNo' AND [object_id] = OBJECT_ID(N'Defaults'))
BEGIN
  ALTER TABLE Defaults ADD QestOwnerLabNo INT NULL
END
GO
IF EXISTS(SELECT 1 FROM sys.columns WHERE [name] = N'QestOwnerLabNo' AND [object_id] = OBJECT_ID(N'Defaults'))
BEGIN
  UPDATE Defaults SET QestOwnerLabNo = 0 WHERE QestOwnerLabNo IS NULL
END 
GO

-- Replace null QestOwnerLabNo for Defaults
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Defaults' AND COLUMN_NAME = 'QestOwnerLabNo')
BEGIN 
	UPDATE Defaults SET QestOwnerLabNo = 0 WHERE QestOwnerLabNo IS NULL
END
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
	EXEC qest_DropIndex 'SpecificationRecords','IX_SpecificationRecords_SpecificationID'
	ALTER TABLE dbo.SpecificationRecords ALTER COLUMN SpecificationID int NOT NULL
END
GO

-- Set SpecificationRecords.ObjectID non-nullable
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SpecificationRecords' AND COLUMN_NAME = 'ObjectID' AND IS_NULLABLE = 'YES')
BEGIN 
	ALTER TABLE dbo.SpecificationRecords ALTER COLUMN ObjectID int NOT NULL
END
GO

--Create QestOwnerLabNo for table SpecificationRecords if it doesn't exist, retrieve value from specification
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'SpecificationRecords')
BEGIN
	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE [name] = N'QestOwnerLabNo' AND [object_id] = OBJECT_ID(N'SpecificationRecords'))
	BEGIN
	  ALTER TABLE SpecificationRecords ADD QestOwnerLabNo INT NULL
	END 
	IF EXISTS(SELECT 1 FROM sys.columns WHERE [name] = N'QestOwnerLabNo' AND [object_id] = OBJECT_ID(N'SpecificationRecords'))
	BEGIN
	  exec('UPDATE SpecificationRecords SET QestOwnerLabNo = (SELECT QestOwnerLabNo FROM Specifications WHERE QestUniqueID = SpecificationID)')
	END 
END
GO

--Create column TestQestUUID for table qestReportMapping if it doesn't exist
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'qestreportmapping')
BEGIN
	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE [name] = N'TestQestUUID' AND [object_id] = OBJECT_ID(N'qestreportmapping'))
	BEGIN
		ALTER TABLE qestreportmapping ADD TestQestUUID uniqueidentifier NULL
	END
END
GO

--Create column QestUniqueID for table qestReportMapping if it doesn't exist
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'qestreportmapping')
BEGIN
	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE [name] = N'QestUniqueID' AND [object_id] = OBJECT_ID(N'QestReportMapping'))
	BEGIN
		ALTER TABLE qestreportmapping ADD qestuniqueid int NOT NULL IDENTITY(1,1)
	END
END
GO

--Create column QestOwnerLabNo for table Users if it doesn't exist
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Users')
BEGIN
	IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Users' AND COLUMN_NAME = 'QestOwnerLabNo')
	BEGIN 
		ALTER TABLE users ADD qestownerlabno int NOT NULL
	END
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
	EXEC [dbo].[qest_DropIndex] 'qestTestStage', 'IX_qestTestStage_TestQestID_Idx'
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

----Set Equipment.QestOwnerLabNo non-nullable
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Equipment' AND COLUMN_NAME = 'QestOwnerLabNo' AND IS_NULLABLE = 'YES')
BEGIN
	ALTER TABLE Equipment ALTER COLUMN QestOwnerLabNo int NOT NULL
END 
GO

--Set LaboratoryMapping.LabNo non-nullable
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'laboratorymapping' AND COLUMN_NAME = 'labno' AND IS_NULLABLE = 'YES')
BEGIN
	ALTER TABLE laboratorymapping ALTER COLUMN labno int NOT NULL
END 
GO

--Set SuitabilityRuleConfigurationTestConditions.SuitabilityRuleConfigurationUUID non-nullable
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SuitabilityRuleConfigurationTestConditions' AND COLUMN_NAME = 'SuitabilityRuleConfigurationUUID' AND IS_NULLABLE = 'YES')
BEGIN
	ALTER TABLE SuitabilityRuleConfigurationTestConditions ALTER COLUMN SuitabilityRuleConfigurationUUID uniqueidentifier NOT NULL
END 
GO

--Set SuitabilityRuleConfigurationTestConditions.TestConditionUUID non-nullable
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SuitabilityRuleConfigurationTestConditions' AND COLUMN_NAME = 'TestConditionUUID' AND IS_NULLABLE = 'YES')
BEGIN
	ALTER TABLE SuitabilityRuleConfigurationTestConditions ALTER COLUMN TestConditionUUID uniqueidentifier NOT NULL
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

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SuitabilityRuleConfigurationTestCondition' AND COLUMN_NAME = 'SuitabilityRuleConfigurationUUID' AND IS_NULLABLE = 'YES')
BEGIN 
	ALTER TABLE dbo.SuitabilityRuleConfigurationTestCondition ALTER COLUMN SuitabilityRuleConfigurationUUID int NOT NULL
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SuitabilityRuleConfigurationTestCondition' AND COLUMN_NAME = 'TestConditionUUID' AND IS_NULLABLE = 'YES')
BEGIN 
	ALTER TABLE dbo.SuitabilityRuleConfigurationTestCondition ALTER COLUMN TestConditionUUID int NOT NULL
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

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'qestReverseLookup' and COLUMN_NAME = 'QestParentUUID')
BEGIN
	ALTER TABLE qestReverseLookup ADD QestParentUUID uniqueidentifier null
END
GO

-- Remove qestReverseLookup entries with invalid QestIDs
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'qestReverseLookup' AND COLUMN_NAME = 'QestID') AND
   EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'qestObjects' AND COLUMN_NAME = 'QestID')
BEGIN 
	--Remove invalid parents first
	UPDATE qestReverseLookup SET QestUniqueParentID = Null, QestParentUUID = Null, QestParentID = NULL WHERE QestParentid NOT IN (SELECT qestid FROM qestobjects)
	DELETE FROM qestReverseLookup WHERE qestid NOT IN (SELECT qestid FROM qestobjects)
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

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'DocumentConcreteDiameterAverage')
BEGIN
	UPDATE DocumentConcreteDiameterAverage SET QestOwnerLabNo = 0 WHERE QestOwnerLabNo = 998
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

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'DocumentFracturedFacesSingle')
BEGIN
	UPDATE DocumentFracturedFacesSingle SET QestID = 111249 WHERE ISNULL(QestID, 0) = 0
END

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'DocumentElongatedSingle')
BEGIN
	UPDATE DocumentElongatedSingle SET QestID = 111247 WHERE ISNULL(QestID, 0) = 0
END

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

-- Clear any bad Sample Article references
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'qestReverseLookup' AND COLUMN_NAME = 'SampleArticleUUID')
AND EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Samples' AND COLUMN_NAME = 'QestUUID')
BEGIN
	UPDATE qestReverseLookup SET SampleArticleUUID = NULL
	WHERE NOT EXISTS (SELECT 1 FROM Samples WHERE QestUUID = SampleArticleUUID)
	AND SampleArticleUUID IS NOT NULL
END
GO

-- Correct nullable qestReverseLookup.QestOwnerLabNo
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'qestReverseLookup' AND COLUMN_NAME = 'QestOwnerLabNo' AND IS_NULLABLE = 'YES')
BEGIN
	EXEC qest_DropIndex 'qestReverseLookup', 'IX_qestReverseLookup_QestOwnerLabNo'
	EXEC('UPDATE qestReverseLookup SET QestOwnerLabNo = 0 WHERE QestOwnerLabNo IS NULL')
	EXEC('ALTER TABLE qestReverseLookup ALTER COLUMN QestOwnerLabNo int NOT NULL')
END
GO

--clean-up crappy suitability rule tables
-- SuitabilityRuleConfigurationTestCondition -- replacement table is named "SuitabilityRuleConfigurationTestConditions" (note the "s" at the end)
if exists (select * from information_schema.tables where table_name = 'SuitabilityRuleConfigurationTestCondition')
begin
  if not exists (select * from dbo.SuitabilityRuleConfigurationTestCondition)
  begin
    drop table dbo.SuitabilityRuleConfigurationTestCondition
  end
end
GO

-- MaterialCategoryTestTypeSuitability -- replacement table is named "SuitabilityTestTypeMaterialCategory"
if exists (select * from information_schema.tables where table_name = 'MaterialCategoryTestTypeSuitability')
begin
  if not exists (select * from dbo.MaterialCategoryTestTypeSuitability)
  begin
    drop table dbo.MaterialCategoryTestTypeSuitability
  end
end
GO

--drop QestUniqueID (not needed -- we have QestUUID as the primary key)
if exists (select * from information_schema.columns where table_name = 'SuitabilityRuleConfiguration' and column_name = 'qestUniqueID')
begin
  exec [dbo].[qest_DropIndex] 'SuitabilityRuleConfiguration', 'IX_SuitabilityRuleConfiguration_QestUniqueID'
  alter table SuitabilityRuleConfiguration drop column qestUniqueID;
end
GO

--drop useless FK constraint
if exists (select * from sys.foreign_keys where object_id = object_id(N'[dbo].[FK_SuitabilityRuleConfiguration_SuitabilityRuleConfiguration]') and parent_object_id = object_id(N'[dbo].[SuitabilityRuleConfiguration]'))
  alter table [dbo].[SuitabilityRuleConfiguration] drop constraint [FK_SuitabilityRuleConfiguration_SuitabilityRuleConfiguration]
GO

--rename column from QestID to TestTypeQestID
if exists (select * from information_schema.columns where table_name = 'SuitabilityRuleConfiguration' and column_name = 'QestID')
begin
  if not exists (select * from information_schema.columns where table_name = 'SuitabilityRuleConfiguration' and column_name = 'TestTypeQestID')
  begin
    exec sp_rename 'SuitabilityRuleConfiguration.QestID', 'TestTypeQestID', 'column'
  end
  else
  begin
    exec('update SuitabilityRuleConfiguration set TestTypeQestID = QestID where TestTypeQestID is null and QestID is not null;')
    alter table SuitabilityRuleConfiguration drop column QestID;
  end
end
GO

--drop undesirable unique constraint/index on ListMaterialCategory.Code
if exists(select 1 from information_schema.referential_constraints where constraint_name = 'FK_MaterialCategoryTestTypeSuitability_ListMaterialCategory')
begin
  alter table dbo.MaterialCategoryTestTypeSuitability drop constraint FK_MaterialCategoryTestTypeSuitability_ListMaterialCategory;
end
if exists (select * from sys.indexes where object_id = object_id(N'[dbo].[ListMaterialCategory]') and name = N'IX_ListMaterialCategory_Code' and is_unique_constraint = 1)
begin
  alter table [dbo].[ListMaterialCategory] drop constraint [IX_ListMaterialCategory_Code];
end
GO

-- Clean up funky data in qestReverseLookup.QestOwnerLabNo
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'qestReverseLookup' AND COLUMN_NAME = 'QestOwnerLabNo')
BEGIN
	EXEC('
		IF EXISTS (SELECT * FROM qestReverseLookup WHERE QestOwnerLabNo = -1)
		BEGIN
		  UPDATE qestReverseLookup SET QestOwnerLabNo = NULL WHERE QestOwnerLabNo = -1
		END
	')
END
GO

-- Correct incorrect unique constraint
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'TestStageData' AND CONSTRAINT_NAME = 'IX_TestStageData_QestParentUUID_Idx' AND CONSTRAINT_TYPE = 'UNIQUE')
BEGIN
	ALTER TABLE TestStageData DROP CONSTRAINT IX_TestStageData_QestParentUUID_Idx
END
GO

-- Rename:  TestStageData.Idx to TestStageData.PerformOrder
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TestStageData' AND COLUMN_NAME = 'Idx')
BEGIN
	EXEC sp_rename
		@objname = 'TestStageData.Idx',
		@newname = 'PerformOrder',
		@objtype = 'COLUMN'
END
GO

-- Correct nullable qestReverseLookup.QestOwnerLabNo
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TestStageData' AND COLUMN_NAME = 'PerformOrder' AND IS_NULLABLE = 'YES')
BEGIN 
	EXEC('UPDATE TestStageData SET PerformOrder = 0 WHERE PerformOrder IS NULL')
	EXEC('ALTER TABLE TestStageData ALTER COLUMN PerformOrder int NOT NULL')
END
GO

-- Correct nullable qestTestStage.IsCheckStage
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'qestTestStage' AND COLUMN_NAME = 'IsCheckStage' AND IS_NULLABLE = 'YES')
BEGIN 
	EXEC('UPDATE dbo.qestTestStage SET IsCheckStage = 0 WHERE IsCheckStage IS NULL')
	EXEC('ALTER TABLE dbo.qestTestStage ALTER COLUMN IsCheckStage bit NOT NULL')
END
GO

-- Ensure QestOwnerLabNo - ok to add it NULL will be fixed by upgrade
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'TestStageData')
BEGIN
	IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TestStageData' AND COLUMN_NAME = 'QestOwnerLabNo')
	BEGIN 
		ALTER TABLE dbo.TestStageData ADD QestOwnerLabNo int NULL
	END
END
GO

-- Correction to data type for suitability rule configuration -- float -> real
-- Required for some development databases from when the database template was incorrect during early development.
if exists(select 1 from information_schema.columns where table_schema = 'dbo' and table_name = 'SuitabilityRuleConfiguration' and column_name = 'DefaultDiameter' and data_type = 'float')
begin
  alter table [dbo].[SuitabilityRuleConfiguration] alter column [DefaultDiameter] real null;
end
if exists(select 1 from information_schema.columns where table_schema = 'dbo' and table_name = 'SuitabilityRuleConfiguration' and column_name = 'LengthConstant' and data_type = 'float')
begin
  alter table [dbo].[SuitabilityRuleConfiguration] alter column [LengthConstant] real null;
end
if exists(select 1 from information_schema.columns where table_schema = 'dbo' and table_name = 'SuitabilityRuleConfiguration' and column_name = 'LengthDiameterRatio' and data_type = 'float')
begin
  alter table [dbo].[SuitabilityRuleConfiguration] alter column [LengthDiameterRatio] real null;
end
if exists(select 1 from information_schema.columns where table_schema = 'dbo' and table_name = 'SuitabilityRuleConfiguration' and column_name = 'MinimumAbsoluteLength' and data_type = 'float')
begin
  alter table [dbo].[SuitabilityRuleConfiguration] alter column [MinimumAbsoluteLength] real null;
end
if exists(select 1 from information_schema.columns where table_schema = 'dbo' and table_name = 'SuitabilityRuleConfiguration' and column_name = 'MinimumDiameter' and data_type = 'float')
begin
  alter table [dbo].[SuitabilityRuleConfiguration] alter column [MinimumDiameter] real null;
end
if exists(select 1 from information_schema.columns where table_schema = 'dbo' and table_name = 'SuitabilityRuleConfiguration' and column_name = 'MinimumMass' and data_type = 'float')
begin
  alter table [dbo].[SuitabilityRuleConfiguration] alter column [MinimumMass] real null;
end
if exists(select 1 from information_schema.columns where table_schema = 'dbo' and table_name = 'SuitabilityRuleConfiguration' and column_name = 'TrimmingTolerance' and data_type = 'float')
begin
  alter table [dbo].[SuitabilityRuleConfiguration] alter column [TrimmingTolerance] real null;
end
GO


--Rename column (SamplingDeviceDescription -> SamplingDeviceName)
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'dbo' and TABLE_NAME = 'ListSampleLocation' and COLUMN_NAME = 'SamplingDeviceDescription')
begin
  if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'dbo' and TABLE_NAME = 'ListSampleLocation' and COLUMN_NAME = 'SamplingDeviceName')
  begin
    exec sp_rename 'dbo.ListSampleLocation.SamplingDeviceDescription', 'SamplingDeviceName', 'column'
  end
  else
  begin
    alter table ListSampleLocation drop column SamplingDeviceDescription
  end
end
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'dbo' and TABLE_NAME = 'ListSamplingDevice' and COLUMN_NAME = 'SamplingDeviceDescription')
begin
  if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'dbo' and TABLE_NAME = 'ListSamplingDevice' and COLUMN_NAME = 'SamplingDeviceName')
  begin
    exec sp_rename 'dbo.ListSamplingDevice.SamplingDeviceDescription', 'SamplingDeviceName', 'column'
  end
  else
  begin
    alter table ListSamplingDevice drop column SamplingDeviceDescription
  end
end
GO

-- Bad particle density field fix :-D
if exists(select 1 from information_schema.columns where table_schema = 'dbo' and table_name = 'DocumentParticleDensity' and column_name = 'ContainerCode' and data_type = 'real')
begin
  alter table [dbo].DocumentParticleDensity alter column ContainerCode nvarchar(15) null;
end
go

-- Remove the old laboratory vane table (created in advance for fugro) if it exists
IF EXISTS(select 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'DocumentLaboratoryVane')
BEGIN
	EXEC('
		begin transaction;
	
		declare @docs table (uuid uniqueidentifier);

		insert into @docs (uuid)
		select QestUUID
		from dbo.DocumentLaboratoryVane;

		delete from dbo.DocumentLaboratoryVane;
		delete from dbo.qestReportMapping where TestQestUUID in (select uuid from @docs);
		delete from dbo.qestReverseLookup where QestUUID in (select uuid from @docs);
		
		drop table DocumentLaboratoryVane;
		commit transaction;')
END
GO

-- Change DocumentPocketPenetrometer.ReadingPrecision to nvarchar(50)
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DocumentPocketPenetrometer' AND COLUMN_NAME = 'ReadingPrecision')
BEGIN
	ALTER TABLE dbo.DocumentPocketPenetrometer ALTER COLUMN ReadingPrecision nvarchar(50)
END
GO

-- Change DocumentTorvane.ReadingPrecision to nvarchar(50)
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DocumentTorvane' AND COLUMN_NAME = 'ReadingPrecision')
BEGIN
	ALTER TABLE dbo.DocumentTorvane ALTER COLUMN ReadingPrecision nvarchar(50)
END
GO

--Change DocumentConcreteDestructive.ReturnedLoad to real
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'DocumentConcreteDestructive' AND COLUMN_NAME = 'ReturnedLoad' AND DATA_TYPE = 'int')
BEGIN
	ALTER TABLE [dbo].[DocumentConcreteDestructive] ALTER COLUMN [ReturnedLoad] real NULL;
END
GO

-- Remove incorrectly named Primary Key so that structure update can re-create it
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = 'PK_TestAnalysisTriaxial_1' AND CONSTRAINT_TYPE = 'PRIMARY KEY')
BEGIN
	IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS WHERE CONSTRAINT_NAME = 'FK_DocumentTriaxial_TestAnalysisTriaxial')
	BEGIN
		ALTER TABLE DocumentTriaxial DROP CONSTRAINT FK_DocumentTriaxial_TestAnalysisTriaxial
	END

	ALTER TABLE TestAnalysisTriaxial DROP CONSTRAINT PK_TestAnalysisTriaxial_1
END
GO

-- Ensure old audit trigger has been removed
IF OBJECT_ID('TR_AuditTrail_SetKeyUID', 'TR') IS NOT NULL
	DROP TRIGGER TR_AuditTrail_SetKeyUID
GO

-- Remove old Audit constraint
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS WHERE CONSTRAINT_NAME = 'FK_qestReverseLookup_AuditTrail')
BEGIN
	ALTER TABLE AuditTrail DROP CONSTRAINT FK_qestReverseLookup_AuditTrail
END
GO

-- Add QestParentID column to Equipment
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Equipment')
BEGIN
	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE [name] = N'QestParentID' AND [object_id] = OBJECT_ID(N'Equipment'))
	BEGIN
		ALTER TABLE Equipment ADD QestParentID INT NULL
	END
	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE [name] = N'QestUniqueParentID' AND [object_id] = OBJECT_ID(N'Equipment'))
	BEGIN
		ALTER TABLE Equipment ADD QestUniqueParentID INT NULL
	END
END
GO

-- Add QestID Column to Equipment
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Equipment')
BEGIN
	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE [name] = N'QestID' AND [object_id] = OBJECT_ID(N'Equipment'))
	BEGIN
		ALTER TABLE Equipment ADD QestID int NOT NULL
	END
END
GO

-- Add QestID Column to QestObject
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'qestobject')
BEGIN
	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE [name] = N'QestID' AND [object_id] = OBJECT_ID(N'qestobject'))
	BEGIN
		ALTER TABLE qestobject ADD QestID int NOT NULL
	END
END
GO

-- Add QestID Column to WorkTemplates
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'WorkTemplates')
BEGIN
	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE [name] = N'QestID' AND [object_id] = OBJECT_ID(N'WorkTemplates'))
	BEGIN
		ALTER TABLE WorkTemplates ADD QestID int NOT NULL
	END
END
GO

--Add QestID Column to DocumentConcreteRoundSingle, alter if exists
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'DocumentConcreteRoundSingle')
BEGIN
	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE [name] = N'QestID' AND [object_id] = OBJECT_ID(N'DocumentConcreteRoundSingle'))
	BEGIN
		ALTER TABLE DocumentConcreteRoundSingle ADD QestID INT NOT NULL
	END ELSE
	BEGIN
		ALTER TABLE documentconcreteroundsingle ALTER COLUMN QestID INT NOT NULL
	END
END
GO

-- QestID Fix for Record Tables
-- Creates QestID column if it doesn't exist and sets null or zero QestIDs to the correct value
IF OBJECT_ID('qest_FixRecordQestID_TEMP', 'P') IS NOT NULL
	DROP PROCEDURE qest_FixRecordQestID_TEMP
GO

CREATE PROCEDURE qest_FixRecordQestID_TEMP 
    @TableName nvarchar(128), 
    @QestID int
AS 
BEGIN
	DECLARE @SQL nvarchar(max)
    IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = @TableName)
	BEGIN
		IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE [name] = N'QestID' AND [object_id] = OBJECT_ID(@TableName))
		BEGIN
			Set @SQL = 'ALTER TABLE ' + @TableName + ' ADD QestID int null'
			EXEC(@SQL)
		END
		Set @SQL = 'UPDATE ' + @TableName + ' SET QestID = ' + CAST(@QestID AS VARCHAR(16)) + ' WHERE ISNULL(QestID,0) = 0'
		EXEC(@SQL)
	END
END
GO

EXEC qest_FixRecordQestID_TEMP 'SpecificationRecords', 70002
GO
EXEC qest_FixRecordQestID_TEMP 'DocumentAsphaltBulkDensitySingle', 111235
GO
EXEC qest_FixRecordQestID_TEMP 'DocumentAsphaltResModulusRecords', 111236
GO
EXEC qest_FixRecordQestID_TEMP 'documentbenkelmanbeam', 111238
GO
EXEC qest_FixRecordQestID_TEMP 'DocumentCalibrationBalanceDataSingle', 32001
GO
EXEC qest_FixRecordQestID_TEMP 'DocumentCalibrationBalanceRepeatabilitySingle', 32002
GO
EXEC qest_FixRecordQestID_TEMP 'DocumentCalibrationBalanceSinglePointSingle', 32003
GO
EXEC qest_FixRecordQestID_TEMP 'DocumentCaliforniaBearingRatioSingle', 111212
GO
EXEC qest_FixRecordQestID_TEMP 'DocumentDynamicConePenetrometerBlows', 111246
GO
EXEC qest_FixRecordQestID_TEMP 'DocumentLosAngelesValueSingle', 111252
GO
EXEC qest_FixRecordQestID_TEMP 'DocumentSofteningPointRecords', 111263
GO
EXEC qest_FixRecordQestID_TEMP 'DocumentStabilisationAgentCalSingle', 111265
GO
EXEC qest_FixRecordQestID_TEMP 'DocumentStabilisationAgentContSingle', 111266
GO
EXEC qest_FixRecordQestID_TEMP 'DocumentTextureSingle', 111268
GO
EXEC qest_FixRecordQestID_TEMP 'DocumentViscosityOfEmulsionSingle', 111272
GO
EXEC qest_FixRecordQestID_TEMP 'DocumentWeatheringQualityCycles', 111274
GO
EXEC qest_FixRecordQestID_TEMP 'DocumentAggSoilDispersionSingle', 111234
GO
EXEC qest_FixRecordQestID_TEMP 'DocumentCalibrationNGConsistencyASSingle', 32004
GO
EXEC qest_FixRecordQestID_TEMP 'DocumentCalibrationNGConsistencySingle', 32005
GO
EXEC qest_FixRecordQestID_TEMP 'DocumentCalibrationNuclearGaugeSingle', 32006
GO
EXEC qest_FixRecordQestID_TEMP 'DocumentUncCompStrenSummarySingle', 111270
GO
EXEC qest_FixRecordQestID_TEMP 'DocumentShrinkSwellSingle', 111277
GO
EXEC qest_FixRecordQestID_TEMP 'DocumentRandomSiteLocationSingle', 111257
GO
EXEC qest_FixRecordQestID_TEMP 'DocumentRockPointLoadSamples', 111259
GO
EXEC qest_FixRecordQestID_TEMP 'DocumentRockPorositySpecimen', 111260
GO
EXEC qest_FixRecordQestID_TEMP 'DocumentRockStrengthUniaxialSpecimen', 111261
GO
EXEC qest_FixRecordQestID_TEMP 'DocumentMaximumDryCSSpecimen', 111253
GO
EXEC qest_FixRecordQestID_TEMP 'DocumentMoistureCorrelationSingle', 111254
GO
EXEC qest_FixRecordQestID_TEMP 'DocumentDegradationFactorSpecimen', 111244
GO
EXEC qest_FixRecordQestID_TEMP 'DocumentSampleTransferRequestSingle', 42001
GO
EXEC qest_FixRecordQestID_TEMP 'DocumentHveemStabilitySingle', 111230
GO
EXEC qest_FixRecordQestID_TEMP 'DocumentSodiumSulphateSUSASingle', 111231
GO
EXEC qest_FixRecordQestID_TEMP 'DocumentConcreteVaporEmissionSpecimen', 111232
GO
EXEC qest_FixRecordQestID_TEMP 'DocumentConcreteShrinkageSpecimen', 111100
GO
EXEC qest_FixRecordQestID_TEMP 'DocumentLayerThicknessSingle', 111251
GO
EXEC qest_FixRecordQestID_TEMP 'DocumentPermeabilityTest', 111255
GO
EXEC qest_FixRecordQestID_TEMP 'DocumentSpallLithologicalSingle', 111264
GO

IF OBJECT_ID('qest_FixRecordQestID_TEMP', 'P') IS NOT NULL
BEGIN
	DROP PROCEDURE qest_FixRecordQestID_TEMP
END
GO

-- Change InspectionRadiographic.IqiMin to real
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'InspectionRadiographic' AND COLUMN_NAME = 'IqiMin' AND DATA_TYPE = 'int')
BEGIN
	ALTER TABLE dbo.InspectionRadiographic ALTER COLUMN IqiMin real
END
GO

-- Change InspectionRadiographic.IqiMax to real
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'InspectionRadiographic' AND COLUMN_NAME = 'IqiMax' AND DATA_TYPE = 'int')
BEGIN
	ALTER TABLE dbo.InspectionRadiographic ALTER COLUMN IqiMax real
END
GO

--Change InspectionRadiographic.Iqi to nvarchar(20)
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'InspectionRadiographic' AND COLUMN_NAME = 'Iqi' AND DATA_TYPE = 'int')
BEGIN
	ALTER TABLE dbo.InspectionRadiographic ALTER COLUMN Iqi nvarchar(20)
END
GO

--InspectionJobSafety: rename column from PlotSurfaces to HotSurfaces
IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'InspectionJobSafety' AND COLUMN_NAME = 'PlotSurfaces')
BEGIN
  IF NOT EXISTS(SELECT 1 from INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'InspectionJobSafety' AND COLUMN_NAME = 'HotSurfaces')
  BEGIN
    EXEC sp_rename 'dbo.InspectionJobSafety.PlotSurfaces', 'HotSurfaces', 'COLUMN'
  END
  ELSE
  BEGIN
    ALTER TABLE dbo.InspectionJobSafety DROP COLUMN PlotSurfaces
  END
END
GO

IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'InspectionRadiographicReader' AND COLUMN_NAME = 'Strength')
BEGIN
	alter table InspectionRadiographicReader alter column Strength real
END
GO
