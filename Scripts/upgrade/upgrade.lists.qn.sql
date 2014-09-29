
-- Generate QestUUID for Lists
DECLARE @TableName nvarchar(255)
DECLARE tableCursor CURSOR LOCAL for
	SELECT name FROM sys.tables WHERE type_desc = 'USER_TABLE' AND name LIKE 'List%' 
	AND NOT name = 'ListLanguageTranslations' ORDER BY name
	-- LanguageTranslations excluded because not currently edited in QL and has a specific PK
	-- will need to be converted to QestUUID PK and correct indexing at some point.
	
OPEN tableCursor
FETCH NEXT FROM tableCursor INTO @TableName
WHILE @@FETCH_STATUS = 0 BEGIN
	EXEC qest_GenerateQestUUID @TableName	
	FETCH NEXT FROM tableCursor INTO @TableName
END
CLOSE tableCursor
DEALLOCATE tableCursor
GO

