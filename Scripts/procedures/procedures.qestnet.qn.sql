
-- Procedure for returning work progress rules
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_GetWorkProgressRules' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
    DROP PROCEDURE [dbo].[qest_GetWorkProgressRules]
END
GO

CREATE PROCEDURE [dbo].[qest_GetWorkProgressRules] @QestID int
AS
BEGIN
	SELECT Stage, PercentComplete, Criteria, Predicate FROM qestWorkProgressRulesByQestID WHERE 
	NOT Stage IS NULL AND NOT PercentComplete IS NULL AND NOT Criteria IS NULL AND QestID = @QestID
	ORDER BY Stage
END
GO

-- Procedure for returning permission values
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_GetPermissionMaps' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
    DROP PROCEDURE [dbo].[qest_GetPermissionMaps]
END
GO

CREATE PROCEDURE [dbo].[qest_GetPermissionMaps] @PersonID int, @ActivityID int, @LocationID int
AS
BEGIN
	SELECT PermissionMap
	FROM RolePermissions AS perm
	WHERE 
	perm.ActivityID in
	(
		SELECT a2.QestUniqueID
		FROM Activities a1
			INNER JOIN Activities a2 ON (a1.Lft BETWEEN a2.Lft AND a2.Rgt)
		WHERE a1.QestUniqueID = @ActivityID
	)
	AND perm.RoleID in
	(
		SELECT map.RoleID FROM PeopleRolesMapping map WHERE map.PersonID = @PersonID
	)
	AND (@LocationID = 0 OR perm.LocationID in
	(
		SELECT l2.QestUniqueID
		FROM Laboratory l1
			INNER JOIN Laboratory l2 ON (l1.Lft BETWEEN l2.Lft AND l2.Rgt)
		WHERE l1.QestUniqueID = @LocationID
	))
	AND (perm.InstanceID = '')
END
GO

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_GetDescendantIDs' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
    DROP PROCEDURE [dbo].[qest_GetDescendantIDs]
END
GO

CREATE PROCEDURE [dbo].[qest_GetDescendantIDs] @QestUUID uniqueidentifier
AS
BEGIN
	WITH R AS 
	(
		SELECT * FROM qestReverseLookup WHERE QestParentUUID = @QestUUID
		UNION ALL
		SELECT C.* FROM qestReverseLookup C JOIN R ON C.QestParentUUID = R.QestUUID
	)
	SELECT QestID, QestUUID FROM R
END
GO

-- CSV table function - used in work orders requiring correction procedure below
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'CSVTable' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'FUNCTION')
BEGIN
    DROP FUNCTION [dbo].[CSVTable]
END
GO

CREATE FUNCTION dbo.CSVTable(@Str varchar(7000))
RETURNS @t table (numberval int, stringval varchar(100), DateVal datetime)
AS
BEGIN
	DECLARE @i int;
	DECLARE @c varchar(100);

	SET @Str = @Str + ','
	SET @i = 1;
	SET @c = '';

	WHILE @i <= len(@Str)
	BEGIN
		IF substring(@Str,@i,1) = ','
	BEGIN
		INSERT INTO @t
		VALUES (CASE WHEN isnumeric(@c)=1 THEN @c ELSE Null END, rtrim(ltrim(@c)), 
				CASE WHEN isdate(@c)=1 THEN @c ELSE Null END)
		SET @c = ''
	END
	ELSE
		SET @c = @c + substring(@Str,@i,1)
		SET @i = @i +1
	END
	RETURN
END
GO

-- Get the work orders requiring correction
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_GetWorkOrdersCorrectionRequired' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
    DROP PROCEDURE [dbo].[qest_GetWorkOrdersCorrectionRequired]
END
GO

