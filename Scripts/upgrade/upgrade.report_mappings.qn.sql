
-- Ensure TestQestUUID & ReportQestUUID
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'qestReportMapping')
BEGIN
	IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'qestReportMapping' AND COLUMN_NAME = 'TestQestUUID')
	BEGIN 
		ALTER TABLE qestReportMapping ADD TestQestUUID uniqueidentifier NULL 
	END

	IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'qestReportMapping' AND COLUMN_NAME = 'ReportQestUUID')
	BEGIN 
		ALTER TABLE qestReportMapping ADD ReportQestUUID uniqueidentifier NULL 
	END
END
GO	

-- Set TestQestUUID from qestReverseLookups	
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'qestReportMapping' AND COLUMN_NAME = 'TestQestUUID')
BEGIN
	UPDATE M SET TestQestUUID = R.QestUUID FROM qestReportMapping M 
	INNER JOIN qestReverseLookup R ON R.QestID = M.TestQestID AND R.QestUniqueID = M.TestQestUniqueID 
	WHERE M.TestQestUUID IS NULL
	
	-- Any report mapping without a test is invalid  (REVIEW)
	DELETE FROM qestReportMapping WHERE TestQestUUID IS NULL
	
	ALTER TABLE qestReportMapping ALTER COLUMN TestQestUUID uniqueidentifier NOT NULL
END
GO

-- Set ReportQestUUID from qestReverseLookups	
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'qestReportMapping' AND COLUMN_NAME = 'ReportQestUUID')
BEGIN
	UPDATE M SET ReportQestUUID = R.QestUUID FROM qestReportMapping M 
	INNER JOIN qestReverseLookup R ON R.QestID = M.ReportQestID AND R.QestUniqueID = M.ReportQestUniqueID 
	WHERE M.ReportQestUUID IS NULL

	-- Any report mapping where the QestUUID cannot be determined  (REVIEW)	
	DELETE FROM qestReportMapping WHERE ReportQestUUID IS NULL AND NOT (ReportQestID IS NULL OR ReportQestUniqueID IS NULL)
END
GO

-- Add Index on TestQestUUID. Added here in order to allow the 'WHERE' clause in the index.
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[qestReportMapping]') AND name = N'IX_qestReportMapping_TestQestUUID')
DROP INDEX [IX_qestReportMapping_TestQestUUID] ON [dbo].[qestReportMapping]
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'qestReportMapping')
AND NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[qestReportMapping]') AND name = N'IX_qestReportMapping_TestQestUUID')
CREATE NONCLUSTERED INDEX [IX_qestReportMapping_TestQestUUID] ON [dbo].[qestReportMapping]
(
	[TestQestUUID] ASC
)
INCLUDE ( 	[ReportQestID],
	[TestQestID],
	[ReportQestUniqueID],
	[TestQestUniqueID],
	[Mapping]) 
WHERE ([TestQestUUID] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

