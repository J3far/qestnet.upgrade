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

----US Defaults ASTM
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1602, null, 67101) --Slump Only
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1602, 'CIP100', 68350)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1602, 'COMP100', 68001)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1602, 'COMP150', 68001)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1602, 'COMP225', 68001)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1602, 'COMP75', 68001)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1602, 'COMPCOR', 68401)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1602, 'COMPUNIT', 69000)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1602, 'CRMSQ50', 68730)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1602, 'ELAS100', 68520)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1602, 'ELAS150', 68520)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1602, 'ELASCOR', 68530)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1602, 'FLEX', 68101)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1602, 'FLEXC', 68130)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1602, 'GRO100', 68750)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1602, 'GRO50', 68750)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1602, 'GRO75', 68750)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1602, 'GROCUBE', 68801)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1602, 'GROCUBNS', 68860)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1602, 'GROPRIS', 68900)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1602, 'GROSQ100', 68830)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1602, 'HOLPRIS', 68910)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1602, 'LCOMP75', 68450)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1602, 'LW75', 68460)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1602, 'MOR50', 68650)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1602, 'MOR75', 68650)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1602, 'MORCUBE', 68701)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1602, 'OTHER', 68900)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1602, 'SHOTCOR', 68600)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1602, 'SPLTEN', 68330)

----US Defaults RILEM
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1602, 'AVC100', 68500)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1602, 'AWC100', 68510)

----US Defaults BS
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1602, 'ELBS100', 68540)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1602, 'ELBS150', 68540)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1602, 'ELBSCOR', 68550)

----NZ Defaults
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1603, null, 67102) --Slump Only
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1603, 'COMP100', 68002)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1603, 'COMP150', 68002)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1603, 'OTHER', 68900)

----AU Defaults AS
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1604, null, 67100) --Slump Only
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1604, 'COMP100', 68000)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1604, 'COMP150', 68000)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1604, 'COMPCOR', 68400)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1604, 'COMPRCOR', 68404)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1604, 'DENFLX10', 68150)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1604, 'DENFLX15', 68150)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1604, 'DENS100', 68050)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1604, 'DENS150', 68050)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1604, 'DENSCOR', 68430)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1604, 'FLEX100', 68100)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1604, 'FLEX150', 68100)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1604, 'GROCUBE', 68800)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1604, 'INDTEN', 68300)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1604, 'MORCUBE', 68700)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1604, 'OTHER', 68900)

----US Masonry Defaults
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1605, 'ABSBLOCK', 69070)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1605, 'ABSCOUP', 69070)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1605, 'ABSGPU', 69400)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1605, 'ABSGPUC', 69400)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1605, 'ABSIPU', 69360)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1605, 'ABSIPUC', 69360)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1605, 'ABSPAVC', 69310)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1605, 'ABSPAVER', 69310)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1605, 'ABSRWU', 69210)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1605, 'ABSRWUC', 69210)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1605, 'AREABLOC', 69060)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1605, 'AREACOUP', 69060)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1605, 'AREAPRIS', 68930)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1605, 'COMPAVC', 69300)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1605, 'COMPAVER', 69300)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1605, 'COMPBLOC', 69050)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1605, 'COMPCOUP', 69050)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1605, 'COMPGPU', 69380)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1605, 'COMPGPUC', 69380)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1605, 'COMPIPU', 69340)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1605, 'COMPIPUC', 69340)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1605, 'COMPRWU', 69200)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1605, 'COMPRWUC', 69200)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1605, 'CRMSQ50', 69731)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1605, 'GRO100', 68751)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1605, 'GRO50', 68751)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1605, 'GRO75', 68751)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1605, 'GROCUBE', 68804)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1605, 'GROCUBNS', 68861)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1605, 'GROPRIS', 68901)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1605, 'GROSQ100', 68831)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1605, 'HOLPRIS', 68911)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1605, 'MOR50', 68651)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1605, 'MOR75', 68651)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1605, 'MORCUBE', 68704)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1605, 'OTHER', 68900)
--INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Default', 1, 1605, 'SOLPRIS', 68920)

--US Defaults ASTM
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1602, null, 67101) --Slump Only
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1602, 'CIP100', 68350)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1602, 'COMP100', 68001)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1602, 'COMP150', 68001)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1602, 'COMP225', 68001)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1602, 'COMP75', 68001)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1602, 'COMPCOR', 68401)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1602, 'COMPUNIT', 69000)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1602, 'CRMSQ50', 68730)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1602, 'ELAS100', 68520)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1602, 'ELAS150', 68520)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1602, 'ELASCOR', 68530)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1602, 'FLEX', 68101)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1602, 'FLEXC', 68130)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1602, 'GRO100', 68750)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1602, 'GRO50', 68750)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1602, 'GRO75', 68750)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1602, 'GROCUBE', 68801)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1602, 'GROCUBNS', 68860)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1602, 'GROPRIS', 68900)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1602, 'GROSQ100', 68830)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1602, 'HOLPRIS', 68910)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1602, 'LCOMP75', 68450)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1602, 'LW75', 68460)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1602, 'MOR50', 68650)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1602, 'MOR75', 68650)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1602, 'MORCUBE', 68701)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1602, 'OTHER', 68900)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1602, 'SHOTCOR', 68600)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1602, 'SPLTEN', 68330)

