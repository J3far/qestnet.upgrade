
IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = '325FB182-CB35-4088-B6C8-6D981DDD493D') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('325FB182-CB35-4088-B6C8-6D981DDD493D', 'Aggsoil Sample', 'Spectra.QESTLab.Entities.AggsoilSample, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'Aggsoil Sample', TypeName = 'Spectra.QESTLab.Entities.AggsoilSample, QESTLab.Entities' WHERE QestEntityUUID = '325FB182-CB35-4088-B6C8-6D981DDD493D' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = 'FC7747AF-3291-4377-8CCD-9754C8C92BEB') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('FC7747AF-3291-4377-8CCD-9754C8C92BEB', 'Asphalt Nuclear Field Density', 'Spectra.QESTLab.Entities.AsphaltNuclearFieldDensity, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'Asphalt Nuclear Field Density', TypeName = 'Spectra.QESTLab.Entities.AsphaltNuclearFieldDensity, QESTLab.Entities' WHERE QestEntityUUID = 'FC7747AF-3291-4377-8CCD-9754C8C92BEB' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = '59C9472F-AB50-45AD-A7FF-94E638D10A5E') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('59C9472F-AB50-45AD-A7FF-94E638D10A5E', 'Asphalt Sample', 'Spectra.QESTLab.Entities.AsphaltSample, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'Asphalt Sample', TypeName = 'Spectra.QESTLab.Entities.AsphaltSample, QESTLab.Entities' WHERE QestEntityUUID = '59C9472F-AB50-45AD-A7FF-94E638D10A5E' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = '1503F3D6-DB3D-4499-B3E5-A22600A6365C') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('1503F3D6-DB3D-4499-B3E5-A22600A6365C', 'Atterberg Limit', 'Spectra.QESTLab.Entities.AtterbergLimit, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'Atterberg Limit', TypeName = 'Spectra.QESTLab.Entities.AtterbergLimit, QESTLab.Entities' WHERE QestEntityUUID = '1503F3D6-DB3D-4499-B3E5-A22600A6365C' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = '86AC4B44-6794-4B2C-8DA4-A22600A6365C') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('86AC4B44-6794-4B2C-8DA4-A22600A6365C', 'California Bearing Ratio', 'Spectra.QESTLab.Entities.CaliforniaBearingRatio, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'California Bearing Ratio', TypeName = 'Spectra.QESTLab.Entities.CaliforniaBearingRatio, QESTLab.Entities' WHERE QestEntityUUID = '86AC4B44-6794-4B2C-8DA4-A22600A6365C' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = 'F89F9987-F5AC-41E2-82A8-050B8E117103') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('F89F9987-F5AC-41E2-82A8-050B8E117103', 'Concrete Sample', 'Spectra.QESTLab.Entities.ConcreteSample, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'Concrete Sample', TypeName = 'Spectra.QESTLab.Entities.ConcreteSample, QESTLab.Entities' WHERE QestEntityUUID = 'F89F9987-F5AC-41E2-82A8-050B8E117103' END 
GO
	
IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = 'AB79C2C3-9E4B-4B57-B06E-A2C900F1D126') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('AB79C2C3-9E4B-4B57-B06E-A2C900F1D126', 'Concrete Shrinkage', 'Spectra.QESTLab.Entities.ConcreteShrinkage, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'Concrete Shrinkage', TypeName = 'Spectra.QESTLab.Entities.ConcreteShrinkage, QESTLab.Entities' WHERE QestEntityUUID = 'AB79C2C3-9E4B-4B57-B06E-A2C900F1D126' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = 'DA20E982-12CA-4496-B1B1-A2C900F1D126') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('DA20E982-12CA-4496-B1B1-A2C900F1D126', 'Concrete Shrinkage Specimen', 'Spectra.QESTLab.Entities.ConcreteShrinkageSpecimen, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'Concrete Shrinkage Specimen', TypeName = 'Spectra.QESTLab.Entities.ConcreteShrinkageSpecimen, QESTLab.Entities' WHERE QestEntityUUID = 'DA20E982-12CA-4496-B1B1-A2C900F1D126' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = '7F85E4B2-68D1-4D7F-BF7F-1127B40B83C0') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('7F85E4B2-68D1-4D7F-BF7F-1127B40B83C0', 'Concrete Specimen', 'Spectra.QESTLab.Entities.ConcreteSpecimen, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'Concrete Specimen', TypeName = 'Spectra.QESTLab.Entities.ConcreteSpecimen, QESTLab.Entities' WHERE QestEntityUUID = '7F85E4B2-68D1-4D7F-BF7F-1127B40B83C0' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = 'FE180C19-790C-45B4-9AC9-0E66144A3EE6') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('FE180C19-790C-45B4-9AC9-0E66144A3EE6', 'Concrete Thickness', 'Spectra.QESTLab.Entities.ConcreteThickness, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'Concrete Thickness', TypeName = 'Spectra.QESTLab.Entities.ConcreteThickness, QESTLab.Entities' WHERE QestEntityUUID = 'FE180C19-790C-45B4-9AC9-0E66144A3EE6' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = 'B71A17D3-B620-41CB-874C-A26800D8A75E') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('B71A17D3-B620-41CB-874C-A26800D8A75E', 'Cone Penetrometer Atterberg Limit', 'Spectra.QESTLab.Entities.ConePenetrometerAtterbergLimit, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'Cone Penetrometer Atterberg Limit', TypeName = 'Spectra.QESTLab.Entities.ConePenetrometerAtterbergLimit, QESTLab.Entities' WHERE QestEntityUUID = 'B71A17D3-B620-41CB-874C-A26800D8A75E' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = '5F144D1A-13F0-44BF-85DF-A26C00E76E45') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('5F144D1A-13F0-44BF-85DF-A26C00E76E45', 'Cone Penetrometer Liquid Limit Specimen', 'Spectra.QESTLab.Entities.ConePenetrometerLiquidLimitSpecimen, QESTLab.Entities') END 
ELSE
	BEGIN UPDATE qestEntity SET Name = 'Cone Penetrometer Liquid Limit Specimen', TypeName = 'Spectra.QESTLab.Entities.ConePenetrometerLiquidLimitSpecimen, QESTLab.Entities' WHERE QestEntityUUID = '5F144D1A-13F0-44BF-85DF-A26C00E76E45' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = '3FAEB807-ABAD-4C57-894B-A26C00E76E45') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('3FAEB807-ABAD-4C57-894B-A26C00E76E45', 'Cone Penetrometer Plastic Limit Specimen', 'Spectra.QESTLab.Entities.ConePenetrometerPlasticLimitSpecimen, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'Cone Penetrometer Plastic Limit Specimen', TypeName = 'Spectra.QESTLab.Entities.ConePenetrometerPlasticLimitSpecimen, QESTLab.Entities' WHERE QestEntityUUID = '3FAEB807-ABAD-4C57-894B-A26C00E76E45' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = 'F893E9F4-CE8C-4BF2-811D-A2BC00E1F494') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('F893E9F4-CE8C-4BF2-811D-A2BC00E1F494', 'Density Drive Cylinder', 'Spectra.QESTLab.Entities.DensityDriveCylinder, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'Density Drive Cylinder', TypeName = 'Spectra.QESTLab.Entities.DensityDriveCylinder, QESTLab.Entities' WHERE QestEntityUUID = 'F893E9F4-CE8C-4BF2-811D-A2BC00E1F494' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = '300BD23C-3A89-4646-AD25-A2810120735A') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('300BD23C-3A89-4646-AD25-A2810120735A', 'Geotechnical Sample', 'Spectra.QESTLab.Entities.GeotechnicalSample, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'Geotechnical Sample', TypeName = 'Spectra.QESTLab.Entities.GeotechnicalSample, QESTLab.Entities' WHERE QestEntityUUID = '300BD23C-3A89-4646-AD25-A2810120735A' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = 'DB7208CD-3CF0-4FE1-852D-A22E00DFAC2C') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('DB7208CD-3CF0-4FE1-852D-A22E00DFAC2C', 'Liquid Limit Specimen', 'Spectra.QESTLab.Entities.LiquidLimitSpecimen, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'Liquid Limit Specimen', TypeName = 'Spectra.QESTLab.Entities.LiquidLimitSpecimen, QESTLab.Entities' WHERE QestEntityUUID = 'DB7208CD-3CF0-4FE1-852D-A22E00DFAC2C' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = 'E29904C4-970C-4031-843D-A22600A6365C') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('E29904C4-970C-4031-843D-A22600A6365C', 'Maximum Dry Density', 'Spectra.QESTLab.Entities.MaximumDryDensityTest, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'Maximum Dry Density', TypeName = 'Spectra.QESTLab.Entities.MaximumDryDensityTest, QESTLab.Entities' WHERE QestEntityUUID = 'E29904C4-970C-4031-843D-A22600A6365C' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = '46164FD3-7835-4223-99C6-B075CF253E38') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('46164FD3-7835-4223-99C6-B075CF253E38', 'Moisture Content', 'Spectra.QESTLab.Entities.MoistureContentTest, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'Moisture Content', TypeName = 'Spectra.QESTLab.Entities.MoistureContentTest, QESTLab.Entities' WHERE QestEntityUUID = '46164FD3-7835-4223-99C6-B075CF253E38' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = 'C2F67FF9-6BA8-4447-8205-E22E75989060') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('C2F67FF9-6BA8-4447-8205-E22E75989060', 'Nuclear Field Density', 'Spectra.QESTLab.Entities.NuclearFieldDensity, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'Nuclear Field Density', TypeName = 'Spectra.QESTLab.Entities.NuclearFieldDensity, QESTLab.Entities' WHERE QestEntityUUID = 'C2F67FF9-6BA8-4447-8205-E22E75989060' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = '18812DDC-C274-4051-8ADE-B615B7DDD20D') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('18812DDC-C274-4051-8ADE-B615B7DDD20D', 'Other Sample', 'Spectra.QESTLab.Entities.OtherSample, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'Other Sample', TypeName = 'Spectra.QESTLab.Entities.OtherSample, QESTLab.Entities' WHERE QestEntityUUID = '18812DDC-C274-4051-8ADE-B615B7DDD20D' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = 'ED917156-37B7-4E5A-99F6-6A88F084A097') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('ED917156-37B7-4E5A-99F6-6A88F084A097', 'Particle Size Distribution', 'Spectra.QESTLab.Entities.ParticleSizeDistribution, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'Particle Size Distribution', TypeName = 'Spectra.QESTLab.Entities.ParticleSizeDistribution, QESTLab.Entities' WHERE QestEntityUUID = 'ED917156-37B7-4E5A-99F6-6A88F084A097' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = '7727541D-FBCE-401C-ADCF-E518CAB7E362') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('7727541D-FBCE-401C-ADCF-E518CAB7E362', 'Particle Size Distribution Reduced', 'Spectra.QESTLab.Entities.ParticleSizeDistributionReduced, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'Particle Size Distribution Reduced', TypeName = 'Spectra.QESTLab.Entities.ParticleSizeDistributionReduced, QESTLab.Entities' WHERE QestEntityUUID = '7727541D-FBCE-401C-ADCF-E518CAB7E362' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = 'DB7F289A-3CAC-44E3-A580-7E17D5704F58') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('DB7F289A-3CAC-44E3-A580-7E17D5704F58', 'Pavement Thickness', 'Spectra.QESTLab.Entities.PavementThickness, QESTLab.Entities') END 