-- This stored proc is specific to PSI as it requires some custom fields (CorrectionRequired, CorrectionComplete) to exist.
-- Since a 'create procedure' statement has to be the first query in the batch, if you want an if statement first, you need to
-- use 'EXEC', which means converting the stored proc to a string.  Not nice, but it "works".
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SampleRegister' AND COLUMN_NAME = '_CorrectionRequired')
OR NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DocumentConcreteDestructive' AND COLUMN_NAME = '_CorrectionRequired')
  PRINT 'Skipped: custom field CorrectionRequired was not found in SampleRegister and DocumentConcreteDestructive tables.'
ELSE
EXEC(
'CREATE procedure [dbo].[qest_GetWorkOrdersCorrectionRequired]
	@LocationIDs nvarchar (max),
	@PersonCode nvarchar (30)
AS
BEGIN
	SELECT QestUUID FROM WorkOrders WHERE QestUniqueID in (SELECT DISTINCT W.QESTUniqueID
	FROM WorkOrders W
	LEFT JOIN SampleRegister S ON W.QestUniqueID = S.QestUniqueParentID AND W.QestID = S.QestParentID
	LEFT JOIN DocumentConcreteDestructive D ON W.QestUniqueID = D.QestUniqueParentID AND W.QestID = D.QestParentID
	LEFT JOIN LaboratoryMapping L ON W.QESTOwnerLabNo = L.LabNo
	WHERE L.LocationID IN (SELECT NumberVal from dbo.CSVTable(@LocationIDs)) AND W.QestID = 101 AND W.Inactive != 1
	AND W.PersonCode = @PersonCode
	AND (S._CorrectionRequired = ''True'' AND S._CorrectionComplete IS NULL) OR S._CorrectionComplete != ''True''
	OR (D._CorrectionRequired = ''True'' AND D._CorrectionComplete IS NULL) OR D._CorrectionComplete != ''True'')
	ORDER BY StartTime, FinishTime, ProjectCode, ProjectName, WorkOrderID
END')

-- Procedure for returning laboratory list for a person
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_GetLaboratoriesByPerson' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
    DROP PROCEDURE [dbo].[qest_GetLaboratoriesByPerson]
END
GO

CREATE PROCEDURE [dbo].[qest_GetLaboratoriesByPerson] @PersonID int
AS
BEGIN
	DECLARE @t TABLE
	(
		[LocationID] int unique not null,
		[ParentLocationID] int null,
		[QestID] int null,
		[LabNo] int null,
		[Name] nvarchar(200) null,
		[Inactive] bit null
	)

	DECLARE @AID int
	SELECT @AID = QestUniqueID FROM Activities WHERE QestID = 90113
	
	INSERT INTO @t ([LocationID], [ParentLocationID], [QestID], [LabNo], [Name], [Inactive])
	SELECT [QestUniqueID], [QestUniqueParentID], [QestID], [LabNo], [Name], [Inactive] 
	FROM dbo.qest_GetLocations(@PersonID, @AID, '', 1) -- READ permission test
	
	SELECT * FROM @t
END
GO

-- Procedure for business rule names
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_GetRuleTypeNames' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
    DROP PROCEDURE [dbo].[qest_GetRuleTypeNames]
END
GO

CREATE procedure [dbo].[qest_GetRuleTypeNames]
  @EntityType nvarchar(255),
  @QestID int,
  @RuleTrigger int
AS
BEGIN
	SELECT BR.TypeName FROM qestBusinessRule BR
	INNER JOIN qestEntity E on E.QestEntityUUID = BR.QestEntityUUID
	WHERE E.TypeName = @EntityType AND BR.QestID = @QestID AND BR.RuleTrigger = @RuleTrigger
	ORDER BY BR.ExecutionOrder ASC
END
GO

-- Procedure for returning list results
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_GetListItems' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
    DROP PROCEDURE [dbo].[qest_GetListItems]
END
GO

CREATE procedure [dbo].[qest_GetListItems]
	@QestID int,
	@LabNo int,
	@TextField varchar(255),
	@CodeField varchar(255) = '',
	@FilterField varchar(255) = '',
	@IncludeGlobals bit = 1,
	@Preferred bit = 0,
	@Restrictions varchar(8000) = ''
AS
BEGIN
	DECLARE @TableName varchar(255)
	SELECT @TableName = Value FROM qestObjects WHERE QestID = @QestID AND Property = 'TableName'

	DECLARE @TableQestID int
	SELECT @TableQestID = @QestID
	IF EXISTS(SELECT 1 FROM qestObjects WHERE QestID = @QestID AND Property = 'QestIdInTable')
	BEGIN
		SELECT @TableQestID = Value FROM qestObjects WHERE QestID = @QestID AND Property = 'QestIdInTable'
	END

	IF (ISNULL(@CodeField, '') = '') BEGIN SET @CodeField = 'NULL' END
	IF (ISNULL(@FilterField, '') = '') BEGIN SET @FilterField = 'NULL' END
	
	DECLARE @SQL varchar(4000)
	SELECT @SQL = 'SELECT QestUniqueID, ' + @FilterField + ' As FilterValue, ' + @CodeField + ' As Code, ' + @TextField + ' As Name FROM ' + @TableName
	+ ' WHERE QestID = ' + CAST(@TableQestID as varchar) + ' AND ISNULL(' + @TextField + ','''') <> '''''
	+ ' AND ISNULL(Inactive,0) = 0 AND (QestOwnerLabNo = ' + CAST(@LabNo as varchar)
	
	IF (@IncludeGlobals = 1)
	BEGIN
		IF (@Preferred = 0)
		BEGIN
			SELECT @SQL = @SQL + ' OR QestOwnerLabNo = 0'
		END ELSE BEGIN
			SELECT @SQL = @SQL + ' OR PreferredLabNo = ' + CAST(@LabNo as varchar)
		END 	
	END

	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME=@TableName AND column_name='LaboratoryMapping') 
	BEGIN 
		SELECT @SQL = @SQL + ' OR LaboratoryMapping LIKE ''%,' + CAST(@LabNo as varchar) + ',%'')'
	END
	ELSE
	BEGIN
		SELECT @SQL = @SQL + ')'
	END

	IF (LEN(@Restrictions) > 0)
	BEGIN
		SELECT @SQL = @SQL + ' AND ' + @Restrictions
	END 
	
	SELECT @SQL = @SQL + ' ORDER BY Name'

	EXEC (@SQL)
