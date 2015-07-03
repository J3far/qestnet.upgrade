
-- No longer required
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_GetDocumentIdByBarcode' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
    DROP PROCEDURE [dbo].[qest_GetDocumentIdByBarcode]
    PRINT 'Removed procedure: qest_GetDocumentIdByBarcode'
END
GO

-- No longer required
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_GetChildStatusFlags' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
    DROP PROCEDURE [dbo].[qest_GetChildStatusFlags]
    PRINT 'Removed procedure: qest_GetChildStatusFlags'
END
GO

IF OBJECT_ID('TR_DocumentTimekeepingRecords_RL', 'TR') IS NOT NULL
BEGIN
	DROP TRIGGER TR_DocumentTimekeepingRecords_RL
	PRINT 'Removed trigger: TR_DocumentTimekeepingRecords_RL'
END
GO

IF OBJECT_ID('TR_DocumentConcreteDestructiveSpecimen_RL', 'TR') IS NOT NULL
BEGIN
	DROP TRIGGER TR_DocumentConcreteDestructiveSpecimen_RL
	PRINT 'Removed trigger: TR_DocumentConcreteDestructiveSpecimen_RL'
END
GO

IF OBJECT_ID('TR_DocumentPSDHydrometer_RL', 'TR') IS NOT NULL
BEGIN
	DROP TRIGGER TR_DocumentPSDHydrometer_RL
	PRINT 'Removed trigger: TR_DocumentPSDHydrometer_RL'
END
GO

IF OBJECT_ID('TR_DocumentAtterbergLimitsSpecimen_RL', 'TR') IS NOT NULL
BEGIN
	DROP TRIGGER TR_DocumentAtterbergLimitsSpecimen_RL
	PRINT 'Removed trigger: TR_DocumentAtterbergLimitsSpecimen_RL'
END
GO

IF OBJECT_ID('TR_DocumentAtterbergLimitsCPSpecimens_RL', 'TR') IS NOT NULL
BEGIN
	DROP TRIGGER TR_DocumentAtterbergLimitsCPSpecimens_RL
	PRINT 'Removed trigger: TR_DocumentAtterbergLimitsCPSpecimens_RL'
END
GO

IF OBJECT_ID('TR_DocumentTriaxialSingleReading_RL', 'TR') IS NOT NULL
BEGIN
	DROP TRIGGER TR_DocumentTriaxialSingleReading_RL
	PRINT 'Removed trigger: TR_DocumentTriaxialSingleReading_RL'
END
GO

IF OBJECT_ID('TR_DocumentAtterbergLimitsSpecimen_RL', 'TR') IS NOT NULL
	DROP TRIGGER TR_DocumentAtterbergLimitsSpecimen_RL
	PRINT 'Removed trigger: TR_DocumentAtterbergLimitsSpecimen_RL'
GO

IF OBJECT_ID('TR_DocumentAtterbergLimitsCPSpecimens_RL', 'TR') IS NOT NULL
	DROP TRIGGER TR_DocumentAtterbergLimitsCPSpecimens_RL
	PRINT 'Removed trigger: TR_DocumentAtterbergLimitsCPSpecimens_RL'
GO

IF OBJECT_ID('TR_DocumentConcreteShrinkageSpecimen_RL', 'TR') IS NOT NULL
	DROP TRIGGER TR_DocumentConcreteShrinkageSpecimen_RL
	PRINT 'Removed trigger: TR_DocumentConcreteShrinkageSpecimen_RL'
GO


