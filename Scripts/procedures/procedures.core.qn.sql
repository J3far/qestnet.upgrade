
-- Create procedure which updates the mappings from the Laboratory table
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_UpdateLaboratoryMappings' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
    DROP PROCEDURE [dbo].[qest_UpdateLaboratoryMappings]
END
GO

CREATE PROCEDURE [dbo].[qest_UpdateLaboratoryMappings]
AS
BEGIN
	INSERT INTO LaboratoryMapping (LocationUUID, LocationQestID, LabNo)
	SELECT QestUUID, QestID, LabNo FROM Laboratory WHERE LabNo < 998 AND LabNo >= 0 AND ISNULL([Owner], 0) = 1 
		AND NOT QestUUID IN (SELECT LocationUUID FROM LaboratoryMapping)
	UNION 
	SELECT TOP 1 QestUUID, QestID, 0 FROM Laboratory WHERE ISNULL(IsGlobal, 0) = 1 
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
BEGIN	
	-- Ensure QES FIXME
	IF NOT EXISTS (SELECT 1 FROM qestObjects WHERE QestID = @TestStageQestID AND Property = 'TableName')
	BEGIN
		INSERT INTO qestObjects (QestID, Property, Value) VALUES (@TestStageQestID, 'TableName', 'TestStageData')	
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
END
GO
