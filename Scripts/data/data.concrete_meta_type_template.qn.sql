--Create Temp Stored Proc

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'temp_AddToSpecimenTypeMetaMap' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
    EXEC('CREATE PROCEDURE dbo.temp_AddToSpecimenTypeMetaMap AS RETURN 0');
END
GO

ALTER PROCEDURE dbo.temp_AddToSpecimenTypeMetaMap 
	@TemplateName as nvarchar(50), @TemplateQestUniqueID as int, @IsDefaultTemplate as bit, @SampleQestID as int, @Type as nvarchar(8), @MetaQestID as int
AS
BEGIN
	declare @DisplayOrder as int
	select @DisplayOrder = COUNT(*) from QestSpecimenTypeMetaMap where TemplateQestUniqueID = @TemplateQestUniqueID
	INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [IsDefaultTemplate], [SampleQestID], [Type], [MetaQestID], [DisplayOrder]) VALUES (@TemplateName, @TemplateQestUniqueID, @IsDefaultTemplate, @SampleQestID, @Type, @MetaQestID, @DisplayOrder)
END

GO
--Create Templates

DELETE FROM QestSpecimenTypeMetaMap WHERE TemplateName = 'Default' OR TemplateQestUniqueID = 1
DELETE FROM QestSpecimenTypeMetaMap WHERE TemplateName = 'AS (2015)' OR TemplateQestUniqueID = 2
DELETE FROM QestSpecimenTypeMetaMap WHERE TemplateName = 'ASTM' OR TemplateQestUniqueID = 3
DELETE FROM QestSpecimenTypeMetaMap WHERE TemplateName = 'RMS' OR TemplateQestUniqueID = 4
DELETE FROM QestSpecimenTypeMetaMap WHERE TemplateName = 'Q' OR TemplateQestUniqueID = 5
DELETE FROM QestSpecimenTypeMetaMap WHERE TemplateName = 'NZS' OR TemplateQestUniqueID = 6
DELETE FROM QestSpecimenTypeMetaMap WHERE TemplateName = 'TxDOT' OR TemplateQestUniqueID = 7
DELETE FROM QestSpecimenTypeMetaMap WHERE TemplateName = 'AASHTO' OR TemplateQestUniqueID = 8
DELETE FROM QestSpecimenTypeMetaMap WHERE TemplateName = 'AS Reduced' OR TemplateQestUniqueID = 9
DELETE FROM QestSpecimenTypeMetaMap WHERE TemplateName = 'RILEM' OR TemplateQestUniqueID = 10
DELETE FROM QestSpecimenTypeMetaMap WHERE TemplateName = 'BS' OR TemplateQestUniqueID = 11
DELETE FROM QestSpecimenTypeMetaMap WHERE TemplateName = 'WA' OR TemplateQestUniqueID = 12
DELETE FROM QestSpecimenTypeMetaMap WHERE TemplateName = 'HY' OR TemplateQestUniqueID = 13
DELETE FROM QestSpecimenTypeMetaMap WHERE TemplateName = 'AS (1999)' OR TemplateQestUniqueID = 14
DELETE FROM QestSpecimenTypeMetaMap WHERE TemplateName = 'ASTM (2014)' OR TemplateQestUniqueID = 15
DELETE FROM QestSpecimenTypeMetaMap WHERE TemplateName = 'ASTM (2012)' OR TemplateQestUniqueID = 16
DELETE FROM QestSpecimenTypeMetaMap WHERE TemplateName = 'ASTM (2007)' OR TemplateQestUniqueID = 17

----US Defaults ASTM
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1602, '', 67101 --Slump Only
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1602, 'CIP100', 68350
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1602, 'COMP100', 68001
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1602, 'COMP150', 68001
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1602, 'COMP225', 68001
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1602, 'COMP75', 68001
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1602, 'COMPCOR', 68401
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1602, 'COMPUNIT', 69000
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1602, 'CRMSQ50', 68730
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1602, 'ELAS100', 68520
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1602, 'ELAS150', 68520
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1602, 'ELASCOR', 68530
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1602, 'FLEX', 68101
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1602, 'FLEXC', 68130
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1602, 'GRO100', 68750
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1602, 'GRO50', 68750
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1602, 'GRO75', 68750
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1602, 'GROCUBE', 68801
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1602, 'GROCUBNS', 68860
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1602, 'GROPRIS', 68900
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1602, 'GROSQ100', 68830
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1602, 'HOLPRIS', 68910
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1602, 'LCOMP75', 68450
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1602, 'LW75', 68460
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1602, 'MOR50', 68650
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1602, 'MOR75', 68650
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1602, 'MORCUBE', 68701
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1602, 'OTHER', 69900
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1602, 'SHOTCOR', 68600
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1602, 'SPLTEN', 68330

