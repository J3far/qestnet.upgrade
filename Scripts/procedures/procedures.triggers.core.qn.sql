
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


-- Remove uniqueid update trigger
IF NOT OBJECT_ID('TR_qestReverseLookup_Update_UniqueID', 'TR') IS NULL
	DROP TRIGGER TR_qestReverseLookup_Update_UniqueID
GO

-- Add uniqueid update trigger
CREATE TRIGGER TR_qestReverseLookup_Update_UniqueID
ON qestReverseLookup AFTER UPDATE
AS
	IF UPDATE(QestUniqueID)
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
		
			-- Set ids into child reverselookups
			UPDATE C SET 
			QestParentID = RL.QestID, 
			QestUniqueParentID = RL.QestUniqueID
			FROM qestReverseLookup RL
			INNER JOIN inserted I ON I.QestUUID = RL.QestUUID
			INNER JOIN deleted D ON D.QestUUID = RL.QestUUID
			INNER JOIN qestReverseLookup C ON RL.QestUUID = C.QestParentUUID
			WHERE NOT D.QestUniqueID = I.QestUniqueID
			AND NOT (C.QestParentID = RL.QestID AND C.QestUniqueParentID = RL.QestUniqueID)
			
			-- Update ParentIDs in document table (eek)
			DECLARE @QestUUID uniqueidentifier
			DECLARE @TableName nvarchar(255)
				
			DECLARE InsertedCursor CURSOR FOR
				SELECT C.QestUUID, Q.[Value] 
				FROM qestReverseLookup RL
				INNER JOIN inserted I ON I.QestUUID = RL.QestUUID
				INNER JOIN deleted D ON D.QestUUID = RL.QestUUID
				INNER JOIN qestReverseLookup C ON RL.QestUUID = C.QestParentUUID
				LEFT JOIN qestObjects Q ON Q.QestID = C.QestID AND Q.Property = 'TableName'
				WHERE NOT D.QestUniqueID = I.QestUniqueID
				
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
			AND NOT (RL.QestParentID = P.QestID AND RL.QestUniqueParentID = P.QestUniqueID)
			
			-- Update ParentIDs in document table (eek)
			DECLARE @QestUUID uniqueidentifier
			DECLARE @TableName nvarchar(255)
				
			DECLARE InsertedCursor CURSOR FOR
				SELECT I.QestUUID, Q.[Value] 
				FROM qestReverseLookup RL
				INNER JOIN inserted I ON I.QestUUID = RL.QestUUID
				INNER JOIN deleted D ON D.QestUUID = RL.QestUUID
				LEFT JOIN qestObjects Q ON Q.QestID = I.QestID AND Q.Property = 'TableName'
				WHERE NOT D.QestParentUUID = I.QestParentUUID
				
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
-- Add trigger to clear QESTLab permissions cache on logout / session termination
IF OBJECT_ID('dbo.TR_SessionConnections_InvalidatePermissionsCache', 'TR') IS NOT NULL
    DROP TRIGGER TR_SessionConnections_InvalidatePermissionsCache
GO

CREATE TRIGGER TR_SessionConnections_InvalidatePermissionsCache
ON dbo.SessionConnections AFTER DELETE
AS
  DECLARE @PersonID int
  SELECT @PersonID = u.PersonID
  FROM deleted d
    inner join dbo.Users u on u.QestUniqueID = d.UserID

  if @PersonID is not null
  BEGIN
    EXEC dbo.qest_InvalidatePermissionsCache 0, @PersonID
  END
go