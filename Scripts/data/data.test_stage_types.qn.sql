
-- Remove the uniqueness constraint while the stages run in
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = 'IX_qestTestStage_TestQestID_Idx' AND CONSTRAINT_TYPE = 'UNIQUE')
BEGIN
	EXEC qest_DropIndex 'qestTestStage', 'IX_qestTestStage_TestQestID_Idx'
END
GO

-- Moisture Content [ASTM D 2166]
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000001, @TestQestID = 110940, @Idx = 0, @Code = 'MP', @Name = 'Material Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000002, @TestQestID = 110940, @Idx = 1, @Code = 'WW', @Name = 'Wet Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000003, @TestQestID = 110940, @Idx = 2, @Code = 'DW', @Name = 'Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000004, @TestQestID = 110940, @Idx = 3, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000005, @TestQestID = 110940, @Idx = 4, @Code = 'FC', @Name = 'Final Check', @IsCheckStage = 1
GO

-- Moisture Content [BS 1377-2: 1990]
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000011, @TestQestID = 110941, @Idx = 0, @Code = 'MP', @Name = 'Material Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000012, @TestQestID = 110941, @Idx = 1, @Code = 'WW', @Name = 'Wet Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000013, @TestQestID = 110941, @Idx = 2, @Code = 'DW', @Name = 'Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000014, @TestQestID = 110941, @Idx = 3, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000015, @TestQestID = 110941, @Idx = 4, @Code = 'FC', @Name = 'Final Check', @IsCheckStage = 1
GO

-- Atterberg Limits [BS 1377-2: 1990 cl 4.6]
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000021, @TestQestID = 110942, @Idx = 0, @Code = 'P', @Name = 'Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000022, @TestQestID = 110942, @Idx = 1, @Code = 'LLWW', @Name = 'Liquid Limit Wet Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000023, @TestQestID = 110942, @Idx = 2, @Code = 'PLWW', @Name = 'Plastic Limit Wet Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000024, @TestQestID = 110942, @Idx = 3, @Code = 'LLDW', @Name = 'Liquid Limit Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000025, @TestQestID = 110942, @Idx = 4, @Code = 'PLDW', @Name = 'Plastic Limit Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000026, @TestQestID = 110942, @Idx = 5, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000027, @TestQestID = 110942, @Idx = 6, @Code = 'FC', @Name = 'Final Check', @IsCheckStage = 1
GO

-- Atterberg Limits [BS 1377-2: 1990 cl 4.5]
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000031, @TestQestID = 110943, @Idx = 0, @Code = 'P', @Name = 'Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000032, @TestQestID = 110943, @Idx = 1, @Code = 'LLWW', @Name = 'Liquid Limit Wet Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000033, @TestQestID = 110943, @Idx = 2, @Code = 'PLWW', @Name = 'Plastic Limit Wet Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000034, @TestQestID = 110943, @Idx = 3, @Code = 'LLDW', @Name = 'Liquid Limit Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000035, @TestQestID = 110943, @Idx = 4, @Code = 'PLDW', @Name = 'Plastic Limit Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000036, @TestQestID = 110943, @Idx = 5, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000037, @TestQestID = 110943, @Idx = 6, @Code = 'FC', @Name = 'Final Check', @IsCheckStage = 1
GO

-- Atterberg Limits CP [BS 1377-2: 1990 cl 4.3]
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000041, @TestQestID = 110944, @Idx = 0, @Code = 'P', @Name = 'Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000042, @TestQestID = 110944, @Idx = 1, @Code = 'LLWW', @Name = 'Liquid Limit Wet Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000043, @TestQestID = 110944, @Idx = 2, @Code = 'PLWW', @Name = 'Plastic Limit Wet Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000044, @TestQestID = 110944, @Idx = 3, @Code = 'LLDW', @Name = 'Liquid Limit Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000045, @TestQestID = 110944, @Idx = 4, @Code = 'PLDW', @Name = 'Plastic Limit Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000046, @TestQestID = 110944, @Idx = 5, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000047, @TestQestID = 110944, @Idx = 6, @Code = 'FC', @Name = 'Final Check', @IsCheckStage = 1
GO

-- Atterberg Limits CP [BS 1377-2: 1990 cl 4.4]
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000051, @TestQestID = 110945, @Idx = 0, @Code = 'P', @Name = 'Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000052, @TestQestID = 110945, @Idx = 1, @Code = 'LLWW', @Name = 'Liquid Limit Wet Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000053, @TestQestID = 110945, @Idx = 2, @Code = 'PLWW', @Name = 'Plastic Limit Wet Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000054, @TestQestID = 110945, @Idx = 3, @Code = 'LLDW', @Name = 'Liquid Limit Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000055, @TestQestID = 110945, @Idx = 4, @Code = 'PLDW', @Name = 'Plastic Limit Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000056, @TestQestID = 110945, @Idx = 5, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000057, @TestQestID = 110945, @Idx = 6, @Code = 'FC', @Name = 'Final Check', @IsCheckStage = 1
GO