----US Defaults RILEM
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1602, 'AVC100', 68500
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1602, 'AWC100', 68510

----US Defaults BS
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1602, 'ELBS100', 68540
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1602, 'ELBS150', 68540
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1602, 'ELBSCOR', 68550

----NZ Defaults
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1603, '', 67102 --Slump Only
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1603, 'COMP100', 68002
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1603, 'COMP150', 68002
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1603, 'OTHER', 69900

----AU Defaults AS
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1604, '', 67100 --Slump Only
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1604, 'COMP100', 68000
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1604, 'COMP150', 68000
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1604, 'COMPCOR', 68400
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1604, 'COMPRCOR', 68404
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1604, 'DENFLX10', 68150
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1604, 'DENFLX15', 68150
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1604, 'DENS100', 68050
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1604, 'DENS150', 68050
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1604, 'DENSCOR', 68430
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1604, 'FLEX100', 68100
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1604, 'FLEX150', 68100
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1604, 'GROCUBE', 68800
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1604, 'INDTEN', 68300
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1604, 'MORCUBE', 68700
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1604, 'OTHER', 69900

----US Masonry Defaults
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1605, 'ABSBLOCK', 69070
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1605, 'ABSCOUP', 69070
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1605, 'ABSGPU', 69400
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1605, 'ABSGPUC', 69400
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1605, 'ABSIPU', 69360
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1605, 'ABSIPUC', 69360
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1605, 'ABSPAVC', 69310
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1605, 'ABSPAVER', 69310
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1605, 'ABSRWU', 69210
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1605, 'ABSRWUC', 69210
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1605, 'AREABLOC', 69060
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1605, 'AREACOUP', 69060
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1605, 'AREAPRIS', 68930
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1605, 'COMPAVC', 69300
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1605, 'COMPAVER', 69300
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1605, 'COMPBLOC', 69050
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1605, 'COMPCOUP', 69050
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1605, 'COMPGPU', 69380
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1605, 'COMPGPUC', 69380
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1605, 'COMPIPU', 69340
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1605, 'COMPIPUC', 69340
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1605, 'COMPRWU', 69200
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1605, 'COMPRWUC', 69200
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1605, 'CRMSQ50', 68731
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1605, 'GRO100', 68751
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1605, 'GRO50', 68751
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1605, 'GRO75', 68751
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1605, 'GROCUBE', 68804
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1605, 'GROCUBNS', 68861
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1605, 'GROPRIS', 68901
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1605, 'GROSQ100', 68831
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1605, 'HOLPRIS', 68911
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1605, 'MOR50', 68651
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1605, 'MOR75', 68651
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1605, 'MORCUBE', 68704
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1605, 'OTHER', 69900
--exec temp_AddToSpecimenTypeMetaMap 'Default', 1, 0, 1605, 'SOLPRIS', 68920

