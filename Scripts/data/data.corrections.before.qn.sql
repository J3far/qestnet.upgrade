

-- Should be no permanent data in SessionLocks
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'SessionLocks')
BEGIN 
	DELETE FROM SessionLocks
END
GO

-- Should be no permanent data in SessionConnections
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'SessionConnections')
BEGIN 
	DELETE FROM SessionConnections
END
GO

-- Delete any stage definitions not in use - genuine ones will be added again in later script
if exists (select * from information_schema.tables where table_name = 'qestTestStage')
  and exists (select * from information_schema.tables where table_name = 'TestStageData')
  and exists (select * from information_schema.tables where table_name = 'LTP_PlannedTestStages')
begin
  DELETE FROM qestTestStage 
  WHERE TestStageQestID NOT IN (SELECT QestID FROM TestStageData)
  AND TestStageQestID NOT IN (SELECT TestStageQestID FROM LTP_PlannedTestStages)
end
GO

-- Fix any duplicate test stage indexes if the unique index is not in place (shifts them up to high number to be corrected in later script)
if exists (select * from information_schema.tables where table_name = 'qestTestStage')
  and NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name = 'IX_qestTestStage_TestQestID_Idx' AND is_unique = 1)
BEGIN 
	UPDATE T SET Idx = 9999 + S.Idx + S.rk
	FROM qestTestStage T INNER JOIN
	(
		SELECT TestStageQestID, TestQestID, Idx,
		ROW_NUMBER() OVER(PARTITION BY TestQestID, Idx ORDER BY TestStageQestID) AS rk
		FROM qestTestStage
	) S
	ON T.TestStageQestID = S.TestStageQestID
	WHERE S.rk > 1
END

-- Correct QestID for specimen table with QestID column already present
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'DocumentAsphaltPrepCompactionSingle')
BEGIN
	UPDATE DocumentAsphaltPrepCompactionSingle SET QestID = 111233 WHERE QestID <= 0
END 

-- Delete any Users without an associated Person
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Users')
BEGIN
	IF EXISTS(SELECT 1 FROM Users WHERE PersonID NOT IN (SELECT qestUniqueID FROM People) OR PersonID IS NULL)
	BEGIN
	  DELETE FROM Users WHERE PersonID NOT IN (SELECT qestuniqueID FROM People) OR PersonID IS NULL
	END
END
GO

--Replace null QestOwnerLabNo with 0 (global) for ListClient
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ListClient')
BEGIN
	UPDATE [dbo].[ListClient] SET QestOwnerLabNo = 0 WHERE QestOwnerLabNo IS NULL
END
GO

--Drops the IX_Equipment_QestOwnerLabNo to allow nullable QestOwnerLabNo to be changed to Non-Nullable
IF EXISTS(SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_Equipment_QestOwnerLabNo')
BEGIN
      DROP INDEX Equipment.IX_Equipment_QestOwnerLabNo
END
GO