-- Atterberg Limits [ASTM D 4318]
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000061, @TestQestID = 110946, @Idx = 0, @Code = 'P', @Name = 'Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000062, @TestQestID = 110946, @Idx = 1, @Code = 'LLWW', @Name = 'Liquid Limit Wet Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000063, @TestQestID = 110946, @Idx = 2, @Code = 'PLWW', @Name = 'Plastic Limit Wet Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000064, @TestQestID = 110946, @Idx = 3, @Code = 'LLDW', @Name = 'Liquid Limit Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000065, @TestQestID = 110946, @Idx = 4, @Code = 'PLDW', @Name = 'Plastic Limit Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000066, @TestQestID = 110946, @Idx = 5, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000067, @TestQestID = 110946, @Idx = 6, @Code = 'FC', @Name = 'Final Check', @IsCheckStage = 1
GO

-- Atterberg Limits [ASTM D 4318 B]
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000071, @TestQestID = 110947, @Idx = 0, @Code = 'P', @Name = 'Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000072, @TestQestID = 110947, @Idx = 1, @Code = 'LLWW', @Name = 'Liquid Limit Wet Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000073, @TestQestID = 110947, @Idx = 2, @Code = 'PLWW', @Name = 'Plastic Limit Wet Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000074, @TestQestID = 110947, @Idx = 3, @Code = 'LLDW', @Name = 'Liquid Limit Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000075, @TestQestID = 110947, @Idx = 4, @Code = 'PLDW', @Name = 'Plastic Limit Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000076, @TestQestID = 110947, @Idx = 5, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000077, @TestQestID = 110947, @Idx = 6, @Code = 'FC', @Name = 'Final Check', @IsCheckStage = 1
GO

-- Triaxial Initial Moisture Content
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000081, @TestQestID = 111025, @Idx = 0, @Code = 'MP', @Name = 'Material Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000082, @TestQestID = 111025, @Idx = 1, @Code = 'WW', @Name = 'Wet Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000083, @TestQestID = 111025, @Idx = 2, @Code = 'DW', @Name = 'Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000084, @TestQestID = 111025, @Idx = 3, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000085, @TestQestID = 111025, @Idx = 4, @Code = 'FC', @Name = 'Final Check', @IsCheckStage = 1
GO

-- Triaxial Final Moisture Content 
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000091, @TestQestID = 111026, @Idx = 0, @Code = 'MP', @Name = 'Material Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000092, @TestQestID = 111026, @Idx = 1, @Code = 'WW', @Name = 'Wet Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000093, @TestQestID = 111026, @Idx = 2, @Code = 'DW', @Name = 'Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000094, @TestQestID = 111026, @Idx = 3, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000095, @TestQestID = 111026, @Idx = 4, @Code = 'FC', @Name = 'Final Check', @IsCheckStage = 1
GO

-- Min/Max Dry Density [ASTM D 4253, D 4254]
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000101, @TestQestID = 110904, @Idx = 0, @Code = 'MP', @Name = 'Material Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000107, @TestQestID = 110904, @Idx = 1, @Code = 'EQ', @Name = 'Equipment Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000102, @TestQestID = 110904, @Idx = 2, @Code = 'MIDW', @Name = 'Minimum Density Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000103, @TestQestID = 110904, @Idx = 3, @Code = 'MAWW', @Name = 'Maximum Density Wet Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000104, @TestQestID = 110904, @Idx = 4, @Code = 'MADW', @Name = 'Maximum Density Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000105, @TestQestID = 110904, @Idx = 5, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000106, @TestQestID = 110904, @Idx = 6, @Code = 'FC', @Name = 'Final Check', @IsCheckStage = 1
GO

-- Min/Max Dry Density [BS 1377-4: 1990]
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000111, @TestQestID = 110905, @Idx = 0, @Code = 'MP', @Name = 'Material Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000117, @TestQestID = 110905, @Idx = 1, @Code = 'EQ', @Name = 'Equipment Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000112, @TestQestID = 110905, @Idx = 2, @Code = 'MIDW', @Name = 'Minimum Density Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000113, @TestQestID = 110905, @Idx = 3, @Code = 'MAWW', @Name = 'Maximum Density Wet Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000114, @TestQestID = 110905, @Idx = 4, @Code = 'MADW', @Name = 'Maximum Density Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000115, @TestQestID = 110905, @Idx = 5, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000116, @TestQestID = 110905, @Idx = 6, @Code = 'FC', @Name = 'Final Check', @IsCheckStage = 1
GO

