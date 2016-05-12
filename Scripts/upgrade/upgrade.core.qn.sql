
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'qestReverseLookup')
BEGIN

	-- MAKE THIS A REPAIR THING? 
	--BEGIN TRANSACTION
	--	SELECT DISTINCT QestID, QestUniqueID, QestParentID, QestUniqueParentID INTO RL_TEMP
	--	FROM qestReverseLookup GROUP BY QestUniqueID, QestID, QestParentID, QestUniqueParentID HAVING COUNT(*) > 1

	--	DELETE qestReverseLookup FROM qestReverseLookup RL JOIN RL_TEMP TT ON RL.QestID = TT.QestID AND RL.QestUniqueID = TT.QestUniqueID

	--	INSERT INTO qestReverseLookup (QestUniqueID, QestID, QestParentID, QestUniqueParentID)
	--	SELECT QestUniqueID, QestID, QestParentID, QestUniqueParentID FROM RL_TEMP

	--	DROP TABLE RL_TEMP
	--COMMIT TRANSACTION
	--GO

	-- VALIDATION: Check for zero QestUniqueIDs
	IF EXISTS(SELECT 1 FROM qestReverseLookup WHERE QestUniqueID = 0)
	BEGIN
	  declare @list_of_tables nvarchar(4000)
      select @list_of_tables = substring((select ', ' + convert(nvarchar(8), rl.QestID) + coalesce(' - ' + tn.Value, '')
      from (select distinct QestID from qestReverseLookup where QestUniqueID = 0) rl
      left join qestObjects tn on rl.QestID = tn.QestID and tn.Property = 'tablename'
      for xml path ('') ), 3, 4000)

		RAISERROR ('qestReverseLookup corruption detected. Zero-value QestUniqueIDs exist for the following object types: %s
  For each document table, check that QestUniqueID column marked as the identity column and the *_Insert_UniqueID trigger is operational.

  You may be able to fix this data using the following SQL script, but you should test it first!:

  begin transaction
  declare curSQL cursor fast_forward for
  select ''update rl set QestUniqueID = src.QestUniqueID from [dbo].[qestReverseLookup] rl inner join '' + quotename(t.table_name) + '' src on rl.QestUUID = src.QestUUID where rl.QestUniqueID = 0''
  from INFORMATION_SCHEMA.TABLES t
  where exists (
    select *
      from qestReverseLookup rl
      inner join qestObjects o on rl.QestID = o.QestID and o.Property = ''TableName''
      where rl.QestUniqueID = 0
        and o.Value = t.TABLE_NAME
  )
  and t.TABLE_SCHEMA = ''dbo''
  order by t.TABLE_NAME
  open curSQL
  declare @sql_statement nvarchar(max)
  fetch next from curSQL into @sql_statement
  while @@FETCH_STATUS = 0
  begin
    exec sp_executesql @sql_statement
    fetch next from curSQL into @sql_statement
  end
  close curSQL
  deallocate curSQL
  rollback transaction

  ', 16, 0, @list_of_tables)
	END

	-- VALIDATION: Check for duplicate QestID, QestUniqueID pairs
	IF EXISTS(SELECT 1 FROM qestReverseLookup GROUP BY QestUniqueID, QestID HAVING COUNT(*) > 1)
	BEGIN
	  declare @number_of_duplicates int;
	  select @number_of_duplicates = count(*) from (SELECT 1 X FROM qestReverseLookup GROUP BY QestUniqueID, QestID HAVING COUNT(*) > 1) X
		RAISERROR ('qestReverseLookup corruption detected. %d Duplicate QestID/QestUniqueID pairs found.
	You can list them using:
	  select QestID, QestUniqueID, count(*)
	  from qestReverseLookup
	  group by QestID, QestUniqueID
	  having count(*) > 1
	', 16, 0, @number_of_duplicates)
	END
		
	EXEC [dbo].[qest_InsertUpdateColumn] 'qestReverseLookup', 'QestUUID', 'uniqueidentifier', NULL, 'YES', NULL
	EXEC [dbo].[qest_InsertUpdateColumn] 'qestReverseLookup', 'QestParentUUID', 'uniqueidentifier', NULL, 'YES', NULL
	EXEC [dbo].[qest_InsertUpdateColumn] 'qestReverseLookup', 'SampleArticleUUID', 'uniqueidentifier', NULL, 'YES', NULL
	EXEC [dbo].[qest_InsertUpdateColumn] 'qestReverseLookup', 'TestPlanUUID', 'uniqueidentifier', NULL, 'YES', NULL
	EXEC [dbo].[qest_InsertUpdateColumn] 'qestReverseLookup', 'QestOwnerLabNo', 'int', NULL, 'NO', '((0))'
	EXEC [dbo].[qest_InsertUpdateColumn] 'qestReverseLookup', 'QestCreatedBy', 'int', NULL, 'YES', NULL
	EXEC [dbo].[qest_InsertUpdateColumn] 'qestReverseLookup', 'QestCreatedDate', 'datetime', NULL, 'YES', NULL
	EXEC [dbo].[qest_InsertUpdateColumn] 'qestReverseLookup', 'QestModifiedBy', 'int', NULL, 'YES', NULL
	EXEC [dbo].[qest_InsertUpdateColumn] 'qestReverseLookup', 'QestModifiedDate', 'datetime', NULL, 'YES', NULL
	EXEC [dbo].[qest_InsertUpdateColumn] 'qestReverseLookup', 'QestStatusFlags', 'int', NULL, 'YES', NULL
		
	-- Ensure index on QestUniqueID & QestID, important for update performance
	IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_qestReverseLookup_QestUniqueID_QestID')
	BEGIN
		CREATE INDEX IX_qestReverseLookup_QestUniqueID_QestID ON qestReverseLookup ([QestUniqueID],[QestID])
	END
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Laboratory') 
BEGIN
	EXEC qest_GenerateQestUUID 'Laboratory'
END
GO

EXEC qest_EnableActivityForQestnet 'Users'
GO
EXEC qest_EnableActivityForQestnet 'People'
GO
EXEC qest_EnableActivityForQestnet 'SpecificationRecords'
GO
EXEC qest_EnableActivityForQestnet 'Specifications'
GO

-- PATCH: Establish Users.PersonUUID using Users.PersonID
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Users')
BEGIN
	IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Users' AND COLUMN_NAME = 'PersonUUID')
	BEGIN 
		ALTER TABLE Users ADD PersonUUID uniqueidentifier NULL 
	END
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'People' AND COLUMN_NAME = 'QestUniqueID') AND
	EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Users' AND COLUMN_NAME = 'PersonUUID')
BEGIN 
 	-- Populate PersonUUID
	UPDATE U SET PersonUUID = P.QestUUID
	FROM People P INNER JOIN Users U ON P.QestUniqueID = U.PersonID
	WHERE U.PersonUUID IS NULL

	-- Turn PersonUUID non-nullable
	ALTER TABLE Users ALTER COLUMN PersonUUID uniqueidentifier NOT NULL
END
GO

-- PATCH: Establish LaboratoryMapping.LocationUUID using LaboratoryMapping.LocationID
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'LaboratoryMapping')
BEGIN
	IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'LaboratoryMapping' AND COLUMN_NAME = 'LocationUUID')
	BEGIN 
		ALTER TABLE LaboratoryMapping ADD LocationUUID uniqueidentifier NULL 
	END	
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Laboratory' AND COLUMN_NAME = 'QestUniqueID')
	AND EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'LaboratoryMapping' AND COLUMN_NAME = 'LocationUUID')
