

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
DELETE FROM qestTestStage WHERE TestStageQestID NOT IN (SELECT QestID FROM TestStageData)

-- Fix any duplicate test stage indexes if the unique index is not in place (shifts them up to high number to be corrected in later script)
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name = 'IX_qestTestStage_TestQestID_Idx' AND is_unique = 1)
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