END
GO

-- Get the unique IDs of the mapped external documents
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_GetMappedExternals' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
    DROP PROCEDURE [dbo].[qest_GetMappedExternals]
END
GO

CREATE procedure [dbo].[qest_GetMappedExternals]
	@QestID int,
	@AutoCreate bit = 1
AS
BEGIN
	SELECT DISTINCT EXT.QestUniqueID As QestUniqueID, ISNULL(CLS.AllowSign,0) As AllowSign
	--, MAP.QestID As DocumentTypeID,
	--EXT.DocumentName, EXT.DocumentDescription, CLS.QestUniqueID As ClassID,
	--CLS.ClassCode, CLS.ClassName, CLS.IsDefault, CLS.IsTemplate,
	--CLS.IsPrintable, CLS.IsExecutable, CLS.IntegrationModel, CLS.AccessModel,
	--CLS.AllowArchive, CLS.AllowPublish, EXT.MultipleSample, EXT.ParentTemplate
	FROM
	DocumentExternal EXT,
	ExternalDocumentMapping MAP,
	qestExternalDocumentClasses CLS,
	qestExternalDocumentClassesSecurity SEC
	WHERE EXT.DocumentClassCode = CLS.ClassCode
	AND CLS.ClassCode = SEC.ClassCode
	AND ISNULL(EXT.DocumentMappingAllowed, 0) = 1
	AND ISNULL(CLS.AutoCreate, 0) = @AutoCreate
	AND EXT.QestUniqueID = MAP.ExternalDocumentID
	AND MAP.QestID = @QestID
END
GO