--US Defaults ASTM
if exists(select 1 from qestViewConfiguration where Active = 1 and Code in ('US', 'ME', 'Default'))
begin
	exec temp_AddToSpecimenTypeMetaMap 'ASTM', 3, -1, 1602, '', 67101 --Slump Only
	exec temp_AddToSpecimenTypeMetaMap 'ASTM', 3, -1, 1602, 'CIP100', 68350
	exec temp_AddToSpecimenTypeMetaMap 'ASTM', 3, -1, 1602, 'COMP75', 68001
	exec temp_AddToSpecimenTypeMetaMap 'ASTM', 3, -1, 1602, 'COMP100', 68001
	exec temp_AddToSpecimenTypeMetaMap 'ASTM', 3, -1, 1602, 'COMP150', 68001
	exec temp_AddToSpecimenTypeMetaMap 'ASTM', 3, -1, 1602, 'COMP225', 68001
	exec temp_AddToSpecimenTypeMetaMap 'ASTM', 3, -1, 1602, 'COMPCOR', 68401
	exec temp_AddToSpecimenTypeMetaMap 'ASTM', 3, -1, 1602, 'COMPUNIT', 69000
	exec temp_AddToSpecimenTypeMetaMap 'ASTM', 3, -1, 1602, 'CRMSQ50', 68730
	exec temp_AddToSpecimenTypeMetaMap 'ASTM', 3, -1, 1602, 'ELAS100', 68520
	exec temp_AddToSpecimenTypeMetaMap 'ASTM', 3, -1, 1602, 'ELAS150', 68520
	exec temp_AddToSpecimenTypeMetaMap 'ASTM', 3, -1, 1602, 'ELASCOR', 68530
	exec temp_AddToSpecimenTypeMetaMap 'ASTM', 3, -1, 1602, 'FLEX', 68101
	exec temp_AddToSpecimenTypeMetaMap 'ASTM', 3, -1, 1602, 'FLEXC', 68130
	exec temp_AddToSpecimenTypeMetaMap 'ASTM', 3, -1, 1602, 'GRO50', 68750
	exec temp_AddToSpecimenTypeMetaMap 'ASTM', 3, -1, 1602, 'GRO75', 68750
	exec temp_AddToSpecimenTypeMetaMap 'ASTM', 3, -1, 1602, 'GRO100', 68750
	exec temp_AddToSpecimenTypeMetaMap 'ASTM', 3, -1, 1602, 'GROCUBE', 68801
	exec temp_AddToSpecimenTypeMetaMap 'ASTM', 3, -1, 1602, 'GROCUBNS', 68860
	exec temp_AddToSpecimenTypeMetaMap 'ASTM', 3, -1, 1602, 'GROPRIS', 68900
	exec temp_AddToSpecimenTypeMetaMap 'ASTM', 3, -1, 1602, 'GROSQ100', 68830
	exec temp_AddToSpecimenTypeMetaMap 'ASTM', 3, -1, 1602, 'HOLPRIS', 68910
	exec temp_AddToSpecimenTypeMetaMap 'ASTM', 3, -1, 1602, 'LCOMP75', 68450
	exec temp_AddToSpecimenTypeMetaMap 'ASTM', 3, -1, 1602, 'LW75', 68460
	exec temp_AddToSpecimenTypeMetaMap 'ASTM', 3, -1, 1602, 'MOR50', 68650
	exec temp_AddToSpecimenTypeMetaMap 'ASTM', 3, -1, 1602, 'MOR75', 68650
	exec temp_AddToSpecimenTypeMetaMap 'ASTM', 3, -1, 1602, 'MORCUBE', 68701
	exec temp_AddToSpecimenTypeMetaMap 'ASTM', 3, -1, 1602, 'OTHER', 69900
	exec temp_AddToSpecimenTypeMetaMap 'ASTM', 3, -1, 1602, 'SHOTCOR', 68600
	exec temp_AddToSpecimenTypeMetaMap 'ASTM', 3, -1, 1602, 'SPLTEN', 68330
end

--US Defaults TxDOT
if exists(select 1 from qestViewConfiguration where Active = 1 and Code in ('US', 'Default'))
begin
	exec temp_AddToSpecimenTypeMetaMap 'TxDOT', 7, 0, 1602, '', 67105 --Slump Only
	exec temp_AddToSpecimenTypeMetaMap 'TxDOT', 7, 0, 1602, 'COMP75', 68005
	exec temp_AddToSpecimenTypeMetaMap 'TxDOT', 7, 0, 1602, 'COMP100', 68005
	exec temp_AddToSpecimenTypeMetaMap 'TxDOT', 7, 0, 1602, 'COMP150', 68005
	exec temp_AddToSpecimenTypeMetaMap 'TxDOT', 7, 0, 1602, 'COMP225', 68005
	exec temp_AddToSpecimenTypeMetaMap 'TxDOT', 7, 0, 1602, 'COMPCOR', 68406
	exec temp_AddToSpecimenTypeMetaMap 'TxDOT', 7, 0, 1602, 'FLEX', 68104
	exec temp_AddToSpecimenTypeMetaMap 'TxDOT', 7, 0, 1602, 'OTHER', 69900
end

