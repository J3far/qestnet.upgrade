
-- Create procedure which updates the mappings from the Laboratory table
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_UpdateLaboratoryMappings' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
    DROP PROCEDURE [dbo].[qest_UpdateLaboratoryMappings]
END
GO

CREATE PROCEDURE [dbo].[qest_UpdateLaboratoryMappings]
AS
BEGIN
	INSERT INTO LaboratoryMapping (LocationID, LocationUUID, LocationQestID, LabNo)
	SELECT QestUniqueID, QestUUID, QestID, LabNo FROM Laboratory WHERE LabNo < 998 AND LabNo >= 0 AND ISNULL([Owner], 0) = 1 
		AND NOT QestUUID IN (SELECT LocationUUID FROM LaboratoryMapping)
	UNION 
	SELECT TOP 1 QestUniqueID, QestUUID, QestID, 0 FROM Laboratory WHERE ISNULL(IsGlobal, 0) = 1 
		AND NOT QestUUID IN (SELECT LocationUUID FROM LaboratoryMapping)
END
GO


IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_InsertUpdateTestStage' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
    DROP PROCEDURE [dbo].[qest_InsertUpdateTestStage]
END
GO

CREATE PROCEDURE [dbo].[qest_InsertUpdateTestStage] 
	@TestStageQestID int, 
	@TestQestID int, 
	@Idx int, 
	@Code nvarchar(20), 
	@Name nvarchar(100),
	@IsCheckStage bit = 0
AS
BEGIN TRY

	-- Ensure QES FIXME
	IF NOT EXISTS (SELECT 1 FROM qestObjects WHERE QestID = @TestStageQestID AND Property = 'TableName')
	BEGIN
		INSERT INTO qestObjects (QestID, Property, Value) VALUES (@TestStageQestID, 'TableName', 'TestStageData')
	END
	
	IF NOT EXISTS (SELECT 1 FROM qestObjects WHERE QestID = @TestStageQestID AND Property = 'ActivityParent')
	BEGIN
		INSERT INTO qestObjects (QestID, Property, Value) VALUES (@TestStageQestID, 'ActivityParent', '14')
	END

	IF EXISTS (SELECT 1 FROM qestTestStage WHERE TestStageQestID = @TestStageQestID)
	BEGIN	
		UPDATE qestTestStage SET TestQestID = @TestQestID, Idx = @Idx, Code = @Code, Name = @Name, IsCheckStage = @IsCheckStage
		WHERE TestStageQestID = @TestStageQestID		
	END ELSE BEGIN
		INSERT INTO qestTestStage 
		(TestStageQestID, TestQestID, Idx, Code, Name, IsCheckStage, MinimumCount, Inactive)
		VALUES 
		(@TestStageQestID, @TestQestID, @Idx, @Code, @Name, @IsCheckStage, 0, 0)		
	END
END TRY
BEGIN CATCH
  declare @errSeverity int, @errState int, @errProcedure sysname, @errMessage as nvarchar(max)
  select @errSeverity = ERROR_SEVERITY(), @errState = ERROR_STATE(), @errProcedure = ERROR_PROCEDURE(), @errMessage = ERROR_MESSAGE();
  raiserror('Failed to insert/update test stage [TestStageQestID: %d; TestQestID: %d; Idx: %d]
  Error Message: %s
  Procedure: %s', @errSeverity, @errState, @TestStageQestID, @TestQestID, @Idx, @errMessage, @errProcedure);
END CATCH
