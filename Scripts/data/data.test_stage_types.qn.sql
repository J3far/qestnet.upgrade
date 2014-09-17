
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
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000023, @TestQestID = 110942, @Idx = 1, @Code = 'PLWW', @Name = 'Plastic Limit Wet Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000024, @TestQestID = 110942, @Idx = 2, @Code = 'LLDW', @Name = 'Liquid Limit Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000025, @TestQestID = 110942, @Idx = 2, @Code = 'PLDW', @Name = 'Plastic Limit Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000026, @TestQestID = 110942, @Idx = 3, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000027, @TestQestID = 110942, @Idx = 4, @Code = 'FC', @Name = 'Final Check', @IsCheckStage = 1
GO

-- Atterberg Limits [BS 1377-2: 1990 cl 4.5]
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000031, @TestQestID = 110943, @Idx = 0, @Code = 'P', @Name = 'Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000032, @TestQestID = 110943, @Idx = 1, @Code = 'LLWW', @Name = 'Liquid Limit Wet Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000033, @TestQestID = 110943, @Idx = 1, @Code = 'PLWW', @Name = 'Plastic Limit Wet Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000034, @TestQestID = 110943, @Idx = 2, @Code = 'LLDW', @Name = 'Liquid Limit Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000035, @TestQestID = 110943, @Idx = 2, @Code = 'PLDW', @Name = 'Plastic Limit Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000036, @TestQestID = 110943, @Idx = 3, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000037, @TestQestID = 110943, @Idx = 4, @Code = 'FC', @Name = 'Final Check', @IsCheckStage = 1
GO

-- Atterberg Limits CP [BS 1377-2: 1990 cl 4.3]
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000041, @TestQestID = 110944, @Idx = 0, @Code = 'P', @Name = 'Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000042, @TestQestID = 110944, @Idx = 1, @Code = 'LLWW', @Name = 'Liquid Limit Wet Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000043, @TestQestID = 110944, @Idx = 1, @Code = 'PLWW', @Name = 'Plastic Limit Wet Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000044, @TestQestID = 110944, @Idx = 2, @Code = 'LLDW', @Name = 'Liquid Limit Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000045, @TestQestID = 110944, @Idx = 2, @Code = 'PLDW', @Name = 'Plastic Limit Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000046, @TestQestID = 110944, @Idx = 3, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000047, @TestQestID = 110944, @Idx = 4, @Code = 'FC', @Name = 'Final Check', @IsCheckStage = 1
GO

-- Atterberg Limits CP [BS 1377-2: 1990 cl 4.4]
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000051, @TestQestID = 110945, @Idx = 0, @Code = 'P', @Name = 'Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000052, @TestQestID = 110945, @Idx = 1, @Code = 'LLWW', @Name = 'Liquid Limit Wet Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000053, @TestQestID = 110945, @Idx = 1, @Code = 'PLWW', @Name = 'Plastic Limit Wet Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000054, @TestQestID = 110945, @Idx = 2, @Code = 'LLDW', @Name = 'Liquid Limit Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000055, @TestQestID = 110945, @Idx = 2, @Code = 'PLDW', @Name = 'Plastic Limit Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000056, @TestQestID = 110945, @Idx = 3, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000057, @TestQestID = 110945, @Idx = 4, @Code = 'FC', @Name = 'Final Check', @IsCheckStage = 1
GO

-- Atterberg Limits [ASTM D 4318]
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000061, @TestQestID = 110946, @Idx = 0, @Code = 'P', @Name = 'Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000062, @TestQestID = 110946, @Idx = 1, @Code = 'LLWW', @Name = 'Liquid Limit Wet Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000063, @TestQestID = 110946, @Idx = 1, @Code = 'PLWW', @Name = 'Plastic Limit Wet Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000064, @TestQestID = 110946, @Idx = 2, @Code = 'LLDW', @Name = 'Liquid Limit Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000065, @TestQestID = 110946, @Idx = 2, @Code = 'PLDW', @Name = 'Plastic Limit Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000066, @TestQestID = 110946, @Idx = 3, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000067, @TestQestID = 110946, @Idx = 4, @Code = 'FC', @Name = 'Final Check', @IsCheckStage = 1
GO

