-- Remove legacy document foreign keys (from QF2/QF3)
-- FIXME: should be more accurate

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'qestObject')
BEGIN 
	EXEC qest_DropReferencingForeignKeys 'qestObject'
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'LaboratoryMapping')
BEGIN 
	EXEC qest_DropReferencingForeignKeys 'LaboratoryMapping'
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Laboratory')
BEGIN 
	EXEC qest_DropReferencingForeignKeys 'Laboratory'
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Users')
BEGIN 
	EXEC qest_DropReferencingForeignKeys 'Users'
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'People')
BEGIN 
	EXEC qest_DropReferencingForeignKeys 'People'
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Specifications')
BEGIN 
	EXEC qest_DropReferencingForeignKeys 'Specifications'
END
GO