-- Min/Max Dry Density [LT-028, LT-029]
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000121, @TestQestID = 110919, @Idx = 0, @Code = 'MP', @Name = 'Material Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000127, @TestQestID = 110919, @Idx = 1, @Code = 'EQ', @Name = 'Equipment Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000122, @TestQestID = 110919, @Idx = 2, @Code = 'MIDW', @Name = 'Minimum Density Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000123, @TestQestID = 110919, @Idx = 3, @Code = 'MAWW', @Name = 'Maximum Density Wet Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000124, @TestQestID = 110919, @Idx = 4, @Code = 'MADW', @Name = 'Maximum Density Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000125, @TestQestID = 110919, @Idx = 5, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000126, @TestQestID = 110919, @Idx = 6, @Code = 'FC', @Name = 'Final Check', @IsCheckStage = 1
GO

-- Particle Density [ASTM D 854 - 2010]
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000131, @TestQestID = 110908, @Idx = 0, @Code = 'MP', @Name = 'Material Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000132, @TestQestID = 110908, @Idx = 1, @Code = 'WW', @Name = 'Wet Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000136, @TestQestID = 110908, @Idx = 2, @Code = 'MCDW', @Name = 'Moisture Content Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000133, @TestQestID = 110908, @Idx = 3, @Code = 'DW', @Name = 'Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000134, @TestQestID = 110908, @Idx = 4, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000135, @TestQestID = 110908, @Idx = 5, @Code = 'FC', @Name = 'Final Check', @IsCheckStage = 1
GO

-- Particle Density [BS 1377-2: 1990 cl 8.3]
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000141, @TestQestID = 110909, @Idx = 0, @Code = 'MP', @Name = 'Material Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000143, @TestQestID = 110909, @Idx = 1, @Code = 'DW', @Name = 'Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000142, @TestQestID = 110909, @Idx = 2, @Code = 'WW', @Name = 'Wet Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000144, @TestQestID = 110909, @Idx = 3, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000145, @TestQestID = 110909, @Idx = 4, @Code = 'FC', @Name = 'Final Check', @IsCheckStage = 1
GO

-- Particle Density [BS 1377-2: 1990 cl 8.4]
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000151, @TestQestID = 110913, @Idx = 0, @Code = 'MP', @Name = 'Material Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000153, @TestQestID = 110913, @Idx = 1, @Code = 'DW', @Name = 'Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000152, @TestQestID = 110913, @Idx = 2, @Code = 'WW', @Name = 'Wet Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000154, @TestQestID = 110913, @Idx = 3, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000155, @TestQestID = 110913, @Idx = 4, @Code = 'FC', @Name = 'Final Check', @IsCheckStage = 1
GO

-- Triaxial CIU - Consolidated Isotropically Undrained Compression [ASTM D 4767] 
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000161, @TestQestID = 110822, @Idx = 0, @Code = 'MP', @Name = 'Material Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000162, @TestQestID = 110822, @Idx = 1, @Code = 'P', @Name = 'Preparation & Initial water content wet weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000163, @TestQestID = 110822, @Idx = 2, @Code = 'IWC', @Name = 'Initial water content dry weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000164, @TestQestID = 110822, @Idx = 3, @Code = 'S', @Name = 'Saturation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000165, @TestQestID = 110822, @Idx = 4, @Code = 'IC', @Name = 'Isotropic Consolidation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000166, @TestQestID = 110822, @Idx = 5, @Code = 'SH', @Name = 'Shearing'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000167, @TestQestID = 110822, @Idx = 6, @Code = 'F', @Name = 'Specimen Failure/Final water content wet weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000168, @TestQestID = 110822, @Idx = 7, @Code = 'FWC', @Name = 'Final water content dry weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000172, @TestQestID = 110822, @Idx = 8, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000169, @TestQestID = 110822, @Idx = 9, @Code = 'QCT', @Name = 'QC Check on Entirety of Test', @IsCheckStage = 1
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000170, @TestQestID = 110822, @Idx = 10, @Code = 'I', @Name = 'Interpretation - Mohr Circle'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000171, @TestQestID = 110822, @Idx = 11, @Code = 'QCI', @Name = 'QC Check on Interpretation', @IsCheckStage = 1
GO