--US Defaults AASHTO
if exists(select 1 from qestViewConfiguration where Active = 1 and Code in ('US', 'Default'))
begin
	exec temp_AddToSpecimenTypeMetaMap 'AASHTO', 8, 0, 1602, '', 67106 --Slump Only
	exec temp_AddToSpecimenTypeMetaMap 'AASHTO', 8, 0, 1602, 'COMP75', 68006
	exec temp_AddToSpecimenTypeMetaMap 'AASHTO', 8, 0, 1602, 'COMP100', 68006
	exec temp_AddToSpecimenTypeMetaMap 'AASHTO', 8, 0, 1602, 'COMP150', 68006
	exec temp_AddToSpecimenTypeMetaMap 'AASHTO', 8, 0, 1602, 'COMP225', 68006
	exec temp_AddToSpecimenTypeMetaMap 'AASHTO', 8, 0, 1602, 'FLEX', 68105
	exec temp_AddToSpecimenTypeMetaMap 'AASHTO', 8, 0, 1602, 'FLEXC', 68131
end

--US Defaults RILEM
if exists(select 1 from qestViewConfiguration where Active = 1 and Code in ('ME', 'Default'))
begin
	exec temp_AddToSpecimenTypeMetaMap 'RILEM', 10, 0, 1602, 'AVC100', 68500
	exec temp_AddToSpecimenTypeMetaMap 'RILEM', 10, 0, 1602, 'AWC100', 68510
end

--US Defaults BS
if exists(select 1 from qestViewConfiguration where Active = 1 and Code in ('ME', 'Default'))
begin
	exec temp_AddToSpecimenTypeMetaMap 'BS', 11, 0, 1602, 'ELBS100', 68540
	exec temp_AddToSpecimenTypeMetaMap 'BS', 11, 0, 1602, 'ELBS150', 68540
	exec temp_AddToSpecimenTypeMetaMap 'BS', 11, 0, 1602, 'ELBSCOR', 68550
	exec temp_AddToSpecimenTypeMetaMap 'BS', 11, 0, 1602, 'COMPCOR', 68407
	exec temp_AddToSpecimenTypeMetaMap 'BS', 11, 0, 1602, 'COMP100', 68008
	exec temp_AddToSpecimenTypeMetaMap 'BS', 11, 0, 1602, 'COMP150', 68008
end

--NZ Defaults
if exists(select 1 from qestViewConfiguration where Active = 1 and Code in ('NZ', 'Default'))
begin
	exec temp_AddToSpecimenTypeMetaMap 'NZS', 6, -1, 1603, '', 67102 --Slump Only
	exec temp_AddToSpecimenTypeMetaMap 'NZS', 6, -1, 1603, 'COMP100', 68002
	exec temp_AddToSpecimenTypeMetaMap 'NZS', 6, -1, 1603, 'COMP150', 68002
	exec temp_AddToSpecimenTypeMetaMap 'NZS', 6, -1, 1603, 'OTHER', 69900
end

--AU Defaults AS
if exists(select 1 from qestViewConfiguration where Active = 1 and Code in ('AUP', 'AUT', 'Default'))
begin
	exec temp_AddToSpecimenTypeMetaMap 'AS (2015)', 2, -1, 1604, '', 67100 --Slump Only
	exec temp_AddToSpecimenTypeMetaMap 'AS (2015)', 2, -1, 1604, 'COMP100', 68000
	exec temp_AddToSpecimenTypeMetaMap 'AS (2015)', 2, -1, 1604, 'COMP150', 68000
	exec temp_AddToSpecimenTypeMetaMap 'AS (2015)', 2, -1, 1604, 'COMPCOR', 68400
	exec temp_AddToSpecimenTypeMetaMap 'AS (2015)', 2, -1, 1604, 'COMPRCOR', 68404
	exec temp_AddToSpecimenTypeMetaMap 'AS (2015)', 2, -1, 1604, 'DENFLX10', 68150
	exec temp_AddToSpecimenTypeMetaMap 'AS (2015)', 2, -1, 1604, 'DENFLX15', 68150
	exec temp_AddToSpecimenTypeMetaMap 'AS (2015)', 2, -1, 1604, 'DENS100', 68050
	exec temp_AddToSpecimenTypeMetaMap 'AS (2015)', 2, -1, 1604, 'DENS150', 68050
	exec temp_AddToSpecimenTypeMetaMap 'AS (2015)', 2, -1, 1604, 'DENSCOR', 68430
	exec temp_AddToSpecimenTypeMetaMap 'AS (2015)', 2, -1, 1604, 'FLEX100', 68100
	exec temp_AddToSpecimenTypeMetaMap 'AS (2015)', 2, -1, 1604, 'FLEX150', 68100
	exec temp_AddToSpecimenTypeMetaMap 'AS (2015)', 2, -1, 1604, 'GROCUBE', 68800
	exec temp_AddToSpecimenTypeMetaMap 'AS (2015)', 2, -1, 1604, 'INDTEN', 68300
	exec temp_AddToSpecimenTypeMetaMap 'AS (2015)', 2, -1, 1604, 'MORCUBE', 68700
	exec temp_AddToSpecimenTypeMetaMap 'AS (2015)', 2, -1, 1604, 'OTHER', 69900