--US Defaults TxDOT
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('TxDOT', 7, 1602, null, 67105) --Slump Only
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('TxDOT', 7, 1602, 'COMP100', 68005)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('TxDOT', 7, 1602, 'COMP150', 68005)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('TxDOT', 7, 1602, 'COMP225', 68005)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('TxDOT', 7, 1602, 'COMP75', 68005)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('TxDOT', 7, 1602, 'COMPCOR', 68406)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('TxDOT', 7, 1602, 'FLEX', 68104)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('TxDOT', 7, 1602, 'OTHER', 68900)

--US Defaults AASHTO
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('AASHTO', 8, 1602, null, 67106) --Slump Only
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('AASHTO', 8, 1602, 'COMP100', 68006)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('AASHTO', 8, 1602, 'COMP150', 68006)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('AASHTO', 8, 1602, 'COMP225', 68006)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('AASHTO', 8, 1602, 'COMP75', 68006)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('AASHTO', 8, 1602, 'COMPCOR', 68406)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('AASHTO', 8, 1602, 'FLEX', 68105)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('AASHTO', 8, 1602, 'FLEXC', 68131)

--US Defaults RILEM
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('RILEM', 10, 1602, 'AVC100', 68500)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('RILEM', 10, 1602, 'AWC100', 68510)

--US Defaults BS
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('BS', 11, 1602, 'ELBS100', 68540)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('BS', 11, 1602, 'ELBS150', 68540)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('BS', 11, 1602, 'ELBSCOR', 68550)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('BS', 11, 1602, 'COMPCOR', 68407)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('BS', 11, 1602, 'COMP100', 68008)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('BS', 11, 1602, 'COMP150', 68008)

--NZ Defaults
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('NZS', 6, 1603, null, 67102) --Slump Only
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('NZS', 6, 1603, 'COMP100', 68002)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('NZS', 6, 1603, 'COMP150', 68002)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('NZS', 6, 1603, 'OTHER', 68900)

--AU Defaults AS
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('AS (2015)', 2, 1604, null, 67100) --Slump Only
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('AS (2015)', 2, 1604, 'COMP100', 68000)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('AS (2015)', 2, 1604, 'COMP150', 68000)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('AS (2015)', 2, 1604, 'COMPCOR', 68400)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('AS (2015)', 2, 1604, 'COMPRCOR', 68404)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('AS (2015)', 2, 1604, 'DENFLX10', 68150)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('AS (2015)', 2, 1604, 'DENFLX15', 68150)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('AS (2015)', 2, 1604, 'DENS100', 68050)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('AS (2015)', 2, 1604, 'DENS150', 68050)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('AS (2015)', 2, 1604, 'DENSCOR', 68430)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('AS (2015)', 2, 1604, 'FLEX100', 68100)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('AS (2015)', 2, 1604, 'FLEX150', 68100)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('AS (2015)', 2, 1604, 'GROCUBE', 68800)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('AS (2015)', 2, 1604, 'INDTEN', 68300)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('AS (2015)', 2, 1604, 'MORCUBE', 68700)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('AS (2015)', 2, 1604, 'OTHER', 68900)

--AU Defaults RMS
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('RMS', 4, 1604, null, 67103) --Slump Only
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('RMS', 4, 1604, 'COMP100', 68003)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('RMS', 4, 1604, 'COMP150', 68003)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('RMS', 4, 1604, 'COMPCOR', 68402)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('RMS', 4, 1604, 'COMPRCOR', 68404)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('RMS', 4, 1604, 'DENFLX10', 68152)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('RMS', 4, 1604, 'DENFLX15', 68152)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('RMS', 4, 1604, 'DENS100', 68052)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('RMS', 4, 1604, 'DENS150', 68052)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('RMS', 4, 1604, 'DENSCOR', 68431)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('RMS', 4, 1604, 'FLEX100', 68102)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('RMS', 4, 1604, 'FLEX150', 68102)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('RMS', 4, 1604, 'GROCUBE', 68802)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('RMS', 4, 1604, 'INDTEN', 68301)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('RMS', 4, 1604, 'MORCUBE', 68702)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('RMS', 4, 1604, 'OTHER', 68900)