-- Triaxial CIU - Consolidated Isotropically Undrained Compression [BS 1377, 1990]
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000181, @TestQestID = 110823, @Idx = 0, @Code = 'MP', @Name = 'Material Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000182, @TestQestID = 110823, @Idx = 1, @Code = 'P', @Name = 'Preparation & Initial water content wet weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000183, @TestQestID = 110823, @Idx = 2, @Code = 'IWC', @Name = 'Initial water content dry weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000184, @TestQestID = 110823, @Idx = 3, @Code = 'S', @Name = 'Saturation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000185, @TestQestID = 110823, @Idx = 4, @Code = 'IC', @Name = 'Isotropic Consolidation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000186, @TestQestID = 110823, @Idx = 5, @Code = 'SH', @Name = 'Shearing'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000187, @TestQestID = 110823, @Idx = 6, @Code = 'F', @Name = 'Specimen Failure/Final water content wet weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000188, @TestQestID = 110823, @Idx = 7, @Code = 'FWC', @Name = 'Final water content dry weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000192, @TestQestID = 110823, @Idx = 8, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000189, @TestQestID = 110823, @Idx = 9, @Code = 'QCT', @Name = 'QC Check on Entirety of Test', @IsCheckStage = 1
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000190, @TestQestID = 110823, @Idx = 10, @Code = 'I', @Name = 'Interpretation - Mohr Circle'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000191, @TestQestID = 110823, @Idx = 11, @Code = 'QCI', @Name = 'QC Check on Interpretation', @IsCheckStage = 1
GO

-- Triaxial CID - Consolidated Isotropically Drained Compression [ASTM D 7181]
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000201, @TestQestID = 110824, @Idx = 0, @Code = 'MP', @Name = 'Material Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000202, @TestQestID = 110824, @Idx = 1, @Code = 'P', @Name = 'Preparation & Initial water content wet weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000203, @TestQestID = 110824, @Idx = 2, @Code = 'IWC', @Name = 'Initial water content dry weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000204, @TestQestID = 110824, @Idx = 3, @Code = 'S', @Name = 'Saturation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000205, @TestQestID = 110824, @Idx = 4, @Code = 'IC', @Name = 'Isotropic Consolidation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000206, @TestQestID = 110824, @Idx = 5, @Code = 'SH', @Name = 'Shearing'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000207, @TestQestID = 110824, @Idx = 6, @Code = 'F', @Name = 'Specimen Failure/Final water content wet weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000208, @TestQestID = 110824, @Idx = 7, @Code = 'FWC', @Name = 'Final water content dry weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000212, @TestQestID = 110824, @Idx = 8, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000209, @TestQestID = 110824, @Idx = 9, @Code = 'QCT', @Name = 'QC Check on Entirety of Test', @IsCheckStage = 1
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000210, @TestQestID = 110824, @Idx = 10, @Code = 'I', @Name = 'Interpretation - Mohr Circle'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000211, @TestQestID = 110824, @Idx = 11, @Code = 'QCI', @Name = 'QC Check on Interpretation', @IsCheckStage = 1
GO

-- Triaxial CID - Consolidated Isotropically Drained Compression [BS 1377, 1990]
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000221, @TestQestID = 110825, @Idx = 0, @Code = 'MP', @Name = 'Material Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000222, @TestQestID = 110825, @Idx = 1, @Code = 'P', @Name = 'Preparation & Initial water content wet weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000223, @TestQestID = 110825, @Idx = 2, @Code = 'IWC', @Name = 'Initial water content dry weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000224, @TestQestID = 110825, @Idx = 3, @Code = 'S', @Name = 'Saturation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000225, @TestQestID = 110825, @Idx = 4, @Code = 'IC', @Name = 'Isotropic Consolidation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000226, @TestQestID = 110825, @Idx = 5, @Code = 'SH', @Name = 'Shearing'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000227, @TestQestID = 110825, @Idx = 6, @Code = 'F', @Name = 'Specimen Failure/Final water content wet weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000228, @TestQestID = 110825, @Idx = 7, @Code = 'FWC', @Name = 'Final water content dry weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000232, @TestQestID = 110825, @Idx = 8, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000229, @TestQestID = 110825, @Idx = 9, @Code = 'QCT', @Name = 'QC Check on Entirety of Test', @IsCheckStage = 1
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000230, @TestQestID = 110825, @Idx = 10, @Code = 'I', @Name = 'Interpretation - Mohr Circle'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000231, @TestQestID = 110825, @Idx = 11, @Code = 'QCI', @Name = 'QC Check on Interpretation', @IsCheckStage = 1
GO