end

--AU Defaults RMS
if exists(select 1 from qestViewConfiguration where Active = 1 and Code in ('AUP', 'AUT', 'Default'))
begin
	exec temp_AddToSpecimenTypeMetaMap 'RMS', 4, 0, 1604, '', 67103 --Slump Only
	exec temp_AddToSpecimenTypeMetaMap 'RMS', 4, 0, 1604, 'COMP100', 68003
	exec temp_AddToSpecimenTypeMetaMap 'RMS', 4, 0, 1604, 'COMP150', 68003
	exec temp_AddToSpecimenTypeMetaMap 'RMS', 4, 0, 1604, 'COMPCOR', 68402
	exec temp_AddToSpecimenTypeMetaMap 'RMS', 4, 0, 1604, 'COMPRCOR', 68404
	exec temp_AddToSpecimenTypeMetaMap 'RMS', 4, 0, 1604, 'DENFLX10', 68152
	exec temp_AddToSpecimenTypeMetaMap 'RMS', 4, 0, 1604, 'DENFLX15', 68152
	exec temp_AddToSpecimenTypeMetaMap 'RMS', 4, 0, 1604, 'DENS100', 68052
	exec temp_AddToSpecimenTypeMetaMap 'RMS', 4, 0, 1604, 'DENS150', 68052
	exec temp_AddToSpecimenTypeMetaMap 'RMS', 4, 0, 1604, 'DENSCOR', 68431
	exec temp_AddToSpecimenTypeMetaMap 'RMS', 4, 0, 1604, 'FLEX100', 68102
	exec temp_AddToSpecimenTypeMetaMap 'RMS', 4, 0, 1604, 'FLEX150', 68102
	exec temp_AddToSpecimenTypeMetaMap 'RMS', 4, 0, 1604, 'GROCUBE', 68802
	exec temp_AddToSpecimenTypeMetaMap 'RMS', 4, 0, 1604, 'INDTEN', 68301
	exec temp_AddToSpecimenTypeMetaMap 'RMS', 4, 0, 1604, 'MORCUBE', 68702
	exec temp_AddToSpecimenTypeMetaMap 'RMS', 4, 0, 1604, 'OTHER', 69900
end

--AU Defaults Q
if exists(select 1 from qestViewConfiguration where Active = 1 and Code in ('AUP', 'AUT', 'Default'))
begin
	exec temp_AddToSpecimenTypeMetaMap 'Q', 5, 0, 1604, '', 67104 --Slump Only
	exec temp_AddToSpecimenTypeMetaMap 'Q', 5, 0, 1604, 'COMP100', 68004
	exec temp_AddToSpecimenTypeMetaMap 'Q', 5, 0, 1604, 'COMP150', 68004
	exec temp_AddToSpecimenTypeMetaMap 'Q', 5, 0, 1604, 'COMPCOR', 68403
	exec temp_AddToSpecimenTypeMetaMap 'Q', 5, 0, 1604, 'COMPRCOR', 68404
	exec temp_AddToSpecimenTypeMetaMap 'Q', 5, 0, 1604, 'DENFLX10', 68153
	exec temp_AddToSpecimenTypeMetaMap 'Q', 5, 0, 1604, 'DENFLX15', 68153
	exec temp_AddToSpecimenTypeMetaMap 'Q', 5, 0, 1604, 'DENS100', 68053
	exec temp_AddToSpecimenTypeMetaMap 'Q', 5, 0, 1604, 'DENS150', 68053
	exec temp_AddToSpecimenTypeMetaMap 'Q', 5, 0, 1604, 'DENSCOR', 68432
	exec temp_AddToSpecimenTypeMetaMap 'Q', 5, 0, 1604, 'FLEX100', 68103
	exec temp_AddToSpecimenTypeMetaMap 'Q', 5, 0, 1604, 'FLEX150', 68103
	exec temp_AddToSpecimenTypeMetaMap 'Q', 5, 0, 1604, 'GROCUBE', 68803
	exec temp_AddToSpecimenTypeMetaMap 'Q', 5, 0, 1604, 'INDTEN', 68302
	exec temp_AddToSpecimenTypeMetaMap 'Q', 5, 0, 1604, 'MORCUBE', 68703
	exec temp_AddToSpecimenTypeMetaMap 'Q', 5, 0, 1604, 'OTHER', 69900
