
-- FIXME:  Need to figure out how to resolve these properly!!
DELETE FROM DocumentExternal WHERE QestID = 18230 AND QestParentID = 20002
DELETE FROM qestReportMapping WHERE TestQestID = 18230
DELETE FROM qestReverseLookup WHERE QestID = 18230 AND QestParentID = 20002
GO

-- QEST OBEJCTS
-- Post any missing QestIDs that already exist in the qestObjects table (possible is old databases)
INSERT INTO qestObject (QestID) SELECT DISTINCT QestID FROM qestObjects WHERE NOT QestID IN (SELECT QestID FROM qestObject)
GO

-- LABORATORY MAPPINGS
EXEC dbo.qest_UpdateLaboratoryMappings


-- BARCODE REGISTER
-- Ensure BarcodeRegister.RefQestUUID is set for documents with a qestReverseLookup match
UPDATE BarcodeRegister SET RefQestUUID = R.QestUUID FROM BarcodeRegister B
INNER JOIN qestReverseLookup R ON B.RefQestID = R.QestID AND B.RefQestUniqueID = R.QestUniqueID
WHERE B.RefQestUUID IS NULL
GO
-- Ensure BarcodeRegister.RefQestUUID is set for documents with a Sample match
UPDATE BarcodeRegister SET RefQestUUID = S.QestUUID FROM BarcodeRegister B
INNER JOIN Samples S ON B.RefQestID = S.QestID AND B.RefQestUniqueID = S.QestUniqueID
WHERE B.RefQestUUID IS NULL
GO
-- Ensure BarcodeRegister.RefQestUUID is set for documents with a Person match
UPDATE BarcodeRegister SET RefQestUUID = P.QestUUID FROM BarcodeRegister B
INNER JOIN People P ON B.RefQestID = P.QestID AND B.RefQestUniqueID = P.QestUniqueID
WHERE B.RefQestUUID IS NULL
GO


-- AUDIT TRAIL
-- For a given QestUUID generate the new-format audit key.  Returns null if the object doesn't exists in qestReverseLookup.
-- Format:   QestID_A:QestUUID_A|QestID_B:QestUUID_B|QestID_C:QestUUID_C  (where A is parent of B is parent of C)
-- UUIDs are in their natural cast and QestIDs are not zero padded to any particular length
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_AuditKeyForUUID' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'FUNCTION')
BEGIN
    DROP FUNCTION dbo.qest_AuditKeyForUUID
END
GO

CREATE FUNCTION dbo.qest_AuditKeyForUUID (@QestUUID uniqueidentifier)
RETURNS nvarchar(max)
BEGIN
	DECLARE @Result AS nvarchar(max);

  	WITH R AS 
	(
		SELECT QestID, QestUUID, QestParentUUID, CAST(RIGHT('00000000' + CAST(QestID As nvarchar(12)), 8) + ':' + CAST(QestUUID AS nvarchar(50)) + '|' AS nvarchar(max)) AS ObjectKey
		FROM qestReverseLookup WHERE QestUUID = @QestUUID
		UNION ALL
		SELECT P.QestID, P.QestUUID, P.QestParentUUID, CAST(RIGHT('00000000' + CAST(P.QestID As nvarchar(12)), 8) + ':' + CAST(P.QestUUID AS nvarchar(50)) + '|' + R.ObjectKey AS nvarchar(max)) AS ObjectKey 
		FROM qestReverseLookup P JOIN R ON P.QestUUID = R.QestParentUUID
	)
	
	SELECT TOP 1 @Result = ObjectKey FROM R ORDER BY LEN(ObjectKey) DESC
	RETURN @Result
END
GO

-- Set UUID for Object if we can figure it out - only applied to QF2/QF3 audit rows which had a ObjectQestUniqueID column
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'AuditTrail' AND COLUMN_NAME = 'ObjectQestUniqueID')
BEGIN 
	UPDATE A SET ObjectQestUUID = R.QestUUID 
	FROM AuditTrail A 
	INNER JOIN qestReverseLookup R ON R.QestID = A.QestID AND R.QestUniqueID = A.ObjectQestUniqueID 
	WHERE A.ObjectQestUUID IS NULL
END
GO

-- Update old object keys (TEST SPEED! - may need to mandate Audit Archive before running)
UPDATE AuditTrail SET ObjectKey = dbo.qest_AuditKeyForUUID(ObjectQestUUID) 
WHERE ObjectQestUUID IS NOT NULL AND (ObjectKey IS NULL OR ObjectKey LIKE 'ID%')
GO

-- If no key can be created from reverse lookups just combine the QestID & ObjectQestUUID in the row already
UPDATE AuditTrail SET ObjectKey = RIGHT('00000000' + CAST(QestID As nvarchar(12)), 8) + ':' + CAST(ObjectQestUUID AS nvarchar(50)) + '|'
WHERE ObjectKey IS NULL AND ObjectQestUUID IS NOT NULL
GO

-- Samples.SampleType
if exists(select * from Samples where SampleType is null)
begin
  update Samples set Disturbed = 0 where Disturbed is null;
  update Samples set SampleType = 0 where Disturbed = 0 and (SampleType is null or SampleType <> 0);
  update Samples set SampleType = 1 where Disturbed = 1 and (SampleType is null or SampleType = 0);
end
GO
