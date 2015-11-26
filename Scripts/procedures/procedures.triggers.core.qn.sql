
--  Trigger for automatic creation of LaboratoryMapping rows
IF OBJECT_ID('TR_LaboratoryMapping', 'TR') IS NOT NULL
	DROP TRIGGER TR_LaboratoryMapping
GO

CREATE TRIGGER TR_LaboratoryMapping
ON Laboratory AFTER INSERT, UPDATE
AS
	EXEC dbo.qest_UpdateLaboratoryMappings
GO

-- Trigger for automatic creation of qestObject rows (QestIDs)
IF OBJECT_ID('TR_qestObjects_QestObjectID', 'TR') IS NOT NULL
	DROP TRIGGER TR_qestObjects_QestObjectID
GO
CREATE TRIGGER TR_qestObjects_QestObjectID
ON qestObjects INSTEAD OF INSERT
AS
	INSERT INTO qestObject (QestID) SELECT QestID FROM inserted WHERE NOT QestID IN (SELECT QestID FROM qestObject)
	INSERT INTO qestObjects (QestID, QestActive, QestExtra, [Property], [Value], [ValueText]) SELECT QestID, QestActive, QestExtra,[Property], [Value], [ValueText] FROM inserted
GO


-- Ensures TestStageData have the correct QestUniqueParentID value
IF OBJECT_ID('TR_TestStageData_Insert_ParentUniqueID', 'TR') IS NOT NULL
	DROP TRIGGER TR_TestStageData_Insert_ParentUniqueID
GO

CREATE TRIGGER TR_TestStageData_Insert_ParentUniqueID
ON TestStageData AFTER INSERT
AS
	-- Set QestUniqueParentID
	UPDATE TestStageData SET QestUniqueParentID = RL.QestUniqueID, QestParentID = RL.QestID
	FROM qestReverseLookup RL 
	INNER JOIN inserted I ON I.QestParentUUID = RL.QestUUID 
	INNER JOIN TestStageData D ON D.QestParentUUID = RL.QestUUID
GO

-- Remove parent reference update trigger
IF NOT OBJECT_ID('TR_qestReverseLookup_Update_Parent', 'TR') IS NULL
	DROP TRIGGER TR_qestReverseLookup_Update_Parent
GO