end

--AU Defaults AS Old
if exists(select 1 from qestViewConfiguration where Active = 1 and Code in ('AUP', 'AUT', 'Default'))
begin
	exec temp_AddToSpecimenTypeMetaMap 'AS (1999)', 14, 0, 1604, '', 67100 --Slump Only
	exec temp_AddToSpecimenTypeMetaMap 'AS (1999)', 14, 0, 1604, 'COMP100', 68000
	exec temp_AddToSpecimenTypeMetaMap 'AS (1999)', 14, 0, 1604, 'COMP150', 68000
	exec temp_AddToSpecimenTypeMetaMap 'AS (1999)', 14, 0, 1604, 'COMPCOR', 68400
	exec temp_AddToSpecimenTypeMetaMap 'AS (1999)', 14, 0, 1604, 'COMPRCOR', 68404
	exec temp_AddToSpecimenTypeMetaMap 'AS (1999)', 14, 0, 1604, 'DENFLX10', 68150
	exec temp_AddToSpecimenTypeMetaMap 'AS (1999)', 14, 0, 1604, 'DENFLX15', 68150
	exec temp_AddToSpecimenTypeMetaMap 'AS (1999)', 14, 0, 1604, 'DENS100', 68050
	exec temp_AddToSpecimenTypeMetaMap 'AS (1999)', 14, 0, 1604, 'DENS150', 68050
	exec temp_AddToSpecimenTypeMetaMap 'AS (1999)', 14, 0, 1604, 'DENSCOR', 68430
	exec temp_AddToSpecimenTypeMetaMap 'AS (1999)', 14, 0, 1604, 'FLEX100', 68100
	exec temp_AddToSpecimenTypeMetaMap 'AS (1999)', 14, 0, 1604, 'FLEX150', 68100
	exec temp_AddToSpecimenTypeMetaMap 'AS (1999)', 14, 0, 1604, 'GROCUBE', 68805
	exec temp_AddToSpecimenTypeMetaMap 'AS (1999)', 14, 0, 1604, 'INDTEN', 68300
	exec temp_AddToSpecimenTypeMetaMap 'AS (1999)', 14, 0, 1604, 'MORCUBE', 68705
	exec temp_AddToSpecimenTypeMetaMap 'AS (1999)', 14, 0, 1604, 'OTHER', 69900
end

--WA
if exists(select 1 from qestViewConfiguration where Active = 1 and Code in ('AUP', 'AUT', 'Default'))
begin
	exec temp_AddToSpecimenTypeMetaMap 'WA', 12, 0, 1604, 'GROCUBE', 68806
end

--HY
if exists(select 1 from qestViewConfiguration where Active = 1 and Code in ('AUP', 'AUT', 'Default'))
begin
	exec temp_AddToSpecimenTypeMetaMap 'HY', 13, 0, 1604, 'GROCUBE', 68807
end

