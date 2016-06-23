----------------------------------------------------------------------------------------------------------------------------
-- SQ08134
-- Update the PSDHasBeenOpened and CurrentSpecification field so when a PSD screen is loaded, the split set will not be added unexpectedly
--
-- 
--
-- Created By: Weiwen Chi
-- Created Date: 26-May-2016
-- Modified By: Krzysztof Kot
-- Modified Date: 30-May-2016
--
-- Version 2.0
-- Change Log
--  1.0 Original Version
--  2.0 Fix the parentheses
--  2.1 Restrict update to only problematic records
--
-- Repeatability: Safe
-- Re-Run Requirement: Once. 
----------------------------------------------------------------------------------------------------------------------------

begin tran
declare @whereClause nvarchar(max)
declare @sql nvarchar(max)

select
     @whereClause = isnull(@whereClause + ' or ' + COLUMN_NAME + ' is not null', COLUMN_NAME + ' is not null')
from 
       INFORMATION_SCHEMA.columns 
where 
       TABLE_NAME = 'DocumentParticleSizeDistribution' 
       and (COLUMN_NAME like '%mass%' Or COLUMN_NAME like '%code%')


select @sql =
'UPDATE  DocumentParticleSizeDistribution
SET PSDHasBeenOpened=1, CurrentSpecification=QestSpecification
WHERE ((' + @whereClause + ')
OR QestTestedBy is not null) and ((PSDHasBeenOpened=0 or PSDHasBeenOpened is null) or (CurrentSpecification<>QestSpecification or (currentSpecification is null and qestspecification is not null)))'

exec sp_executesql @sql

commit

