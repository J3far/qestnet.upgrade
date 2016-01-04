-------------------------------------------------------------------------
-- cr#2779 Suitability Rules for Triaxial Tests
-- 
-- Database schema corrections for obsolete columns previously used with suitability rule definitions.
-- These have been superseded by a new implementation for QESTLab 4.0 / FDBB release
--
-- Database: QESTLab
-- Created By: Lief Martin
-- Created Date: 15 Dec 2015
-- Last Modified By: Lief Martin
-- Last Modified: 15 Dec 2015
-- 
-- Version: 1.0
-- Change LOG
--	1.0 Original Version
--
-- Repeatability: SAFE 
-- Re-run Requirement: Once-off
-------------------------------------------------------------------------

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'dbo' and TABLE_NAME = 'SuitabilityTestTypeMaterialCategory' AND COLUMN_NAME = 'MinimumMass' AND DATA_TYPE = 'float')
BEGIN 
	alter table [dbo].[SuitabilityTestTypeMaterialCategory] alter column MinimumMass real null;
END
GO
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'dbo' and  TABLE_NAME = 'SuitabilityRuleConfiguration' AND COLUMN_NAME = 'DefaultDiameter')
BEGIN 
  alter table [dbo].[SuitabilityRuleConfiguration] drop column DefaultDiameter
END
GO
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'dbo' and  TABLE_NAME = 'SuitabilityRuleConfiguration' AND COLUMN_NAME = 'LengthDiameterRatio')
BEGIN 
  alter table [dbo].[SuitabilityRuleConfiguration] drop column LengthDiameterRatio
END
GO
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'dbo' and  TABLE_NAME = 'SuitabilityRuleConfiguration' AND COLUMN_NAME = 'LengthConstant')
BEGIN 
  alter table [dbo].[SuitabilityRuleConfiguration] drop column LengthConstant
END
GO