--US ASTM Masonry Defaults
if exists(select 1 from qestViewConfiguration where Active = 1 and Code in ('US', 'ME', 'Default'))
begin
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2014)', 15, -1, 1605, 'ABSBLOCK', 69070
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2014)', 15, -1, 1605, 'ABSCOUP', 69070
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2014)', 15, -1, 1605, 'ABSGPU', 69400
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2014)', 15, -1, 1605, 'ABSGPUC', 69400
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2014)', 15, -1, 1605, 'ABSIPU', 69360
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2014)', 15, -1, 1605, 'ABSIPUC', 69360
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2014)', 15, -1, 1605, 'ABSPAVC', 69310
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2014)', 15, -1, 1605, 'ABSPAVER', 69310
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2014)', 15, -1, 1605, 'ABSRWU', 69210
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2014)', 15, -1, 1605, 'ABSRWUC', 69210
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2014)', 15, -1, 1605, 'AREABLOC', 69060
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2014)', 15, -1, 1605, 'AREACOUP', 69060
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2014)', 15, -1, 1605, 'AREAPRIS', 68930
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2014)', 15, -1, 1605, 'COMPAVC', 69300
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2014)', 15, -1, 1605, 'COMPAVER', 69300
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2014)', 15, -1, 1605, 'COMPBLOC', 69050
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2014)', 15, -1, 1605, 'COMPCOUP', 69050
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2014)', 15, -1, 1605, 'COMPGPU', 69380
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2014)', 15, -1, 1605, 'COMPGPUC', 69380
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2014)', 15, -1, 1605, 'COMPIPU', 69340
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2014)', 15, -1, 1605, 'COMPIPUC', 69340
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2014)', 15, -1, 1605, 'COMPRWU', 69200
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2014)', 15, -1, 1605, 'COMPRWUC', 69200
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2014)', 15, -1, 1605, 'CRMSQ50', 68731
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2014)', 15, -1, 1605, 'GRO50', 68751
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2014)', 15, -1, 1605, 'GRO75', 68751
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2014)', 15, -1, 1605, 'GRO100', 68751
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2014)', 15, -1, 1605, 'GROCUBE', 68804
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2014)', 15, -1, 1605, 'GROCUBNS', 68861
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2014)', 15, -1, 1605, 'GROPRIS', 68901
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2014)', 15, -1, 1605, 'GROSQ100', 68831
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2014)', 15, -1, 1605, 'HOLPRIS', 68911
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2014)', 15, -1, 1605, 'MOR50', 68651
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2014)', 15, -1, 1605, 'MOR75', 68651
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2014)', 15, -1, 1605, 'MORCUBE', 68704
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2014)', 15, -1, 1605, 'OTHER', 69900
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2014)', 15, -1, 1605, 'SOLPRIS', 68920
end

--US ASTM Masonry Defaults
if exists(select 1 from qestViewConfiguration where Active = 1 and Code in ('US', 'ME', 'Default'))
begin
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2012)', 16, 0, 1605, 'ABSBLOCK', 69072
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2012)', 16, 0, 1605, 'ABSCOUP', 69072
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2012)', 16, 0, 1605, 'ABSGPU', 69402
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2012)', 16, 0, 1605, 'ABSGPUC', 69402
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2012)', 16, 0, 1605, 'ABSIPU', 69362
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2012)', 16, 0, 1605, 'ABSIPUC', 69362
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2012)', 16, 0, 1605, 'ABSRWU', 69212
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2012)', 16, 0, 1605, 'ABSRWUC', 69212
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2012)', 16, 0, 1605, 'AREABLOC', 69062
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2012)', 16, 0, 1605, 'AREACOUP', 69062
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2012)', 16, 0, 1605, 'AREAPRIS', 68930
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2012)', 16, 0, 1605, 'COMPBLOC', 69052
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2012)', 16, 0, 1605, 'COMPCOUP', 69052
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2012)', 16, 0, 1605, 'COMPGPU', 69382
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2012)', 16, 0, 1605, 'COMPGPUC', 69382
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2012)', 16, 0, 1605, 'COMPIPU', 69342
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2012)', 16, 0, 1605, 'COMPIPUC', 69342
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2012)', 16, 0, 1605, 'COMPRWU', 69202
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2012)', 16, 0, 1605, 'COMPRWUC', 69202
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2012)', 16, 0, 1605, 'CRMSQ50', 68731
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2012)', 16, 0, 1605, 'GRO50', 68751
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2012)', 16, 0, 1605, 'GRO75', 68751
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2012)', 16, 0, 1605, 'GRO100', 68751
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2012)', 16, 0, 1605, 'GROCUBE', 68804
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2012)', 16, 0, 1605, 'GROCUBNS', 68861
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2012)', 16, 0, 1605, 'GROPRIS', 68901
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2012)', 16, 0, 1605, 'GROSQ100', 68831
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2012)', 16, 0, 1605, 'HOLPRIS', 68911
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2012)', 16, 0, 1605, 'MOR50', 68651
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2012)', 16, 0, 1605, 'MOR75', 68651
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2012)', 16, 0, 1605, 'MORCUBE', 68704
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2012)', 16, 0, 1605, 'OTHER', 69900
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2012)', 16, 0, 1605, 'SOLPRIS', 68920
end

