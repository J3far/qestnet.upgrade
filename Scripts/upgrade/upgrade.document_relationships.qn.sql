IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'qestReverseLookup' AND COLUMN_NAME = 'QestParentUUID')
BEGIN
	IF NOT OBJECT_ID('TR_qestReverseLookup_Update_Parent', 'TR') IS NULL
	BEGIN
		DISABLE TRIGGER TR_qestReverseLookup_Update_Parent ON qestReverseLookup
		PRINT 'Enabled trigger: TR_qestReverseLookup_Update_Parent'
	END
	
	-- Set qestReverseLookup.QestParentUUID using QestParentID/QestUniqueParentID where NULL
	UPDATE C SET QestParentUUID = P.QestUUID FROM qestReverseLookup P, qestReverseLookup C 
	WHERE P.QestID = C.QestParentID AND P.QestUniqueID = C.QestUniqueParentID AND C.QestParentUUID IS NULL
	
	IF NOT OBJECT_ID('TR_qestReverseLookup_Update_Parent', 'TR') IS NULL
	BEGIN
		ENABLE TRIGGER TR_qestReverseLookup_Update_Parent ON qestReverseLookup
		PRINT 'Disabled trigger: TR_qestReverseLookup_Update_Parent'
	END
END
GO