ELSE
	BEGIN UPDATE qestEntity SET Name = 'Pavement Thickness', TypeName = 'Spectra.QESTLab.Entities.PavementThickness, QESTLab.Entities' WHERE QestEntityUUID = 'DB7F289A-3CAC-44E3-A580-7E17D5704F58' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = '473D23B7-9418-44DA-B75A-A2DD00E5E91E') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('473D23B7-9418-44DA-B75A-A2DD00E5E91E', 'PHDeterminationTest', 'Spectra.QESTLab.Entities.PHDeterminationTest, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'PHDeterminationTest', TypeName = 'Spectra.QESTLab.Entities.PHDeterminationTest, QESTLab.Entities' WHERE QestEntityUUID = '473D23B7-9418-44DA-B75A-A2DD00E5E91E' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = '5E904032-EDA7-4739-A964-A22E00DFAC2C') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('5E904032-EDA7-4739-A964-A22E00DFAC2C', 'Plastic Limit Specimen', 'Spectra.QESTLab.Entities.PlasticLimitSpecimen, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'Plastic Limit Specimen', TypeName = 'Spectra.QESTLab.Entities.PlasticLimitSpecimen, QESTLab.Entities' WHERE QestEntityUUID = '5E904032-EDA7-4739-A964-A22E00DFAC2C' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = 'C9041191-A093-485B-A014-9B83145408A5') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('C9041191-A093-485B-A014-9B83145408A5', 'Relative Compaction', 'Spectra.QESTLab.Entities.RelativeCompaction, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'Relative Compaction', TypeName = 'Spectra.QESTLab.Entities.RelativeCompaction, QESTLab.Entities' WHERE QestEntityUUID = 'C9041191-A093-485B-A014-9B83145408A5' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = '17883E65-2891-4236-8494-4B2FF00647B9') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('17883E65-2891-4236-8494-4B2FF00647B9', 'Sand Replacement', 'Spectra.QESTLab.Entities.SandReplacement, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'Sand Replacement', TypeName = 'Spectra.QESTLab.Entities.SandReplacement, QESTLab.Entities' WHERE QestEntityUUID = '17883E65-2891-4236-8494-4B2FF00647B9' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = 'E34ED6E0-2649-453A-856D-A20400BEC893') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('E34ED6E0-2649-453A-856D-A20400BEC893', 'Test Report', 'Spectra.QESTLab.Entities.TestReport, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'Test Report', TypeName = 'Spectra.QESTLab.Entities.TestReport, QESTLab.Entities' WHERE QestEntityUUID = 'E34ED6E0-2649-453A-856D-A20400BEC893' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = '6E805F95-B056-4F5B-B7D4-F7332A34450D') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('6E805F95-B056-4F5B-B7D4-F7332A34450D', 'Test Report Image', 'Spectra.QESTLab.Entities.TestReportImage, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'Test Report Image', TypeName = 'Spectra.QESTLab.Entities.TestReportImage, QESTLab.Entities' WHERE QestEntityUUID = '6E805F95-B056-4F5B-B7D4-F7332A34450D' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = 'D82C3CD8-D69D-4430-8531-A20B00FA02D1') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('D82C3CD8-D69D-4430-8531-A20B00FA02D1', 'Timekeeping', 'Spectra.QESTLab.Entities.Timekeeping, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'Timekeeping', TypeName = 'Spectra.QESTLab.Entities.Timekeeping, QESTLab.Entities' WHERE QestEntityUUID = 'D82C3CD8-D69D-4430-8531-A20B00FA02D1' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = 'B048503D-419F-4065-A59C-A20B00FA02D1') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('B048503D-419F-4065-A59C-A20B00FA02D1', 'Timekeeping Record', 'Spectra.QESTLab.Entities.TimekeepingRecord, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'Timekeeping Record', TypeName = 'Spectra.QESTLab.Entities.TimekeepingRecord, QESTLab.Entities' WHERE QestEntityUUID = 'B048503D-419F-4065-A59C-A20B00FA02D1' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = '610C2FE0-5B46-4C81-91ED-A2D600E909CD') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('610C2FE0-5B46-4C81-91ED-A2D600E909CD', 'Triaxial', 'Spectra.QESTLab.Entities.Triaxial, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'Triaxial', TypeName = 'Spectra.QESTLab.Entities.Triaxial, QESTLab.Entities' WHERE QestEntityUUID = '610C2FE0-5B46-4C81-91ED-A2D600E909CD' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = '27790456-E445-4A38-AC15-A2D600E909CD') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('27790456-E445-4A38-AC15-A2D600E909CD', 'Triaxial Reading', 'Spectra.QESTLab.Entities.TriaxialReading, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'Triaxial Reading', TypeName = 'Spectra.QESTLab.Entities.TriaxialReading, QESTLab.Entities' WHERE QestEntityUUID = '27790456-E445-4A38-AC15-A2D600E909CD' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = 'F505EDD4-B482-427F-B1D9-FAE319F6377C') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('F505EDD4-B482-427F-B1D9-FAE319F6377C', 'User Document 024', 'Spectra.QESTLab.Entities.UserDocument024, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'User Document 024', TypeName = 'Spectra.QESTLab.Entities.UserDocument024, QESTLab.Entities' WHERE QestEntityUUID = 'F505EDD4-B482-427F-B1D9-FAE319F6377C' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = '8D91B4ED-3530-49E3-B0BF-BC8DF5971211') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('8D91B4ED-3530-49E3-B0BF-BC8DF5971211', 'User Document 043', 'Spectra.QESTLab.Entities.UserDocument043, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'User Document 043', TypeName = 'Spectra.QESTLab.Entities.UserDocument043, QESTLab.Entities' WHERE QestEntityUUID = '8D91B4ED-3530-49E3-B0BF-BC8DF5971211' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = '1DD5316B-BB12-47C7-BD35-FBF7C4F11978') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('1DD5316B-BB12-47C7-BD35-FBF7C4F11978', 'User Document 047', 'Spectra.QESTLab.Entities.UserDocument047, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'User Document 047', TypeName = 'Spectra.QESTLab.Entities.UserDocument047, QESTLab.Entities' WHERE QestEntityUUID = '1DD5316B-BB12-47C7-BD35-FBF7C4F11978' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = '4A346579-6C7B-4557-AF07-609B922EB6FF') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('4A346579-6C7B-4557-AF07-609B922EB6FF', 'User Document 049', 'Spectra.QESTLab.Entities.UserDocument049, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'User Document 049', TypeName = 'Spectra.QESTLab.Entities.UserDocument049, QESTLab.Entities' WHERE QestEntityUUID = '4A346579-6C7B-4557-AF07-609B922EB6FF' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = 'C17D2547-4BDD-4249-ACE5-7B36C3BFCEE7') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('C17D2547-4BDD-4249-ACE5-7B36C3BFCEE7', 'User Document 051', 'Spectra.QESTLab.Entities.UserDocument051, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'User Document 051', TypeName = 'Spectra.QESTLab.Entities.UserDocument051, QESTLab.Entities' WHERE QestEntityUUID = 'C17D2547-4BDD-4249-ACE5-7B36C3BFCEE7' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = '7ECF0726-33FD-4B37-903A-000A38BC6781') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('7ECF0726-33FD-4B37-903A-000A38BC6781', 'User Document 053', 'Spectra.QESTLab.Entities.UserDocument053, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'User Document 053', TypeName = 'Spectra.QESTLab.Entities.UserDocument053, QESTLab.Entities' WHERE QestEntityUUID = '7ECF0726-33FD-4B37-903A-000A38BC6781' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = '00CC50D0-1FAF-4203-B4B0-9BCAE9B89D73') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('00CC50D0-1FAF-4203-B4B0-9BCAE9B89D73', 'User Document 056', 'Spectra.QESTLab.Entities.UserDocument056, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'User Document 056', TypeName = 'Spectra.QESTLab.Entities.UserDocument056, QESTLab.Entities' WHERE QestEntityUUID = '00CC50D0-1FAF-4203-B4B0-9BCAE9B89D73' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = 'C613F301-73E2-404F-B157-0420B0FAB250') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('C613F301-73E2-404F-B157-0420B0FAB250', 'User Document 058', 'Spectra.QESTLab.Entities.UserDocument058, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'User Document 058', TypeName = 'Spectra.QESTLab.Entities.UserDocument058, QESTLab.Entities' WHERE QestEntityUUID = 'C613F301-73E2-404F-B157-0420B0FAB250' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = '2053C973-3687-4169-92C7-5594AB336900') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('2053C973-3687-4169-92C7-5594AB336900', 'User Document 062', 'Spectra.QESTLab.Entities.UserDocument062, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'User Document 062', TypeName = 'Spectra.QESTLab.Entities.UserDocument062, QESTLab.Entities' WHERE QestEntityUUID = '2053C973-3687-4169-92C7-5594AB336900' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = '7F523929-9F9D-45E5-A4A7-96416DE32C42') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('7F523929-9F9D-45E5-A4A7-96416DE32C42', 'User Document 064', 'Spectra.QESTLab.Entities.UserDocument064, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'User Document 064', TypeName = 'Spectra.QESTLab.Entities.UserDocument064, QESTLab.Entities' WHERE QestEntityUUID = '7F523929-9F9D-45E5-A4A7-96416DE32C42' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = '04F94CDD-9BFE-44E0-81DE-FA01DA3841F9') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('04F94CDD-9BFE-44E0-81DE-FA01DA3841F9', 'User Document 074', 'Spectra.QESTLab.Entities.UserDocument074, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'User Document 074', TypeName = 'Spectra.QESTLab.Entities.UserDocument074, QESTLab.Entities' WHERE QestEntityUUID = '04F94CDD-9BFE-44E0-81DE-FA01DA3841F9' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = '8A4C99BD-7874-46E7-B66E-426B8BCF3AD1') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('8A4C99BD-7874-46E7-B66E-426B8BCF3AD1', 'User Document 080', 'Spectra.QESTLab.Entities.UserDocument080, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'User Document 080', TypeName = 'Spectra.QESTLab.Entities.UserDocument080, QESTLab.Entities' WHERE QestEntityUUID = '8A4C99BD-7874-46E7-B66E-426B8BCF3AD1' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = '48EE2895-434D-44F7-BA77-6128460F11EB') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('48EE2895-434D-44F7-BA77-6128460F11EB', 'User Document 082', 'Spectra.QESTLab.Entities.UserDocument082, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'User Document 082', TypeName = 'Spectra.QESTLab.Entities.UserDocument082, QESTLab.Entities' WHERE QestEntityUUID = '48EE2895-434D-44F7-BA77-6128460F11EB' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = '5FCB48EF-A0BF-4246-AC31-CDDA2746287A') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('5FCB48EF-A0BF-4246-AC31-CDDA2746287A', 'User Document 090', 'Spectra.QESTLab.Entities.UserDocument090, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'User Document 090', TypeName = 'Spectra.QESTLab.Entities.UserDocument090, QESTLab.Entities' WHERE QestEntityUUID = '5FCB48EF-A0BF-4246-AC31-CDDA2746287A' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = 'C2657240-5FE7-4840-B50A-E11D4C56AD02') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('C2657240-5FE7-4840-B50A-E11D4C56AD02', 'User Document 092', 'Spectra.QESTLab.Entities.UserDocument092, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'User Document 092', TypeName = 'Spectra.QESTLab.Entities.UserDocument092, QESTLab.Entities' WHERE QestEntityUUID = 'C2657240-5FE7-4840-B50A-E11D4C56AD02' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = 'AD35EBEA-686E-4F40-B20E-718822D17DAE') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('AD35EBEA-686E-4F40-B20E-718822D17DAE', 'User Document 094', 'Spectra.QESTLab.Entities.UserDocument094, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'User Document 094', TypeName = 'Spectra.QESTLab.Entities.UserDocument094, QESTLab.Entities' WHERE QestEntityUUID = 'AD35EBEA-686E-4F40-B20E-718822D17DAE' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = '13579BD0-FBEE-44EA-BE05-A6CE199848B7') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('13579BD0-FBEE-44EA-BE05-A6CE199848B7', 'User Document 096', 'Spectra.QESTLab.Entities.UserDocument096, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'User Document 096', TypeName = 'Spectra.QESTLab.Entities.UserDocument096, QESTLab.Entities' WHERE QestEntityUUID = '13579BD0-FBEE-44EA-BE05-A6CE199848B7' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = 'CC0A4849-90E0-4CE7-89D7-8BDB203C05A9') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('CC0A4849-90E0-4CE7-89D7-8BDB203C05A9', 'User Document 098', 'Spectra.QESTLab.Entities.UserDocument098, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'User Document 098', TypeName = 'Spectra.QESTLab.Entities.UserDocument098, QESTLab.Entities' WHERE QestEntityUUID = 'CC0A4849-90E0-4CE7-89D7-8BDB203C05A9' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = '8A341354-0D82-4027-95F2-A28F9A0AF400') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('8A341354-0D82-4027-95F2-A28F9A0AF400', 'User Document 100', 'Spectra.QESTLab.Entities.UserDocument100, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'User Document 100', TypeName = 'Spectra.QESTLab.Entities.UserDocument100, QESTLab.Entities' WHERE QestEntityUUID = '8A341354-0D82-4027-95F2-A28F9A0AF400' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = '15FB28B7-F765-494B-88BC-35588F473121') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('15FB28B7-F765-494B-88BC-35588F473121', 'User Document 103', 'Spectra.QESTLab.Entities.UserDocument103, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'User Document 103', TypeName = 'Spectra.QESTLab.Entities.UserDocument103, QESTLab.Entities' WHERE QestEntityUUID = '15FB28B7-F765-494B-88BC-35588F473121' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = '0A84D6EC-32CE-4B58-BD3C-5D7A4BBCE37F') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('0A84D6EC-32CE-4B58-BD3C-5D7A4BBCE37F', 'User Document 105', 'Spectra.QESTLab.Entities.UserDocument105, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'User Document 105', TypeName = 'Spectra.QESTLab.Entities.UserDocument105, QESTLab.Entities' WHERE QestEntityUUID = '0A84D6EC-32CE-4B58-BD3C-5D7A4BBCE37F' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = 'A655DC1A-53DF-4B9B-8AC6-640FD967A4BB') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('A655DC1A-53DF-4B9B-8AC6-640FD967A4BB', 'User Document 107', 'Spectra.QESTLab.Entities.UserDocument107, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'User Document 107', TypeName = 'Spectra.QESTLab.Entities.UserDocument107, QESTLab.Entities' WHERE QestEntityUUID = 'A655DC1A-53DF-4B9B-8AC6-640FD967A4BB' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = 'DAC81EB0-FD8B-4505-814E-BA676A6C90C4') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('DAC81EB0-FD8B-4505-814E-BA676A6C90C4', 'User Document 109', 'Spectra.QESTLab.Entities.UserDocument109, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'User Document 109', TypeName = 'Spectra.QESTLab.Entities.UserDocument109, QESTLab.Entities' WHERE QestEntityUUID = 'DAC81EB0-FD8B-4505-814E-BA676A6C90C4' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = '0B9625C7-CD97-405E-996A-DFAEDE0A3D2C') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('0B9625C7-CD97-405E-996A-DFAEDE0A3D2C', 'User Document 111', 'Spectra.QESTLab.Entities.UserDocument111, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'User Document 111', TypeName = 'Spectra.QESTLab.Entities.UserDocument111, QESTLab.Entities' WHERE QestEntityUUID = '0B9625C7-CD97-405E-996A-DFAEDE0A3D2C' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = '88F14080-31CE-42E4-BEFC-571FC2EA98C4') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('88F14080-31CE-42E4-BEFC-571FC2EA98C4', 'User Document 113', 'Spectra.QESTLab.Entities.UserDocument113, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'User Document 113', TypeName = 'Spectra.QESTLab.Entities.UserDocument113, QESTLab.Entities' WHERE QestEntityUUID = '88F14080-31CE-42E4-BEFC-571FC2EA98C4' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = '8C52B5E7-EFF9-4A15-A5ED-BF861B133BF6') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('8C52B5E7-EFF9-4A15-A5ED-BF861B133BF6', 'User Document 115', 'Spectra.QESTLab.Entities.UserDocument115, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'User Document 115', TypeName = 'Spectra.QESTLab.Entities.UserDocument115, QESTLab.Entities' WHERE QestEntityUUID = '8C52B5E7-EFF9-4A15-A5ED-BF861B133BF6' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = '9E63E397-3183-47B2-891B-E9E92B560999') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('9E63E397-3183-47B2-891B-E9E92B560999', 'User Document 117', 'Spectra.QESTLab.Entities.UserDocument117, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'User Document 117', TypeName = 'Spectra.QESTLab.Entities.UserDocument117, QESTLab.Entities' WHERE QestEntityUUID = '9E63E397-3183-47B2-891B-E9E92B560999' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = '489516FE-2797-4DA4-A6F8-A39E46A63B99') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('489516FE-2797-4DA4-A6F8-A39E46A63B99', 'User Document 119', 'Spectra.QESTLab.Entities.UserDocument119, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'User Document 119', TypeName = 'Spectra.QESTLab.Entities.UserDocument119, QESTLab.Entities' WHERE QestEntityUUID = '489516FE-2797-4DA4-A6F8-A39E46A63B99' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = '37B40109-C7A7-419F-9AD1-8932B011BCE1') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('37B40109-C7A7-419F-9AD1-8932B011BCE1', 'User Document 121', 'Spectra.QESTLab.Entities.UserDocument121, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'User Document 121', TypeName = 'Spectra.QESTLab.Entities.UserDocument121, QESTLab.Entities' WHERE QestEntityUUID = '37B40109-C7A7-419F-9AD1-8932B011BCE1' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = 'F34002FC-EE4C-4AE1-898F-8629C2443CE6') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('F34002FC-EE4C-4AE1-898F-8629C2443CE6', 'User Document 123', 'Spectra.QESTLab.Entities.UserDocument123, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'User Document 123', TypeName = 'Spectra.QESTLab.Entities.UserDocument123, QESTLab.Entities' WHERE QestEntityUUID = 'F34002FC-EE4C-4AE1-898F-8629C2443CE6' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = 'E0985F48-539D-43A7-9544-0989488D3D9D') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('E0985F48-539D-43A7-9544-0989488D3D9D', 'User Document 125', 'Spectra.QESTLab.Entities.UserDocument125, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'User Document 125', TypeName = 'Spectra.QESTLab.Entities.UserDocument125, QESTLab.Entities' WHERE QestEntityUUID = 'E0985F48-539D-43A7-9544-0989488D3D9D' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = 'FF1F5F09-D921-430D-87A4-7B5D1D05F693') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('FF1F5F09-D921-430D-87A4-7B5D1D05F693', 'User Document 126', 'Spectra.QESTLab.Entities.UserDocument126, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'User Document 126', TypeName = 'Spectra.QESTLab.Entities.UserDocument126, QESTLab.Entities' WHERE QestEntityUUID = 'FF1F5F09-D921-430D-87A4-7B5D1D05F693' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = '1F09A4C6-F685-4E66-A7C7-50CE3F28EE9D') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('1F09A4C6-F685-4E66-A7C7-50CE3F28EE9D', 'User Document 127', 'Spectra.QESTLab.Entities.UserDocument127, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'User Document 127', TypeName = 'Spectra.QESTLab.Entities.UserDocument127, QESTLab.Entities' WHERE QestEntityUUID = '1F09A4C6-F685-4E66-A7C7-50CE3F28EE9D' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = '763D2764-C54D-4939-86E8-39745F74C1CD') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('763D2764-C54D-4939-86E8-39745F74C1CD', 'User Document 128', 'Spectra.QESTLab.Entities.UserDocument128, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'User Document 128', TypeName = 'Spectra.QESTLab.Entities.UserDocument128, QESTLab.Entities' WHERE QestEntityUUID = '763D2764-C54D-4939-86E8-39745F74C1CD' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = '9BBA5BE5-AFD3-4F46-B056-5ED89F841226') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('9BBA5BE5-AFD3-4F46-B056-5ED89F841226', 'User Document 129', 'Spectra.QESTLab.Entities.UserDocument129, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'User Document 129', TypeName = 'Spectra.QESTLab.Entities.UserDocument129, QESTLab.Entities' WHERE QestEntityUUID = '9BBA5BE5-AFD3-4F46-B056-5ED89F841226' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = '532C88DE-43BF-4DE2-A964-223880F326B8') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('532C88DE-43BF-4DE2-A964-223880F326B8', 'User Document 130', 'Spectra.QESTLab.Entities.UserDocument130, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'User Document 130', TypeName = 'Spectra.QESTLab.Entities.UserDocument130, QESTLab.Entities' WHERE QestEntityUUID = '532C88DE-43BF-4DE2-A964-223880F326B8' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = 'C95E027F-5ADF-4D91-9AD9-ECB6DAFA2178') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('C95E027F-5ADF-4D91-9AD9-ECB6DAFA2178', 'User Document 132', 'Spectra.QESTLab.Entities.UserDocument132, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'User Document 132', TypeName = 'Spectra.QESTLab.Entities.UserDocument132, QESTLab.Entities' WHERE QestEntityUUID = 'C95E027F-5ADF-4D91-9AD9-ECB6DAFA2178' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = '9362FC86-AC27-4979-A98B-E130CCA128C3') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('9362FC86-AC27-4979-A98B-E130CCA128C3', 'User Document 134', 'Spectra.QESTLab.Entities.UserDocument134, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'User Document 134', TypeName = 'Spectra.QESTLab.Entities.UserDocument134, QESTLab.Entities' WHERE QestEntityUUID = '9362FC86-AC27-4979-A98B-E130CCA128C3' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = '29C3CD02-A21C-49B4-87D6-6B8C13B6D41C') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('29C3CD02-A21C-49B4-87D6-6B8C13B6D41C', 'User Document 136', 'Spectra.QESTLab.Entities.UserDocument136, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'User Document 136', TypeName = 'Spectra.QESTLab.Entities.UserDocument136, QESTLab.Entities' WHERE QestEntityUUID = '29C3CD02-A21C-49B4-87D6-6B8C13B6D41C' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = '84EF1D65-7C61-44DE-90E3-7999C9770AFB') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('84EF1D65-7C61-44DE-90E3-7999C9770AFB', 'Work Order', 'Spectra.QESTLab.Entities.WorkOrder, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'Work Order', TypeName = 'Spectra.QESTLab.Entities.WorkOrder, QESTLab.Entities' WHERE QestEntityUUID = '84EF1D65-7C61-44DE-90E3-7999C9770AFB' END 
GO

IF NOT EXISTS(SELECT 1 FROM qestEntity WHERE QestEntityUUID = '65013616-B10F-441E-B842-A35D0095EE0D') 
	BEGIN INSERT INTO qestEntity (QestEntityUUID, Name, TypeName) VALUES ('65013616-B10F-441E-B842-A35D0095EE0D', 'MinAndMaxDensity', 'Spectra.QESTLab.Entities.MinAndMaxDensity, QESTLab.Entities') END 
ELSE 
	BEGIN UPDATE qestEntity SET Name = 'MinAndMaxDensity', TypeName = 'Spectra.QESTLab.Entities.MinAndMaxDensity, QESTLab.Entities' WHERE QestEntityUUID = '65013616-B10F-441E-B842-A35D0095EE0D' END 
GO