-- Triaxial CAU - Consolidated Anisotropically Undrained Compression [ASTM D 4767] 
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000241, @TestQestID = 110826, @Idx = 0, @Code = 'MP', @Name = 'Material Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000242, @TestQestID = 110826, @Idx = 1, @Code = 'P', @Name = 'Preparation & Initial water content wet weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000243, @TestQestID = 110826, @Idx = 2, @Code = 'IWC', @Name = 'Initial water content dry weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000244, @TestQestID = 110826, @Idx = 3, @Code = 'S', @Name = 'Saturation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000245, @TestQestID = 110826, @Idx = 4, @Code = 'IC', @Name = 'Isotropic Consolidation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000246, @TestQestID = 110826, @Idx = 5, @Code = 'AC', @Name = 'Anisotropic Consolidation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000247, @TestQestID = 110826, @Idx = 6, @Code = 'SH', @Name = 'Shearing'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000248, @TestQestID = 110826, @Idx = 7, @Code = 'F', @Name = 'Specimen Failure/Final water content wet weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000249, @TestQestID = 110826, @Idx = 8, @Code = 'FWC', @Name = 'Final water content dry weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000253, @TestQestID = 110826, @Idx = 9, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000250, @TestQestID = 110826, @Idx = 10, @Code = 'QCT', @Name = 'QC Check on Entirety of Test', @IsCheckStage = 1
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000251, @TestQestID = 110826, @Idx = 11, @Code = 'I', @Name = 'Interpretation - Mohr Circle'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000252, @TestQestID = 110826, @Idx = 12, @Code = 'QCI', @Name = 'QC Check on Interpretation', @IsCheckStage = 1
GO

-- Triaxial CAD - Consolidated Anisotropically Drained Compression [ASTM D 7181]
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000261, @TestQestID = 110827, @Idx = 0, @Code = 'MP', @Name = 'Material Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000262, @TestQestID = 110827, @Idx = 1, @Code = 'P', @Name = 'Preparation & Initial water content wet weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000263, @TestQestID = 110827, @Idx = 2, @Code = 'IWC', @Name = 'Initial water content dry weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000264, @TestQestID = 110827, @Idx = 3, @Code = 'S', @Name = 'Saturation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000265, @TestQestID = 110827, @Idx = 4, @Code = 'IC', @Name = 'Isotropic Consolidation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000266, @TestQestID = 110827, @Idx = 5, @Code = 'AC', @Name = 'Anisotropic Consolidation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000267, @TestQestID = 110827, @Idx = 6, @Code = 'SH', @Name = 'Shearing'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000268, @TestQestID = 110827, @Idx = 7, @Code = 'F', @Name = 'Specimen Failure/Final water content wet weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000269, @TestQestID = 110827, @Idx = 8, @Code = 'FWC', @Name = 'Final water content dry weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000273, @TestQestID = 110827, @Idx = 9, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000270, @TestQestID = 110827, @Idx = 10, @Code = 'QCT', @Name = 'QC Check on Entirety of Test', @IsCheckStage = 1
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000271, @TestQestID = 110827, @Idx = 11, @Code = 'I', @Name = 'Interpretation - Mohr Circle'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000272, @TestQestID = 110827, @Idx = 12, @Code = 'QCI', @Name = 'QC Check on Interpretation', @IsCheckStage = 1
GO

-- Triaxial CAD - Consolidated Anisotropically Drained Compression [BS 1377, 1990]
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000281, @TestQestID = 110830, @Idx = 0, @Code = 'MP', @Name = 'Material Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000282, @TestQestID = 110830, @Idx = 1, @Code = 'P', @Name = 'Preparation & Initial water content wet weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000283, @TestQestID = 110830, @Idx = 2, @Code = 'IWC', @Name = 'Initial water content dry weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000284, @TestQestID = 110830, @Idx = 3, @Code = 'S', @Name = 'Saturation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000285, @TestQestID = 110830, @Idx = 4, @Code = 'IC', @Name = 'Isotropic Consolidation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000286, @TestQestID = 110830, @Idx = 5, @Code = 'AC', @Name = 'Anisotropic Consolidation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000287, @TestQestID = 110830, @Idx = 6, @Code = 'SH', @Name = 'Shearing'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000288, @TestQestID = 110830, @Idx = 7, @Code = 'F', @Name = 'Specimen Failure/Final water content wet weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000289, @TestQestID = 110830, @Idx = 8, @Code = 'FWC', @Name = 'Final water content dry weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000293, @TestQestID = 110830, @Idx = 9, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000290, @TestQestID = 110830, @Idx = 10, @Code = 'QCT', @Name = 'QC Check on Entirety of Test', @IsCheckStage = 1
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000291, @TestQestID = 110830, @Idx = 11, @Code = 'I', @Name = 'Interpretation - Mohr Circle'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000292, @TestQestID = 110830, @Idx = 12, @Code = 'QCI', @Name = 'QC Check on Interpretation', @IsCheckStage = 1
GO