--US ASTM Masonry Defaults
if exists(select 1 from qestViewConfiguration where Active = 1 and Code in ('US', 'ME', 'Default'))
begin
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2007)', 17, 0, 1605, 'ABSBLOCK', 69073
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2007)', 17, 0, 1605, 'ABSCOUP', 69073
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2007)', 17, 0, 1605, 'ABSGPU', 69403
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2007)', 17, 0, 1605, 'ABSGPUC', 69403
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2007)', 17, 0, 1605, 'ABSIPU', 69363
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2007)', 17, 0, 1605, 'ABSIPUC', 69363
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2007)', 17, 0, 1605, 'ABSRWU', 69213
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2007)', 17, 0, 1605, 'ABSRWUC', 69213
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2007)', 17, 0, 1605, 'AREABLOC', 69063
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2007)', 17, 0, 1605, 'AREACOUP', 69063
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2007)', 17, 0, 1605, 'AREAPRIS', 68930
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2007)', 17, 0, 1605, 'COMPBLOC', 69053
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2007)', 17, 0, 1605, 'COMPCOUP', 69053
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2007)', 17, 0, 1605, 'COMPGPU', 69383
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2007)', 17, 0, 1605, 'COMPGPUC', 69383
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2007)', 17, 0, 1605, 'COMPIPU', 69343
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2007)', 17, 0, 1605, 'COMPIPUC', 69343
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2007)', 17, 0, 1605, 'COMPRWU', 69203
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2007)', 17, 0, 1605, 'COMPRWUC', 69203
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2007)', 17, 0, 1605, 'CRMSQ50', 68731
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2007)', 17, 0, 1605, 'GRO50', 68751
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2007)', 17, 0, 1605, 'GRO75', 68751
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2007)', 17, 0, 1605, 'GRO100', 68751
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2007)', 17, 0, 1605, 'GROCUBE', 68804
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2007)', 17, 0, 1605, 'GROCUBNS', 68861
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2007)', 17, 0, 1605, 'GROPRIS', 68901
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2007)', 17, 0, 1605, 'GROSQ100', 68831
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2007)', 17, 0, 1605, 'HOLPRIS', 68911
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2007)', 17, 0, 1605, 'MOR50', 68651
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2007)', 17, 0, 1605, 'MOR75', 68651
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2007)', 17, 0, 1605, 'MORCUBE', 68704
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2007)', 17, 0, 1605, 'OTHER', 69900
	exec temp_AddToSpecimenTypeMetaMap 'ASTM (2007)', 17, 0, 1605, 'SOLPRIS', 68920
end

--US BS Masonry Defaults
if exists(select 1 from qestViewConfiguration where Active = 1 and Code in ('ME', 'Default'))
begin
	exec temp_AddToSpecimenTypeMetaMap 'BS', 11, -1, 1605, 'ABSBLOCK', 69071
	exec temp_AddToSpecimenTypeMetaMap 'BS', 11, -1, 1605, 'ABSCOUP', 69071
	exec temp_AddToSpecimenTypeMetaMap 'BS', 11, -1, 1605, 'ABSGPU', 69401
	exec temp_AddToSpecimenTypeMetaMap 'BS', 11, -1, 1605, 'ABSGPUC', 69401
	exec temp_AddToSpecimenTypeMetaMap 'BS', 11, -1, 1605, 'ABSIPU', 69361
	exec temp_AddToSpecimenTypeMetaMap 'BS', 11, -1, 1605, 'ABSIPUC', 69361
	exec temp_AddToSpecimenTypeMetaMap 'BS', 11, -1, 1605, 'AREABLOC', 69061
	exec temp_AddToSpecimenTypeMetaMap 'BS', 11, -1, 1605, 'AREACOUP', 69061
	exec temp_AddToSpecimenTypeMetaMap 'BS', 11, -1, 1605, 'COMPBLOC', 69051
	exec temp_AddToSpecimenTypeMetaMap 'BS', 11, -1, 1605, 'COMPCOUP', 69051
	exec temp_AddToSpecimenTypeMetaMap 'BS', 11, -1, 1605, 'COMPGPU', 69381
	exec temp_AddToSpecimenTypeMetaMap 'BS', 11, -1, 1605, 'COMPGPUC', 69381
	exec temp_AddToSpecimenTypeMetaMap 'BS', 11, -1, 1605, 'COMPIPU', 69341
	exec temp_AddToSpecimenTypeMetaMap 'BS', 11, -1, 1605, 'COMPIPUC', 69341
end

GO

DROP PROC temp_AddToSpecimenTypeMetaMap



