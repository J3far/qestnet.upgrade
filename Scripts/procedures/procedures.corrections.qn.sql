
-- Updating GetWorkflow
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_do_GetWorkflow' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
    DROP PROCEDURE [dbo].[qest_do_GetWorkflow]
END
GO

-- Updating GetWorkflows
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_do_GetWorkflows' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
    DROP PROCEDURE [dbo].[qest_do_GetWorkflows]
END
GO

-- Updating getWorkflowStages
-- Procedure for returning workflow stages of a workflow
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_do_GetWorkflowStages' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
    DROP PROCEDURE [dbo].[qest_do_GetWorkflowStages]
END
GO

-- GetViewDetails
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_do_GetViewDetails' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
    DROP PROCEDURE [dbo].[qest_do_GetViewDetails]
END
GO

-- GetDisplayObjectCollectionByViewID
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_do_GetDisplayObjectCollectionByViewID' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
    DROP PROCEDURE [dbo].[qest_do_GetDisplayObjectCollectionByViewID]
END
GO

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_do_GetDisplayObjectCollectionByViewID_WithLength' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
    DROP PROCEDURE [dbo].qest_do_GetDisplayObjectCollectionByViewID_WithLength
END
GO

-- GetViewByName
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_do_GetViewByName' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
    DROP PROCEDURE [dbo].[qest_do_GetViewByName]
END
GO

-- CSV table function - used in work orders requiring correction procedure below
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'CSVTable' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'FUNCTION')
BEGIN
    DROP FUNCTION [dbo].[CSVTable]
END
GO

-- Procedure for business rule names
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_GetRuleTypeNames' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
    DROP PROCEDURE [dbo].[qest_GetRuleTypeNames]
END
GO

-- Ensures TestStageData have the correct QestUniqueParentID value
IF OBJECT_ID('TR_TestStageData_Insert_ParentUniqueID', 'TR') IS NOT NULL
	DROP TRIGGER TR_TestStageData_Insert_ParentUniqueID
GO

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_UserDocumentBaseInitialise' AND ROUTINE_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
	DROP PROCEDURE [dbo].[qest_UserDocumentBaseInitialise]
END
GO

CREATE PROC dbo.qest_UserDocumentBaseInitialise @QestID int = 0
AS
	-- TODO: Remove calls to this proc from QL
GO

-- Remove UserDocumentBase triggers
IF NOT OBJECT_ID('TR_DocumentExternal_TableSync_Delete', 'TR') IS NULL
	DROP TRIGGER TR_DocumentExternal_TableSync_Delete
GO
IF NOT OBJECT_ID('TR_DocumentExternal_TableSync_Insert', 'TR') IS NULL
	DROP TRIGGER TR_DocumentExternal_TableSync_Insert
GO
IF NOT OBJECT_ID('TR_DocumentExternal_TableSync_Update', 'TR') IS NULL
	DROP TRIGGER TR_DocumentExternal_TableSync_Update
GO

-- Remove qestReverseLookup Insert UniqueIDs trigger
IF NOT OBJECT_ID('TR_qestReverseLookup_Insert_UniqueIDs', 'TR') IS NULL
	DROP TRIGGER TR_qestReverseLookup_Insert_UniqueIDs
GO