-- Triaxial CAU - Consolidated Anisotropically Undrained Compression [BS 1377, 1990]
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000301, @TestQestID = 110831, @Idx = 0, @Code = 'MP', @Name = 'Material Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000302, @TestQestID = 110831, @Idx = 1, @Code = 'P', @Name = 'Preparation & Initial water content wet weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000303, @TestQestID = 110831, @Idx = 2, @Code = 'IWC', @Name = 'Initial water content dry weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000304, @TestQestID = 110831, @Idx = 3, @Code = 'S', @Name = 'Saturation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000305, @TestQestID = 110831, @Idx = 4, @Code = 'IC', @Name = 'Isotropic Consolidation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000306, @TestQestID = 110831, @Idx = 5, @Code = 'AC', @Name = 'Anisotropic Consolidation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000307, @TestQestID = 110831, @Idx = 6, @Code = 'SH', @Name = 'Shearing'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000308, @TestQestID = 110831, @Idx = 7, @Code = 'F', @Name = 'Specimen Failure/Final water content wet weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000309, @TestQestID = 110831, @Idx = 8, @Code = 'FWC', @Name = 'Final water content dry weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000313, @TestQestID = 110831, @Idx = 9, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000310, @TestQestID = 110831, @Idx = 10, @Code = 'QCT', @Name = 'QC Check on Entirety of Test', @IsCheckStage = 1
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000311, @TestQestID = 110831, @Idx = 11, @Code = 'I', @Name = 'Interpretation - Mohr Circle'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000312, @TestQestID = 110831, @Idx = 12, @Code = 'QCI', @Name = 'QC Check on Interpretation', @IsCheckStage = 1
GO

-- Triaxial UU - Unconsolidated Undrained Compression [ASTM D 2850]
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000321, @TestQestID = 110828, @Idx = 0, @Code = 'MP', @Name = 'Material Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000322, @TestQestID = 110828, @Idx = 1, @Code = 'P', @Name = 'Preparation & Initial water content wet weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000323, @TestQestID = 110828, @Idx = 2, @Code = 'IWC', @Name = 'Initial water content dry weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000324, @TestQestID = 110828, @Idx = 3, @Code = 'SH', @Name = 'Shearing'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000325, @TestQestID = 110828, @Idx = 4, @Code = 'F', @Name = 'Specimen Failure/Final water content wet weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000326, @TestQestID = 110828, @Idx = 5, @Code = 'FWC', @Name = 'Final water content dry weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000330, @TestQestID = 110828, @Idx = 6, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000327, @TestQestID = 110828, @Idx = 7, @Code = 'QCT', @Name = 'QC Check on Entirety of Test', @IsCheckStage = 1
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000328, @TestQestID = 110828, @Idx = 8, @Code = 'I', @Name = 'Interpretation - Mohr Circle'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000329, @TestQestID = 110828, @Idx = 9, @Code = 'QCI', @Name = 'QC Check on Interpretation', @IsCheckStage = 1
GO

-- Triaxial UU - Unconsolidated Undrained Compression [BS 1377 Part 7, cl.8]
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000341, @TestQestID = 110829, @Idx = 0, @Code = 'MP', @Name = 'Material Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000342, @TestQestID = 110829, @Idx = 1, @Code = 'P', @Name = 'Preparation & Initial water content wet weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000343, @TestQestID = 110829, @Idx = 2, @Code = 'IWC', @Name = 'Initial water content dry weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000344, @TestQestID = 110829, @Idx = 3, @Code = 'SH', @Name = 'Shearing'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000345, @TestQestID = 110829, @Idx = 4, @Code = 'F', @Name = 'Specimen Failure/Final water content wet weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000346, @TestQestID = 110829, @Idx = 5, @Code = 'FWC', @Name = 'Final water content dry weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000350, @TestQestID = 110829, @Idx = 6, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000347, @TestQestID = 110829, @Idx = 7, @Code = 'QCT', @Name = 'QC Check on Entirety of Test', @IsCheckStage = 1
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000348, @TestQestID = 110829, @Idx = 8, @Code = 'I', @Name = 'Interpretation - Mohr Circle'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000349, @TestQestID = 110829, @Idx = 9, @Code = 'QCI', @Name = 'QC Check on Interpretation', @IsCheckStage = 1
GO

