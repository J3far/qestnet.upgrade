

-- Should be no permanent data in SessionLocks
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'SessionLocks')
BEGIN 
	DELETE FROM SessionLocks
END
GO

-- Should be no permanent data in SessionConnections
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'SessionConnections')
BEGIN 
	DELETE FROM SessionConnections
END
GO