-- Add parent reference update trigger
CREATE TRIGGER TR_qestReverseLookup_Update_Parent
ON qestReverseLookup AFTER UPDATE
AS
	IF UPDATE(QestParentUUID)
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
		
			-- Set ParentIDs in qestReverseLookups
			UPDATE RL SET 
			QestParentID = P.QestID, 
			QestUniqueParentID = P.QestUniqueID
			FROM qestReverseLookup RL
			INNER JOIN inserted I ON I.QestUUID = RL.QestUUID
			INNER JOIN deleted D ON D.QestUUID = RL.QestUUID
			INNER JOIN qestReverseLookup P ON P.QestUUID = I.QestParentUUID
			WHERE NOT D.QestParentUUID = I.QestParentUUID
			
			-- Update ParentIDs in document table (eek)
			DECLARE @QestUUID uniqueidentifier
			DECLARE @TableName nvarchar(255)
				
			DECLARE InsertedCursor CURSOR FOR
				SELECT I.QestUUID, Q.[Value] 
				FROM inserted I
				INNER JOIN deleted D ON D.QestUUID = I.QestUUID 
				LEFT JOIN qestObjects Q ON Q.QestID = I.QestID AND Q.Property = 'TableName'
				WHERE D.QestParentUUID <> I.QestParentUUID
				
			OPEN InsertedCursor		
			FETCH NEXT FROM InsertedCursor INTO @QestUUID, @TableName
			WHILE @@FETCH_STATUS = 0
			BEGIN
				IF (@TableName IS NULL)
				BEGIN
					RAISERROR('TableName not found in qestObjects.', 16, 1) 
				END ELSE BEGIN			
					EXEC('UPDATE D SET QestParentID = RL.QestParentID, QestUniqueParentID = RL.QestUniqueParentID
					FROM ' + @TableName + ' D INNER JOIN qestReverseLookup RL ON D.QestUUID = RL.QestUUID 
					WHERE D.QestUUID = ''' + @QestUUID  + '''')
				END
				
				FETCH NEXT FROM InsertedCursor INTO @QestUUID, @TableName
			END
	    
			CLOSE InsertedCursor
			DEALLOCATE InsertedCursor
			
			COMMIT
		END TRY		
		BEGIN CATCH
			ROLLBACK
			RAISERROR('TableName not found in qestObjects.', 16, 1) 
		END CATCH
	END
GO

-- Remove qestReverseLookup Insert UniqueIDs trigger
IF NOT OBJECT_ID('TR_qestReverseLookup_Insert_UniqueIDs', 'TR') IS NULL
	DROP TRIGGER TR_qestReverseLookup_Insert_UniqueIDs
GO

-- Add qestReverseLookup Insert UniqueIDs trigger
CREATE TRIGGER TR_qestReverseLookup_Insert_UniqueIDs
ON qestReverseLookup AFTER INSERT
AS
	BEGIN TRANSACTION
	BEGIN TRY
		
		DECLARE @QestUUID uniqueidentifier
		DECLARE @TableName nvarchar(255)
				
		DECLARE InsertedCursor CURSOR FOR
			SELECT I.QestUUID, Q.[Value] 
			FROM inserted I
			LEFT JOIN qestObjects Q ON Q.QestID = I.QestID AND Q.Property = 'TableName'
				
		OPEN InsertedCursor		
		FETCH NEXT FROM InsertedCursor INTO @QestUUID, @TableName
		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF (@TableName IS NULL)
			BEGIN
				RAISERROR('TableName not found in qestObjects.', 16, 1) 
			END ELSE BEGIN
				-- Set QestUniqueParentID, QestParentID in qestReverseLookup from parent qestReverseLookup
				EXEC('UPDATE D SET QestUniqueParentID = PRL.QestUniqueID, QestParentID = PRL.QestID
				FROM ' + @TableName + ' D 
				INNER JOIN qestReverseLookup RL ON D.QestUUID = RL.QestUUID
				INNER JOIN qestReverseLookup PRL ON PRL.QestUUID = RL.QestParentUUID
				WHERE D.QestUUID = ''' + @QestUUID  + '''')

				-- Set QestUniqueID, QestUniqueParentID, QestParentID in qestReverseLookup from document			
				EXEC('UPDATE RL SET QestUniqueID = D.QestUniqueID, QestUniqueParentID = D.QestUniqueParentID, QestParentID = D.QestParentID
				FROM ' + @TableName + ' D 
				INNER JOIN qestReverseLookup RL ON D.QestUUID = RL.QestUUID 
				WHERE D.QestUUID = ''' + @QestUUID  + '''')
			END
				
			FETCH NEXT FROM InsertedCursor INTO @QestUUID, @TableName
		END
	    
		CLOSE InsertedCursor
		DEALLOCATE InsertedCursor
			
		COMMIT
	END TRY		
	BEGIN CATCH
		ROLLBACK
		RAISERROR('TableName not found in qestObjects.', 16, 1) 
	END CATCH
GO

-- Add trigger to generate object keys for audit
IF OBJECT_ID('TR_AuditTrail_SetObjectKey', 'TR') IS NOT NULL
	DROP TRIGGER TR_AuditTrail_SetObjectKey
GO

CREATE TRIGGER [dbo].[TR_AuditTrail_SetObjectKey]
ON [dbo].[AuditTrail] AFTER INSERT
AS
	UPDATE AuditTrail
	SET ObjectKey = dbo.qest_AuditKeyForUUID(A.ObjectQestUUID)
	FROM
	AuditTrail A INNER JOIN inserted I ON A.QestUniqueID = I.QestUniqueID
	WHERE A.ObjectKey IS NULL AND A.ObjectQestUUID IS NOT NULL 
GO

-- Add trigger to set work progress ids
IF OBJECT_ID('TR_WorkProgress_Insert_UniqueIDs', 'TR') IS NOT NULL
	DROP TRIGGER TR_WorkProgress_Insert_UniqueIDs
GO

CREATE TRIGGER [dbo].[TR_WorkProgress_Insert_UniqueIDs]
ON [dbo].[WorkProgress] AFTER INSERT
AS
	-- Set core IDs from reverseLookups
	UPDATE D SET
	QestID = RL.QestID, 
	QestUniqueID = RL.QestUniqueID,
	QestUniqueParentID = RL.QestUniqueParentID, 
	QestParentID = RL.QestParentID
	FROM qestReverseLookup RL 
	INNER JOIN inserted I ON I.QestUUID = RL.QestUUID 
	INNER JOIN WorkProgress D ON D.QestUUID = RL.QestUUID
GO

-- Correct bug in trigger TR_INS_UPD_DocumentGDS, where installed
IF OBJECT_ID('TR_INS_UPD_DocumentGDS', 'TR') IS NOT NULL
BEGIN
    EXEC('ALTER TRIGGER [dbo].[TR_INS_UPD_DocumentGDS]
	ON [dbo].[DocumentGroundDescriptionSingle] AFTER INSERT, UPDATE
	AS		
		--Find first soil description from affected tests
		UPDATE GD
		SET 
		GD.SoilDescription1 = GDS.[Description],
		GD.Offset1_SI = GDS.Offset_SI,
		GD.Offset1_IP = GDS.Offset_IP,
		GD.Height1_SI = GDS.Height_SI,
		GD.Height1_IP = GDS.Height_IP
		FROM
		(    SELECT 
				-- Where at least one offset (ie. depth) is null, use the record with the lowest QestUniqueId
				-- Otherwise use the record with the lowest offset (ie. the shallowest)
				CASE WHEN COUNT(*) - COUNT(s.Offset) <> 0
				THEN MIN(S.QESTUniqueID)
				ELSE (SELECT s1.QestUniqueID from DocumentGroundDescriptionSingle S1 where s1.Offset = Min(S.offset) and s1.QestUniqueParentID = i.QestUniqueParentID)
				END AS FirstUID,
				i.QESTUniqueParentID 
			FROM DocumentGroundDescriptionSingle S 
			INNER JOIN inserted i 
			ON S.QestUniqueParentID = i.QestUniqueParentID
			GROUP BY i.QestUniqueParentID
		) UPD
		INNER JOIN DocumentGroundDescriptionSingle GDS
		ON GDS.QestUniqueID = UPD.FirstUID	
		LEFT JOIN DocumentGroundDescription GD
		ON GD.QestUniqueID = GDS.QestUniqueParentID')
END