-- Incremental Oedometer [ASTM D 2435] 
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000361, @TestQestID = 110920, @Idx = 0, @Code = 'MP', @Name = 'Material Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000362, @TestQestID = 110920, @Idx = 1, @Code = 'P', @Name = 'Preparation & Initial water content wet weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000363, @TestQestID = 110920, @Idx = 2, @Code = 'IWC', @Name = 'Initial water content dry weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000364, @TestQestID = 110920, @Idx = 3, @Code = 'LS', @Name = 'Load stage'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000365, @TestQestID = 110920, @Idx = 4, @Code = 'FDM', @Name = 'Final Density Measurement/Entry'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000366, @TestQestID = 110920, @Idx = 5, @Code = 'FWC', @Name = 'Final water content dry weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000367, @TestQestID = 110920, @Idx = 6, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000368, @TestQestID = 110920, @Idx = 7, @Code = 'QCT', @Name = 'QC Check on Entirety of Test', @IsCheckStage = 1
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000369, @TestQestID = 110920, @Idx = 8, @Code = 'I', @Name = 'Interpretation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000371, @TestQestID = 110920, @Idx = 9, @Code = 'QCI', @Name = 'QC Check on Interpretation', @IsCheckStage = 1
GO

-- Incremental Oedometer [BS 1377-5: 1990] 
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000381, @TestQestID = 110921, @Idx = 0, @Code = 'MP', @Name = 'Material Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000382, @TestQestID = 110921, @Idx = 1, @Code = 'P', @Name = 'Preparation & Initial water content wet weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000383, @TestQestID = 110921, @Idx = 2, @Code = 'IWC', @Name = 'Initial water content dry weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000384, @TestQestID = 110921, @Idx = 3, @Code = 'LS', @Name = 'Load stage'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000385, @TestQestID = 110921, @Idx = 4, @Code = 'FDM', @Name = 'Final Density Measurement/Entry'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000386, @TestQestID = 110921, @Idx = 5, @Code = 'FWC', @Name = 'Final water content dry weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000387, @TestQestID = 110921, @Idx = 6, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000388, @TestQestID = 110921, @Idx = 7, @Code = 'QCT', @Name = 'QC Check on Entirety of Test', @IsCheckStage = 1
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000389, @TestQestID = 110921, @Idx = 8, @Code = 'I', @Name = 'Interpretation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000391, @TestQestID = 110921, @Idx = 9, @Code = 'QCI', @Name = 'QC Check on Interpretation', @IsCheckStage = 1
GO

-- Incremental Oedometer Initial Moisture Content
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000401, @TestQestID = 111036, @Idx = 0, @Code = 'MP', @Name = 'Material Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000402, @TestQestID = 111036, @Idx = 1, @Code = 'WW', @Name = 'Wet Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000403, @TestQestID = 111036, @Idx = 2, @Code = 'DW', @Name = 'Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000404, @TestQestID = 111036, @Idx = 3, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000405, @TestQestID = 111036, @Idx = 4, @Code = 'FC', @Name = 'Final Check', @IsCheckStage = 1
GO

-- Incremental Oedometer Final Moisture Content 
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000411, @TestQestID = 111037, @Idx = 0, @Code = 'MP', @Name = 'Material Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000412, @TestQestID = 111037, @Idx = 1, @Code = 'WW', @Name = 'Wet Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000413, @TestQestID = 111037, @Idx = 2, @Code = 'DW', @Name = 'Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000414, @TestQestID = 111037, @Idx = 3, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000415, @TestQestID = 111037, @Idx = 4, @Code = 'FC', @Name = 'Final Check', @IsCheckStage = 1
GO