BEGIN 
	UPDATE LaboratoryMapping SET LocationUUID = L.QestUUID
	FROM Laboratory L 
	INNER JOIN LaboratoryMapping M ON L.QestUniqueID = M.LocationID 
	WHERE M.LocationUUID IS NULL 

	ALTER TABLE LaboratoryMapping ALTER COLUMN LocationUUID uniqueidentifier NOT NULL
END
GO

-- PATCH: Establish SpecificationRecords.QestParentUUID using SpecificationRecords.SpecificationID
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'SpecificationRecords')
BEGIN
	IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SpecificationRecords' AND COLUMN_NAME = 'QestParentUUID')
	BEGIN 
		ALTER TABLE SpecificationRecords ADD QestParentUUID uniqueidentifier NULL 
	END
END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Specifications' AND COLUMN_NAME = 'QestUniqueID')
	AND EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SpecificationRecords' AND COLUMN_NAME = 'QestParentUUID')
BEGIN
	IF EXISTS(SELECT 1 FROM Specifications WHERE QestUUID IS NOT NULL GROUP BY QestUUID HAVING COUNT(*) > 1)
	BEGIN
		UPDATE Specifications SET QestUUID = NULL WHERE QestUUID IN (SELECT QestUUID FROM Specifications WHERE QestUUID IS NOT NULL GROUP BY QestUUID HAVING COUNT(*) > 1)
	END
	UPDATE SpecificationRecords SET QestParentUUID = S.QestUUID
	FROM Specifications S 
	INNER JOIN SpecificationRecords R ON S.QestUniqueID = R.SpecificationID 
	WHERE R.QestParentUUID IS NULL

	ALTER TABLE SpecificationRecords ALTER COLUMN QestParentUUID uniqueidentifier NOT NULL
END
GO







