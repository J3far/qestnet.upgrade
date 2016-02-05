
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
	EXEC('UPDATE A SET ObjectQestUUID = R.QestUUID 
	FROM AuditTrail A 
	INNER JOIN qestReverseLookup R ON R.QestID = A.QestID AND R.QestUniqueID = A.ObjectQestUniqueID 
	WHERE A.ObjectQestUUID IS NULL')
END
GO

-- AuditTrail.QestUniqueParentID no longer required
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'AuditTrail' AND COLUMN_NAME = 'QestUniqueParentID')
BEGIN
	ALTER TABLE dbo.AuditTrail DROP COLUMN QestUniqueParentID
END
GO

-- AuditTrail.ObjectQestUniqueID no longer required
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'AuditTrail' AND COLUMN_NAME = 'ObjectQestUniqueID')
BEGIN
	EXEC qest_DropIndex 'AuditTrail', 'IX_AuditTrail_QestIDObjectQestUniqueID'
	ALTER TABLE dbo.AuditTrail DROP COLUMN ObjectQestUniqueID
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

-- Remove duplicate rows in qestReportMapping
IF EXISTS(SELECT 1 FROM qestReportMapping GROUP BY ReportQestID,ReportQestUniqueID,TestQestID,TestQestUniqueID,Mapping HAVING COUNT(*) > 1)
BEGIN
	DELETE FROM qestReportMapping WHERE QestUniqueID NOT IN (SELECT MIN(QestUniqueID) FROM qestReportMapping GROUP BY ReportQestID,ReportQestUniqueID,TestQestID,TestQestUniqueID,Mapping)
END 
GO

-- Set UTCTime to true for 4.0 onwards
IF EXISTS(SELECT 1 FROM Options WHERE OptionName = 'UTCTime')
BEGIN
	UPDATE Options SET OptionValue = 'True' WHERE OptionName = 'UTCTime'
END
ELSE
BEGIN
	INSERT INTO Options(OptionKey,OptionValue,OptionName) Values ('\QLO\QESTLAB\UTCTime','True','UTCTime')
END
GO

-- Patch report pictures created with QESTNET ID 90201 over to the QESTLab ID 111278, for compatibility purposes
-- As report pictures are childless, and these two object IDs are stored the same way, this can be done by straightforward substitution.
IF EXISTS(SELECT 1 From QestReverseLookup WHERE QestID = 90201) OR EXISTS(SELECT 1 FROM DocumentCertificatesPictures WHERE QestID = 90201)
BEGIN
	UPDATE DocumentCertificatesPictures SET QestID = 111278 WHERE QestID = 90201

	UPDATE qestReverseLookup SET QestID = 111278 WHERE QestID = 90201

	UPDATE AuditTrail SET QestID = 111278, 
                          ObjectKey = CASE WHEN ObjectKey Like 'ID%' -- old object key format
                                           THEN LEFT(ObjectKey,Len(ObjectKey)-16) + '00111278' + RIGHT(ObjectKey,8)
                                      ELSE REPLACE(ObjectKey,'00090201:','00111278:') -- new object key format
                                      END
	WHERE QestID = 90201
END
GO

-- Patches required for existing ASTM RC screens to maintain compatibility with new screen design
-- Create missing density / unit weight values for ASTM proctors created under previous screen.
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DocumentMaximumDryDensity' AND COLUMN_NAME = 'MaximumDryDensity')
 AND EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DocumentMaximumDryDensity' AND COLUMN_NAME = 'MaximumDryUnitWeight')
 AND EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DocumentMaximumDryDensity' AND COLUMN_NAME = 'AdjustedMDD')
 AND EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DocumentMaximumDryDensity' AND COLUMN_NAME = 'AdjustedMDUW')
 BEGIN
	-- ASTM metric proctors - find Density (t/m3) from known Unit Weight (kN/m3)
	UPDATE DocumentMaximumDryDensity SET MaximumDryDensity = (MaximumDryUnitWeight / 9.80665), AdjustedMDD = (AdjustedMDUW / 9.80665) WHERE QestID IN (110401, 110403, 110411, 110412) AND coalesce(MaximumDryDensity,AdjustedMDD) is null  AND coalesce(MaximumDryUnitWeight, AdjustedMDUW) is not null
	
	-- ASTM non-metric proctors - copy Unit Weight from known Density (numerically equivalent due to units)
	UPDATE DocumentMaximumDryDensity SET MaximumDryUnitWeight = MaximumDryDensity, AdjustedMDUW = AdjustedMDD WHERE QestID IN (110032, 110033, 110036, 110037, 110043, 110048, 110052, 110053, 110079, 110084, 110377, 110378) AND coalesce(MaximumDryDensity,AdjustedMDD) is not null  AND coalesce(MaximumDryUnitWeight, AdjustedMDUW) is null