-- PSD TEST (FIXME: Only framework stages added, update QestIDs on the entities if they get shuffled around
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000421, @TestQestID = 110932, @Idx = 0, @Code = 'MP', @Name = 'Material Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000422, @TestQestID = 110932, @Idx = 1, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000423, @TestQestID = 110932, @Idx = 2, @Code = 'FC', @Name = 'Final Check', @IsCheckStage = 1
GO

-- Bulk Density [BS 1377-2: 1990 cl 7.3] (110929)
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000501, @TestQestID = 110929, @Idx = 0, @Code = 'MP', @Name = 'Material Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000504, @TestQestID = 110929, @Idx = 1, @Code = 'M', @Name = 'Measurement'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000505, @TestQestID = 110929, @Idx = 2, @Code = 'MCDW', @Name = 'Moisture Content Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000502, @TestQestID = 110929, @Idx = 3, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000503, @TestQestID = 110929, @Idx = 4, @Code = 'FC', @Name = 'Final Check', @IsCheckStage = 1
GO

-- Bulk Density [BS 1377-2: 1990 cl 7.4] (110939)
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000511, @TestQestID = 110939, @Idx = 0, @Code = 'MP', @Name = 'Material Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000514, @TestQestID = 110939, @Idx = 1, @Code = 'M', @Name = 'Measurement'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000515, @TestQestID = 110939, @Idx = 2, @Code = 'MCDW', @Name = 'Moisture Content Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000512, @TestQestID = 110939, @Idx = 3, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000513, @TestQestID = 110939, @Idx = 4, @Code = 'FC', @Name = 'Final Check', @IsCheckStage = 1
GO

-- Unit Weight [ASTM D 7263 - 2009] (110922)
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000521, @TestQestID = 110922, @Idx = 0, @Code = 'MP', @Name = 'Material Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000524, @TestQestID = 110922, @Idx = 1, @Code = 'M', @Name = 'Measurement'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000525, @TestQestID = 110922, @Idx = 2, @Code = 'MCDW', @Name = 'Moisture Content Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000522, @TestQestID = 110922, @Idx = 3, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000523, @TestQestID = 110922, @Idx = 4, @Code = 'FC', @Name = 'Final Check', @IsCheckStage = 1
GO

-- Bulk Density [BS 1377-2: 1990 cl 7.2] (110917)
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000531, @TestQestID = 110917, @Idx = 0, @Code = 'MP', @Name = 'Material Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000534, @TestQestID = 110917, @Idx = 1, @Code = 'M', @Name = 'Measurement'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000535, @TestQestID = 110917, @Idx = 2, @Code = 'MCDW', @Name = 'Moisture Content Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000532, @TestQestID = 110917, @Idx = 3, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000533, @TestQestID = 110917, @Idx = 4, @Code = 'FC', @Name = 'Final Check', @IsCheckStage = 1
GO

-- Unit Weight [ASTM D 7263 - Method A] (110948)
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000541, @TestQestID = 110948, @Idx = 0, @Code = 'MP', @Name = 'Material Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000544, @TestQestID = 110948, @Idx = 1, @Code = 'M', @Name = 'Measurement'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000545, @TestQestID = 110948, @Idx = 2, @Code = 'MCDW', @Name = 'Moisture Content Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000542, @TestQestID = 110948, @Idx = 3, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000543, @TestQestID = 110948, @Idx = 4, @Code = 'FC', @Name = 'Final Check', @IsCheckStage = 1
GO

-- Density Moisture Content (111038)
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000551, @TestQestID = 111038, @Idx = 0, @Code = 'MP', @Name = 'Material Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000552, @TestQestID = 111038, @Idx = 1, @Code = 'WW', @Name = 'Wet Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000553, @TestQestID = 111038, @Idx = 2, @Code = 'DW', @Name = 'Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000554, @TestQestID = 111038, @Idx = 4, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000555, @TestQestID = 111038, @Idx = 5, @Code = 'FC', @Name = 'Final Check', @IsCheckStage = 1
GO

--Unit Weight [ASTM D 7263 - Method B] (110949)
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000561, @TestQestID = 110949, @Idx = 0, @Code = 'MP', @Name = 'Material Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000564, @TestQestID = 110949, @Idx = 1, @Code = 'M', @Name = 'Measurement'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000565, @TestQestID = 110949, @Idx = 2, @Code = 'MCDW', @Name = 'Moisture Content Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000562, @TestQestID = 110949, @Idx = 3, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000563, @TestQestID = 110949, @Idx = 4, @Code = 'FC', @Name = 'Final Check', @IsCheckStage = 1
GO

-- Pocket Penetrometer 
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000571, @TestQestID = 110910, @Idx = 0, @Code = 'MP', @Name = 'Material Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000572, @TestQestID = 110910, @Idx = 1, @Code = 'M', @Name = 'Measurement'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000573, @TestQestID = 110910, @Idx = 3, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000574, @TestQestID = 110910, @Idx = 4, @Code = 'FC', @Name = 'Final Check', @IsCheckStage = 1
GO

-- Torvane
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000581, @TestQestID = 110911, @Idx = 0, @Code = 'MP', @Name = 'Material Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000582, @TestQestID = 110911, @Idx = 1, @Code = 'M', @Name = 'Measurement'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000583, @TestQestID = 110911, @Idx = 3, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000584, @TestQestID = 110911, @Idx = 4, @Code = 'FC', @Name = 'Final Check', @IsCheckStage = 1
GO


-- Restore uniqueness constraint
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = 'IX_qestTestStage_TestQestID_Idx' AND CONSTRAINT_TYPE = 'UNIQUE')
BEGIN
	ALTER TABLE [dbo].[qestTestStage] ADD CONSTRAINT [IX_qestTestStage_TestQestID_Idx] UNIQUE ([TestQestID],[Idx])
END
GO

