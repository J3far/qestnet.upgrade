
-- TODO:  Switch to insert/update statements

DELETE FROM qestBusinessRule
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger) 
VALUES ('84EF1D65-7C61-44DE-90E3-7999C9770AFB', 101, 'Spectra.QESTLab.Entities.Rules.WorkOrder.RuleWorkOrder, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('325FB182-CB35-4088-B6C8-6D981DDD493D', 1001, 'Spectra.QESTLab.Entities.Rules.Samples.Aggsoil.RuleAggsoilSample, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('18812DDC-C274-4051-8ADE-B615B7DDD20D', 1401, 'Spectra.QESTLab.Entities.Rules.Samples.Other.RuleOtherSample, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('F89F9987-F5AC-41E2-82A8-050B8E117103', 1602, 'Spectra.QESTLab.Entities.Rules.Samples.Concrete.RuleConcreteSample, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('F89F9987-F5AC-41E2-82A8-050B8E117103', 1604, 'Spectra.QESTLab.Entities.Rules.Samples.Concrete.RuleConcreteSample, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('59C9472F-AB50-45AD-A7FF-94E638D10A5E', 1701, 'Spectra.QESTLab.Entities.Rules.Samples.Asphalt.RuleAsphaltSample, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('300BD23C-3A89-4646-AD25-A2810120735A', 1801, 'Spectra.QESTLab.Entities.Rules.Samples.Geotechnical.RuleGeotechnicalSample, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('1503F3D6-DB3D-4499-B3E5-A22600A6365C', 11509, 'Spectra.QESTLab.Entities.Rules.Tests.Aggsoil.RuleAtterbergLimit, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('1503F3D6-DB3D-4499-B3E5-A22600A6365C', 11510, 'Spectra.QESTLab.Entities.Rules.Tests.Aggsoil.RuleAtterbergLimit, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('B71A17D3-B620-41CB-874C-A26800D8A75E', 11511, 'Spectra.QESTLab.Entities.Rules.Tests.Aggsoil.RuleConePenetrometerAtterbergLimit, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('B71A17D3-B620-41CB-874C-A26800D8A75E', 11512, 'Spectra.QESTLab.Entities.Rules.Tests.Aggsoil.RuleConePenetrometerAtterbergLimit, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('B048503D-419F-4065-A59C-A20B00FA02D1', 18021, 'Spectra.QESTLab.Entities.Rules.Misc.RuleTimekeepingRecord, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('6E805F95-B056-4F5B-B7D4-F7332A34450D', 90201, 'Spectra.QESTLab.Entities.Rules.Misc.RuleTestReportImage, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('1503F3D6-DB3D-4499-B3E5-A22600A6365C', 110047, 'Spectra.QESTLab.Entities.Rules.Tests.Aggsoil.RuleAtterbergLimit, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('46164FD3-7835-4223-99C6-B075CF253E38', 110060, 'Spectra.QESTLab.Entities.Rules.Tests.Aggsoil.RuleMoistureContent, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('46164FD3-7835-4223-99C6-B075CF253E38', 110066, 'Spectra.QESTLab.Entities.Rules.Tests.Aggsoil.RuleMoistureContent, QESTLab.Entities.Rules', 0, 1)
GO



INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('1503F3D6-DB3D-4499-B3E5-A22600A6365C', 110087, 'Spectra.QESTLab.Entities.Rules.Tests.Aggsoil.RuleAtterbergLimit, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('C9041191-A093-485B-A014-9B83145408A5', 110201, 'Spectra.QESTLab.Entities.Rules.Tests.Aggsoil.RuleRelativeCompaction, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('C9041191-A093-485B-A014-9B83145408A5', 110202, 'Spectra.QESTLab.Entities.Rules.Tests.Aggsoil.RuleRelativeCompaction, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('C2F67FF9-6BA8-4447-8205-E22E75989060', 110243, 'Spectra.QESTLab.Entities.Rules.Tests.Aggsoil.RuleNuclearFieldDensity, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('17883E65-2891-4236-8494-4B2FF00647B9', 110304, 'Spectra.QESTLab.Entities.Rules.Tests.Aggsoil.RuleSandReplacement, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('C2F67FF9-6BA8-4447-8205-E22E75989060', 110706, 'Spectra.QESTLab.Entities.Rules.Tests.Aggsoil.RuleNuclearFieldDensity, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('7727541D-FBCE-401C-ADCF-E518CAB7E362', 110739, 'Spectra.QESTLab.Entities.Rules.Tests.Aggsoil.RuleParticleSizeDistributionReduced, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('DB7F289A-3CAC-44E3-A580-7E17D5704F58', 110763, 'Spectra.QESTLab.Entities.Rules.Tests.Aggsoil.RulePavementThickness, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('C2F67FF9-6BA8-4447-8205-E22E75989060', 110800, 'Spectra.QESTLab.Entities.Rules.Tests.Aggsoil.RuleNuclearFieldDensity, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('DB7208CD-3CF0-4FE1-852D-A22E00DFAC2C', 111000, 'Spectra.QESTLab.Entities.Rules.Tests.Aggsoil.RuleLiquidLimitSpecimen, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('5E904032-EDA7-4739-A964-A22E00DFAC2C', 111001, 'Spectra.QESTLab.Entities.Rules.Tests.Aggsoil.RulePlasticLimitSpecimen, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('5F144D1A-13F0-44BF-85DF-A26C00E76E45', 111002, 'Spectra.QESTLab.Entities.Rules.Tests.Aggsoil.RuleConePenetrometerLiquidLimitSpecimen, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('3FAEB807-ABAD-4C57-894B-A26C00E76E45', 111003, 'Spectra.QESTLab.Entities.Rules.Tests.Aggsoil.RuleConePenetrometerPlasticLimitSpecimen, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('FE180C19-790C-45B4-9AC9-0E66144A3EE6', 116132, 'Spectra.QESTLab.Entities.Rules.Tests.Concrete.RuleThickness, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('FC7747AF-3291-4377-8CCD-9754C8C92BEB', 117018, 'Spectra.QESTLab.Entities.Rules.Tests.Asphalt.RuleNuclearFieldDensity, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('610C2FE0-5B46-4C81-91ED-A2D600E909CD', 110822, 'Spectra.QESTLab.Entities.Rules.Tests.Aggsoil.RuleTriaxial, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('610C2FE0-5B46-4C81-91ED-A2D600E909CD', 110823, 'Spectra.QESTLab.Entities.Rules.Tests.Aggsoil.RuleTriaxial, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('610C2FE0-5B46-4C81-91ED-A2D600E909CD', 110824, 'Spectra.QESTLab.Entities.Rules.Tests.Aggsoil.RuleTriaxial, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('610C2FE0-5B46-4C81-91ED-A2D600E909CD', 110825, 'Spectra.QESTLab.Entities.Rules.Tests.Aggsoil.RuleTriaxial, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('610C2FE0-5B46-4C81-91ED-A2D600E909CD', 110826, 'Spectra.QESTLab.Entities.Rules.Tests.Aggsoil.RuleTriaxial, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('610C2FE0-5B46-4C81-91ED-A2D600E909CD', 110827, 'Spectra.QESTLab.Entities.Rules.Tests.Aggsoil.RuleTriaxial, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('610C2FE0-5B46-4C81-91ED-A2D600E909CD', 110828, 'Spectra.QESTLab.Entities.Rules.Tests.Aggsoil.RuleTriaxial, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('610C2FE0-5B46-4C81-91ED-A2D600E909CD', 110829, 'Spectra.QESTLab.Entities.Rules.Tests.Aggsoil.RuleTriaxial, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('F893E9F4-CE8C-4BF2-811D-A2BC00E1F494', 110245, 'Spectra.QESTLab.Entities.Rules.Tests.Aggsoil.RuleDensityDriveCylinder, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('FC7747AF-3291-4377-8CCD-9754C8C92BEB', 117062, 'Spectra.QESTLab.Entities.Rules.Tests.Asphalt.RuleNuclearFieldDensity, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('FC7747AF-3291-4377-8CCD-9754C8C92BEB', 117062, 'Spectra.QESTLab.Entities.Rules.Tests.Asphalt.RuleNuclearFieldDensity, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('AB79C2C3-9E4B-4B57-B06E-A2C900F1D126', 16015, 'Spectra.QESTLab.Entities.Rules.Tests.Concrete.RuleShrinkage, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('DA20E982-12CA-4496-B1B1-A2C900F1D126', 111100, 'Spectra.QESTLab.Entities.Rules.Tests.Concrete.RuleShrinkageSpecimen, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('65013616-B10F-441E-B842-A35D0095EE0D', 110904, 'Spectra.QESTLab.Entities.Rules.Tests.Aggsoil.MinAndMaxDensity.RuleMinAndMaxDensity, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('65013616-B10F-441E-B842-A35D0095EE0D', 110905, 'Spectra.QESTLab.Entities.Rules.Tests.Aggsoil.MinAndMaxDensity.RuleMinAndMaxDensity, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('65013616-B10F-441E-B842-A35D0095EE0D', 110919, 'Spectra.QESTLab.Entities.Rules.Tests.Aggsoil.MinAndMaxDensity.RuleMinAndMaxDensity, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('ED917156-37B7-4E5A-99F6-6A88F084A097', 110930, 'Spectra.QESTLab.Entities.Rules.Tests.Aggsoil.RuleParticleSizeDistribution, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('ED917156-37B7-4E5A-99F6-6A88F084A097', 110931, 'Spectra.QESTLab.Entities.Rules.Tests.Aggsoil.RuleParticleSizeDistribution, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('ED917156-37B7-4E5A-99F6-6A88F084A097', 110932, 'Spectra.QESTLab.Entities.Rules.Tests.Aggsoil.RuleParticleSizeDistribution, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('ED917156-37B7-4E5A-99F6-6A88F084A097', 110933, 'Spectra.QESTLab.Entities.Rules.Tests.Aggsoil.RuleParticleSizeDistribution, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('ED917156-37B7-4E5A-99F6-6A88F084A097', 110934, 'Spectra.QESTLab.Entities.Rules.Tests.Aggsoil.RuleParticleSizeDistribution, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('ED917156-37B7-4E5A-99F6-6A88F084A097', 110935, 'Spectra.QESTLab.Entities.Rules.Tests.Aggsoil.RuleParticleSizeDistribution, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('ED917156-37B7-4E5A-99F6-6A88F084A097', 110936, 'Spectra.QESTLab.Entities.Rules.Tests.Aggsoil.RuleParticleSizeDistribution, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('ED917156-37B7-4E5A-99F6-6A88F084A097', 110937, 'Spectra.QESTLab.Entities.Rules.Tests.Aggsoil.RuleParticleSizeDistribution, QESTLab.Entities.Rules', 0, 1)
GO

INSERT INTO qestBusinessRule (QestEntityUUID, QestID, TypeName, ExecutionOrder, RuleTrigger)
VALUES ('ED917156-37B7-4E5A-99F6-6A88F084A097', 110938, 'Spectra.QESTLab.Entities.Rules.Tests.Aggsoil.RuleParticleSizeDistribution, QESTLab.Entities.Rules', 0, 1)
GO