--AU Defaults Q
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Q', 5, 1604, null, 67104) --Slump Only
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Q', 5, 1604, 'COMP100', 68004)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Q', 5, 1604, 'COMP150', 68004)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Q', 5, 1604, 'COMPCOR', 68403)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Q', 5, 1604, 'COMPRCOR', 68404)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Q', 5, 1604, 'DENFLX10', 68153)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Q', 5, 1604, 'DENFLX15', 68153)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Q', 5, 1604, 'DENS100', 68053)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Q', 5, 1604, 'DENS150', 68053)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Q', 5, 1604, 'DENSCOR', 68432)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Q', 5, 1604, 'FLEX100', 68103)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Q', 5, 1604, 'FLEX150', 68103)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Q', 5, 1604, 'GROCUBE', 68803)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Q', 5, 1604, 'INDTEN', 68302)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Q', 5, 1604, 'MORCUBE', 68703)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('Q', 5, 1604, 'OTHER', 68900)

--AU Defaults AS Old
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('AS (1999)', 14, 1604, null, 67100) --Slump Only
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('AS (1999)', 14, 1604, 'COMP100', 68000)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('AS (1999)', 14, 1604, 'COMP150', 68000)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('AS (1999)', 14, 1604, 'COMPCOR', 68400)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('AS (1999)', 14, 1604, 'COMPRCOR', 68404)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('AS (1999)', 14, 1604, 'DENFLX10', 68150)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('AS (1999)', 14, 1604, 'DENFLX15', 68150)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('AS (1999)', 14, 1604, 'DENS100', 68050)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('AS (1999)', 14, 1604, 'DENS150', 68050)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('AS (1999)', 14, 1604, 'DENSCOR', 68430)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('AS (1999)', 14, 1604, 'FLEX100', 68100)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('AS (1999)', 14, 1604, 'FLEX150', 68100)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('AS (1999)', 14, 1604, 'GROCUBE', 68805)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('AS (1999)', 14, 1604, 'INDTEN', 68300)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('AS (1999)', 14, 1604, 'MORCUBE', 68705)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('AS (1999)', 14, 1604, 'OTHER', 68900)

--WA
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('WA', 12, 1604, 'GROCUBE', 68806)

--HY
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('HY', 13, 1604, 'GROCUBE', 68807)

--US ASTM Masonry Defaults
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1605, 'ABSBLOCK', 69070)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1605, 'ABSCOUP', 69070)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1605, 'ABSGPU', 69400)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1605, 'ABSGPUC', 69400)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1605, 'ABSIPU', 69360)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1605, 'ABSIPUC', 69360)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1605, 'ABSPAVC', 69310)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1605, 'ABSPAVER', 69310)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1605, 'ABSRWU', 69210)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1605, 'ABSRWUC', 69210)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1605, 'AREABLOC', 69060)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1605, 'AREACOUP', 69060)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1605, 'AREAPRIS', 68930)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1605, 'COMPAVC', 69300)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1605, 'COMPAVER', 69300)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1605, 'COMPBLOC', 69050)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1605, 'COMPCOUP', 69050)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1605, 'COMPGPU', 69380)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1605, 'COMPGPUC', 69380)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1605, 'COMPIPU', 69340)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1605, 'COMPIPUC', 69340)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1605, 'COMPRWU', 69200)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1605, 'COMPRWUC', 69200)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1605, 'CRMSQ50', 69731)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1605, 'GRO100', 68751)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1605, 'GRO50', 68751)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1605, 'GRO75', 68751)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1605, 'GROCUBE', 68804)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1605, 'GROCUBNS', 68861)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1605, 'GROPRIS', 68901)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1605, 'GROSQ100', 68831)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1605, 'HOLPRIS', 68911)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1605, 'MOR50', 68651)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1605, 'MOR75', 68651)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1605, 'MORCUBE', 68704)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1605, 'OTHER', 68900)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('ASTM', 3, 1605, 'SOLPRIS', 68920)

--US BS Masonry Defaults
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('BS', 11, 1605, 'ABSBLOCK', 69071)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('BS', 11, 1605, 'ABSCOUP', 69071)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('BS', 11, 1605, 'ABSGPU', 69401)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('BS', 11, 1605, 'ABSGPUC', 69401)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('BS', 11, 1605, 'ABSIPU', 69361)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('BS', 11, 1605, 'ABSIPUC', 69361)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('BS', 11, 1605, 'AREABLOC', 69061)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('BS', 11, 1605, 'AREACOUP', 69061)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('BS', 11, 1605, 'COMPBLOC', 69051)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('BS', 11, 1605, 'COMPCOUP', 69051)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('BS', 11, 1605, 'COMPGPU', 69381)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('BS', 11, 1605, 'COMPGPUC', 69381)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('BS', 11, 1605, 'COMPIPU', 69341)
INSERT INTO QestSpecimenTypeMetaMap ([TemplateName], [TemplateQestUniqueID], [SampleQestID], [Type], [MetaQestID]) VALUES ('BS', 11, 1605, 'COMPIPUC', 69341)