END
GO

-- Set 'Enter Oversize' to 1 if null
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DocumentAggSoilCompaction' AND COLUMN_NAME = 'EnterOversize')
BEGIN
	-- The original intention was to only set EnterOversize to 1 if any oversize field contained a value
	-- However, the impact on execution time (7m30s vs. 5s) and the low number of cases where this distinction would have any meaning (128 out of 1.04 million)
	--  make it better to set this to 1 for all pre-existing screens, as there's no harm in doing so.
	UPDATE DocumentAggSoilCompaction SET EnterOversize = 1 WHERE EnterOversize is null AND (QestID in (110201, 110202, 110404))	
END
GO
-- End ASTM RC patches

-- Patch to fix report issue numbers incorrectly set to 1 by QESTNET when never signed
UPDATE DC SET DC.IssueNo = 0 
FROM DocumentCertificates DC WHERE DC.IssueNo = 1 and DC.SignatoryDate IS NULL AND 
NOT EXISTS (SELECT 1 FROM DocumentArchivedTestReports DATR WHERE DATR.QestUniqueParentID = DC.QestUniqueID and DATR.QestParentID = DC.QestID)
UPDATE DE SET DE.IssueNo = 0 
FROM DocumentExternal DE WHERE DE.IssueNo = 1 and DE.SignatoryDate IS NULL AND 
NOT EXISTS (SELECT 1 FROM DocumentArchivedTestReports DATR WHERE DATR.QestUniqueParentID = DE.QestUniqueID and DATR.QestParentID = DE.QestID)
GO

-- Correct Report Mapping UUIDs created prior to a bug fix in QESTLab's QLO > Certificate.cls
update m set m.TestQestUUID = l.QestUUID
from qestReportMapping m
	inner join qestReverseLookup l on l.QestID = m.TestQestID and l.QestUniqueID = m.TestQestUniqueID
where m.TestQestUUID <> l.QestUUID
go

update m set m.ReportQestUUID = l.QestUUID
from qestReportMapping m
	inner join qestReverseLookup l on l.QestID = m.ReportQestID and l.QestUniqueID = m.ReportQestUniqueID
where m.ReportQestUUID <> l.QestUUID
	and m.ReportQestID is not null
	and m.ReportQestUniqueID is not null
go

--- WORK ORDER TIME STAMP PATCHES ---

-- Fix Work Order Duration where negative (QESTLab used to set this negative when StartTime/FinishTime crossed midnight - we now take FinishTime to be next day).
UPDATE WorkOrders SET
	Duration = Duration + 24
WHERE Duration is not null and Duration < 0

-- Combine WorkDate and StartTime to get a datetime stamp for when work commences. Will not change date component of WorkDate or time component of StartTime.
-- Only apply when StartTime's date has not been set.
UPDATE WorkOrders SET 
	StartTime = DATEADD(day, 0, DATEDIFF(day, 0, WorkDate)) + DATEADD(day, 0 - DATEDIFF(day, 0, StartTime), StartTime),
	WorkDate = DATEADD(day, 0, DATEDIFF(day, 0, WorkDate)) + DATEADD(day, 0 - DATEDIFF(day, 0, StartTime), StartTime),
	FinishTime = CASE WHEN COALESCE(Duration,0) = 0 THEN
					--If no Duration is stored, we must assume that FinishTime is
						-- on the same day if FinishTime >= StartTime
						-- on the next day if FinishTime < StartTime (eg. 23:00 -> 00:45)
					DATEADD(day, 0, DATEDIFF(day, 0, WorkDate)) + CASE WHEN StartTime > FinishTime THEN 1 ELSE 0 END  + DATEADD(day, 0 - DATEDIFF(day, 0, FinishTime), FinishTime)
				ELSE 
					-- If we have Duration (in hours), add to Starttime to get FinishTime.
					DATEADD(hour, Duration, DATEADD(day, 0, DATEDIFF(day, 0, WorkDate)) + DATEADD(day, 0 - DATEDIFF(day, 0, StartTime), StartTime))
				END
where WorkDate is not null and StartTime is not null and StartTime <= '1901-01-01'

-- Now we have StartTime/FinishTime sorted out, fix Duration where null or 0.
UPDATE WorkOrders SET
	Duration = CAST((FinishTime - StartTime) as real) * 24.0
WHERE COALESCE(Duration,0) = 0 AND StartTime is not null AND FinishTime is not null

--- END WORK ORDER TIME STAMP PATCHES ---