-- Atterberg Limits [ASTM D 4318 B]
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000071, @TestQestID = 110947, @Idx = 0, @Code = 'P', @Name = 'Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000072, @TestQestID = 110947, @Idx = 1, @Code = 'LLWW', @Name = 'Liquid Limit Wet Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000073, @TestQestID = 110947, @Idx = 1, @Code = 'PLWW', @Name = 'Plastic Limit Wet Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000074, @TestQestID = 110947, @Idx = 2, @Code = 'LLDW', @Name = 'Liquid Limit Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000075, @TestQestID = 110947, @Idx = 2, @Code = 'PLDW', @Name = 'Plastic Limit Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000076, @TestQestID = 110947, @Idx = 3, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000077, @TestQestID = 110947, @Idx = 4, @Code = 'FC', @Name = 'Final Check', @IsCheckStage = 1
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
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000102, @TestQestID = 110904, @Idx = 1, @Code = 'MIDW', @Name = 'Minimum Density Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000103, @TestQestID = 110904, @Idx = 2, @Code = 'MAWW', @Name = 'Maximum Density Wet Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000104, @TestQestID = 110904, @Idx = 3, @Code = 'MADW', @Name = 'Maximum Density Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000105, @TestQestID = 110904, @Idx = 4, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000106, @TestQestID = 110904, @Idx = 5, @Code = 'FC', @Name = 'Final Check', @IsCheckStage = 1
GO

-- Min/Max Dry Density [BS 1377-4: 1990]
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000111, @TestQestID = 110905, @Idx = 0, @Code = 'MP', @Name = 'Material Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000112, @TestQestID = 110905, @Idx = 1, @Code = 'MIDW', @Name = 'Minimum Density Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000113, @TestQestID = 110905, @Idx = 2, @Code = 'MAWW', @Name = 'Maximum Density Wet Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000114, @TestQestID = 110905, @Idx = 3, @Code = 'MADW', @Name = 'Maximum Density Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000115, @TestQestID = 110905, @Idx = 4, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000116, @TestQestID = 110905, @Idx = 5, @Code = 'FC', @Name = 'Final Check', @IsCheckStage = 1
GO

-- Min/Max Dry Density [LT-028, LT-029]
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000121, @TestQestID = 110919, @Idx = 0, @Code = 'MP', @Name = 'Material Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000122, @TestQestID = 110919, @Idx = 1, @Code = 'MIDW', @Name = 'Minimum Density Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000123, @TestQestID = 110919, @Idx = 2, @Code = 'MAWW', @Name = 'Maximum Density Wet Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000124, @TestQestID = 110919, @Idx = 3, @Code = 'MADW', @Name = 'Maximum Density Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000125, @TestQestID = 110919, @Idx = 4, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000126, @TestQestID = 110919, @Idx = 5, @Code = 'FC', @Name = 'Final Check', @IsCheckStage = 1
GO

-- Particle Density [ASTM D 854 - 2010]
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000131, @TestQestID = 110908, @Idx = 0, @Code = 'MP', @Name = 'Material Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000132, @TestQestID = 110908, @Idx = 1, @Code = 'WW', @Name = 'Wet Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000133, @TestQestID = 110908, @Idx = 2, @Code = 'DW', @Name = 'Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000134, @TestQestID = 110908, @Idx = 4, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000135, @TestQestID = 110908, @Idx = 5, @Code = 'FC', @Name = 'Final Check', @IsCheckStage = 1
GO

-- Particle Density [BS 1377-2: 1990 cl 8.3]
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000141, @TestQestID = 110909, @Idx = 0, @Code = 'MP', @Name = 'Material Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000142, @TestQestID = 110909, @Idx = 1, @Code = 'WW', @Name = 'Wet Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000143, @TestQestID = 110909, @Idx = 2, @Code = 'DW', @Name = 'Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000144, @TestQestID = 110909, @Idx = 4, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000145, @TestQestID = 110909, @Idx = 5, @Code = 'FC', @Name = 'Final Check', @IsCheckStage = 1
GO

-- Particle Density [BS 1377-2: 1990 cl 8.4]
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000151, @TestQestID = 110913, @Idx = 0, @Code = 'MP', @Name = 'Material Preparation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000152, @TestQestID = 110913, @Idx = 1, @Code = 'WW', @Name = 'Wet Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000153, @TestQestID = 110913, @Idx = 2, @Code = 'DW', @Name = 'Dry Weights'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000154, @TestQestID = 110913, @Idx = 4, @Code = 'MF', @Name = 'Material Finalisation'
GO
EXEC qest_InsertUpdateTestStage @TestStageQestID = 2000155, @TestQestID = 110913, @Idx = 5, @Code = 'FC', @Name = 'Final Check', @IsCheckStage = 1
GO