-- Procedure for returning QESTLab options (returns only the most specific option and not regional & global if they also exist
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_GetOptionValue' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
    DROP PROCEDURE [dbo].[qest_GetOptionValue]
END
GO

CREATE procedure [dbo].[qest_GetOptionValue]
	@Name varchar(255),
	@QestID int = 0,
	@LocationID int = 0
AS
BEGIN
	SELECT TOP 1 O.QestUniqueID, O.OptionValue FROM Options O
	INNER JOIN
	(
		SELECT l2.QestUniqueID As LocationID, l2.Lvl As Lvl
		FROM Laboratory l1
			INNER JOIN Laboratory l2 ON (l1.Lft BETWEEN l2.Lft AND l2.Rgt)
		WHERE l1.QestUniqueID = @LocationID
	) L ON L.LocationID = O.LocationID OR (O.LocationID IS NULL AND L.Lvl = 1)
	WHERE O.OptionName = @Name AND (ISNULL(O.QestID, 0) = @QestID) 
	ORDER BY L.Lvl DESC
END
GO

-- Procedure for getting the next counter number and incrementing
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_GetNextCounterNumber' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
    DROP PROCEDURE [dbo].[qest_GetNextCounterNumber]
END
GO

CREATE procedure [dbo].[qest_GetNextCounterNumber]
	@QestUniqueParentID int,
	@LabNo int = NULL,
	@GroupingFieldValue1 nvarchar(50) = NULL,
	@GroupingFieldValue2 nvarchar(50) = NULL,
	@GroupingFieldValue3 nvarchar(50) = NULL,
	@GroupingFieldValue4 nvarchar(50) = NULL,
	@GroupingFieldValue5 nvarchar(50) = NULL
AS
BEGIN
	
	DECLARE @NN int
	DECLARE @UID int 
	DECLARE @LOCSPECIFIC bit
	
	-- Test if count is location specific
	SELECT @LOCSPECIFIC = ISNULL(LocationSpecific,0) FROM Counters WHERE QestUniqueID = @QestUniqueParentID
	
	-- Get existing value
	SELECT TOP 1 @UID = QestUniqueID, @NN = NextNumber FROM CounterValues
	WHERE QestUniqueParentID = @QestUniqueParentID AND
		((QestOwnerLabNo IS NULL AND @LOCSPECIFIC = 0) OR (QestOwnerLabNo = @LabNo AND NOT @LOCSPECIFIC = 0)) AND
		(GroupingFieldValue1 = @GroupingFieldValue1 OR (GroupingFieldValue1 IS NULL AND @GroupingFieldValue1 IS NULL)) AND
		(GroupingFieldValue2 = @GroupingFieldValue2 OR (GroupingFieldValue2 IS NULL AND @GroupingFieldValue2 IS NULL)) AND
		(GroupingFieldValue3 = @GroupingFieldValue3 OR (GroupingFieldValue3 IS NULL AND @GroupingFieldValue3 IS NULL)) AND
		(GroupingFieldValue4 = @GroupingFieldValue4 OR (GroupingFieldValue4 IS NULL AND @GroupingFieldValue4 IS NULL)) AND
		(GroupingFieldValue5 = @GroupingFieldValue5 OR (GroupingFieldValue5 IS NULL AND @GroupingFieldValue5 IS NULL))

	IF (@UID IS NULL)
	BEGIN		
		-- Insert new row and return NextNumber 1
		INSERT INTO CounterValues (QestUniqueParentID, NextNumber, QESTOwnerLabNo, GroupingFieldValue1, GroupingFieldValue2, GroupingFieldValue3, GroupingFieldValue4, GroupingFieldValue5)
		VALUES (@QestUniqueParentID, 2, CASE @LOCSPECIFIC WHEN 0 THEN NULL ELSE @LabNo END, @GroupingFieldValue1, @GroupingFieldValue2, @GroupingFieldValue3, @GroupingFieldValue4, @GroupingFieldValue5)	
		SET @NN = 1
	
	END ELSE BEGIN	
		-- Increment NextNumber
		UPDATE CounterValues SET NextNumber = @NN + 1 WHERE QestUniqueID = @UID			
	END
	
	SELECT @NN -- Return next number
END
GO