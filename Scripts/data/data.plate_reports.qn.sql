----------------------------------------------------------------------------------------------------
--
-- Plate reports
--
-- Stored procedures used to find suitable tests and data for inclusion on plate reports.
--
----------------------------------------------------------------------------------------------------
set nocount on;

/* INTERNAL PATCH -- the 'break on each...' option was initially a string, but we changed it to an
 * enumeration.  This happened before release to Fugro, but for internal purposes it means that some
 * of our databases have a nvarchar field that needs to be changed to an integer.
 *
 * This can be deleted when it is deemed no longer necessary for internal use.
 *
 */
if exists ( select * from INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'dbo' and TABLE_NAME = 'DocumentCertificates' and COLUMN_NAME = 'SectionBreak' and DATA_TYPE = 'nvarchar' )
begin
  update DocumentCertificates 
  set SectionBreak = 
    case SectionBreak
      when 'LocationUUID' then '1'
      when 'SampleUUID' then '2'
      else '0' 
    end 
  alter table DocumentCertificates
    alter column SectionBreak int null;
end
GO

if not exists (select * from sys.objects where object_id = object_id(N'[dbo].[qest_plate_AddOption]') and type in (N'P', N'PC'))
  exec ('create proc [dbo].[qest_plate_AddOption] as select 0 tmp');
GO
alter proc [dbo].[qest_plate_AddOption]
  @qestUUID uniqueidentifier,             -- ID of the option - must be unique
  @name nvarchar(20),                     -- name of the option - must be unique, used to look up the option
  @groupName nvarchar(20),                -- (English) group name/caption - so that options that are similar to one another can be displayed together
  @caption nvarchar(50),                  -- (English) caption to display to the user
  @defaultValue nvarchar(100),            -- default value that applies if the option hasn't been set at either the project level, or the report level
  @formatString nvarchar(max),            -- any format string that will work with the QLCGridTextBox ...
  @appliesTo nvarchar(100) = null         -- comma delimited list of QestIDs to which this option applies (in the range 18500-18599)
as
  set nocount on;

  --make sure that the name is unique
  if exists(select * from dbo.qestPlateReportOptions where QestUUID != @qestUUID and Name = @name)
  begin
    raiserror('Cannot add plate report option ''%s'' - Name must be unique.', 16, 1, @name)
    return 1;
  end
  
  --validate the appliesTo parameter - NULL is okay
  if @appliesTo like '%[^0-9,]%'
  begin
    raiserror ('The appliesTo tests property (%s) for plate report option %s is invalid - unable to create/update option configuration.', 16, 1, @appliesTo, @name);
    return 1;
  end
  
  if exists(select * from dbo.qestPlateReportOptions where QestUUID = @qestUUID)
    update dbo.qestPlateReportOptions
      set GroupName = @groupName, Name = @name, Caption = @caption, DefaultValue = @defaultValue, FormatString = @formatString
	  where QestUUID = @qestUUID
  else
    insert into dbo.qestPlateReportOptions (QestUUID, GroupName, Name, Caption, DefaultValue, FormatString)
      values (@qestUUID, @groupName, @name, @caption, @defaultValue, @formatString)

  if @appliesTo is null
  begin
    -- this option applies to ALL plate reports
    insert into dbo.qestPlateReportOptionMapping (PlateReportOptionUUID, PlateReportQestID)
      select distinct @qestUUID, o.QestID 
      from QestObjects o
      where o.QestID between 18500 and 18599
      and not exists (select * from dbo.qestPlateReportOptionMapping om where om.PlateReportOptionUUID = @qestUUID and om.PlateReportQestID = o.QestID)
  end
  else
  begin
    -- this options applies to a subset of plate reports
    insert into dbo.qestPlateReportOptionMapping (PlateReportOptionUUID, PlateReportQestID)
      select distinct @qestUUID, o.QestID 
      from QestObjects o
      where o.QestID between 18500 and 18599
        and ',' + @appliesTo + ',' like '%,' + cast(o.QestID as nvarchar(8)) + ',%'
      and not exists (select * from dbo.qestPlateReportOptionMapping om where om.PlateReportOptionUUID = @qestUUID and om.PlateReportQestID = o.QestID)
  end

GO

----------------------------------------------------------------------------------------------------

if not exists (select * from sys.objects where object_id = object_id(N'[dbo].[qest_plate_SetOption]') and type in (N'P', N'PC'))
  exec ('create proc [dbo].[qest_plate_SetOption] as select 0 tmp');
GO
alter proc [dbo].[qest_plate_SetOption]
  @projectUUID uniqueidentifier = null,
  @reportUUID uniqueidentifier = null,
  @name nvarchar(20),
  @value nvarchar(100)
as
  set nocount on;

  declare @optionUUID uniqueidentifier;
  select @optionUUID = QestUUID from dbo.qestPlateReportOptions where Name = @name;
  
  declare @hasError bit;
  set @hasError = 0;
  if @optionUUID is null
  begin
    raiserror('Cannot set plate report option ''%s'' - an option with this name was not found in the database.', 16, 1, @name)
    set @hasError = 1;
  end
  if @projectUUID is null and @reportUUID is null
  begin
    raiserror('Cannot set plate report option ''%s'' - you must specify either a project or report to set the option.', 16, 1, @name)
    set @hasError = 1;
  end
  if @projectUUID is not null and not exists (select * from ListProject where QestUUID = @projectUUID)
  begin
    raiserror('Cannot set plate report option ''%s'' - unable to find a matching project.', 16, 1, @name)
    set @hasError = 1;
  end
  if @reportUUID is not null
  begin
    if not exists (select * from DocumentCertificates where QestUUID = @reportUUID)
    begin
      raiserror('Cannot set plate report option ''%s'' - unable to find a matching plate report.', 16, 1, @name)
      set @hasError = 1;
    end
    else if not exists (select * from DocumentCertificates r inner join qestPlateReportOptionMapping om on r.QestID = om.PlateReportQestID where r.QestUUID = @reportUUID)
    begin
      declare @objectType nvarchar(100);
      select @objectType = coalesce(cast(Value as nvarchar(100)), cast(r.QestID as nvarchar(100))) from DocumentCertificates r left join qestobjects ot on r.QestID = ot.QestID where r.QestUUID = @reportUUID
      raiserror('Cannot set plate report option ''%s'' - this option does not apply to plate reports of type @s.', 16, 1, @objectType)
      set @hasError = 1;
    end
  end
  if @projectUUID is not null and @reportUUID is not null
  begin
    raiserror('Cannot set plate report option ''%s'' - you cannot specify both a report and a project.', 16, 1, @name)
    set @hasError = 1;
  end
  if @hasError = 1 
    return 1;
  
  declare @qestUUID uniqueidentifier;
  select @qestUUID = QestUUID 
    from QestPlateReportOptionValues
    where (ProjectUUID = @projectUUID or @projectUUID is null)
      and (ReportUUID = @reportUUID or @reportUUID is null)
      and OptionUUID = @optionUUID;
  
  if @qestUUID is not null
    update QestPlateReportOptionValues set Value = @value where QestUUID = @qestUUID
  else
    insert into qestPlateReportOptionValues (QestUUID, ProjectUUID, ReportUUID, OptionUUID, Value)
    values (NEWID(), @projectUUID, @reportUUID, @optionUUID, @value)
GO

----------------------------------------------------------------------------------------------------



if not exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_SCHEMA = 'dbo' and TABLE_NAME = 'view_PlateReportOptions')
  exec('create view [dbo].[view_PlateReportOptions] as select 0 tmp;');
GO
alter view [dbo].[view_PlateReportOptions]
as
  select ProjectUUID = p.QestUUID
       , ReportUUID = r.QestUUID
       , OptionUUID = o.QestUUID
       , Name = o.Name
       , GroupName = o.GroupName
       , Caption =o.Caption
       , FormatString = o.FormatString
       , Value = coalesce(ro.Value, po.Value, o.DefaultValue)
       , InheritedValue = coalesce(po.Value, o.DefaultValue)
    from DocumentCertificates r
    inner join qestPlateReportOptionMapping om on r.QestID = om.PlateReportQestID
    inner join qestPlateReportOptions o on o.QestUUID = om.PlateReportOptionUUID
    left join ListProject p on r.ClientCode = p.ClientCode and r.ProjectCode = p.ProjectCode
    left join qestPlateReportOptionValues ro on r.QestUUID = ro.ReportUUID and o.QestUUID = ro.OptionUUID
    left join qestPlateReportOptionValues po on p.QestUUID = po.ProjectUUID and o.QestUUID = po.OptionUUID
    where r.QestUUID is not null
  union all
  select p.QestUUID
       , null
       , o.QestUUID
       , o.Name
       , o.GroupName
       , o.Caption
       , o.FormatString
       , coalesce(po.Value, o.DefaultValue)
       , InheritedValue = o.DefaultValue
    from ListProject p
    cross join qestPlateReportOptions o
    left join qestPlateReportOptionValues po on p.QestUUID = po.ProjectUUID and o.QestUUID = po.OptionUUID
    where p.QestUUID is not null
GO

----------------------------------------------------------------------------------------------------

exec [dbo].[qest_plate_AddOption]
  @qestUUID = 'EFCC817C-3EDA-4431-A9D0-AE2E30547B98',
  @name = 'LocationLabel',
  @groupName = 'Common',
  @caption = 'Location Label',
  @defaultValue = 'Borehole',
  @formatString = 'LISTTOCODE:Borehole;Borehole;Boring;Boring;Location;Location;'

exec [dbo].[qest_plate_AddOption]
  @qestUUID = '918451C8-DCB5-4BBD-ABEB-50CB5C78B0BE',
  @name = 'SampleDepthFormat',
  @groupName = 'Common',
  @caption = 'Sample Depth Format',
  @defaultValue = '0.00',
  @formatString = 'LISTTOCODE:0.0;0.0;0.00;0.00;'

exec [dbo].[qest_plate_AddOption]
  @qestUUID = '1F41DAA1-844F-476D-9E1A-E4D903CDE251',
  @name = 'UomSystem',
  @groupName = 'Common',
  @caption = 'UOM System for Report',
  @defaultValue = 'Lab',
  @formatString = 'LISTTOCODE:Lab;Use Laboratory Setting;US;US Customary units (IP);SI;International System of Units (SI);'

exec [dbo].[qest_plate_AddOption]
  @qestUUID = 'CC3F644C-09DD-48DE-9421-E0214D34E4B7',
  @name = 'AtterbergPlotScale',
  @groupName = 'Atterberg Limits',
  @caption = 'A-Line/U-Line Plot Scale',
  @defaultValue = 'Auto',
  @formatString = 'LISTTOCODE:Auto;Automatic (determined from data);Normal;Normal (LL: 0-80%, PI: 0-60%);Large;Large (LL: 0-160%, PI: 0-120%);Extra-large;Extra-large (LL:0-320%, PI:0-240%);',
  @appliesTo = '18520' --comma delimited list of QestIDs that this option applies to.
  
exec [dbo].[qest_plate_AddOption]
  @qestUUID = '07CDABF5-35D5-42A2-9FAF-84AF3614A600',
  @name = 'PrintSignature',
  @groupName = 'Common',
  @caption = 'Print Signature',
  @defaultValue = 'Yes',
  @formatString = 'LISTTOCODE:Yes;Yes;No;No'
GO

exec [dbo].[qest_plate_AddOption]
  @qestUUID = 'E0018E89-B3A4-41EE-A084-EC5D1F0BF3BF',
  @name = 'UndisturbedLabel',
  @groupName = 'Common',
  @caption = 'Undisturbed or Intact',
  @defaultValue = 'Undisturbed',
  @formatString = 'LISTTOCODE:Undisturbed;Undisturbed;Intact;Intact;',
  @appliesTo = '18515,18530,18531,18532,18533,18534,18539,18545,18550,18560,18570,18571' --comma delimited list of QestIDs that this option applies to.

----------------------------------------------------------------------------------------------------

if not exists (select * from sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[qest_GetDepth]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
  exec('create function [dbo].[qest_GetDepth]() returns int as begin return 0 end;');
GO
alter function [dbo].[qest_GetDepth](@depth real, @length real, @sampleDepthMode nvarchar(10), @IPUnits bit)
returns real
as
begin
  --Note: If a sample has no length (null), that's because it's "disturbed".  We consider those as having zero length.
  declare @uom nvarchar(6);
  select @uom = case when @IPUnits = 1 then 'ft' else 'm' end;
  return
    Round([dbo].[uomLength](case
      when @sampleDepthMode = 'top'    then @depth
      when @sampleDepthMode = 'middle' then @depth + coalesce((@length / 2), 0)
      when @sampleDepthMode = 'base'   then @depth + coalesce( @length     , 0)
      else @depth
    end, @uom), 4);
end
GO

if not exists (select * from sys.objects where object_id = object_id(N'[dbo].[qest_plate_GetReportProperties]') and type in (N'P', N'PC'))
  exec ('create proc [dbo].[qest_plate_GetReportProperties] as select 0 tmp');
GO
alter proc [dbo].[qest_plate_GetReportProperties]
  @reportUUID uniqueidentifier,
  @qestID int = null out,
  @sampleDepthMode nvarchar(10) = null out,
  @IPUnits bit = null out
as
  select @qestID = r.QestID
    , @sampleDepthMode = dbo.[qest_GetLaboratoryOption](r.QestOwnerLabNo, '\QLO\Formatting\SampleDepthMode', 'top')
    , @IPUnits = 
      case uom.Value
        when 'SI' then 0
        when 'IP' then 1
        when 'US' then 1
        else 
        case [dbo].[qest_GetLaboratoryOption](r.QestOwnerLabNo, '\QLO\Formatting\IPUnits', 'False') 
          when 'true' then 1
          else 0
        end
      end
  from DocumentCertificates r 
    left join view_PlateReportOptions uom on uom.ReportUUID = r.QestUUID and uom.Name = 'UomSystem' 
  where r.QestUUID = @reportUUID;
GO


----------------------------------------------------------------------------------------------------

if not exists (select * from sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[qest_GetLaboratoryOption]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
  exec('create function [dbo].[qest_GetLaboratoryOption]() returns int as begin return 0 end;');
GO
alter function [dbo].[qest_GetLaboratoryOption]
(
  @labNo int, 
  @optionKey nvarchar(255), 
  @defaultValue nvarchar(4000)
)
returns nvarchar(4000)
as
begin
  declare @optionValue nvarchar(4000);
  select top 1 @optionValue = OptionValue
    from Laboratory lab
      inner join Laboratory ancestor on ancestor.Lft <= lab.Lft and ancestor.Rgt >= lab.Rgt
      inner join Options o on ancestor.QestUniqueID = o.LocationID
    where lab.LabNo = @labNo 
      and o.OptionKey = @optionKey
      and o.OptionValue <> ''
    order by ancestor.Lvl desc;
  if @optionValue is null
  begin
    set @optionValue = @defaultValue;
  end
  return @optionValue;
end
GO

----------------------------------------------------------------------------------------------------

if not exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_SCHEMA = 'dbo' and TABLE_NAME = 'view_SampleDescription')
  exec('create view [dbo].[view_SampleDescription] as select 0 tmp;');
GO
alter view [dbo].[view_SampleDescription]
as
/* view_SampleDescription
 *
 * This view looks up the sample description for a specific sample or sub-sample, with the intention that it gives back a
 * value that can be reported alongside other test results (e.g. on the WC plate).
 *
 * It's not quite the same as is used for the 'sample description' report because that one just deals with the actual
 * sample description tests.  This one will return a single row for every sample in the database, with the best valid sample
 * description that can be found.
 *
 * As a rough outline:
 *   - If a Ground Description test was done on the sample itself, then we return the first Description value from the test.
 *     In the case of a disturbed sample, this will be the only description.  In the case of an undisturbed sample, it will
 *     be an incomplete result (the description will come from the first layer instead).
 *   - If no Ground Description test was done on the sample, we look at the parent sample(s), and see if a ground description
 *     test was done on one of them (nearest parent first).  We look for the first parent with a ground description test, and
 *     look within that test at the layers (only when the ground description was on an undisturbed sample) to find which layer 
 *     our sub-sample came from to decide with description to use.
 *
 * The basic rules for this view are:
 *   - there WILL be exactly one row for every sample article in the database (active or not)
 *   - If that sample article, or one of its parents had a ground description test, we'll end up using one of the descriptions
 *     from that test. 
 *
 */
with cte
as
(
  select AncestorUUID = s.QestUUID, DescendentUUID = s.QestUUID, Distance = 0
    from Samples s
  union all
    select cte.AncestorUUID, r.QestChildUUID, cte.Distance + 1
    from cte 
    inner join SampleRelationships r on cte.DescendentUUID = r.QestParentUUID
)
select SampleArticleUUID = s.QestUUID, x.Description, x.GroupSymbol, x.GroupName
from Samples s
left join 
(
select s.QestUUID, gds.Description, GroupSymbol = vi.GroupSymbol, GroupName = vi.GroupName
    , BestMatch = case when ROW_NUMBER() over (partition by s.QestUUID order by Distance asc, gds.offset asc) = 1 then 1 else 0 end
from Samples s
  inner join cte on s.QestUUID = cte.DescendentUUID 
  inner join Samples a on cte.AncestorUUID = a.QestUUID
  inner join qestReverseLookup rl on cte.AncestorUUID = rl.SampleArticleUUID
  inner join DocumentGroundDescription gd on rl.QestUUID = gd.QestUUID
  inner join DocumentGroundDescriptionSingle gds on gd.QestID = gds.QestParentID and gd.QestUniqueID = gds.QestUniqueParentID
  left join DocumentVisualIdentification vi on gds.QestParentID = vi.QestParentID and gds.QestUniqueParentID = vi.QestUniqueParentID and gds.Offset = vi.SampleOffset and gds.Height = vi.SampleHeight
    and 
    (
      -- this join probably doesn't work because the Ground Description test has no idea what offset and height are
      -- all about ... wait for fixes to be implemented.
      (a.Disturbed = 1) or 
      ((s.Depth + (s.Length / 2)) >= gds.Offset and (s.Depth + (s.Length / 2)) <= (gds.Offset + gds.Height))
    )
) x on s.QestUUID = x.QestUUID and BestMatch = 1

GO

----------------------------------------------------------------------------------------------------

if not exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_SCHEMA = 'dbo' and TABLE_NAME = 'view_moisturecontent')
  exec('create view [dbo].[view_moisturecontent] as select 0 tmp;');
GO
alter view [dbo].[view_moisturecontent]
as
with cte
as
(
  select AncestorUUID = s.QestUUID, DescendentUUID = s.QestUUID, Distance = 0
    from Samples s
  union all
    select cte.AncestorUUID, r.QestChildUUID, cte.Distance + 1
    from cte 
    inner join SampleRelationships r on cte.DescendentUUID = r.QestParentUUID
)
select SampleArticleUUID = s.QestUUID, x.MoistureContent
from Samples s
left join 
(
select s.QestUUID, mc.MoistureContent
    , BestMatch = case when ROW_NUMBER() over (partition by s.QestUUID order by Distance asc) = 1 then 1 else 0 end
from Samples s
  inner join cte on s.QestUUID = cte.DescendentUUID 
  inner join Samples a on cte.AncestorUUID = a.QestUUID
  inner join qestReverseLookup rl on cte.AncestorUUID = rl.SampleArticleUUID
  inner join DocumentMoistureContent mc on rl.QestUUID = mc.QestUUID
    and a.Disturbed = 1
) x on s.QestUUID = x.QestUUID and BestMatch = 1

GO

----------------------------------------------------------------------------------------------------

if not exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_SCHEMA = 'dbo' and TABLE_NAME = 'view_QestPlateReportNotes')
  exec('create view [dbo].[view_QestPlateReportNotes] as select 0 tmp;');
GO
alter view [dbo].[view_QestPlateReportNotes]
as
select n.QestUniqueID 
     , ReportUUID = c.QestUUID 
     , ReportNo = c.ReportNo 
     , LocationUUID = l.QestUUID
     , LocationCode = l.Code
     , Notes = n.Notes
from DocumentCertificates c
inner join ListSampleLocation l on c.ClientCode = l.ClientCode 
and 
(
  c.ProjectCode = l.ProjectCode and '|' + c.BoreholeCodes + '|' like '%' + l.Code + '%'
  or exists(select * from qestPlateReportNotes x where x.ReportUUID = c.QestUUID and x.LocationUUID = l.QestUUID)
)
left join qestPlateReportNotes n on n.ReportUUID = c.QestUUID and n.LocationUUID = l.QestUUID
GO

----------------------------------------------------------------------------------------------------

if not exists (select * from sys.objects where object_id = object_id(N'[dbo].[qest_plate_FindReportableTests]') and type in (N'P', N'PC'))
  exec ('create proc [dbo].[qest_plate_FindReportableTests] as select 0 tmp');
GO
alter proc [dbo].[qest_plate_FindReportableTests]
  @reportUUID uniqueidentifier,
  @clientCode nvarchar(50) = null,
  @projectCode nvarchar(50) = null,
  @boreholeList nvarchar(1000) = null,
  @minimumDepth real = null,
  @maximumDepth real = null,
  @testMethodQestIds nvarchar(1000) = null,
  @onlyCheckedTests bit = 0,
  @showReported bit = 0
as

  --The qestlab.qes entry for each type of plate report will need to store the QestIDs of all reportable test types I think.
  
  --look up the depth and UOM configuration for the report
  declare @qestID int, @IPUnits bit, @sampleDepthMode nvarchar(8);
  exec [dbo].[qest_plate_GetReportProperties] @reportUUID = @reportUUID, @qestID = @qestID out, @sampleDepthMode = @sampleDepthMode out, @IPUnits = @IPUnits out;
  
-- Get the list of test methods / tables etc that can be displayed by this type of plate report
-- KK says that all of the tests will have a 'remarks' column, they don't at the moment, so I'm
-- returning NULL for test methods that don't have one.
declare @reportableTests nvarchar(max)
select @reportableTests = Value
  from qestObjects 
  where QestID = @qestID and Property = 'ReportableTests';

-- If the reportable tests property is invalid, throw an error.
if @reportableTests like '%[^0-9,]%' or @reportableTests = '' or @reportableTests is null
begin
  raiserror ('The reportable tests property (%s) for object type [%d] is invalid or missing - unable to search for tests.', 16, 1, @reportableTests, @qestID);
  return 1;
end

declare @customPlateReportView sysname;
select @customPlateReportView = Value
  from qestObjects 
  where QestID = @qestID and Property = 'ReportableTestsCustomView';


--if the user-specified list of qestids is invalid, raise an error.  Note that we treat '' as NULL.
if @testMethodQestIds = ''
  set @testMethodQestIds = null;
if @testMethodQestIds is not null and ( @testMethodQestIds like '%[^0-9,]%' or not @testMethodQestIds like '%[0-9]%' )
begin
  raiserror ('The testMethodQestIds parameter (%s) is invalid.  It must be a comma delimited list of QestId values (or NULL).', 16, 1, @testMethodQestIds);
  return 1;
end

declare @sql_testTables nvarchar(max);
if @customPlateReportView <> '' 
begin
  if not exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_SCHEMA = 'dbo' and TABLE_NAME = @customPlateReportView)
  begin
    raiserror ('The custom plate report view (%s) for test type %d could not be found in the database.', 16, 1, @customPlateReportView, @qestID);
    return 1;
  end
  set @sql_testTables = 'select QestUUID, QestID, QestUniqueID, QestCheckedBy, QestCheckedDate, QestTestedBy, QestTestedDate, Remarks, GroupUUID from ' + QUOTENAME(@customPlateReportView);
end
else
begin
  declare @tableName nvarchar(100), @hasRemarksColumn bit, @hasGroupColumn bit
  declare curTables cursor fast_forward for
    select distinct tableName.Value, cast(case when col_Remarks.COLUMN_NAME is not null then 1 else 0 end as bit), cast(case when col_GroupUUID.COLUMN_NAME is not null then 1 else 0 end as bit)
    from qestObjects tableName
      inner join INFORMATION_SCHEMA.COLUMNS col_QestUUID on col_QestUUID.TABLE_SCHEMA = 'dbo' and col_QestUUID.TABLE_NAME = tableName.Value and col_QestUUID.COLUMN_NAME = 'QestUUID' and col_QestUUID.DATA_TYPE = 'uniqueidentifier'
      inner join INFORMATION_SCHEMA.COLUMNS col_QestID on col_QestID.TABLE_SCHEMA = 'dbo' and col_QestID.TABLE_NAME = tableName.Value and col_QestID.COLUMN_NAME = 'QestID' and col_QestID.DATA_TYPE = 'int'
      inner join INFORMATION_SCHEMA.COLUMNS col_QestUniqueID on col_QestUniqueID.TABLE_SCHEMA = 'dbo' and col_QestUniqueID.TABLE_NAME = tableName.Value and col_QestUniqueID.COLUMN_NAME = 'QestUniqueID' and col_QestUniqueID.DATA_TYPE = 'int'
      inner join INFORMATION_SCHEMA.COLUMNS col_CheckedBy on col_CheckedBy.TABLE_SCHEMA = 'dbo' and col_CheckedBy.TABLE_NAME = tableName.Value and col_CheckedBy.COLUMN_NAME = 'QestCheckedBy' and col_CheckedBy.DATA_TYPE = 'int'
      inner join INFORMATION_SCHEMA.COLUMNS col_CheckedDate on col_CheckedDate.TABLE_SCHEMA = 'dbo' and col_CheckedDate.TABLE_NAME = tableName.Value and col_CheckedDate.COLUMN_NAME = 'QestCheckedDate' and col_CheckedDate.DATA_TYPE = 'datetime'
      inner join INFORMATION_SCHEMA.COLUMNS col_TestedBy on col_TestedBy.TABLE_SCHEMA = 'dbo' and col_TestedBy.TABLE_NAME = tableName.Value and col_TestedBy.COLUMN_NAME = 'QestTestedBy' and col_TestedBy.DATA_TYPE = 'int'
      inner join INFORMATION_SCHEMA.COLUMNS col_TestedDate on col_TestedDate.TABLE_SCHEMA = 'dbo' and col_TestedDate.TABLE_NAME = tableName.Value and col_TestedDate.COLUMN_NAME = 'QestTestedDate' and col_TestedDate.DATA_TYPE = 'datetime'
      left join INFORMATION_SCHEMA.COLUMNS col_Remarks on col_TestedDate.TABLE_SCHEMA = 'dbo' and col_TestedDate.TABLE_NAME = tableName.Value and col_TestedDate.COLUMN_NAME = 'Remarks' and col_TestedDate.DATA_TYPE in ('ntext', 'nvarchar')
      left join INFORMATION_SCHEMA.COLUMNS col_GroupUUID on col_GroupUUID.TABLE_SCHEMA = 'dbo' and col_GroupUUID.TABLE_NAME = tableName.Value and col_GroupUUID.COLUMN_NAME = 'TestAnalysisUUID' and col_GroupUUID.DATA_TYPE in ('uniqueidentifier')
    where ',' + @reportableTests + ',' like '%,' + CAST(tableName.QestID as nvarchar(8)) + ',%'
      and (@testMethodQestIds is null or ',' + @testMethodQestIds + ',' like '%,' + CAST(tableName.QestID as nvarchar(8)) + ',%')
      and tableName.Property = 'TableName'
    order by tableName.Value

  open curTables
  fetch next from curTables into @tableName, @hasRemarksColumn, @hasGroupColumn
  while @@FETCH_STATUS = 0
  begin
    select @sql_testTables = coalesce(@sql_testTables + '
  union all ', '') 
    + 'select QestUUID, QestID, QestUniqueID, QestCheckedBy, QestCheckedDate, QestTestedBy, QestTestedDate, Remarks' + case when @hasRemarksColumn = 0 then ' = cast(null as nvarchar(max))' else '' end + ', GroupUUID' + case when @hasGroupColumn = 0 then ' = cast(null as uniqueidentifier)' else ' = TestAnalysisUUID' end
    + ' from [dbo].' + QUOTENAME(@tableName) + ' where QestID in (' + @reportableTests + ')'
    fetch next from curTables into @tableName, @hasRemarksColumn, @hasGroupColumn
  end
  close curTables
  deallocate curTables
end
--select @sql_testTables

-- Get report linked deprecated tests
declare @DeprecatedTests nvarchar(4000)
select
    @DeprecatedTests = cast(substring((
           select CHAR(10) + o.Value + ' (' + cast(o.QestID as nvarchar(8)) + ')' 
           from qestPlateReportMapping m 
		        inner join qestReverseLookup r on m.TestUUID = r.QestUUID 
		        inner join qestObjects o on o.QestID = r.QestID and o.Property = 'Name'
		   where m.ReportUUID = @reportUUID and r.QestID in (110816,110817,110820,110821)
          for xml path('')), 2, 4000) as nvarchar(1000))

--Is the report linked to deprecated tests
if len(@DeprecatedTests) > 0 begin
    --remove refernces to these tests if report is unsigned
    if not exists(select 1 from DocumentCertificates where QestUUID = @reportUUID and coalesce(SignatoryID,0) > 0) begin
        delete m from qestPlateReportMapping m inner join qestReverseLookup r on m.TestUUID = r.QestUUID where m.ReportUUID = @reportUUID and r.QestID in (110816,110817,110820,110821)
    end
    -- Else send warning it still has deprecated tests
    else begin
		set @DeprecatedTests = '<ql_warning>The following test types reported by this report have been deprecated and are no longer reportable; '+@DeprecatedTests+'</ql_warning>'
	    select @DeprecatedTests
	    raiserror(@DeprecatedTests, 16, 1)
	    return 1
    end 
end
--Clear @testMethodQestIds for deprecated tests
if @testMethodQestIds in ('110816','110817','110820','110821')
	set @testMethodQestIds = ''

if @sql_testTables is null 
begin
	set @DeprecatedTests  = cast(coalesce(@reportUUID,'') as nvarchar(100))+' '+coalesce(@clientCode,'')+' '+coalesce(@projectCode,'')+' '+coalesce(@boreholeList,'')+' '+ 
	                        cast(coalesce(@minimumDepth,'') as nvarchar(100))+' '+cast(coalesce(@maximumDepth,'') as nvarchar(100))+' '+coalesce(@testMethodQestIds,'')+' '+
							cast(coalesce(@onlyCheckedTests,'') as nvarchar(1))+' '+cast(coalesce(@showReported,'') as nvarchar(1))
    raiserror('Unable to determine reportable tests.', 16, 1)
	return 1
end

--build up our SQL query...
declare @sql_to_execute nvarchar(max)
set @sql_to_execute  = '
select *
from
(
select 
    [TestUUID] = t.QestUUID 
  , [MappingUUID] = m.QestUUID

  , [Selected] = cast(case when m.QestUUID is not null then 1 else 0 end as bit)

  , [Borehole] = s.BoreholeCode
  , [Sample]= s.SampleArticleID
  
  , [Depth]= [dbo].[qest_GetDepth](s.Depth, s.Length, @sampleDepthMode, @IPUnits)
  
  , [TestMethod] = coalesce(tm.Value + '' ['' + ta.Value + '']'', ta.Value, tm.Value)
  
  , [Tested] = cast(case when t.QestTestedDate is not null then 1 else 0 end as bit)
  , [TestedBy] = p_tst.Code
  , [TestedDate] =  t.QestTestedDate

  , [Checked] = finalCheck.CheckApproved
  , [CheckedBy] = p_chk.Code
  , [CheckedDate] =  t.QestCheckedDate

  , [Remarks] = t.Remarks
  
  , [GroupUUID] = t.GroupUUID
  
  , [ExistingMapping] = cast( substring( 
        (select '', '' + c.ReportNo 
          from dbo.DocumentCertificates c
          inner join dbo.qestPlateReportMapping rm on c.QestUUID = rm.ReportUUID
          where c.QestUUID <> @reportUUID and rm.TestUUID = rl.QestUUID
            and c.QestID = @qestID
        order by c.ReportNo
        for xml path('''')),3,1000) as nvarchar(1000))
  
  --since we return selected items that do not actually match the search criteria, we need a way to identify
  --whether the test does, or does not match the search criteria.
  , [IsMatch] = cast(case when
    (
	    s.ClientCode = @clientCode 
	    and s.ProjectCode = @projectCode
	    and ''|'' + @boreholeList + ''|'' like ''%|'' + s.BoreholeCode + ''|%''
	  
	    and 
	    (
	      @minimumDepth is null
	      or [dbo].[qest_GetDepth](s.Depth, s.Length, @sampleDepthMode, @IPUnits) >= @minimumDepth
	    )
	    and 
	    (
	      @maximumDepth is null
	      or [dbo].[qest_GetDepth](s.Depth, s.Length, @sampleDepthMode, @IPUnits) <= @maximumDepth
	    )
	
	    and '','' + @reportableTests + '','' like ''%,'' + CAST(rl.QestID as nvarchar(8)) + '',%''
	    and (@testMethodQestIds is null or '','' + @testMethodQestIds + '','' like ''%,'' + CAST(rl.QestID as nvarchar(8)) + '',%'')
	    and (@onlyCheckedTests = 0 or finalCheck.CheckApproved = 1)
	    and (coalesce(finalCheck.CheckRejected, 0) = 0)
    )
    then 1 else 0 end as bit)
from ('
      + @sql_testTables +
      ') t
  inner join (
              select rlt.QestUUID, SampleArticleUUID = coalesce(rlt.SampleArticleUUID, rls.SampleArticleUUID), rlt.QestID
              from qestReverseLookup rlt 
                   left join qestReverseLookup rls on rlt.SampleArticleUUID is null and rlt.QestParentUUID = rls.QestUUID
             ) rl on rl.QestUUID = t.QestUUID
  inner join Samples s on rl.SampleArticleUUID = s.QestUUID 

  left join QestObjects tm on rl.QestID = tm.QestID and tm.Property = ''Method''
  left join QestObjects ta on rl.QestID = ta.QestID and ta.Property = ''Abbreviation''
  
  left join Users u_chk on t.QestCheckedBy = u_chk.QESTUniqueID
  left join People p_chk on u_chk.PersonID = p_chk.QestUniqueID
  left join Users u_tst on t.QestTestedBy = u_tst.QESTUniqueID
  left join People p_tst on u_tst.PersonID = p_tst.QestUniqueID
  left join qestPlateReportMapping m on m.TestUUID = rl.QestUUID and m.ReportUUID = @reportUUID
  
  --joins for the final QC check
  left join (select TestQestID, Idx = max(Idx) from qestTestStage where IsCheckStage = 1 group by TestQestID) finalStage on rl.QestID = finalStage.TestQestID
  left join qestTestStage stage on stage.TestQestID = finalStage.TestQestID and stage.Idx = finalStage.Idx
  left join TestStageData finalCheck on finalCheck.QestID = stage.TestStageQestID and finalCheck.QestParentUUID = rl.QestUUID
  
where 
  (
    --already mapped to this report
    m.QestUUID is not null
  )
  or
  (
    --all the other criteria match up...
    s.ClientCode = @clientCode 
    and s.ProjectCode = @projectCode
    and ''|'' + @boreholeList + ''|'' like ''%|'' + s.BoreholeCode + ''|%''
  
    and 
    (
      @minimumDepth is null
      or [dbo].[qest_GetDepth](s.Depth, s.Length, @sampleDepthMode, @IPUnits) >= @minimumDepth
    )
    and 
    (
      @maximumDepth is null
      or [dbo].[qest_GetDepth](s.Depth, s.Length, @sampleDepthMode, @IPUnits) <= @maximumDepth
    )

    and '','' + @reportableTests + '','' like ''%,'' + CAST(rl.QestID as nvarchar(8)) + '',%''
    and (@testMethodQestIds is null or '','' + @testMethodQestIds + '','' like ''%,'' + CAST(rl.QestID as nvarchar(8)) + '',%'')
	and (@onlyCheckedTests = 0 or finalCheck.CheckApproved = 1)
	and (coalesce(finalCheck.CheckRejected, 0) = 0)
  )
) x
where 
(
  @showReported = 1 or [ExistingMapping] is null or [MappingUUID] is not null
)
order by x.Borehole, x.Depth, x.Sample, x.TestUUID'

declare @params nvarchar(max)
set @params = N'@reportUUID uniqueidentifier, @qestID int, @clientCode nvarchar(50), @projectCode nvarchar(50), @boreholeList nvarchar(1000), @minimumDepth real, @maximumDepth real, @showReported bit, @IPUnits bit, @sampleDepthMode nvarchar(8), @reportableTests nvarchar(max), @testMethodQestIds nvarchar(max), @onlyCheckedTests bit'

/*
if @debug = 1
begin
  declare @idx int, @tmp nvarchar(4000);
  print 'declare ' + @params;
  set @idx = 1
  while @idx < LEN(@sql_to_execute)
  begin
    
    set @tmp = SUBSTRING(@sql_to_execute, @idx, 4000);
    print @tmp;
    set @idx = @idx + 4000;
  end
end
*/
exec sp_executesql @sql_to_execute, @params, @reportUUID, @qestID, @clientCode, @projectCode, @boreholeList, @minimumDepth, @maximumDepth, @showReported, @IPUnits, @sampleDepthMode, @reportableTests, @testMethodQestIds, @onlyCheckedTests;
GO



----------------------------------------------------------------------------------------------------

/*
 * Certificate.MapIncludedObjectForPlateReport
 *
 * Previously hard-coded in the QLO.Certificate class, however, it turns out that the rules are more
 * complex than originally expected because we need to be able to map incomplete tests to the report.
 * When incomplete tests are mapped to the report, however, we don't want them to become read-only at
 * the point where the report is signed.  So, we have to check that each test is actually complete 
 * before including it in the qestReportMapping table.
 *
 */
if not exists (select * from sys.objects where object_id = object_id(N'[dbo].[qest_plate_MapIncludedObjects]') and type in (N'P', N'PC'))
  exec ('create proc [dbo].[qest_plate_MapIncludedObjects] as select 0 tmp');
GO
alter proc [dbo].[qest_plate_MapIncludedObjects]
  @reportUUID uniqueidentifier
as
set nocount on;
begin transaction;
begin try;
  if not exists (select * from DocumentCertificates where QestUUID = @reportUUID)
  begin
    if exists (select * from DocumentExternal where QestUUID = @reportUUID)
    begin
      commit;
      return; -- external reports don't map to any other documents
    end
    declare @tmp nvarchar(100);
    set @tmp = cast(@reportUUID as nvarchar(100))
    raiserror('A report with ID {%s} could not be found in the database', 16, 1, @tmp);
  end

  declare @tableNames table (TableName sysname);
  insert into @tableNames (TableName)
    select distinct tn.Value
    from qestObjects tn
    where tn.Property = 'TableName'
    and QestID in 
    (
      select rl.QestID 
      from qestReverseLookup rl
      inner join qestPlateReportMapping m on rl.QestUUID = m.TestUUID
      where m.ReportUUID = @reportUUID 
    )
  declare @tableName sysname;
  select top 1 @tableName
    from @tableNames t
    where not exists (select * from INFORMATION_SCHEMA.COLUMNS c where c.TABLE_SCHEMA = 'dbo' and c.TABLE_NAME = t.TableName and c.COLUMN_NAME = 'QestUUID')
      or not exists (select * from INFORMATION_SCHEMA.COLUMNS c where c.TABLE_SCHEMA = 'dbo' and c.TABLE_NAME = t.TableName and c.COLUMN_NAME = 'QestUniqueID')
      or not exists (select * from INFORMATION_SCHEMA.COLUMNS c where c.TABLE_SCHEMA = 'dbo' and c.TABLE_NAME = t.TableName and c.COLUMN_NAME = 'QestID')
      or not exists (select * from INFORMATION_SCHEMA.COLUMNS c where c.TABLE_SCHEMA = 'dbo' and c.TABLE_NAME = t.TableName and c.COLUMN_NAME = 'QestStatusFlags')
  if @tableName is not null
  begin
    raiserror('The database schema for one or more tests mapped to the report is invalid.  First invalid table: %s', 16, 1, @tableName);
  end

  declare curTables cursor fast_forward for select TableName from @tableNames;
  open curTables
  fetch next from curTables into @tableName
  while @@FETCH_STATUS = 0
  begin
    declare @sql_to_execute nvarchar(max);
    --Status flags:  Complete: 0x0001; Tested: 0x0004; Checked: 0x0008;
    --Complete+Tested+Checked = 0x000D
    --Dynamic SQL because the table name varies depending on the test method.
    select @sql_to_execute =
    'insert into qestReportMapping (ReportQestUUID, ReportQestID, ReportQestUniqueID, TestQestUUID, TestQestID, TestQestUniqueID, Registration, Mapping) 
      select c.QestUUID, c.QestID, c.QestUniqueID, t.QestUUID, t.QestID, t.QestUniqueID, null, 1
      from [dbo].[DocumentCertificates] c
      inner join [dbo].[qestPlateReportMapping] m on c.QestUUID = m.ReportUUID
      inner join [dbo].' + quotename(@tableName) + ' t on m.TestUUID = t.QestUUID
      where c.QestUUID = @reportUUID
        and (t.QestStatusFlags & 0x000D) = 0x000D
        and not exists
        (
          select * 
          from [dbo].[qestReportMapping] x 
          where x.ReportQestID = c.QestID
            and x.ReportQestUniqueID = c.QestUniqueID
            and x.TestQestID = t.QestID
            and x.TestQestUniqueID = t.QestUniqueID
            and x.Mapping = 1 
        )';
    exec sp_executesql @sql_to_execute, N'@reportUUID uniqueidentifier', @reportUUID
    fetch next from curTables into @tableName
  end
  close curTables
  deallocate curTables
  
  commit transaction
end try
begin catch
  declare @errMessage nvarchar(max), @errState int, @errSeverity int;
  select @errMessage = ERROR_MESSAGE(),
    @errSeverity = ERROR_SEVERITY(),
    @errState = ERROR_STATE();
  rollback
  raiserror(@errMessage, @errMessage, @errSeverity, @errState)
end catch
GO

----------------------------------------------------------------------------------------------------

if not exists (select * from sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[qest_Plate_GetOrganicMoistureRounding_ASTMD2974]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
  exec('create function [dbo].[qest_Plate_GetOrganicMoistureRounding_ASTMD2974]() returns int as begin return 0 end;');
GO
alter function [dbo].[qest_Plate_GetOrganicMoistureRounding_ASTMD2974](@MoistureContent real, @OvenDriedBasis bit)
returns nvarchar(8)
as
begin
  DECLARE @roundedValue as nvarchar(8)
  --Note: If a sample has no length (null), that's because it's "disturbed".  We consider those as having zero length.
  if @OvenDriedBasis = 0
  BEGIN
    SET @roundedValue = cast([dbo].[qest_round_to_even](@MoistureContent,2) as numeric(36,2))
  END
  else
  begin
	set @roundedValue =
	case when @MoistureContent > 1000 then  cast(20*[dbo].[qest_round_to_even](@MoistureContent/20,0) as numeric(36,0))
	     when @MoistureContent > 500 then  cast(10*[dbo].[qest_round_to_even](@MoistureContent/10,0) as numeric(36,0))
	     when @MoistureContent > 100 then  cast(5*[dbo].[qest_round_to_even](@MoistureContent/5,0) as numeric(36,0))
	     else  cast([dbo].[qest_round_to_even](@MoistureContent,0) as numeric(36,0))
	end
  end
  RETURN @roundedValue
end
GO

----------------------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[qest_Plate_GetSampleTypeDescription]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
  EXEC('create function [dbo].[qest_Plate_GetSampleTypeDescription]() returns nvarchar(50) as begin return 0 end;');
GO
ALTER FUNCTION [dbo].[qest_Plate_GetSampleTypeDescription](@SampleType int) RETURNS nvarchar(50)
AS
BEGIN
	-- Return descriptive string corresponding to integer SampleType
	RETURN
		CASE WHEN @SampleType = 0 THEN 'Undisturbed'
			 WHEN @SampleType = 1 THEN 'Disturbed'
			 WHEN @SampleType = 2 THEN 'Remoulded'
			 WHEN @SampleType = 3 THEN 'Reconstituted'
			 ELSE '-' -- Report "-" for Null or invalid input
		END
END
GO

----------------------------------------------------------------------------------------------------

-- 3.1 Sample Description --

if not exists (select * from sys.objects where object_id = object_id(N'[dbo].[qest_plate_sampledescription]') and type in (N'P', N'PC'))
  exec ('create proc [dbo].[qest_plate_sampledescription] as select 0 tmp');
GO
alter proc [dbo].[qest_plate_sampledescription]
  @reportUUID uniqueidentifier
as
  set nocount on;
  
  declare @sampleDepthMode nvarchar(10), @IPUnits bit;
  exec [dbo].[qest_plate_GetReportProperties] @reportUUID = @reportUUID, @sampleDepthMode = @sampleDepthMode out, @IPUnits = @IPUnits out;
  
  select QestID = coalesce(vi.QestID, t.QestID)
       , t.QestUniqueID
       , t.QestUUID
       , t.QestSpecification
       , IsTestChecked = case when t.QestCheckedDate is not null then 1 else 0 end
       , RecordUniqueID = r.QestUniqueID
       , Borehole = s.BoreholeCode
       , Sample = s.SampleArticleID
       , Depth = 
         case 
           when r.QestUniqueID is null then [dbo].[qest_GetDepth](s.Depth, s.Length, @sampleDepthMode, @IPUnits)
           else [dbo].[qest_GetDepth](r.Offset_SI, r.Height_SI, @sampleDepthMode, @IPUnits)
         end
       , r.MajorComponent
       , r.Description
  from DocumentCertificates c
    inner join qestPlateReportMapping m on c.QestUUID = m.ReportUUID
    inner join qestReverseLookup rl on m.TestUUID = rl.QestUUID
    inner join Samples s on s.QestUUID = rl.SampleArticleUUID 
    inner join DocumentGroundDescription t on t.QestUUID = m.TestUUID
    left join DocumentGroundDescriptionSingle r on t.QestID = r.QestParentID and t.QestUniqueID = r.QestUniqueParentID
    left join DocumentVisualIdentification vi on r.QestParentID = vi.QestParentID and r.QestUniqueParentID = vi.QestUniqueParentID and r.Offset = vi.SampleOffset and r.Height = vi.SampleHeight
  where c.QestUUID = @reportUUID
  order by s.BoreholeCode, s.Depth, s.SampleArticleID, s.QestUUID, t.QestUUID, r.Offset, r.QestUUID
GO

----------------------------------------------------------------------------------------------------

-- 3.2 Water Content

if not exists (select * from sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[round_sf]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
  exec('create function [dbo].[round_sf]() returns int as begin return 0 end;');
GO
/* Round a number to the specified number of decimal places.
 *
 * http://stackoverflow.com/questions/1920933/round-to-n-significant-figures-in-sql
 *
 */
alter function [dbo].[round_sf](@number float, @sf int) returns float as
begin
    declare @r float
    select @r = case when @number = 0 then 0 else round(@number ,@sf -1-floor(log10(abs(@number )))) end
    return (@r)
end
GO

if not exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_SCHEMA = 'dbo' and TABLE_NAME = 'WaterContentPlateReportView')
  exec('create view dbo.WaterContentPlateReportView as select 0 tmp');
GO

alter view dbo.WaterContentPlateReportView as
	
  select m.QestUUID, m.QestID, m.QestUniqueID, m.QestCheckedBy, QestCheckedDate, QestTestedBy, QestTestedDate, Remarks, GroupUUID = null
    from DocumentMoistureContent m
    inner join qestReverseLookup rl on rl.QestUUID = m.QestUUID
    inner join Samples s on s.QestUUID = rl.SampleArticleUUID
    where rl.SampleArticleUUID is not null 
  union all
  select m.QestUUID, m.QestID, m.QestUniqueID, m.QestCheckedBy, QestCheckedDate, QestTestedBy, QestTestedDate, Remarks, GroupUUID = null
    from DocumentMoistureContent m
    inner join qestReverseLookup rl on rl.QestUUID = m.QestUUID
    inner join qestReverseLookup rlp on rlp.QestUUID = rl.QestParentUUID
    inner join Samples s on s.QestUUID = rlp.SampleArticleUUID
    where rl.SampleArticleUUID is null and s.Disturbed = 0 --Can't have disturbed Oedometer or Triaxial Moisture Contents
GO

if not exists (select * from sys.objects where object_id = object_id(N'[dbo].[qest_plate_watercontent]') and type in (N'P', N'PC'))
  exec ('create proc [dbo].[qest_plate_watercontent] as select 0 tmp');
GO
alter proc [dbo].[qest_plate_watercontent]
  @reportUUID uniqueidentifier
as
  set nocount on;

  declare @sampleDepthMode nvarchar(10), @IPUnits bit;
  exec [dbo].[qest_plate_GetReportProperties] @reportUUID = @reportUUID, @sampleDepthMode = @sampleDepthMode out, @IPUnits = @IPUnits out;
  
  -- When reporting a water content test that was done as a part of another test, we need to map the QestID to the water content test
  -- method referenced by the standard for that test. That ensures that the correct reportable fields for the water content part of 
  -- the test will be displayed on the report.
  declare @qestIdMapping table(QestID int, ReportAsQestId int, MoistureContentID int, RoundingDecimalPlaces int, RoundingSignificantFigures int); 
  insert @qestIdMapping (QestID, ReportAsQestId, MoistureContentID, RoundingDecimalPlaces, RoundingSignificantFigures)
              select 110816, 110066 , 111025,    1 , null -- Triaxial UU Undisturbed [ASTM D 2850] --> Moisture Content of Soil and Rock [ASTM D 2216], assume reporting to 1 decimal place.
    union all select 110820, 110386 , 111025, null ,    2 -- Triaxial UU Undisturbed [BS 1377 Part 7, cl.8] --> Moisture Content [BS 1377-2: 1990] *, report to 2 significant figures 
    union all select 110822, 110940 , 111025,    1 , null -- ASTM CIU Triaxial initial
    union all select 110824, 110940 , 111025,    1 , null -- ASTM CID Triaxial initial
    union all select 110826, 110940 , 111025,    1 , null -- ASTM CAU Triaxial initial
    union all select 110827, 110940 , 111025,    1 , null -- ASTM CAD Triaxial initial
    union all select 110828, 110940 , 111025,    1 , null -- ASTM UU Triaxial initial
    union all select 110816, 110066 , 111026,    1 , null -- Triaxial UU Undisturbed [ASTM D 2850] --> Moisture Content of Soil and Rock [ASTM D 2216], assume reporting to 1 decimal place.
    union all select 110820, 110386 , 111026, null ,    2 -- Triaxial UU Undisturbed [BS 1377 Part 7, cl.8] --> Moisture Content [BS 1377-2: 1990] *, report to 2 significant figures 
    union all select 110822, 110940 , 111026,    1 , null -- ASTM CIU Triaxial final
    union all select 110824, 110940 , 111026,    1 , null -- ASTM CID Triaxial final
    union all select 110826, 110940 , 111026,    1 , null -- ASTM CAU Triaxial final
    union all select 110827, 110940 , 111026,    1 , null -- ASTM CAD Triaxial final
    union all select 110828, 110940 , 111026,    1 , null -- ASTM UU Triaxial final
    union all select 110920, 110940 , 111036,    1 , null -- ASTM OED
    union all select 110920, 110940 , 111037,    1 , null -- ASTM OED
    union all select 110912, 110940 , 111025,    1 , null -- ASTM UCS	
    union all select 110948, 110940 , 111038,    1 , null -- Bulk Density/Unit Weight
    union all select 110949, 110940 , 111038,    1 , null -- Bulk Density/Unit Weight
    union all select 110823, 110951 , 111025, null ,    2 -- BS CIU Triaxial initial
    union all select 110825, 110951 , 111025, null ,    2 -- BS CID Triaxial initial
    union all select 110829, 110951 , 111025, null ,    2 -- BS UU Triaxial initial
    union all select 110830, 110951 , 111025, null ,    2 -- BS CAD Triaxial initial
    union all select 110831, 110951 , 111025, null ,    2 -- BS CAU Triaxial initial
	union all select 110914, 110951 , 111025, null ,    2 -- BS UCS Triaxial initial 
    union all select 110823, 110951 , 111026, null ,    2 -- BS CIU Triaxial final
    union all select 110825, 110951 , 111026, null ,    2 -- BS CID Triaxial final
    union all select 110829, 110951 , 111026, null ,    2 -- BS UU Triaxial final
    union all select 110830, 110951 , 111026, null ,    2 -- BS CAD Triaxial final
    union all select 110831, 110951 , 111026, null ,    2 -- BS CAU Triaxial final	    
	union all select 110914, 110951 , 111026, null ,    2 -- BS UCS Triaxial final
    union all select 110921, 110951 , 111036, null ,    2 -- BS OED
    union all select 110921, 110951 , 111037, null ,    2 -- BS OED
    union all select 110914, 110940 , 111025, null ,    2 -- BS UCS
    union all select 110917, 110941 , 111038,    1 , null -- BS Bulk Density/Unit Weight
    union all select 110929, 110941 , 111038,    1 , null -- BS Bulk Density/Unit Weight
    union all select 110939, 110941 , 111038,    1 , null -- BS Bulk Density/Unit Weight
    union all select 110952, 110951 , 111038,    1 , null -- ISO Bulk Density/Unit Weight
    union all select 110953, 110951 , 111038,    1 , null -- ISO Bulk Density/Unit Weight
    union all select 110954, 110951 , 111038,    1 , null -- ISO Bulk Density/Unit Weight
	

  select t.QestID
       , t.QestUniqueID
       , t.QestUUID
       , t.QestSpecification
       , IsTestChecked = case when t.QestCheckedDate is not null then 1 else 0 end
       , Borehole = s.BoreholeCode
       , Sample = s.SampleArticleID
       , Specimen = null
       , Depth = [dbo].[qest_GetDepth](s.Depth, s.Length, @sampleDepthMode, @IPUnits)
       , SoilDescription = d.Description
       , Remarks = t.Remarks
       , WaterContent = t.MoistureContentReported
       , MethodAB = t.Method
	   , MoistureContentFormat = t.MoistureContentFormat
	  
  from DocumentCertificates c
    inner join qestPlateReportMapping m on c.QestUUID = m.ReportUUID
    inner join 
    ( 
	   --case t.QestID when 110951 then '' when 110941 then 'R:t10:2sf;:0' when 110386 then '' else '0.00' end
      select QestID, QestUniqueID, QestUUID, QestSpecification, QestCheckedDate, MoistureContentReported = NULLIF(MoistureContentReported, ''), Remarks, Method = MoistureMethod
	       , MoistureContentFormat = '@'
        from DocumentMoistureContent where QestID in (110940, 110066)
      union all
	  select QestID, QestUniqueID, QestUUID, QestSpecification, QestCheckedDate, MoistureContentReported = NULLIF(MoistureContent, ''), Remarks, Method = MoistureMethod
	       , MoistureContentFormat = 'R:t10:2sf;:0'
        from DocumentMoistureContent where QestID in (110941, 110386)
      union all
	  select QestID, QestUniqueID, QestUUID, QestSpecification, QestCheckedDate, MoistureContentReported = NULLIF(MoistureContent, ''), Remarks, Method = MoistureMethod
	       , MoistureContentFormat = 'R:t10:2sf;t99.9:0.0;:0'
        from DocumentMoistureContent where QestID in (110951)
      union all
        select [QestID] = idmap.ReportAsQestId, x.QestUniqueID, x.QestUUID, x.QestSpecification, x.QestCheckedDate, [MoistureContentReported] =
        cast(
          case 
            when idmap.RoundingDecimalPlaces is not null then round(x.MoistureContent, idmap.RoundingDecimalPlaces)         
            when idmap.RoundingSignificantFigures > 0    then [dbo].[round_sf](x.MoistureContent, idmap.RoundingSignificantFigures)
            else round(x.MoistureContent, 2)             --no rounding specified - we'll default to 2 decimal places...
          end 
          as nvarchar(10))
        , x.Remarks, x.Method, MoistureContentFormat = '@'
        from
        (
          select rls.QestID, MoistureID = mct.QestID, mct.QestUniqueID, mct.QestUUID, mct.QestSpecification, mct.QestCheckedDate, MoistureContent = mct.MoistureContent, mct.Remarks, Method = null
          from DocumentMoistureContent mct 
		       inner join qestReverseLookup rlt on rlt.QestUUID = mct.QestUUID
			   inner join qestReverseLookup rls on rlt.SampleArticleUUID is null and rlt.QestParentUUID = rls.QestUUID
		  where mct.QestID in (111025, 111026, 111037, 111038)
         ) x 
        inner join @qestIdMapping idmap on x.QestID = idmap.QestID and x.MoistureID = idmap.MoistureContentID
    ) t on t.QestUUID = m.TestUUID
    inner join (
	            select rlt.QestUUID, SampleArticleUUID = coalesce(rlt.SampleArticleUUID, rls.SampleArticleUUID)
			    from qestReverseLookup rlt 
				     left join qestReverseLookup rls on rlt.SampleArticleUUID is null and rlt.QestParentUUID = rls.QestUUID
			   ) rl on rl.QestUUID = t.QestUUID
    inner join Samples s on s.QestUUID = rl.SampleArticleUUID 
    left join [dbo].[view_SampleDescription] d on s.QestUUID = d.SampleArticleUUID
  where c.QestUUID = @reportUUID
  order by s.BoreholeCode, s.Depth, s.SampleArticleID, s.QestUUID, t.QestUUID 
GO

----------------------------------------------------------------------------------------------------

-- 3.3 Bulk Density 

if not exists (select * from sys.objects where object_id = object_id(N'[dbo].[qest_plate_bulkdensity]') and type in (N'P', N'PC'))
  exec ('create proc [dbo].[qest_plate_bulkdensity] as select 0 tmp');
GO
alter proc [dbo].[qest_plate_bulkdensity]
  @reportUUID uniqueidentifier
as
  set nocount on;
  
  declare @sampleDepthMode nvarchar(10), @IPUnits bit;
  exec [dbo].[qest_plate_GetReportProperties] @reportUUID = @reportUUID, @sampleDepthMode = @sampleDepthMode out, @IPUnits = @IPUnits out;
  
  select QestID = tbd.QestID
       , tbd.QestUniqueID
       , tbd.QestUUID
       , tbd.QestSpecification
       , IsTestChecked = case when (tbd.QestCheckedDate is not null or tbd.QestCheckedDate is not null) then 1 else 0 end
       , Borehole = s.BoreholeCode
       , Sample = s.SampleArticleID
       , Depth = [dbo].[qest_GetDepth](s.Depth, s.Length, @sampleDepthMode, @IPUnits)
       , BulkUnitWeight_SI = dbo.uomDensity(tbd.BulkUnitWeight,'Mg/m³')
       , BulkUnitWeight_IP = dbo.uomDensity(tbd.BulkUnitWeight,'pcf')
       , BulkDensity_SI = dbo.uomDensity(tbd.BulkDensity,'Mg/m³')
       , BulkDensity_IP = dbo.uomDensity(tbd.BulkDensity,'pcf')
       , DryUnitWeight_SI = dbo.uomDensity(tbd.DryUnitWeight,'Mg/m³')
       , DryUnitWeight_IP = dbo.uomDensity(tbd.DryUnitWeight,'pcf')
       , DryDensity_SI = dbo.uomDensity(tbd.DryDensity,'Mg/m³')
       , DryDensity_IP = dbo.uomDensity(tbd.DryDensity,'pcf')
       , MoistureContent = tbd.MoistureContent
       , VisualDescription = d.GroupSymbol+' '+d.GroupName
       , MethodUsed = case tbd.QestID when 110917 then 'Clause 7.2' when 110929 then 'Clause 7.3' when 110939 then 'Clause 7.4' when 110952 then 'Clause 5.1' when 110953 then 'Clause 5.2' when 110954 then 'Clause 5.3' else NULL end
       , SampleType = ''
  from DocumentCertificates c
    inner join qestPlateReportMapping m on c.QestUUID = m.ReportUUID
    inner join qestReverseLookup rl on m.TestUUID = rl.QestUUID
    inner join Samples s on s.QestUUID = rl.SampleArticleUUID 
    inner join DocumentBulkDensityDirectMeasurement tbd on tbd.QestUUID = m.TestUUID
    left join [dbo].[view_SampleDescription] d on s.QestUUID = d.SampleArticleUUID
  where c.QestUUID = @reportUUID
  UNION ALL  
  select QestID = tbd.QestID
       , tbd.QestUniqueID
       , tbd.QestUUID
       , tbd.QestSpecification
       , IsTestChecked = case when (tbd.QestCheckedDate is not null or tbd.QestCheckedDate is not null) then 1 else 0 end
       , Borehole = s.BoreholeCode
       , Sample = s.SampleArticleID
       , Depth = [dbo].[qest_GetDepth](s.Depth, s.Length, @sampleDepthMode, @IPUnits)
       , BulkUnitWeight_SI = dbo.uomDensity(tbd.BulkUnitWeight,'Mg/m³')
       , BulkUnitWeight_IP = dbo.uomDensity(tbd.BulkUnitWeight,'pcf')
       , BulkDensity_SI = dbo.uomDensity(tbd.BulkDensity,'Mg/m³')
       , BulkDensity_IP = dbo.uomDensity(tbd.BulkDensity,'pcf')
       , DryUnitWeight_SI = dbo.uomDensity(tbd.DryUnitWeight,'Mg/m³')
       , DryUnitWeight_IP = dbo.uomDensity(tbd.DryUnitWeight,'pcf')
       , DryDensity_SI = dbo.uomDensity(tbd.DryDensity,'Mg/m³')
       , DryDensity_IP = dbo.uomDensity(tbd.DryDensity,'pcf')
       , MoistureContent = tbd.MoistureContent
       , VisualDescription = d.GroupSymbol+' '+d.GroupName
       , MethodUsed = case tbd.QestID when 110917 then 'Clause 7.2' when 110929 then 'Clause 7.3' when 110939 then 'Clause 7.4' when 110952 then 'Clause 5.1' when 110953 then 'Clause 5.2' when 110954 then 'Clause 5.3' else NULL end
       , SampleType = ''
  from DocumentCertificates c
    inner join qestPlateReportMapping m on c.QestUUID = m.ReportUUID
    inner join qestReverseLookup rl on m.TestUUID = rl.QestUUID
    inner join Samples s on s.QestUUID = rl.SampleArticleUUID 
    inner join DocumentBulkDensityCoated tbd on tbd.QestUUID = m.TestUUID
    left join [dbo].[view_SampleDescription] d on s.QestUUID = d.SampleArticleUUID
  where c.QestUUID = @reportUUID
  UNION ALL  
  select QestID = tbd.QestID
       , tbd.QestUniqueID
       , tbd.QestUUID
       , tbd.QestSpecification
       , IsTestChecked = case when (tbd.QestCheckedDate is not null or tbd.QestCheckedDate is not null) then 1 else 0 end
       , Borehole = s.BoreholeCode
       , Sample = s.SampleArticleID
       , Depth = [dbo].[qest_GetDepth](s.Depth, s.Length, @sampleDepthMode, @IPUnits)
       , BulkUnitWeight_SI = dbo.uomDensity(tbdc.BulkUnitWeight,'Mg/m³')
       , BulkUnitWeight_IP = dbo.uomDensity(tbdc.BulkUnitWeight,'pcf')
       , BulkDensity_SI = dbo.uomDensity(tbdc.BulkDensity,'Mg/m³')
       , BulkDensity_IP = dbo.uomDensity(tbdc.BulkDensity,'pcf')
       , DryUnitWeight_SI = dbo.uomDensity(tbdc.DryUnitWeight,'Mg/m³')
       , DryUnitWeight_IP = dbo.uomDensity(tbdc.DryUnitWeight,'pcf')
       , DryDensity_SI = dbo.uomDensity(tbdc.DryDensity,'Mg/m³')
       , DryDensity_IP = dbo.uomDensity(tbdc.DryDensity,'pcf')
       , MoistureContent = tbdc.MoistureContent
       , VisualDescription = d.GroupSymbol+' '+d.GroupName
       , MethodUsed = tbd.ProcedureMethod
       , SampleType = [dbo].[qest_Plate_GetSampleTypeDescription](tbd.SampleType)
  from DocumentCertificates c
    inner join qestPlateReportMapping m on c.QestUUID = m.ReportUUID
    inner join qestReverseLookup rl on m.TestUUID = rl.QestUUID
    inner join Samples s on s.QestUUID = rl.SampleArticleUUID 
    inner join DocumentBulkDensity tbd on tbd.QestUUID = m.TestUUID
    inner join DocumentBulkDensityCoated tbdc on tbd.QestID = tbdc.QestParentID and tbd.QestUniqueID = tbdc.QestUniqueParentID
    left join [dbo].[view_SampleDescription] d on s.QestUUID = d.SampleArticleUUID
  where c.QestUUID = @reportUUID
  UNION ALL  
  select QestID = tbd.QestID
       , tbd.QestUniqueID
       , tbd.QestUUID
       , tbd.QestSpecification
       , IsTestChecked = case when (tbd.QestCheckedDate is not null or tbd.QestCheckedDate is not null) then 1 else 0 end
       , Borehole = s.BoreholeCode
       , Sample = s.SampleArticleID
       , Depth = [dbo].[qest_GetDepth](s.Depth, s.Length, @sampleDepthMode, @IPUnits)
       , BulkUnitWeight_SI = dbo.uomDensity(tbdm.BulkUnitWeight,'Mg/m³')
       , BulkUnitWeight_IP = dbo.uomDensity(tbdm.BulkUnitWeight,'pcf')
       , BulkDensity_SI = dbo.uomDensity(tbdm.BulkDensity,'Mg/m³')
       , BulkDensity_IP = dbo.uomDensity(tbdm.BulkDensity,'pcf')
       , DryUnitWeight_SI = dbo.uomDensity(tbdm.DryUnitWeight,'Mg/m³')
       , DryUnitWeight_IP = dbo.uomDensity(tbdm.DryUnitWeight,'pcf')
       , DryDensity_SI = dbo.uomDensity(tbdm.DryDensity,'Mg/m³')
       , DryDensity_IP = dbo.uomDensity(tbdm.DryDensity,'pcf')
       , MoistureContent = tbdm.MoistureContent
       , VisualDescription = d.GroupSymbol+' '+d.GroupName
       , MethodUsed = tbd.ProcedureMethod
       , SampleType = [dbo].[qest_Plate_GetSampleTypeDescription](tbd.SampleType)
  from DocumentCertificates c
    inner join qestPlateReportMapping m on c.QestUUID = m.ReportUUID
    inner join qestReverseLookup rl on m.TestUUID = rl.QestUUID
    inner join Samples s on s.QestUUID = rl.SampleArticleUUID 
    inner join DocumentBulkDensity tbd on tbd.QestUUID = m.TestUUID
    inner join DocumentBulkDensityDirectMeasurement tbdm on tbd.QestID = tbdm.QestParentID and tbd.QestUniqueID = tbdm.QestUniqueParentID
    left join [dbo].[view_SampleDescription] d on s.QestUUID = d.SampleArticleUUID
  where c.QestUUID = @reportUUID
  order by Borehole, Depth, Sample, QestUUID
GO

----------------------------------------------------------------------------------------------------

-- 3.4 Particle Size Distribution

--user-defined type for our material size category table
if not exists (SELECT * FROM sys.table_types where name = 'qest_plate_PsdSizeCategoryTableType')
begin
create type dbo.qest_plate_PsdSizeCategoryTableType as table
(
  TestUUID uniqueidentifier
  , MaximumParticleSize real --nominal max size, in millimeters
  , Boulders real
  , Cobbles real
  , Gravel real
  , Sand real
  , Silt real
  , Clay real
)
end
GO


if not exists (select * from sys.objects where object_id = object_id(N'[dbo].[qest_plate_particlesizedistribution]') and type in (N'P', N'PC'))
  exec ('create proc [dbo].[qest_plate_particlesizedistribution] as select 0 tmp');
GO
GO
alter proc [dbo].[qest_plate_particlesizedistribution]
  @reportUUID uniqueidentifier
as
  set nocount on;
  
  declare @sampleDepthMode nvarchar(10), @IPUnits bit;
  exec [dbo].[qest_plate_GetReportProperties] @reportUUID = @reportUUID, @sampleDepthMode = @sampleDepthMode out, @IPUnits = @IPUnits out;
  
  ---------------------------------------------
  -- Generate Size-Percent data table.
  -- Union Joins Sieves, Hydrometer and Pipette
  ---------------------------------------------
  declare @psdData table (TestUUID uniqueidentifier, TestID int, Size real, Percentage real, Idx int, Passing real, RetainedIndividual real, RetainedCumulative real)
  insert into @psdData (TestUUID, TestID, Size, Percentage, Passing, RetainedIndividual, RetainedCumulative, Idx)
    select 
	     t.qestuuid, 
		 t.QestID,
         pd.Size, 
		 pd.Percentage, 
		 pd.Percentage, 
		 pd.RetainedIndividual, 
		 pd.RetainedCumulative,
		 ROW_NUMBER() over (partition by t.QestUUID order by pd.Size asc)
    from DocumentCertificates c
       inner join qestPlateReportMapping m on c.QestUUID = m.ReportUUID
	   inner join (
			select QestUUID,
			       QestID,
				   [IncPsdTest] = case QestID when 110950 then  
	                                   case BeginTestAs when 'Combined' then 1 when 'PSDOnly' then 1 else
									        case UseRelatedPSDTest when 1 then 1 else 0 end
									   end
					              else 1 end,
	               [IncSedTest] = case QestID when 110950 then  
	                                   case BeginTestAs when 'SedimentationOnly' then 
									        case UseRelatedPSDTest when 1 then 0 else 1 end
									   else 0 end
	               		    	  else 1 end
			from DocumentPSDTest
		          ) t on t.QestUUID = m.TestUUID
	   inner join qestReverseLookup rt on rt.QestParentUUID = t.QestUUID
	   inner join (
		   --psd part
		   select [QestUUID] = p.QestUUID, 
		          [Size] = dbo.uomLength(sv.Size, 'mm'), 
		   	      [Percentage] = sv.PercentagePassingCumulative, 
		   	      [RetainedIndividual] = sv.PercentageRetainedIndividual, 
		   	      [RetainedCumulative] = sv.PercentageRetainedCumulative,
				  [IsPSDTest] = 1,
				  [IsSEDTest] = 0
		   from DocumentParticleSizeDistribution p 
		   	    inner join qestReverseLookup rp1 on rp1.QestParentUUID = p.QestUUID
		   	    inner join DocumentParticleSizeDistributionSieveRange sr on sr.QestUUID = rp1.QestUUID
		   	    inner join qestReverseLookup rp2 on rp2.QestParentUUID = sr.QestUUID
		   	    inner join DocumentParticleSizeDistributionSieve sv on sv.QestUUID = rp2.QestUUID
		   where p.QestID = 111013 and sr.QestID = 111012 and sv.QestID = 111010
		   
		   union all 
		   
		   --hydrometer part	 
		   select [QestUUID] = h.QestUUID, 
			      [Size] = dbo.uomLength(hs.DiameterSoilParticles, 'mm'), 
				  [Percentage] = hs.PerCentSoilSuspension, 
				  [RetainedIndividual] = null, 
				  [RetainedCumulative] = 100 - hs.PerCentSoilSuspension,
				  [IsPSDTest] = null,
				  [IsSEDTest] = null
		   from DocumentPSDHydrometerTest h 
		        inner join qestReverseLookup rh1 on rh1.QestParentUUID = h.QestUUID
		        inner join DocumentPSDHydrometer hs on hs.QestUUID = rh1.QestUUID
		   where h.QestID = 111014 and hs.QestID = 111011
		   
		   union all 

		   --pipette part	 
		   select [QestUUID] = p.QestUUID, 
			      [Size] = dbo.uomLength(pr.EquivalentParticleDiameter, 'mm'), 
			 	  [Percentage] = pr.K,   -- apparently "K"
			 	  [RetainedIndividual] = null, 
			 	  [RetainedCumulative] = 100 - pr.K,
				  [IsPSDTest] = null,
				  [IsSEDTest] = null
		   from DocumentPSDPipetteTest p 
		        inner join qestReverseLookup rp1 on rp1.QestParentUUID = p.QestUUID
		        inner join DocumentPSDPipetteReading pr on pr.QestUUID = rp1.QestUUID
		   where p.QestID = 111015 and pr.QestID = 111016
		   
		   union all 
		   
		   --Sedimentary Sieves
		   select [QestUUID] = p.QestUUID, 
		          [Size] = dbo.uomLength(sv.Size, 'mm'), 
		   	      [Percentage] = sv.PercentagePassingCumulative, 
		   	      [RetainedIndividual] = sv.PercentageRetainedIndividual, 
		   	      [RetainedCumulative] = sv.PercentageRetainedCumulative,
				  [IsPSDTest] = 0,
				  [IsSEDTest] = 1
		   from DocumentParticleSizeDistribution p 
		   	    inner join qestReverseLookup rp1 on rp1.QestParentUUID = p.QestUUID
		   	    inner join DocumentParticleSizeDistributionSieveRange sr on sr.QestUUID = rp1.QestUUID
		   	    inner join qestReverseLookup rp2 on rp2.QestParentUUID = sr.QestUUID
		   	    inner join DocumentParticleSizeDistributionSieve sv on sv.QestUUID = rp2.QestUUID
		   where p.QestID = 111017
		        
		) pd on pd.QestUUID = rt.QestUUID
		   and (isnull(pd.IsPSDTest, 1) = t.IncPsdTest or isnull(pd.IsSEDTest, 1) = t.IncSedTest)
    where c.QestUUID = @reportUUID
	      and pd.Percentage is not null and pd.Size is not null and pd.Percentage >= 0 and pd.Size > 0
		  
  update psd
  set RetainedIndividual = coalesce(psd_larger.Passing, 100) - psd.Passing
  from @psdData psd
  left join @psdData psd_larger on psd_larger.TestUUID = psd.TestUUID and psd_larger.Idx = psd.Idx + 1
  where psd.RetainedIndividual is null
  ---------------------------------------------
   --Now it's time to use linear interpolation to figure out how much material falls into each of the material categories
   --first, our list of material categories (we might want to turn this into a configuration table at some point).
  ---------------------------------------------
   declare @categories table (Id int identity(1,1), Method nvarchar(10), Name nvarchar(20), MinSize real, MaxSize real)
   insert @categories (Method, Name, MinSize,MaxSize)
               select 'ASTM', 'Boulders'         , 300.000 , null
     union all select 'ASTM', 'Cobbles'          ,  75.000 , 300.000
     union all select 'ASTM', 'Gravel'           ,   4.750 ,  75.000
     union all select 'ASTM', 'Coarse Gravel'    ,  19.000 ,  75.000
     union all select 'ASTM', 'Fine Gravel'      ,   4.750 ,  19.000
     union all select 'ASTM', 'Sand'             ,   0.075 ,   4.750
     union all select 'ASTM', 'Coarse Sand'      ,   2.000 ,   4.750
     union all select 'ASTM', 'Medium Sand'      ,   0.425 ,   2.000
     union all select 'ASTM', 'Fine Sand'        ,   0.075 ,   0.425
     union all select 'ASTM', 'Silt'             ,   0.005 ,   0.075 
     union all select 'ASTM', 'Clay'             ,    null ,   0.005 
     union all select 'ISO' , 'Boulders'         , 200.000 , null
     union all select 'ISO' , 'Cobbles'          ,  63.000 , 200.000
     union all select 'ISO' , 'Gravel'           ,   2.000 ,  63.000
     union all select 'ISO' , 'Coarse Gravel'    ,  20.000 ,  63.000
     union all select 'ISO' , 'Medium Gravel'    ,   6.300 ,  20.000
     union all select 'ISO' , 'Fine Gravel'      ,   2.000 ,   6.300
     union all select 'ISO' , 'Sand'             ,   0.063 ,   2.000
     union all select 'ISO' , 'Coarse Sand'      ,   0.630 ,   2.000
     union all select 'ISO' , 'Medium Sand'      ,   0.200 ,   0.630
     union all select 'ISO' , 'Fine Sand'        ,   0.063 ,   0.200
     union all select 'ISO' , 'Silt'             ,   0.002 ,   0.063 
     union all select 'ISO' , 'Coarse Silt'      ,   0.020 ,   0.063
     union all select 'ISO' , 'Medium Silt'      ,   0.0063,   0.020
     union all select 'ISO' , 'Fine Silt'        ,   0.002 ,   0.0063
     union all select 'ISO' , 'Clay'             ,   null  ,   0.002 


    --and now the calculations - add up the amount of material that falls within each category.
    declare @catData table (TestUUID uniqueidentifier, CategoryId int, Percentage real)
    insert into @catData (TestUUID, CategoryId, Percentage)
    select t.TestUUID, cat.Id, 
    SUM(
       case 
         
         when psd_larger.Size <= coalesce(cat.MinSize, 0) then
           0
         when psd_larger.Size > coalesce(cat.MinSize, 0) and psd_larger.Size <= coalesce(cat.MaxSize, 9999999) then
           case 
             when cat.MinSize is null and psd.Idx = 1 then
			    psd.RetainedIndividual + psd.Passing
             when psd.Size < coalesce(cat.MinSize, 0) then
                psd.RetainedIndividual * ((log(psd_larger.Size) - log(cat.MinSize))/(log(psd_larger.Size) - log(psd.Size)))
             else
                psd.RetainedIndividual
           end
         else -- psd_larger.Size > coalesce(cat.MaxSize, 9999999)
         case 
           when psd.Size <= coalesce(cat.MaxSize, 9999999) and cat.MinSize is null and psd.Idx = 1 then
             psd.RetainedIndividual * ((log(cat.MaxSize) - log(psd.Size))/(log(psd_larger.Size) - log(psd.Size))) + psd.Passing
           when psd.Size <= coalesce(cat.MinSize, 0) then
             psd.RetainedIndividual * ((log(cat.MaxSize) - log(cat.MinSize))/(log(psd_larger.Size) - log(psd.Size)))
           when psd.Size >= coalesce(cat.MinSize, 0) and psd.Size <= coalesce(cat.MaxSize, 9999999) then
             psd.RetainedIndividual * ((log(cat.MaxSize) - log(psd.Size))/(log(psd_larger.Size) - log(psd.Size)))
           else -- psd.Size > coalesce(cat.MaxSize, 9999999)
             0
         end
       end
    )
   from @categories cat
    cross join (select distinct TestUUID from @psdData) t
    left join @psdData psd on psd.TestUUID = t.TestUUID
    left join @psdData psd_larger on psd_larger.TestUUID = psd.TestUUID and (psd_larger.Idx = psd.Idx + 1)
   group by t.TestUUID, cat.Id

   --if we don't know how much material is smaller than a certain size, list the percentage of that material type as NULL,
   --with an exception for the largest category, which has a NULL MinSize
   update cd
	set Percentage = null
	from @catData cd
	  inner join @categories c on cd.CategoryId = c.Id 
	  left join @psdData psd on cd.TestUUID = psd.TestUUID and (psd.Size <= coalesce(c.MinSize , c.MaxSize) or psd.Passing = 0)
    where psd.TestUUID is null

   update cd
	set Percentage = 0
	from @catData cd
	  inner join @categories c on cd.CategoryId = c.Id 
	  inner join @psdData psd on cd.TestUUID = psd.TestUUID and psd.Size <= c.MinSize 
    where psd.Passing = 100

   --if we don't know how much material is larger than a certain size, list the percentage of that material type as NULL,
   --with an exception for the largest category, which has a NULL MaxSize
   update cd
	set Percentage = null
	from @catData cd
	  inner join @categories c on cd.CategoryId = c.Id 
	  left join @psdData psd on cd.TestUUID = psd.TestUUID and (psd.Size >= coalesce(c.MaxSize, c.MinSize) or psd.Passing = 100)
    where psd.TestUUID is null

  --and summarise it all in a convenient little table.  I think we need a table type for this in order to use it in a query...
  declare @cat dbo.qest_plate_PsdSizeCategoryTableType;
  insert into @cat (TestUUID, Boulders, Cobbles, Gravel, Sand, Silt, Clay)
  select TestUUID = t.TestUUID
    , Boulders = max(case when c.Name = 'Boulders' then cd.percentage else null end)
    , Cobbles = max(case when c.Name = 'Cobbles' then cd.percentage else null end)
    , Gravel = max(case when c.Name = 'Gravel' then cd.percentage else null end)
    , Sand = max(case when c.Name = 'Sand' then cd.percentage else null end)
    , Silt = max(case when c.Name = 'Silt' then cd.percentage else null end)
    , Clay = max(case when c.Name = 'Clay' then cd.percentage else null end)
  from @psdData t
    inner join qestObjects m on t.TestID = m.QestID and m.Property = 'Method'
    left join @categories c on c.Method = case when m.Value like 'astm%' then 'astm' else 'iso' end
    left join @catData cd on t.TestUUID = cd.TestUUID and c.Id = cd.CategoryId
  group by t.TestUUID
  
  update cat 
    set MaximumParticleSize = psd.MaximumParticleSize
    from @cat cat 
    inner join (
      select TestUUID, MaximumParticleSize = Min(size)
      from @psdData
      where Passing = 100
      group by TestUUID
    ) psd on cat.TestUUID = psd.TestUUID 
  
   --------------
   -- OUTPUT TIME
   --------------

  --Table 1: individual PSD points for chart
  select 
      QestID = t.QestID
    , BoreholeCode = sa.BoreholeCode
    , Depth = sa.Depth
    , SampleID = sa.SampleArticleID
    , SampleUUID = sa.QestUUID
    , TestUUID = t.QestUUID
    , Diameter = psd.Size
    , Percentage = psd.Percentage 
    , PercentPassing = psd.Passing
    , PercentRetainedCumulative = psd.RetainedCumulative
    , PercentRetainedIndividual = psd.RetainedIndividual
  from qestPlateReportMapping m
    inner join qestReverseLookup rl on m.TestUUID = rl.QestUUID
    inner join Samples sa on sa.QestUUID = rl.SampleArticleUUID 
    inner join DocumentPSDTest t on t.QestUUID = m.TestUUID
    left join @psdData psd on t.QestUUID = psd.TestUUID 
    where m.ReportUUID = @reportUUID
  order by BoreholeCode, Depth, SampleArticleID, SampleUUID, TestUUID, Diameter -- case when @sieveOrderDescending = 1 then -Diameter else Diameter end asc 
  
  --Table 2: summary rows for table
  select t.QestID
       , t.QestUniqueID
       , IsTestChecked = case when t.QestCheckedDate is not null then 1 else 0 end
       , t.QestUUID
       , RowNumber = row_number() over (order by s.BoreholeCode, s.Depth, s.SampleArticleID, s.QestUUID, t.QestUUID)
       , Borehole = s.BoreholeCode
       , Sample = s.SampleArticleID
       , Depth = [dbo].[qest_GetDepth](s.Depth, s.Length, @sampleDepthMode, @IPUnits)
       --, CoefficientUniformity = case CoefficientUniformity when '' then null when 'N/A' then null else CoefficientUniformity end
       --, CoefficientCurvature  = case CoefficientCurvature  when '' then null when 'N/A' then null else CoefficientCurvature  end
       --, CoefficientFm         = case CoefficientFm         when '' then null when 'N/A' then null else CoefficientFm         end
       --, CoefficientCu         = case CoefficientUniformity when '' then null when 'N/A' then null else CoefficientUniformity end
       --, CoefficientCc         = case CoefficientCurvature  when '' then null when 'N/A' then null else CoefficientCurvature  end
       --, CoefficientDm         = case CoefficientDm         when '' then null when 'N/A' then null else CoefficientDm         end
       --, CoefficientCuS        = case CoefficientCuS        when '' then null when 'N/A' then null else CoefficientCuS        end
       --, CoefficientCcS        = case CoefficientCcS        when '' then null when 'N/A' then null else CoefficientCcS        end
       --, CoefficientD50S       = case CoefficientD50S       when '' then null when 'N/A' then null else CoefficientD50S       end
       --, CoefficientU          = case CoefficientU          when '' then null when 'N/A' then null else CoefficientU          end
       --, CoefficientD50G       = case CoefficientD50G       when '' then null when 'N/A' then null else CoefficientD50G       end
       --, MaximumParticleSize = cat.MaximumParticleSize
       --, SpecificGravity = t.SGSoil
       --, SandGravelDescription
       --, SandGravelShape = Shape
       --, SandGravelHardness = Hardness
       --, DispersionDevice
       --, DispersionPeriod
       --, DispersionRemarks = t.Remarks
       --, TestMethod
       , MethodPretreatment = hyd.MethodPretreatment
       --, SampleInformation
       --, CompositeSievingUsedAs
       --, t.GroupCode
       --, t.GroupName
       --, PriorTesting
       , BSClause = case when t.qestid in (110930,11518) then '9.2' 
                         when t.qestid in (110931,11519) then '9.5' 
                         when t.qestid in (110932,11520) then '9.2/9.5' 
                         when t.qestid in (110933,11521) then '9.3' 
                         when t.qestid in (110950) then '9.2/9.4' 
                         else null end
       , cat.Boulders
       , cat.Cobbles
       , cat.Gravel
       , cat.Sand
       , cat.Silt
       , cat.Clay
       , VisualDescription = d.GroupSymbol+' '+d.GroupName 
	   , TotalMass = dbo.uomMass(psd.TotalMass,'g')
	   , OvenDryWashedMass = dbo.uomMass(psd.OvenDryWashedMass,'g')
	   , psd.Sieve_Finer75
	   , psd.Finer75umPrecision
  from DocumentCertificates c
    inner join qestPlateReportMapping m on c.QestUUID = m.ReportUUID
    inner join qestReverseLookup rl on m.TestUUID = rl.QestUUID
    inner join Samples s on s.QestUUID = rl.SampleArticleUUID 
    inner join DocumentPSDTest t on t.QestUUID = m.TestUUID
	left join (
	           select [QestUUID] = p.QestUUID, [QestParentUUID] = rp.QestParentUUID, [TotalMass] = p.TotalMass, [OvenDryWashedMass] = p.OvenDryWashedMass, [Sieve_Finer75] = p.Sieve_Finer75, Finer75umPrecision = p.Finer75umPrecision
			   from DocumentParticleSizeDistribution p
					inner join qestReverseLookup rp on p.QestUUID = rp.QestUUID
			  ) psd on psd.QestParentUUID = t.QestUUID
	left join (
	           select [QestUUID] = h.QestUUID, [QestParentUUID] = rp.QestParentUUID, [MethodPretreatment] = h.MethodPretreatment
			   from DocumentPSDHydrometerTest h
					inner join qestReverseLookup rp on h.QestUUID = rp.QestUUID
			  ) hyd on hyd.QestParentUUID = t.QestUUID
	--left join (
	--           select [QestUUID] = p.QestUUID, [QestParentUUID] = rp.QestParentUUID
	--		   from DocumentPSDPipetteTest p
	--				inner join qestReverseLookup rp on p.QestUUID = rp.QestUUID
	--		  ) pip on pip.QestParentUUID = t.QestUUID
    left join @cat cat on t.QestUUID = cat.TestUUID
    left join [dbo].[view_SampleDescription] d on s.QestUUID = d.SampleArticleUUID
  where m.ReportUUID = @reportUUID
  order by s.BoreholeCode, s.Depth, s.SampleArticleID, s.QestUUID, t.QestUUID


GO

----------------------------------------------------------------------------------------------------

-- 3.5 Atterberg Limits

if not exists (select * from sys.objects where object_id = object_id(N'[dbo].[qest_plate_atterberglimits]') and type in (N'P', N'PC'))
  exec ('create proc [dbo].[qest_plate_atterberglimits] as select 0 tmp');
GO
alter proc [dbo].[qest_plate_atterberglimits]
  @reportUUID uniqueidentifier
as
  set nocount on;
  
  declare @sampleDepthMode nvarchar(10), @IPUnits bit;
  exec [dbo].[qest_plate_GetReportProperties] @reportUUID = @reportUUID, @sampleDepthMode = @sampleDepthMode out, @IPUnits = @IPUnits out;

  --Table 1 - Plasticity Index - Summary Chart and table
  select t.QestID
       , t.QestUniqueID
       , t.QestSpecification
       , ASTM_Plot = case t.QestID when 110047 then 1 when 110087 then 1 when 110946 then 1 when 110947 then 1 else 0 end
       , IsTestChecked = case when t.QestCheckedDate is not null then 1 else 0 end
       , RowNumber = row_number() over (order by s.BoreholeCode, s.Depth, s.SampleArticleID, s.QestUUID, t.QestUUID)
       , Borehole = s.BoreholeCode
       , Sample = s.SampleArticleID
       , Depth = [dbo].[qest_GetDepth](s.Depth, s.Length, @sampleDepthMode, @IPUnits)
       
       --this needs to be the amount passing the sieve, but I'm not familiar with the fields
       , Sieve_0_425 = t.Sieve_0_425
       
       --numeric values for chart - return NULL unless both of the values needed for the chart are available
       , LiquidLimit = case 
           when t.QestNotObtainable = 1 
             or t.LiquidLimitText in ('N/A', '') 
             or t.PlasticityIndexText in ('NP', 'N/P', 'Non-plastic', 'N/A', 'Not determinable', '')
           then null
           else t.LiquidLimit 
         end
       , PlasticityIndex = case 
           when t.QestNotObtainable = 1 
             or t.LiquidLimitText in ('N/A', '') 
             or t.PlasticityIndexText in ('NP', 'N/P', 'Non-plastic', 'N/A', 'Not determinable', '')
           then null
           else t.PlasticityIndex 
         end

       --reportable values for table
       , LiquidLimitText = case 
           when t.QestNotObtainable = 1 then 'I/S'
           when t.LiquidLimitText in ('N/A', '') then null
           else t.LiquidLimitText 
         end
       , PlasticLimitText = case 
           when t.QestNotObtainable = 1 then 'I/S'
           when t.PlasticLimitText in ('NP', 'N/P', 'Non-plastic') then 'N/P'
           when t.PlasticLimitText in ('N/A', '') then null
           else t.PlasticLimitText 
         end
       , PlasticityIndexText = case 
           when t.QestNotObtainable = 1 then 'I/S'
           when t.PlasticityIndexText in ('NP', 'N/P', 'Non-plastic') then 'N/P'
           when t.PlasticityIndexText in ('N/A', 'Not determinable', '') then null
           else t.PlasticityIndexText 
         end
       , Passing425 = 100 - t.Sieve_0_425
       , PreparationMethod 
       , RollingType
       , LLDeviceType
       , GroovingTool
  from DocumentCertificates c
    inner join qestPlateReportMapping m on c.QestUUID = m.ReportUUID
    inner join qestReverseLookup rl on m.TestUUID = rl.QestUUID
    inner join Samples s on s.QestUUID = rl.SampleArticleUUID 
    inner join
    (
      select QestUUID, QestID, QestUniqueID, QestSpecification, QestCheckedDate, QestNotObtainable
           , LiquidLimit, LiquidLimitText, PlasticLimit, PlasticLimitText, PlasticityIndex, PlasticityIndexText, Sieve_0_425
           , PreparationMethod, RollingType, LLDeviceType, GroovingTool
       from DocumentAtterbergLimits
      union all
      select QestUUID, QestID, QestUniqueID, QestSpecification, QestCheckedDate, QestNotObtainable
           , ConePenetration, ConePenetrationText, PlasticLimit, PlasticLimitText, PlasticityIndex, PlasticityIndexText, FractionSize
           , PreparationMethod = null, RollingType = null, LLDeviceType = null, GroovingTool = null
       from DocumentAtterbergLimitsCP cp
    ) t on m.TestUUID = t.QestUUID
  where c.QestUUID = @reportUUID
  order by s.BoreholeCode, s.Depth, s.SampleArticleID, s.QestUUID, t.QestUUID 

  --Table 2 - LL charts - Moisture content vs Blows or Penetration (depends on QestID)
  select r.QestID
       , r.QestSpecification
       , TestQestUniqueID = r.TestUniqueID
       , RecordUniqueID = r.RecordUniqueID
       , Borehole = s.BoreholeCode
       , Sample = s.SampleArticleID
       , Depth = [dbo].[qest_GetDepth](s.Depth, s.Length, @sampleDepthMode, @IPUnits)
       , MoistureContent = r.MoistureContent
       , Blows = r.Blows
       , Penetration = dbo.uomLength(r.Penetration,'mm')
  from DocumentCertificates c
    inner join qestPlateReportMapping m on c.QestUUID = m.ReportUUID
    inner join qestReverseLookup rl on m.TestUUID = rl.QestUUID
    inner join Samples s on s.QestUUID = rl.SampleArticleUUID 
    inner join 
    (
      select TestUUID = t.QestUUID, QestSpecification = t.QestSpecification, QestID = t.QestID, TestUniqueID = t.QestUniqueID, RecordUniqueID = r.QestUniqueID
           , MoistureContent = r.MoistureContent, Blows = r.Blows, Penetration = null
        from DocumentAtterbergLimits t 
        left join DocumentAtterbergLimitsSpecimen r on t.QestID = r.QestParentID and t.QestUniqueID = r.QestUniqueParentID and r.LiquidLimitSpecimen = 1
      union all
      select TestUUID = t.QestUUID, QestSpecification = t.QestSpecification, QestID = t.QestID, TestUniqueID = t.QestUniqueID, RecordUniqueID = r.QestUniqueID
           , MoistureContent = r.MoistureContent, Blows = null, Penetration = r.AvrPenetration
        from DocumentAtterbergLimitsCP t
        left join DocumentAtterbergLimitsCPSpecimens r on t.QestID = r.QestParentID and t.QestUniqueID = r.QestUniqueParentID
    ) r on r.TestUUID = m.TestUUID
  where c.QestUUID = @reportUUID
  order by s.BoreholeCode, s.Depth, s.SampleArticleID, s.QestUUID, r.TestUUID, r.MoistureContent, r.RecordUniqueID
  
  --Table 3 - Plate Method
  -- Declare grouping table
  DECLARE @TableForMethods table (QestID int, NonPlastic bit);  
  INSERT INTO @TableForMethods (QestID, NonPlastic)
  select t.QestID, IsNull(t.NonPlastic,1)
  from DocumentCertificates c
    inner join qestPlateReportMapping m on c.QestUUID = m.ReportUUID
    inner join qestReverseLookup rl on m.TestUUID = rl.QestUUID
    inner join Samples s on s.QestUUID = rl.SampleArticleUUID 
    inner join
    (
      select QestUUID, QestID, NonPlastic
       from DocumentAtterbergLimits ll
      union all
      select QestUUID, QestID, NonPlastic
       from DocumentAtterbergLimitsCP cp
    ) t on m.TestUUID = t.QestUUID
  where c.QestUUID = @reportUUID
  group by t.QestID, t.NonPlastic

  select QestID 
	   , PlateMethod = case t.QestID when 110942 then case IsNull(t.NonPlastic,0) when 1 then 'BS 1377-2: 1990 cl 4.6' else 'BS 1377-2: 1990 cl 4.6, 5.3, 5.4' end
	                                 when 110943 then case IsNull(t.NonPlastic,0) when 1 then 'BS 1377-2: 1990 cl 4.5' else 'BS 1377-2: 1990 cl 4.5, 5.3, 5.4' end
									 when 110944 then case IsNull(t.NonPlastic,0) when 1 then 'BS 1377-2: 1990 cl 4.3' else 'BS 1377-2: 1990 cl 4.3, 5.3, 5.4' end
									 when 110945 then case IsNull(t.NonPlastic,0) when 1 then 'BS 1377-2: 1990 cl 4.4' else 'BS 1377-2: 1990 cl 4.4, 5.3, 5.4' end
									 when 110946 then 'ASTM D 4318'
									 when 110947 then 'ASTM D 4318'
									 when 110047 then 'ASTM D 4318'
									 when 110087 then 'ASTM D 4318'
									 when 11509  then case IsNull(t.NonPlastic,0) when 1 then 'BS 1377-2: 1990 cl 4.6' else 'BS 1377-2: 1990 cl 4.6, 5.3, 5.4' end
	                                 when 11510  then case IsNull(t.NonPlastic,0) when 1 then 'BS 1377-2: 1990 cl 4.5' else 'BS 1377-2: 1990 cl 4.5, 5.3, 5.4' end
									 when 11511  then case IsNull(t.NonPlastic,0) when 1 then 'BS 1377-2: 1990 cl 4.3' else 'BS 1377-2: 1990 cl 4.3, 5.3, 5.4' end
									 when 11512  then case IsNull(t.NonPlastic,0) when 1 then 'BS 1377-2: 1990 cl 4.4' else 'BS 1377-2: 1990 cl 4.4, 5.3, 5.4' end
									 else '' end
  from @TableForMethods t
  where t.NonPlastic = 0 
        or (t.NonPlastic = 1 and not exists(select 1 from @TableForMethods sub where sub.NonPlastic = 0 and sub.QestID = t.QestID))

GO

----------------------------------------------------------------------------------------------------

-- 3.6 Particle Density

if not exists (select * from sys.objects where object_id = object_id(N'[dbo].[qest_plate_particledensity]') and type in (N'P', N'PC'))
  exec ('create proc [dbo].[qest_plate_particledensity] as select 0 tmp');
GO
alter proc [dbo].[qest_plate_particledensity]
  @reportUUID uniqueidentifier
as
  set nocount on;
  
  declare @sampleDepthMode nvarchar(10), @IPUnits bit;
  exec [dbo].[qest_plate_GetReportProperties] @reportUUID = @reportUUID, @sampleDepthMode = @sampleDepthMode out, @IPUnits = @IPUnits out;

   --Table 1 - Summary data - one row per test
  select t.QestID
       , t.QestUniqueID
       , t.QestUUID
       , IsTestChecked = case when t.QestCheckedDate is not null then 1 else 0 end
       , RowNumber = row_number() over (order by s.BoreholeCode, s.Depth, s.SampleArticleID, s.QestUUID, t.QestUUID)
       , Borehole = s.BoreholeCode
       , Sample = s.SampleArticleID
       , Depth = [dbo].[qest_GetDepth](s.Depth, s.Length, @sampleDepthMode, @IPUnits)
       , MethodBSClause = case t.QestID when 110909 then 'Clause 8.3' when 110913 then 'Clause 8.4' else null end
       , AvgParticleDensity_SI = dbo.uomDensity(t.AvgParticleDensityDry,'Mg/m³')
       , AvgParticleDensity_IP = dbo.uomDensity(t.AvgParticleDensityDry,'pcf')
  from DocumentCertificates c
    inner join qestPlateReportMapping m on c.QestUUID = m.ReportUUID
    inner join qestReverseLookup rl on m.TestUUID = rl.QestUUID
    inner join Samples s on s.QestUUID = rl.SampleArticleUUID 
    inner join DocumentParticleDensity t on rl.QestUUID = t.QestUUID 
  where c.QestUUID = @reportUUID
  order by s.BoreholeCode, s.Depth, s.SampleArticleID, s.QestUUID, t.QestUUID

GO

----------------------------------------------------------------------------------------------------

-- 3.61 Specific Gravity

if not exists (select * from sys.objects where object_id = object_id(N'[dbo].[qest_plate_specificgravity]') and type in (N'P', N'PC'))
  exec ('create proc [dbo].[qest_plate_specificgravity] as select 0 tmp');
GO
alter proc [dbo].[qest_plate_specificgravity]
  @reportUUID uniqueidentifier
as
  set nocount on;
  
  declare @sampleDepthMode nvarchar(10), @IPUnits bit;
  exec [dbo].[qest_plate_GetReportProperties] @reportUUID = @reportUUID, @sampleDepthMode = @sampleDepthMode out, @IPUnits = @IPUnits out;

   --Table 1 - Summary data - one row per test
  select t.QestID
       , t.QestUniqueID
       , t.QestUUID
       , IsTestChecked = case when t.QestCheckedDate is not null then 1 else 0 end
       , RowNumber = row_number() over (order by s.BoreholeCode, s.Depth, s.SampleArticleID, s.QestUUID, t.QestUUID)
       , Borehole = s.BoreholeCode
       , Sample = s.SampleArticleID
       , Depth = [dbo].[qest_GetDepth](s.Depth, s.Length, @sampleDepthMode, @IPUnits)
       , VisualDescription = d.GroupSymbol+' '+d.GroupName 
       , PreparationMethod = t.ProcedureMethod
       , PassNo4 = t.PercentPassing_4_75
       , SoilSpecificGravity = t.SpecificGravity20
       , AverageSpecificGravity = t.AvgSpecificGravity
  from DocumentCertificates c
    inner join qestPlateReportMapping m on c.QestUUID = m.ReportUUID
    inner join qestReverseLookup rl on m.TestUUID = rl.QestUUID
    inner join Samples s on s.QestUUID = rl.SampleArticleUUID 
    inner join DocumentParticleDensity t on rl.QestUUID = t.QestUUID 
    left join [dbo].[view_SampleDescription] d on s.QestUUID = d.SampleArticleUUID
  where c.QestUUID = @reportUUID
  order by s.BoreholeCode, s.Depth, s.SampleArticleID, s.QestUUID, t.QestUUID

GO

----------------------------------------------------------------------------------------------------

-- 3.7 Min-Max Density

if not exists (select * from sys.objects where object_id = object_id(N'[dbo].[qest_plate_minmaxdensity]') and type in (N'P', N'PC'))
  exec ('create proc [dbo].[qest_plate_minmaxdensity] as select 0 tmp');
GO
alter proc [dbo].[qest_plate_minmaxdensity]
  @reportUUID uniqueidentifier
as
  set nocount on;
  
  declare @sampleDepthMode nvarchar(10), @IPUnits bit;
  exec [dbo].[qest_plate_GetReportProperties] @reportUUID = @reportUUID, @sampleDepthMode = @sampleDepthMode out, @IPUnits = @IPUnits out;
  
   --Table 1 - Summary data - one row per test
  select t.QestID
       , t.QestUniqueID
       , t.QestUUID
       , IsTestChecked = case when t.QestCheckedDate is not null then 1 else 0 end
       , RowNumber = row_number() over (order by s.BoreholeCode, s.Depth, s.SampleArticleID, s.QestUUID, t.QestUUID)
       , Borehole = s.BoreholeCode
       , Sample = s.SampleArticleID
       , Depth = [dbo].[qest_GetDepth](s.Depth, s.Length, @sampleDepthMode, @IPUnits)
       , MouldSize_SI = dbo.uomVolume(tmax.MouldVolume,'cm³')
       , MouldSize_IP = dbo.uomVolume(tmax.MouldVolume,'ft³')
       , MethodUsed = isnull(tmin.Method,'')+' / '+isnull(tmax.Method,'')
       , MinimumDensity_SI = dbo.uomDensity(tmin.MinDensity,'Mg/m³')
       , MinimumDensity_IP = dbo.uomDensity(tmin.MinDensity,'pcf')
       , MaximumDensity_SI = dbo.uomDensity(coalesce(tmax.MaxDensity, mdd.MaximumDryDensity),'Mg/m³')
       , MaximumDensity_IP = dbo.uomDensity(coalesce(tmax.MaxDensity, mdd.MaximumDryDensity),'pcf')
       , OptimumWaterContent = mdd.OptimumMoistureContent
       , PreparationProcedure = mdd.PreparationMethod
       , AssumedParticleDensityText = case mdd.AssumedAPD when 1 then 'Assumed' else 'Measured' end
       , RetainedMassPercent = mdd.PercentRetained_37_5
       , ParticleDensity_SI = dbo.uomDensity(mdd.ParticleDensity,'Mg/m³')
       , ParticleDensity_IP = dbo.uomDensity(mdd.ParticleDensity,'pcf')
       , VisualDescription = d.GroupSymbol+' '+d.GroupName
  from DocumentCertificates c
    inner join qestPlateReportMapping m on c.QestUUID = m.ReportUUID
    inner join qestReverseLookup rl on m.TestUUID = rl.QestUUID
    inner join Samples s on s.QestUUID = rl.SampleArticleUUID 
    inner join DocumentMinAndMaxDryDensity t on rl.QestUUID = t.QestUUID 
    left join [dbo].[view_SampleDescription] d on s.QestUUID = d.SampleArticleUUID
	left join DocumentMinIndexDensity tmin on tmin.QestParentID = t.QestID and tmin.QestUniqueParentID = t.QestUniqueID and ((t.QestID = 110904 and tmin.QestID = 110923) or (t.QestID in (110905, 110913) and tmin.QestID = 110925) or (t.QestID = 110919 and tmin.QestID = 110927))
	left join DocumentMaxIndexDensity tmax on tmax.QestParentID = t.QestID and tmax.QestUniqueParentID = t.QestUniqueID and ((t.QestID = 110904 and tmax.QestID = 110924))
	left join DocumentMaximumDryDensity mdd on mdd.QestParentID = t.QestID and mdd.QestUniqueParentID = t.QestUniqueID and ((t.QestID in (110905, 110913) and mdd.QestID = 110926) or (t.QestID = 110919 and mdd.QestID = 110928))
  where c.QestUUID = @reportUUID
  order by s.BoreholeCode, s.Depth, s.SampleArticleID, s.QestUUID, t.QestUUID

   --Table 2 - Points/Plot data - 1-6 rows per test
  select t.QestID
       , t.QestUniqueID
       , t.QestUUID
       , IsTestChecked = case when t.QestCheckedDate is not null then 1 else 0 end
       , RowNumber = row_number() over (order by s.BoreholeCode, s.Depth, s.SampleArticleID, s.QestUUID, t.QestUUID)
       , Borehole = s.BoreholeCode
       , Sample = s.SampleArticleID
       , Depth = [dbo].[qest_GetDepth](s.Depth, s.Length, @sampleDepthMode, @IPUnits)
       , DryDensity_SI = dbo.uomDensity(ts.DryDensity,'Mg/m³')
       , DryDensity_IP = dbo.uomDensity(ts.DryDensity,'pcf') 
       , ts.MoistureContent
  from DocumentCertificates c
    inner join qestPlateReportMapping m on c.QestUUID = m.ReportUUID
    inner join qestReverseLookup rl on m.TestUUID = rl.QestUUID
    inner join Samples s on s.QestUUID = rl.SampleArticleUUID 
    inner join DocumentMinAndMaxDryDensity t on rl.QestUUID = t.QestUUID
	left join DocumentMaximumDryDensity tmax on tmax.QestParentID = t.QestID and tmax.QestUniqueParentID = t.QestUniqueID and ((t.QestID = 110908 and tmax.QestID = 110924) or (t.QestID in (110905, 110913) and tmax.QestID = 110926) or (t.QestID = 110919 and tmax.QestID = 110928))
  	left join DocumentMaximumDryDensitySpecimen ts on ts.QestParentID = tmax.QestID and ts.QestUniqueParentID = tmax.QestUniqueID 
  where c.QestUUID = @reportUUID
  order by s.BoreholeCode, s.Depth, s.SampleArticleID, s.QestUUID, t.QestUUID, ts.MoistureContent
GO
----------------------------------------------------------------------------------------------------

-- 3.8 Torvane

if not exists (select * from sys.objects where object_id = object_id(N'[dbo].[qest_plate_torvane]') and type in (N'P', N'PC'))
  exec ('create proc [dbo].[qest_plate_torvane] as select 0 tmp');
GO
alter proc [dbo].[qest_plate_torvane]
  @reportUUID uniqueidentifier
as
  set nocount on;
  
  declare @sampleDepthMode nvarchar(10), @IPUnits bit;
  exec [dbo].[qest_plate_GetReportProperties] @reportUUID = @reportUUID, @sampleDepthMode = @sampleDepthMode out, @IPUnits = @IPUnits out;

   --Table 1 - Summary data - one row per test
  select t.QestID
       , t.QestUniqueID
       , t.QestUUID
       , IsTestChecked = case when t.QestCheckedDate is not null then 1 else 0 end
       , RowNumber = row_number() over (order by s.BoreholeCode, s.Depth, s.SampleArticleID, s.QestUUID, t.QestUUID)
       , Borehole = s.BoreholeCode
       , Sample = s.SampleArticleID
       , Depth = [dbo].[qest_GetDepth](s.Depth, s.Length, @sampleDepthMode, @IPUnits)
       , t.AdaptorSizeCode 
       , UndrainedShearStrengthEstimate_SI = dbo.uomPressure(t.UndrainedShearStrengthEstimate,'kPa')
       , UndrainedShearStrengthEstimate_IP = dbo.uomPressure(t.UndrainedShearStrengthEstimate,'ksf')
       , GreaterThanReading 
       , SampleType = [dbo].[qest_Plate_GetSampleTypeDescription](t.SampleType)
  from DocumentCertificates c
    inner join qestPlateReportMapping m on c.QestUUID = m.ReportUUID
    inner join qestReverseLookup rl on m.TestUUID = rl.QestUUID
    inner join Samples s on s.QestUUID = rl.SampleArticleUUID 
    inner join DocumentTorvane t on rl.QestUUID = t.QestUUID 
  where c.QestUUID = @reportUUID
  order by s.BoreholeCode, s.Depth, s.SampleArticleID, s.QestUUID, t.QestUUID

GO

----------------------------------------------------------------------------------------------------

-- 3.9 Pocket Penetrometer

if not exists (select * from sys.objects where object_id = object_id(N'[dbo].[qest_plate_pocketpenetrometer]') and type in (N'P', N'PC'))
  exec ('create proc [dbo].[qest_plate_pocketpenetrometer] as select 0 tmp');
GO
alter proc [dbo].[qest_plate_pocketpenetrometer]
  @reportUUID uniqueidentifier
as
  set nocount on;
  
  declare @sampleDepthMode nvarchar(10), @IPUnits bit;
  exec [dbo].[qest_plate_GetReportProperties] @reportUUID = @reportUUID, @sampleDepthMode = @sampleDepthMode out, @IPUnits = @IPUnits out;

   --Table 1 - Summary data - one row per test
  select p.QestID
       , p.QestUniqueID
       , p.QestUUID
       , IsTestChecked = case when p.QestCheckedDate is not null then 1 else 0 end
       , RowNumber = row_number() over (order by s.BoreholeCode, s.Depth, s.SampleArticleID, s.QestUUID, p.QestUUID)
       , Borehole = s.BoreholeCode
       , Sample = s.SampleArticleID
       , Depth = [dbo].[qest_GetDepth](s.Depth, s.Length, @sampleDepthMode, @IPUnits)
       , p.AdaptorSizeCode 
       , UndrainedShearStrengthEstimate_SI = dbo.uomPressure(p.UndrainedShearStrengthEstimate,'kPa')
       , UndrainedShearStrengthEstimate_IP = dbo.uomPressure(p.UndrainedShearStrengthEstimate,'ksf')
       , GreaterThanReading
       , SampleType = [dbo].[qest_Plate_GetSampleTypeDescription](p.SampleType)
  from DocumentCertificates c
    inner join qestPlateReportMapping m on c.QestUUID = m.ReportUUID
    inner join qestReverseLookup rl on m.TestUUID = rl.QestUUID
    inner join Samples s on s.QestUUID = rl.SampleArticleUUID 
    inner join DocumentPocketPenetrometer p on rl.QestUUID = p.QestUUID 
  where c.QestUUID = @reportUUID
  order by s.BoreholeCode, s.Depth, s.SampleArticleID, s.QestUUID, p.QestUUID

GO 

----------------------------------------------------------------------------------------------------

-- 3.10 Laboratory Vane

if not exists (select * from sys.objects where object_id = object_id(N'[dbo].[qest_plate_laboratoryvane]') and type in (N'P', N'PC'))
  exec ('create proc [dbo].[qest_plate_laboratoryvane] as select 0 tmp');
GO
alter proc [dbo].[qest_plate_laboratoryvane]
  @reportUUID uniqueidentifier
as
  set nocount on;

  declare @sampleDepthMode nvarchar(10), @IPUnits bit;
  exec [dbo].[qest_plate_GetReportProperties] @reportUUID = @reportUUID, @sampleDepthMode = @sampleDepthMode out, @IPUnits = @IPUnits out;
  
  select t.QestID
       , t.QestUniqueID
       , t.QestUUID
       , t.QestSpecification
       , IsTestChecked = case when t.QestCheckedDate is not null then 1 else 0 end
       , Borehole = s.BoreholeCode
       , Sample = s.SampleArticleID
       , Specimen = null
       , Depth = [dbo].[qest_GetDepth](s.Depth, s.Length, @sampleDepthMode, @IPUnits)
       , SampleType = [dbo].[qest_Plate_GetSampleTypeDescription](t.SampleType)
       , t.QestTestedBy
       , t.QestTestedDate
       , VaneType = sr.VaneBladeCode
       , VaneHeight_SI =  dbo.uomLength(sr.VaneBladeHeight,'mm')
       , VaneHeight_IP = dbo.uomLength(sr.VaneBladeHeight,'in')
       , VaneDiameter_SI = dbo.uomLength(sr.VaneBladeDiameter,'mm')
       , VaneDiameter_IP = dbo.uomLength(sr.VaneBladeDiameter,'in')
       , SpringCode = sr.SpringCode	   
       , SpringConstant_SI = dbo.uomtorque(sr.SpringConstant,'Nm/°')
       , SpringConstant_IP = dbo.uomtorque(sr.SpringConstant,'lbf·ft/°')
	   , FailureTorqueReading_IP = dbo.uomtorque(sr.Torque,'lbf·ft')
       , FailureTorqueReading_SI = dbo.uomtorque(sr.Torque,'N·m')
       , RotationRate = dbo.uomrevrate(sr.RotationRate,'°/min')
       , ShearRate_IP = dbo.uomSpeed(sr.ShearRate,'in/min')
       , ShearRate_SI = dbo.uomSpeed(sr.ShearRate,'mm/min')
       , FailureTime = dbo.uomTime(sr.TimeToFailure,'sec')
       , ShearStrengthEstimate_IP = dbo.uomPressure(sr.ShearStrength,'ksf')
       , ShearStrengthEstimate_SI = dbo.uomPressure(sr.ShearStrength,'kPa')
	   , RotationAboveMax =sr.RotationAboveMax
       , RemouldRevolutions = rr.RemouldRevolutions
       , ResidualFailureTime = dbo.uomTime(rr.TimeToFailure,'sec')
       , ResidualFailureTorqueReading_IP = dbo.uomtorque(rr.Torque,'lbf·ft')
       , ResidualFailureTorqueReading_SI = dbo.uomtorque(rr.Torque,'N·m')
       , ResidualRotationRate = dbo.uomrevrate(rr.RotationRate,'°/min')
       , ResidualShearRate_IP = dbo.uomSpeed(rr.ShearRate,'in/min')
       , ResidualShearRate_SI = dbo.uomSpeed(rr.ShearRate,'mm/min')
       , ResidualShearStrengthEstimate_IP = dbo.uomPressure(rr.ShearStrength,'ksf')
       , ResidualShearStrengthEstimate_SI = dbo.uomPressure(rr.ShearStrength,'kPa')
	   , ResidualRotationAboveMax = t.ResidualRotationAboveMax 
       , VisualDescription = d.GroupSymbol+' '+d.GroupName
       , WaterContent = w.MoistureContent
       , HasResidual = case when rr.QestUUID IS NULL then 0 else 1 end
        from DocumentCertificates c
		inner join qestPlateReportMapping m on c.QestUUID = m.ReportUUID
		inner join qestReverseLookup rl on m.TestUUID = rl.QestUUID
		inner join Samples s on s.QestUUID = rl.SampleArticleUUID 
		inner join DocumentShearStrengthLabVane t on rl.QestUUID = t.QestUUID 
		inner join DocumentShearStrengthLabVaneReadingGroup g on t.QestUniqueID = g.QestUniqueParentID and t.QestID = g.QestParentID and g.QestID = 111108
		inner join DocumentShearStrengthLabVaneReading sr on g.QestUniqueID = sr.QestUniqueParentID and g.QestID = sr.QestParentID and sr.QestID = 111105
		left join [dbo].[view_SampleDescription] d on s.QestUUID = d.SampleArticleUUID
		left join DocumentMoistureContent w on t.QestUniqueID = w.QestUniqueParentID and t.QestID = w.QestParentID and w.QestID = 111106
		left join DocumentShearStrengthLabVaneReading rr on g.QestUniqueID = rr.QestUniqueParentID and g.QestID = rr.QestParentID and rr.QestID = 111107
  where c.QestUUID = @reportUUID
  order by s.BoreholeCode, s.Depth, s.SampleArticleID, s.QestUUID, t.QestUUID 

GO
----------------------------------------------------------------------------------------------------

-- 3.11 Organic Content

if not exists (select * from sys.objects where object_id = object_id(N'[dbo].[qest_plate_organiccontent]') and type in (N'P', N'PC'))
  exec ('create proc [dbo].[qest_plate_organiccontent] as select 0 tmp');
GO
alter proc [dbo].[qest_plate_organiccontent]
  @reportUUID uniqueidentifier
as
  set nocount on;
  
  declare @sampleDepthMode nvarchar(10), @IPUnits bit;
  exec [dbo].[qest_plate_GetReportProperties] @reportUUID = @reportUUID, @sampleDepthMode = @sampleDepthMode out, @IPUnits = @IPUnits out;

   --Table 1 - Summary data - one row per test
  select o.QestID
       , o.QestUniqueID
       , o.QestUUID
       , IsTestChecked = case when o.QestCheckedDate is not null then 1 else 0 end
       , RowNumber = row_number() over (order by s.BoreholeCode, s.Depth, s.SampleArticleID, s.QestUUID, o.QestUUID)
       , Borehole = s.BoreholeCode
       , Sample = s.SampleArticleID
       , Depth = [dbo].[qest_GetDepth](s.Depth, s.Length, @sampleDepthMode, @IPUnits)
       , o.OrganicMatter 
       , o.AshContent
       , TestTemperature=dbo.uomTemperature(o.TestTemperature,'C')
       , MoistureContent = o.MoistureContent
       , MoistureContentFormat = case when o.QestID = 110906 and o.OvenDriedMoistureBasis = 1 then 'R:t100:0;t500:5r;t1000:10r;:20r' else '0.0' end --[dbo].[qest_Plate_GetOrganicMoistureRounding_ASTMD2974](o.MoistureContent ,o.OvenDriedMoistureBasis)
       , MoistureBasis = case when isnull(o.OvenDriedMoistureBasis,0) = 1 then 'Oven-Dried' else 'As-Received' end
  from DocumentCertificates c
    inner join qestPlateReportMapping m on c.QestUUID = m.ReportUUID
    inner join qestReverseLookup rl on m.TestUUID = rl.QestUUID
    inner join Samples s on s.QestUUID = rl.SampleArticleUUID 
    inner join DocumentOrganicsInSoil o on rl.QestUUID = o.QestUUID 
  where c.QestUUID = @reportUUID
  order by s.BoreholeCode, s.Depth, s.SampleArticleID, s.QestUUID, o.QestUUID

GO 

----------------------------------------------------------------------------------------------------

-- 3.12 Carbonate Content

if not exists (select * from sys.objects where object_id = object_id(N'[dbo].[qest_plate_carbonatecontent]') and type in (N'P', N'PC'))
  exec ('create proc [dbo].[qest_plate_carbonatecontent] as select 0 tmp');
GO
alter proc [dbo].[qest_plate_carbonatecontent]
  @reportUUID uniqueidentifier
as
  set nocount on;
  
  declare @sampleDepthMode nvarchar(10), @IPUnits bit;
  exec [dbo].[qest_plate_GetReportProperties] @reportUUID = @reportUUID, @sampleDepthMode = @sampleDepthMode out, @IPUnits = @IPUnits out;

   --Table 1 - Summary data - one row per test
  select t.QestID
       , t.QestUniqueID
       , t.QestUUID
       , IsTestChecked = case when t.QestCheckedDate is not null then 1 else 0 end
       , RowNumber = row_number() over (order by s.BoreholeCode, s.Depth, s.SampleArticleID, s.QestUUID, t.QestUUID)
       , Borehole = s.BoreholeCode
       , Sample = s.SampleArticleID
       , Depth = [dbo].[qest_GetDepth](s.Depth, s.Length, @sampleDepthMode, @IPUnits)
       , t.CalciumCarbonateContent -- Converting
  from DocumentCertificates c
    inner join qestPlateReportMapping m on c.QestUUID = m.ReportUUID
    inner join qestReverseLookup rl on m.TestUUID = rl.QestUUID
    inner join Samples s on s.QestUUID = rl.SampleArticleUUID 
    inner join DocumentCalciumCarbonateContent t on rl.QestUUID = t.QestUUID 
  where c.QestUUID = @reportUUID
  order by s.BoreholeCode, s.Depth, s.SampleArticleID, s.QestUUID, t.QestUUID

GO 

----------------------------------------------------------------------------------------------------

-- Fallcone

if not exists (select * from sys.objects where object_id = object_id(N'[dbo].[qest_plate_fallcone]') and type in (N'P', N'PC'))
  exec ('create proc [dbo].[qest_plate_fallcone] as select 0 tmp');
GO
alter proc [dbo].[qest_plate_fallcone]
  @reportUUID uniqueidentifier
as
  set nocount on;
  
  declare @sampleDepthMode nvarchar(10), @IPUnits bit;
  exec [dbo].[qest_plate_GetReportProperties] @reportUUID = @reportUUID, @sampleDepthMode = @sampleDepthMode out, @IPUnits = @IPUnits out;

   --Table 1 - Summary data - one row per test
  select f.QestID
       , f.QestUniqueID
       , f.QestUUID
       , IsTestChecked = case when f.QestCheckedDate is not null then 1 else 0 end
       , RowNumber = row_number() over (order by s.BoreholeCode, s.Depth, s.SampleArticleID, s.QestUUID, f.QestUUID)
       , Borehole = s.BoreholeCode
       , Sample = s.SampleArticleID
       , Depth = [dbo].[qest_GetDepth](s.Depth, s.Length, @sampleDepthMode, @IPUnits)
       , RemouldedShearStrengthEstimate_SI = dbo.uomPressure(f.UndrainedShearStrengthEstimateRemoulded,'kPa')
       , RemouldedShearStrengthEstimate_IP = dbo.uomPressure(f.UndrainedShearStrengthEstimateRemoulded,'ksf')
       , UndisturbedShearStrengthEstimate_SI = dbo.uomPressure(f.UndrainedShearStrengthEstimateUndisturbed,'kPa')
       , UndisturbedShearStrengthEstimate_IP = dbo.uomPressure(f.UndrainedShearStrengthEstimateUndisturbed,'ksf')
       , f.SpecimenSensitivity
  from DocumentCertificates c
    inner join qestPlateReportMapping m on c.QestUUID = m.ReportUUID
    inner join qestReverseLookup rl on m.TestUUID = rl.QestUUID
    inner join Samples s on s.QestUUID = rl.SampleArticleUUID 
    inner join DocumentFallcone f on rl.QestUUID = f.QestUUID 
  where c.QestUUID = @reportUUID
  order by s.BoreholeCode, s.Depth, s.SampleArticleID, s.QestUUID, f.QestUUID

GO 

----------------------------------------------------------------------------------------------------

-- 3.13 UU Triaxial

if not exists (select * from sys.objects where object_id = object_id(N'[dbo].[qest_plate_triaxial_uu]') and type in (N'P', N'PC'))
  exec ('create proc [dbo].[qest_plate_triaxial_uu] as select 0 tmp');
GO
alter proc [dbo].[qest_plate_triaxial_uu]
  @reportUUID uniqueidentifier
as
  set nocount on;
  
  declare @sampleDepthMode nvarchar(10), @IPUnits bit;
  exec [dbo].[qest_plate_GetReportProperties] @reportUUID = @reportUUID, @sampleDepthMode = @sampleDepthMode out, @IPUnits = @IPUnits out;  
  
   --Table 1 - Summary data - one row per test
  select t.QestID
       , t.QestUniqueID
       , t.QestUUID
       , IsTestChecked = case when t.QestCheckedDate is not null then 1 else 0 end
       , RowNumber = row_number() over (order by s.BoreholeCode, s.Depth, s.SampleArticleID, s.QestUUID, t.QestUUID)
       , Borehole = s.BoreholeCode
       , Sample = s.SampleArticleID
       , Depth = [dbo].[qest_GetDepth](s.Depth, s.Length, @sampleDepthMode, @IPUnits)
       , SampleDescription = t.VisualDescription
       , AxialStrainAtHalf = ts.PeakStressAxialStrainAtHalf
       , CellPressure_IP = dbo.uomPressure(ts.CompressionCellPressure,'ksf')
       , CellPressure_SI = dbo.uomPressure(ts.CompressionCellPressure,'kPa')
       , FailureTypeReported = t.FailureTypeCode
       , FailureModeComment = t.FailureTypeCode+' - '+t.FailureTypeName
       , FailureStrain = ts.PeakStressStrain
       , FailureStress_IP = dbo.uomPressure(ts.PeakStressStress,'ksf')
       , FailureStress_SI = dbo.uomPressure(ts.PeakStressStress,'kPa')
       , InitialBulkDensity_IP = dbo.uomDensity(t.InitialBulkDensity,'pcf')
       , InitialBulkDensity_SI = dbo.uomDensity(t.InitialBulkDensity,'Mg/m³')
       , InitialDiameter_IP = dbo.uomLength(t.InitialDiameter,'in')
       , InitialDiameter_SI = dbo.uomLength(t.InitialDiameter,'mm')
       , InitialDryDensity_IP = dbo.uomDensity(t.InitialDryDensity,'pcf')
       , InitialDryDensity_SI = dbo.uomDensity(t.InitialDryDensity,'Mg/m³')
       , InitialHeight_IP = dbo.uomLength(t.InitialHeight,'in')
       , InitialHeight_SI = dbo.uomLength(t.InitialHeight,'mm')
       , InitialMoistureContent = t.InitialMoistureContentForCalculation
       , InitialMoistureFrom = t.InitialMoistureContentObtainedFrom
       , FinalMoistureContent = t.FinalMoistureContentForCalculation
       , FinalMoistureFrom = t.FinalMoistureContentObtainedFrom
       , MajorPrincipalStress_IP = dbo.uomPressure(ts.PeakStressMajorPrincipalEffectiveStress,'ksf')
       , MajorPrincipalStress_SI = dbo.uomPressure(ts.PeakStressMajorPrincipalEffectiveStress,'kPa')
       , MembraneThickness_IP = dbo.uomLength(t.MembraneThickness,'in')
       , MembraneThickness_SI = dbo.uomLength(t.MembraneThickness,'mm')
       , MembraneCorrection_IP = dbo.uomPressure(ts.PeakStressRubberMembraneCorrection,'ksf')
       , MembraneCorrection_SI = dbo.uomPressure(ts.PeakStressRubberMembraneCorrection,'kPa')
       , MinorPrincipalStress_IP = dbo.uomPressure(ts.PeakStressMinorPrincipalEffectiveStress,'ksf')
       , MinorPrincipalStress_SI = dbo.uomPressure(ts.PeakStressMinorPrincipalEffectiveStress,'kPa')
       , OffOnshoreText = 'Onshore'
       , SampleType = [dbo].[qest_Plate_GetSampleTypeDescription](t.SampleType)
       , StrainRate = dbo.uomRate(Coalesce(ts.StrainRate, t.DataFileRateOfStrain,ts.RequestedRateOfStrain),'/min')
       , UndrainedShearStress_SI = dbo.uomPressure(ts.PeakStressUndrainedShearStress,'kPa')  
       , UndrainedShearStress_IP = dbo.uomPressure(ts.PeakStressUndrainedShearStress,'ksf')
       , UseMoistureInitial = case when ISNULL(t.FinalMoistureContentUsedForCalculation,'') = 'FMC' then 0 else 1 end
  from DocumentCertificates c
    inner join qestPlateReportMapping m on c.QestUUID = m.ReportUUID
    inner join qestReverseLookup rl on m.TestUUID = rl.QestUUID
    inner join Samples s on s.QestUUID = rl.SampleArticleUUID
    inner join DocumentTriaxial t on rl.QestUUID = t.QestUUID
    inner join DocumentTriaxialSingle ts on ts.QestUniqueParentID = t.QestUniqueID and ts.QestID = 111024
  where c.QestUUID = @reportUUID
  order by s.BoreholeCode, s.Depth, s.SampleArticleID, t.QestUUID 
 
  --Table 2 - Triaxial Readings - many rows per test - probably need
  -- more data here for all the extra calculations that may happen...
  
  declare @NullTime bit
  set @NullTime = 0
  
  IF EXISTS(Select 1 from DocumentCertificates c
    inner join qestPlateReportMapping m on c.QestUUID = m.ReportUUID
    inner join qestReverseLookup rl on m.TestUUID = rl.QestUUID
    inner join Samples s on s.QestUUID = rl.SampleArticleUUID
    inner join DocumentTriaxial t on rl.QestUUID = t.QestUUID
    inner join DocumentTriaxialSingle ts on ts.QestUniqueParentID = t.QestUniqueID and ts.QestID = 111024
	left join DocumentTriaxialSingleReading cr on cr.QestUniqueParentID = ts.QestUniqueID and cr.QestID = 111020
  where c.QestUUID = @reportUUID and cr.ElapsedTime is null)
  BEGIN
	  set @NullTime = 1
  END
  
  select t.QestUUID 
       , Sample = s.SampleArticleID
       , Borehole = s.BoreholeCode
       , BezierTension = ts.BezierTension
       , AdjustedStrain = cr.AxialStrain
       , AdjustedStress_SI = dbo.uomPressure(cr.AxialStress,'kPa')
       , AdjustedStress_IP = dbo.uomPressure(cr.AxialStress,'ksf')
	   , StopStrainUsed = case when (ts.StopStrainUsed < isnull(ts.EndPlotStrain,999)) then ts.StopStrainUsed else ts.EndPlotStrain end
  from DocumentCertificates c
    inner join qestPlateReportMapping m on c.QestUUID = m.ReportUUID
    inner join qestReverseLookup rl on m.TestUUID = rl.QestUUID
    inner join Samples s on s.QestUUID = rl.SampleArticleUUID
    inner join DocumentTriaxial t on rl.QestUUID = t.QestUUID
    inner join DocumentTriaxialSingle ts on ts.QestUniqueParentID = t.QestUniqueID and ts.QestID = 111024
	left join DocumentTriaxialSingleReading cr on cr.QestUniqueParentID = ts.QestUniqueID and cr.QestID = 111020
  where c.QestUUID = @reportUUID and (cr.Exclude is null or cr.Exclude = 0)
  order by s.BoreholeCode, s.Depth, s.SampleArticleID, t.QestUUID,   
  CASE WHEN @NullTime = 1 THEN cr.Idx ELSE cr.ElapsedTime END,
  CASE WHEN @NullTime = 1 THEN cr.ElapsedTime ELSE cr.Idx END, cr.QestCreatedDate

  --Table 3 - Normalised triaxial Readings - many rows per test - probably need
  -- more data here for all the extra calculations that may happen...
  set @NullTime = 0

  IF EXISTS(select 1 from DocumentCertificates c
    inner join qestPlateReportMapping m on c.QestUUID = m.ReportUUID
    inner join qestReverseLookup rl on m.TestUUID = rl.QestUUID
    inner join Samples s on s.QestUUID = rl.SampleArticleUUID
    inner join DocumentTriaxial t on rl.QestUUID = t.QestUUID
    inner join DocumentTriaxialSingle ts on ts.QestUniqueParentID = t.QestUniqueID and ts.QestID = 111024
	left join DocumentTriaxialSingleReading cr on cr.QestUniqueParentID = ts.QestUniqueID and cr.QestID = 111020
  where c.QestUUID = @reportUUID and cr.ElapsedTime is null)
  BEGIN
	  set @NullTime = 1
  END
  
  select t.QestUUID 
       , Sample = s.SampleArticleID
       , Borehole = s.BoreholeCode
       , BezierTension = ts.BezierTension
       , AdjustedStrain = cr.AxialStrain
       , NormalisedStress_SI = dbo.uomPressure(cr.AxialStress,'kPa') / x.AdjustedStress_SI
       , NormalisedStress_IP = dbo.uomPressure(cr.AxialStress,'ksf') / x.AdjustedStress_IP
	   , StopStrainUsed = case when (ts.StopStrainUsed < isnull(ts.EndPlotStrain,999)) then ts.StopStrainUsed else ts.EndPlotStrain end
  from DocumentCertificates c
    inner join qestPlateReportMapping m on c.QestUUID = m.ReportUUID
    inner join qestReverseLookup rl on m.TestUUID = rl.QestUUID
    inner join Samples s on s.QestUUID = rl.SampleArticleUUID
    inner join DocumentTriaxial t on rl.QestUUID = t.QestUUID
    inner join DocumentTriaxialSingle ts on ts.QestUniqueParentID = t.QestUniqueID and ts.QestID = 111024
	left join DocumentTriaxialSingleReading cr on cr.QestUniqueParentID = ts.QestUniqueID and cr.QestID = 111020
    left join
    (
      select ts.QestUUID, AdjustedStress_IP = dbo.uomPressure(MAX(AdjustedStress),'ksf'), AdjustedStress_SI = dbo.uomPressure(MAX(AdjustedStress),'kPa')
      from DocumentCertificates c
    inner join qestPlateReportMapping m on c.QestUUID = m.ReportUUID
    inner join qestReverseLookup rl on m.TestUUID = rl.QestUUID
    inner join Samples s on s.QestUUID = rl.SampleArticleUUID 
    inner join DocumentTriaxial t on rl.QestUUID = t.QestUUID 
    inner join DocumentTriaxialSingle ts on ts.QestUniqueParentID = t.QestUniqueID and ts.QestID = 111024
	left join DocumentTriaxialSingleReading cr on cr.QestUniqueParentID = ts.QestUniqueID and cr.QestID = 111020
      group by ts.QestUUID
    ) x on x.QestUUID = ts.QestUUID
  where c.QestUUID = @reportUUID and (cr.Exclude is null or cr.Exclude = 0)
  order by s.BoreholeCode, s.Depth, s.SampleArticleID, t.QestUUID, 
  CASE WHEN @NullTime = 1 THEN cr.Idx ELSE cr.ElapsedTime END,
  CASE WHEN @NullTime = 1 THEN cr.ElapsedTime ELSE cr.Idx END, cr.QestCreatedDate
  
  select PathAndFileName = I.FilePath+'\'+I.FileName
       , t.QestUUID
       , t.QestUniqueID
       , Borehole = s.BoreholeCode
       , Sample = s.SampleArticleID
       , Depth = [dbo].[qest_GetDepth](s.Depth, s.Length, @sampleDepthMode, @IPUnits)
  from DocumentCertificates c
    inner join qestPlateReportMapping m on c.QestUUID = m.ReportUUID
    inner join qestReverseLookup rl on m.TestUUID = rl.QestUUID
    inner join Samples s on s.QestUUID = rl.SampleArticleUUID 
    inner join DocumentTriaxial t on rl.QestUUID = t.QestUUID 
    inner join DocumentImage I on I.QestParentID = t.QestID and I.QestUniqueParentID = t.QestUniqueID and I.QestID = 111019
  where c.QestUUID = @reportUUID
  order by s.BoreholeCode, s.Depth, s.SampleArticleID, t.QestUUID
  
GO


----------------------------------------------------------------------------------------------------

-- 3.14 UCS Unconfined Compressive Strength

if not exists (select * from sys.objects where object_id = object_id(N'[dbo].[qest_plate_unconfinedcompressivestrength]') and type in (N'P', N'PC'))
  exec ('create proc [dbo].[qest_plate_unconfinedcompressivestrength] as select 0 tmp');
GO
ALTER proc [dbo].[qest_plate_unconfinedcompressivestrength]
  @reportUUID uniqueidentifier
as
  set nocount on;
  
  declare @sampleDepthMode nvarchar(10), @IPUnits bit;
  exec [dbo].[qest_plate_GetReportProperties] @reportUUID = @reportUUID, @sampleDepthMode = @sampleDepthMode out, @IPUnits = @IPUnits out;

   --Table 1 - Summary data - one row per test
  select t.QestID
       , t.QestUniqueID
       , t.QestUUID
       , IsTestChecked = case when t.QestCheckedDate is not null then 1 else 0 end
       , RowNumber = row_number() over (order by s.BoreholeCode, s.Depth, s.SampleArticleID, s.QestUUID, t.QestUUID)
       , Borehole = s.BoreholeCode
       , Sample = s.SampleArticleID
       , Depth = [dbo].[qest_GetDepth](s.Depth, s.Length, @sampleDepthMode, @IPUnits)
       , SampleType = [dbo].[qest_Plate_GetSampleTypeDescription](t.SampleType)
       , AxialStrainAtHalf = ts.PeakStressAxialStrainAtHalf
       , CellPressure_IP = dbo.uomPressure(ts.IsotropicCellPressure,'ksf')
       , CellPressure_SI = dbo.uomPressure(ts.IsotropicCellPressure,'kPa')
       , FailureStrain = ts.PeakStressStrain
       , FailureStress_IP = dbo.uomPressure(ts.PeakStressStress,'ksf')
       , FailureStress_SI = dbo.uomPressure(ts.PeakStressStress,'kPa')
       -- For Failure Type, use Code and add legend as a comment if more than 2 tests are on report. Otherwise report failure type directly.
       , FailureTypeReported = CASE WHEN count(*) OVER() > 2 THEN t.FailureTypeCode ELSE t.FailureTypeName END
       , FailureModeComment = CASE WHEN count(*) OVER() > 2 THEN cast(substring((
                                          select distinct ', ' + fm_t.FailureTypeCode + ' = ' + fm_t.FailureTypeName 
                                           from DocumentTriaxial fm_t where fm_t.QestUUID IN (SELECT TestUUID FROM qestPlateReportMapping fm_m WHERE fm_m.ReportUUID = c.QestUUID)
                                          for xml path('')), 3, 1000) as nvarchar(1000)) 
                                   ELSE null END
       , FinalMoistureContent = t.FinalMoistureContentForCalculation
       , FinalMoistureSourcedFrom = t.FinalMoistureContentObtainedFrom
       , HeightDiameterRatio = case when t.InitialHeight > 0 and t.InitialDiameter > 0 then t.InitialHeight / t.InitialDiameter else null end
       , InitialBulkDensity_IP = dbo.uomDensity(t.InitialBulkDensity,'pcf')
       , InitialBulkDensity_SI = dbo.uomDensity(t.InitialBulkDensity,'Mg/m³')
       , InitialDiameter_IP = dbo.uomLength(t.InitialDiameter,'in')
       , InitialDiameter_SI = dbo.uomLength(t.InitialDiameter,'mm')
       , InitialDryDensity_IP = dbo.uomDensity(t.InitialDryDensity,'pcf')
       , InitialDryDensity_SI = dbo.uomDensity(t.InitialDryDensity,'Mg/m³')
       , InitialHeight_IP = dbo.uomLength(t.InitialHeight,'in')
       , InitialHeight_SI = dbo.uomLength(t.InitialHeight,'mm')
       , InitialMoistureContent = t.InitialMoistureContentForCalculation
       , InitialMoistureSourcedFrom = t.InitialMoistureContentObtainedFrom
       , MembraneCorrection_IP = dbo.uomPressure(ts.PeakStressRubberMembraneCorrection,'ksf')
       , MembraneCorrection_SI = dbo.uomPressure(ts.PeakStressRubberMembraneCorrection,'kPa')
       , MembraneThickness_IP = dbo.uomPressure(ts.MembraneThickness,'in')
       , MembraneThickness_SI = dbo.uomPressure(ts.MembraneThickness,'mm')
       , OffOnshoreText = 'Onshore'
       , StrainRate = dbo.uomRate(Coalesce(ts.StrainRate, t.DataFileRateOfStrain,ts.RequestedRateOfStrain),'/hr')
       , UndrainedShearStress_IP = dbo.uomPressure(ts.PeakStressUndrainedShearStress,'ksf') -- PeakStressUndrainedShearStress 
       , UndrainedShearStress_SI = dbo.uomPressure(ts.PeakStressUndrainedShearStress,'kPa') -- PeakStressUndrainedShearStress 
       , UseMoistureInitial = case when ISNULL(t.FinalMoistureContentUsedForCalculation,'') = 'FMC' then 0 else 1 end
       , VisualDescription = t.VisualDescription
  from DocumentCertificates c
    inner join qestPlateReportMapping m on c.QestUUID = m.ReportUUID
    inner join qestReverseLookup rl on m.TestUUID = rl.QestUUID
    inner join Samples s on s.QestUUID = rl.SampleArticleUUID 
    inner join DocumentTriaxial t on rl.QestUUID = t.QestUUID 
    inner join DocumentTriaxialSingle ts on ts.QestUniqueParentID = t.QestUniqueID and ts.QestID = 111024
  where c.QestUUID = @reportUUID
  order by s.BoreholeCode, s.Depth, s.SampleArticleID, t.QestUUID
 
 
  --Table 2 - Triaxial Readings - many rows per test - probably need
  -- more data here for all the extra calculations that may happen...
  select t.QestUUID 
       , Sample = s.SampleArticleID
       , Borehole = s.BoreholeCode
       , BezierTension = ts.BezierTension
       , AdjustedStrain = cr.AxialStrain
       --, AdjustedStress_IP = cr.AxialStress / 47.88
       --, AdjustedStress_SI = cr.AxialStress
	   , AdjustedStress_SI = dbo.uomPressure(cr.AxialStress,'kPa')
       , AdjustedStress_IP = dbo.uomPressure(cr.AxialStress,'ksf')
	   , StopStrainUsed = case when (ts.StopStrainUsed < isnull(ts.EndPlotStrain,999)) then ts.StopStrainUsed else ts.EndPlotStrain end
  from DocumentCertificates c
    inner join qestPlateReportMapping m on c.QestUUID = m.ReportUUID
    inner join qestReverseLookup rl on m.TestUUID = rl.QestUUID
    inner join Samples s on s.QestUUID = rl.SampleArticleUUID 
    inner join DocumentTriaxial t on rl.QestUUID = t.QestUUID 
    inner join DocumentTriaxialSingle ts on ts.QestUniqueParentID = t.QestUniqueID and ts.QestID = 111024
	left join DocumentTriaxialSingleReading cr on cr.QestUniqueParentID = ts.QestUniqueID and cr.QestID = 111020
  where c.QestUUID = @reportUUID and (cr.Exclude is null or cr.Exclude = 0)
  order by s.BoreholeCode, s.Depth, s.SampleArticleID, t.QestUUID, cr.ElapsedTime, cr.Idx, cr.QestCreatedDate


  --Table 3 - Normalised triaxial Readings - many rows per test - probably need
  -- more data here for all the extra calculations that may happen...
  select t.QestUUID 
       , Sample = s.SampleArticleID
       , Borehole = s.BoreholeCode
       , BezierTension = ts.BezierTension
       , AdjustedStrain = cr.AxialStrain
       , NormalisedStress_IP = dbo.uomPressure(cr.AxialStress,'ksf') / x.AdjustedStress_IP
       , NormalisedStress_SI = dbo.uomPressure(cr.AxialStress,'kPa') / x.AdjustedStress_SI
	   , StopStrainUsed = case when (ts.StopStrainUsed < isnull(ts.EndPlotStrain,999)) then ts.StopStrainUsed else ts.EndPlotStrain end
  from DocumentCertificates c
    inner join qestPlateReportMapping m on c.QestUUID = m.ReportUUID
    inner join qestReverseLookup rl on m.TestUUID = rl.QestUUID
    inner join Samples s on s.QestUUID = rl.SampleArticleUUID 
    inner join DocumentTriaxial t on rl.QestUUID = t.QestUUID 
    inner join DocumentTriaxialSingle ts on ts.QestUniqueParentID = t.QestUniqueID and ts.QestID = 111024
	left join DocumentTriaxialSingleReading cr on cr.QestUniqueParentID = ts.QestUniqueID and cr.QestID = 111020
    left join 
    (
      select ts.QestUUID, AdjustedStress_IP = dbo.uomPressure(MAX(AdjustedStress),'ksf'), AdjustedStress_SI = dbo.uomPressure(MAX(AdjustedStress),'kPa')
      from DocumentCertificates c
    inner join qestPlateReportMapping m on c.QestUUID = m.ReportUUID
    inner join qestReverseLookup rl on m.TestUUID = rl.QestUUID
    inner join Samples s on s.QestUUID = rl.SampleArticleUUID 
    inner join DocumentTriaxial t on rl.QestUUID = t.QestUUID 
    inner join DocumentTriaxialSingle ts on ts.QestUniqueParentID = t.QestUniqueID and ts.QestID = 111024
	left join DocumentTriaxialSingleReading cr on cr.QestUniqueParentID = ts.QestUniqueID and cr.QestID = 111020
      group by ts.QestUUID
    ) x on x.QestUUID = ts.QestUUID
  where c.QestUUID = @reportUUID and (cr.Exclude is null or cr.Exclude = 0)
  order by s.BoreholeCode, s.Depth, s.SampleArticleID, t.QestUUID, cr.ElapsedTime, cr.Idx, cr.QestCreatedDate
 
  select PathAndFileName = I.FilePath+'\'+I.FileName
       , t.QestUUID
       , t.QestUniqueID
       , Borehole = s.BoreholeCode
       , Sample = s.SampleArticleID
       , Depth = [dbo].[qest_GetDepth](s.Depth, s.Length, @sampleDepthMode, @IPUnits)
  from DocumentCertificates c
    inner join qestPlateReportMapping m on c.QestUUID = m.ReportUUID
    inner join qestReverseLookup rl on m.TestUUID = rl.QestUUID
    inner join Samples s on s.QestUUID = rl.SampleArticleUUID 
    inner join DocumentTriaxial t on rl.QestUUID = t.QestUUID 
    inner join DocumentImage I on I.QestParentID = t.QestID and I.QestUniqueParentID = t.QestUniqueID and I.QestID = 111019
  where c.QestUUID = @reportUUID
  order by s.BoreholeCode, s.Depth, s.SampleArticleID, t.QestUUID
 
GO

----------------------------------------------------------------------------------------------------

-- 3.16 CIU/CAU/CID/CAD Single Triaxial

if not exists (select * from sys.objects where object_id = object_id(N'[dbo].[qest_plate_triaxial]') and type in (N'P', N'PC'))
  exec ('create proc [dbo].[qest_plate_triaxial] as select 0 tmp');
GO
ALTER proc [dbo].[qest_plate_triaxial]
  @reportUUID uniqueidentifier
as
  set nocount on;  
  
  declare @sampleDepthMode nvarchar(10), @IPUnits bit;
  exec [dbo].[qest_plate_GetReportProperties] @reportUUID = @reportUUID, @sampleDepthMode = @sampleDepthMode out, @IPUnits = @IPUnits out;
 
  DECLARE @TableSetData table (QestUUID uniqueidentifier, QestID int, StageType int, Depth real, SampleArticleID nvarchar(50), BoreholeCode nvarchar(50), SetNumber nvarchar(50), IsTestChecked bit, FailureModeComment nvarchar(1000), SaturationClause bit);
  
  INSERT INTO @TableSetData (QestUUID, QestID, StageType, Depth, SampleArticleID, BoreholeCode, SetNumber, IsTestChecked, FailureModeComment, SaturationClause)
  SELECT ta.QestUUID, td.QestID, ta.StageType, [dbo].[qest_GetDepth](s.Depth, s.Length, @sampleDepthMode, @IPUnits), S.SampleArticleID, S.BoreholeCode, null, case when ta.QestCheckedDate is not null then 1 else 0 end, null, null
  from DocumentCertificates c
    inner join qestPlateReportMapping m on c.QestUUID = m.ReportUUID
    inner join qestReverseLookup rl on m.TestUUID = rl.QestUUID
    INNER JOIN DocumentTriaxial TD ON rl.QestUUID = td.QestUUID 
    inner join TestAnalysisTriaxial ta on ta.QestUUID = TD.TestAnalysisUUID and ta.QestID = 111027
    INNER JOIN qestReverseLookup RL2 ON TD.QestUUID = RL2.QestUUID
    INNER JOIN Samples S on S.QestUUID = RL2.SampleArticleUUID 
  WHERE ta.StageType IN (1, 2) and c.QestUUID = @reportUUID
  
  INSERT INTO @TableSetData (QestUUID, QestID, StageType, Depth, SetNumber, IsTestChecked, SaturationClause)
  SELECT ta.QestUUID, min(td.QestID), ta.StageType, min([dbo].[qest_GetDepth](s.Depth, s.Length, @sampleDepthMode, @IPUnits)),
      ta.SetNumber, case when ta.QestCheckedDate is not null then 1 else 0 end, null
  from DocumentCertificates c
    inner join qestPlateReportMapping m on c.QestUUID = m.ReportUUID
    inner join qestReverseLookup rl on m.TestUUID = rl.QestUUID
    INNER JOIN DocumentTriaxial TD ON  rl.QestUUID = td.QestUUID
    inner join TestAnalysisTriaxial ta on ta.QestUUID = TD.TestAnalysisUUID 
    INNER JOIN qestReverseLookup RL2 ON TD.QestUUID = RL2.QestUUID
    INNER JOIN Samples S on S.QestUUID = RL2.SampleArticleUUID 
  WHERE ta.StageType IN (3) and c.QestUUID = @reportUUID and ta.QestID = 111027
  GROUP BY ta.QestUUID, ta.StageType, ta.SetNumber, ta.QestCheckedDate  
  
  UPDATE tsd SET 
    BoreholeCode = cast(substring((
          select distinct top 3 ', ' + sb.BoreholeCode 
          FROM DocumentTriaxial TDb 
		  inner join TestAnalysisTriaxial tab on tab.QestUUID = TDb.TestAnalysisUUID
		  INNER JOIN qestReverseLookup RL2b ON TDb.QestUUID = RL2b.QestUUID
		  INNER JOIN Samples Sb on Sb.QestUUID = RL2b.SampleArticleUUID 
	      WHERE tab.QestUUID = tsd.QestUUID 
          order by ', ' + sb.BoreholeCode for xml path(''))
      ,3,50) as nvarchar(50)), 
    FailureModeComment = cast(substring((
          select distinct ', ' + fm_t.FailureTypeCode + ' = ' + fm_t.FailureTypeName 
           from DocumentTriaxial fm_t
            where fm_t.TestAnalysisUUID = tsd.QestUUID
          for xml path('')), 3, 1000) as nvarchar(1000))
  FROM @TableSetData tsd
  WHERE StageType IN (3)

  --Stage 1 set saturation method
  UPDATE tsd SET  
  SaturationClause = case ts.SaturationMethod 
			when 'Increments of cell and back pressure' then 1 
			when 'ASTM D 7181 Section 8.2.1' then 1 
			when 'ASTM D 4767 Section 8.2.1' then 1 
			else 0 
		end
  FROM @TableSetData tsd
	   inner join DocumentTriaxial t on tsd.QestUUID = t.TestAnalysisUUID
	   inner join DocumentTriaxialSingle ts on ts.QestUniqueParentID = t.QestUniqueID and ts.QestID = 111024
  WHERE StageType IN (1)   

  --Stage 2 and 3 set saturation method
  UPDATE tsd SET 
    SaturationClause = case tg.SaturationMethod 
			when 'Increments of cell and back pressure' then 1 
			when 'ASTM D 7181 Section 8.2.1' then 1 
			when 'ASTM D 4767 Section 8.2.1' then 1 
			else 0 
		end
  FROM @TableSetData tsd
       inner join (
	       select t.TestAnalysisUUID as 'qestuuid', MAX(ts.SaturationMethod) as 'SaturationMethod'
		   from DocumentTriaxial t 
                inner join DocumentTriaxialSingle ts on ts.QestUniqueParentID = t.QestUniqueID and ts.QestID = 111024
		   group by t.TestAnalysisUUID
	   ) tg on tg.qestuuid = tsd.QestUUID
  WHERE StageType IN (2,3)

   --Table 1 - one row per single test/multi-specimen/multi-stage
SELECT   tsd.QestUUID
       , tsd.QestID
       , tsd.StageType
       , IsTestChecked 
       , Borehole = tsd.BoreholeCode
       , Sample = tsd.SampleArticleID
       , SaturationClauseDry = tsd.SaturationClause	
	   , SaturationClause = tsd.SaturationClause	  
	   , InterpretationNotPerformed = COALESCE(ta.InterpretationNotPerformed,1)
       , EffectiveStressCohesion_SI = dbo.uomPressure(ta.CohesionEffective,'kPa')
       , EffectiveStressCohesion_IP = dbo.uomPressure(ta.CohesionEffective,'ksf')
       , EffectiveStressFrictionAngle = dbo.uomAngle(ta.FrictionAngleEffective,'deg')
       , TotalStressCohesion_SI = dbo.uomPressure(ta.CohesionTotal,'kPa')
       , TotalStressCohesion_IP = dbo.uomPressure(ta.CohesionTotal,'ksf')
       , TotalStressFrictionAngle = dbo.uomAngle(ta.FrictionAngleTotal,'deg')
       , tsd.SetNumber
       , tsd.Depth       
FROM @TableSetData tsd 
     left JOIN TestAnalysisTriaxial ta on ta.QestUUID = tsd.QestUUID
     ORDER BY tsd.BoreholeCode, tsd.Depth, tsd.SampleArticleID, tsd.QestUUID
 
   --Table 2 - Summary data - one row per test/multi-stage one row per specimen on multi-specimen, so 3 specimens
  select tsd.QestID
       , t.QestUniqueID
       , tsd.StageType
       , tsd.QestUUID
       , RowNumber = case tsd.StageType when 1 then null when 2 then '3' else row_number() over (partition by tsd.QestUUID order by s.BoreholeCode, s.Depth, s.SampleArticleID, s.QestUUID, t.QestUUID) end
       , Borehole = s.BoreholeCode
       , Sample = s.SampleArticleID
       , Depth = [dbo].[qest_GetDepth](s.Depth, s.Length, @sampleDepthMode, @IPUnits)
       , VisualDescription = t.VisualDescription
       , AchievedBValue = ts.SaturationBValueAchieved
       , AssumedParticleDensity = case ts.IsSpecificGravityAssumed when 0 then 'Measured' else 'Assumed' end
       , AssumedSpecificGravity = case ts.IsSpecificGravityAssumed when 0 then 'Measured' else 'Assumed' end
       , DifferentialPressure_SI = dbo.uomPressure(ts.SaturationDifferentialPressureUsed,'kPa')
       , DifferentialPressure_IP = dbo.uomPressure(ts.SaturationDifferentialPressureUsed,'ksf')
       , EndDrainsType = t.TypeEndDrainsFitted
       , FailureMode = case when tsd.StageType <> 3 then t.FailureTypeCode + ' - ' + t.FailureTypeName else t.FailureTypeCode end
       , FailureModeComment = tsd.FailureModeComment
       , FinalBulkDensity_SI = dbo.uomDensity(t.FinalBulkDensity,'Mg/m³')
       , FinalBulkDensity_IP = dbo.uomDensity(t.FinalBulkDensity,'pcf')
       , FinalDryDensity_SI = dbo.uomDensity(t.FinalDryDensity,'Mg/m³')
       , FinalDryDensity_IP = dbo.uomDensity(t.FinalDryDensity,'pcf')
       , FinalMoistureContent = t.FinalMoistureContentForCalculation
       , InitialBulkDensity_SI = dbo.uomDensity(t.InitialBulkDensity,'Mg/m³')
       , InitialBulkDensity_IP = dbo.uomDensity(t.InitialBulkDensity,'pcf')
       , InitialDiameter_SI = dbo.uomLength(t.InitialDiameter,'mm')
       , InitialDiameter_IP = dbo.uomLength(t.InitialDiameter,'in')
       , InitialDryDensity_SI = dbo.uomDensity(t.InitialDryDensity,'Mg/m³')
       , InitialDryDensity_IP = dbo.uomDensity(t.InitialDryDensity,'pcf')
       , InitialHeight_SI = dbo.uomLength(t.InitialHeight,'mm')
       , InitialHeight_IP = dbo.uomLength(t.InitialHeight,'in')
       , InitialMoistureContent = t.InitialMoistureContentForCalculation
       , InitialMoistureFrom = t.InitialMoistureContentObtainedFrom
       , InitialSaturation = case when t.InitialSaturation > 100 then 100 else t.InitialSaturation end
       , InitialVoidRatio = t.InitialVoids
	   , ParticleDensity_SI = case 
								when t.ParticleDensity is not null then dbo.uomDensity(t.ParticleDensity,'Mg/m³')
								else dbo.uomDensity(t.SpecificGravity * 998.21,'Mg/m³')
							end
       , ParticleDensity_IP = case 
								when t.ParticleDensity is not null then dbo.uomDensity(t.ParticleDensity,'pcf')
								else dbo.uomDensity(t.SpecificGravity * 998.21,'pcf')
							end
       , PressureIncrement_SI = dbo.uomPressure(ts.SaturationPressureIncrementsApplied,'kPa')
       , PressureIncrement_IP = dbo.uomPressure(ts.SaturationPressureIncrementsApplied,'ksf')
       , SampleType = [dbo].[qest_Plate_GetSampleTypeDescription](t.SampleType)
       , SaturationFinalCellPressure_SI = dbo.uomPressure(ts.SaturationCellPressureOnCompletion,'kPa')
       , SaturationFinalCellPressure_IP = dbo.uomPressure(ts.SaturationCellPressureOnCompletion,'ksf')
       , SaturationFinalPorePressure_SI = dbo.uomPressure(ts.SaturationPorePressureOnCompletion,'kPa')
       , SaturationFinalPorePressure_IP = dbo.uomPressure(ts.SaturationPorePressureOnCompletion,'ksf')
       , SaturationMethodText = case when StageType = 3 then (
											case ts.SaturationMethod 
												when 'Increments of cell and back pressure' then 'A' 
												when 'ASTM D 7181 Section 8.2.1' then 'A' 
												when 'ASTM D 4767 Section 8.2.1' then 'A' 
												when 'Constant moisture content' then 'B' 
												when 'ASTM D 7181 Section 8.2.2' then 'B' 
												when 'ASTM D 4767 Section 8.2.2' then 'B' 
												when 'Fugro in-house' then 'C' 
												when 'Client specific' then 'D' 
												else null end
								) else ts.SaturationMethod end
       , SaturationMethodConstant = 0
       , SideDrainsType = t.TypeSideDrainsFitted
       , t.SpecificGravity
       , SpecimenOrientation = CASE WHEN t.SampleType = 0 -- Only print SpecimenOrientation if undisturbed
									THEN (case s.IsCylinderCut when 1 then 'Horizontal' else 'Vertical' end)
									ELSE '-' END
  from @TableSetData tsd
    inner join DocumentTriaxial t on tsd.QestUUID = t.TestAnalysisUUID
    inner join qestReverseLookup rl on t.QestUUID = rl.QestUUID
    inner join Samples s on s.QestUUID = rl.SampleArticleUUID 
    left join (select QestID, QestUniqueParentID, SaturationBValueAchieved = AVG(SaturationBValueAchieved), IsSpecificGravityAssumed = CAST(AVG(CAST(IsSpecificGravityAssumed as int)) as bit), SaturationDifferentialPressureUsed = AVG(SaturationDifferentialPressureUsed), SaturationPressureIncrementsApplied = AVG(SaturationPressureIncrementsApplied), SaturationCellPressureOnCompletion = AVG(SaturationCellPressureOnCompletion), SaturationPorePressureOnCompletion = AVG(SaturationPorePressureOnCompletion), SaturationMethod = MAX(SaturationMethod) from DocumentTriaxialSingle group by QestUniqueParentID, QestID) ts on ts.QestUniqueParentID = t.QestUniqueID and ts.QestID = 111024
    --inner join DocumentTriaxialSingle ts on ts.QestUniqueParentID = t.QestUniqueID and ts.QestID = 111024
  order by tsd.BoreholeCode, tsd.Depth, tsd.SampleArticleID, tsd.QestUUID

   --Table 3 - per test. 1 row per single, 3 rows per multi specimen/stage
  select tsd.QestID
       , ts.QestUniqueID
       , tsd.StageType
       , tsd.QestUUID
       , BoreholeCode = tsd.BoreholeCode
       , Depth = tsd.Depth
       , SampleArticleID = tsd.SampleArticleID
       , TestUUID = ts.QestUUID
       , StageNumber = ts.StageNumber
       , AnisotropicFlag = 0
       , RowNumber = row_number() over (partition by tsd.QestUUID order by s.BoreholeCode, s.Depth, s.SampleArticleID, s.QestUUID, StageNumber, t.QestUUID)
       , AxialPressure_SI = cast(null as real)
       , AxialPressure_IP = cast(null as real)
       , BackPressure_SI = dbo.uomPressure(ts.IsotropicBackPressure,'kPa')
       , BackPressure_IP = dbo.uomPressure(ts.IsotropicBackPressure,'ksf')
       , CellPressure_SI = dbo.uomPressure(ts.IsotropicCellPressure,'kPa')
       , CellPressure_IP = dbo.uomPressure(ts.IsotropicCellPressure,'ksf')
       , ConsolidationArea_SI = dbo.uomArea(ts.IsotropicArea,'mm²')
       , ConsolidationArea_IP = dbo.uomArea(ts.IsotropicArea,'in²')
       , ConsolidationAreaMethod = ts.IsotropicAreaMethod
       , ConsolidationAxialStrain = ts.IsotropicAxialStrain
       , ConsolidationBulkDensity_SI = dbo.uomDensity(ts.IsotropicBulkDensity,'Mg/m³')
       , ConsolidationBulkDensity_IP = dbo.uomDensity(ts.IsotropicBulkDensity,'pcf')
       , ConsolidationDryDensity_SI = dbo.uomDensity(ts.IsotropicDryDensity,'Mg/m³')
       , ConsolidationDryDensity_IP = dbo.uomDensity(ts.IsotropicDryDensity,'pcf')
       , ConsolidationFinalPorePressure_SI = dbo.uomPressure(ts.IsotropicPorePressureOnCompletion,'kPa')
       , ConsolidationFinalPorePressure_IP = dbo.uomPressure(ts.IsotropicPorePressureOnCompletion,'ksf')
       , ConsolidationMoistureContent = ts.IsotropicMoistureContentForCalculation
       , ConsolidationSaturation = case when ts.IsotropicDegreeOfSaturation > 100 then 100 else ts.IsotropicDegreeOfSaturation end 
       , ConsolidationVoidRatio = ts.IsotropicVoidRatio
       , ConsolidationVolumetricStrain = ts.IsotropicVolumetricStrain
       , DissipationPorePressure = ts.IsotropicCumulativePorePressureDissipation
       , EffectiveAxialPressure_SI = cast(null as real)
       , EffectiveAxialPressure_IP = cast(null as real)
       , EffectiveCellPressure_SI = dbo.uomPressure(ts.IsotropicEffectiveCellPressure,'kPa')
       , EffectiveCellPressure_IP = dbo.uomPressure(ts.IsotropicEffectiveCellPressure,'ksf')
       , Time50PrimaryConsolidation = dbo.uomTime(ts.IsotropicT50,'min')
  from @TableSetData tsd
    inner join DocumentTriaxial t on tsd.QestUUID = t.TestAnalysisUUID
    inner join qestReverseLookup rl on t.QestUUID = rl.QestUUID
    inner join Samples s on s.QestUUID = rl.SampleArticleUUID 
    inner join DocumentTriaxialSingle ts on ts.QestUniqueParentID = t.QestUniqueID and ts.QestID = 111024
  UNION ALL
  select tsd.QestID
       , ts.QestUniqueID
       , tsd.StageType
       , tsd.QestUUID
       , BoreholeCode = tsd.BoreholeCode
       , Depth = tsd.Depth
       , SampleArticleID = tsd.SampleArticleID
       , TestUUID = ts.QestUUID
       , StageNumber = ts.StageNumber
       , AnisotropicFlag = 1
       , RowNumber = cast(null as int)
       , AxialPressure_SI = dbo.uomPressure(ts.AnisotropicAxialPressure,'kPa')
       , AxialPressure_IP = dbo.uomPressure(ts.AnisotropicAxialPressure,'ksf')
       , BackPressure_SI = dbo.uomPressure(ts.AnisotropicBackPressure,'kPa')
       , BackPressure_IP = dbo.uomPressure(ts.AnisotropicBackPressure,'ksf')
       , CellPressure_SI = dbo.uomPressure(ts.AnisotropicCellPressure,'kPa')
       , CellPressure_IP = dbo.uomPressure(ts.AnisotropicCellPressure,'ksf')
       , ConsolidationArea_SI = dbo.uomArea(ts.AnisotropicArea,'mm²')
       , ConsolidationArea_IP = dbo.uomArea(ts.AnisotropicArea,'in²')
       , ConsolidationAreaMethod = ts.AnisotropicAreaMethod
       , ConsolidationAxialStrain = ts.AnisotropicAxialStrain
       , ConsolidationBulkDensity_SI = dbo.uomDensity(ts.AnisotropicBulkDensity,'Mg/m³')
       , ConsolidationBulkDensity_IP = dbo.uomDensity(ts.AnisotropicBulkDensity,'pcf')
       , ConsolidationDryDensity_SI = dbo.uomDensity(ts.AnisotropicDryDensity,'Mg/m³')
       , ConsolidationDryDensity_IP = dbo.uomDensity(ts.AnisotropicDryDensity,'pcf')
       , ConsolidationFinalPorePressure_SI = dbo.uomPressure(ts.AnisotropicPorePressureOnCompletion,'kPa')
       , ConsolidationFinalPorePressure_IP = dbo.uomPressure(ts.AnisotropicPorePressureOnCompletion,'ksf')
       , ConsolidationMoistureContent = ts.AnisotropicMoistureContentForCalculation
       , ConsolidationSaturation = ts.AnisotropicDegreeOfSaturation
       , ConsolidationVoidRatio = ts.AnisotropicVoidRatio
       , ConsolidationVolumetricStrain = ts.AnisotropicVolumetricStrain
       , DissipationPorePressure = ts.AnisotropicCumulativePorePressureDissipation
       , EffectiveAxialPressure_SI = dbo.uomPressure(ts.AnisotropicEffectiveAxialPressure,'kPa')
       , EffectiveAxialPressure_IP = dbo.uomPressure(ts.AnisotropicEffectiveAxialPressure,'ksf')
       , EffectiveCellPressure_SI = dbo.uomPressure(ts.AnisotropicEffectiveCellPressure,'kPa')
       , EffectiveCellPressure_IP = dbo.uomPressure(ts.AnisotropicEffectiveCellPressure,'ksf')
       , Time50PrimaryConsolidation = cast(null as real)
  from @TableSetData tsd
    inner join DocumentTriaxial t on tsd.QestUUID = t.TestAnalysisUUID
    inner join DocumentTriaxialSingle ts on ts.QestUniqueParentID = t.QestUniqueID and ts.QestID = 111024
  where tsd.QestID in (110826,110827,110830,110831)
  order by BoreholeCode, Depth, SampleArticleID, QestUUID, StageNumber, TestUUID, AnisotropicFlag
 
   --Table 4 - per test. 1 row per single, 3 rows per multi specimen/stage
  select tsd.QestID
       , ts.QestUniqueID
       , tsd.StageType
       , tsd.QestUUID
       , RowNumber = row_number() over (partition by tsd.QestUUID order by tsd.BoreholeCode, tsd.Depth, tsd.SampleArticleID, tsd.QestUUID, ts.StageNumber, ts.QestUUID)
       , AxialStrainAtHalf = ts.PeakStressAxialStrainAtHalf
       , CorrectedFailureStress_SI = dbo.uomPressure(ts.PeakStressStress,'kPa')
       , CorrectedFailureStress_IP = dbo.uomPressure(ts.PeakStressStress,'ksf')
       , DrainCorrection_SI = dbo.uomPressure(ts.PeakStressDrainCorrection,'kPa')
       , DrainCorrection_IP = dbo.uomPressure(ts.PeakStressDrainCorrection,'ksf')
       , EffectiveCorrectedFailureStress_SI = dbo.uomPressure(ts.PeakRatioStress,'kPa')
       , EffectiveCorrectedFailureStress_IP = dbo.uomPressure(ts.PeakRatioStress,'ksf')
       , EffectiveDrainCorrection_SI = dbo.uomPressure(ts.PeakRatioDrainCorrection,'kPa')
       , EffectiveDrainCorrection_IP = dbo.uomPressure(ts.PeakRatioDrainCorrection,'ksf')
       , EffectiveFailureStrain = ts.PeakRatioStrain
       , EffectiveMajorPrincipalStress_SI = dbo.uomPressure(ts.PeakRatioMajorPrincipalEffectiveStress,'kPa')
       , EffectiveMajorPrincipalStress_IP = dbo.uomPressure(ts.PeakRatioMajorPrincipalEffectiveStress,'ksf')
       , EffectiveMembraneCorrection_SI = dbo.uomPressure(ts.PeakRatioRubberMembraneCorrection,'kPa')
       , EffectiveMembraneCorrection_IP = dbo.uomPressure(ts.PeakRatioRubberMembraneCorrection,'ksf')
       , EffectiveMinorPrincipalStress_SI = dbo.uomPressure(ts.PeakRatioMinorPrincipalEffectiveStress,'kPa')
       , EffectiveMinorPrincipalStress_IP = dbo.uomPressure(ts.PeakRatioMinorPrincipalEffectiveStress,'ksf')
       , EffectivePrincipalStressRatio = ts.PeakRatioPrincipalStressRatio
       , EffectiveShearExcessPorePressure_SI = dbo.uomPressure(ts.PeakRatioExcessPorePressure,'kPa')
       , EffectiveShearExcessPorePressure_IP = dbo.uomPressure(ts.PeakRatioExcessPorePressure,'ksf')
       , FailureCriteria = ts.StopStrainUsed
       , FailureStrain = ts.PeakStressStrain
       , InitialDeviatorStress_SI = dbo.uomPressure(ts.CompressionInitialStress,'kPa')
       , InitialDeviatorStress_IP = dbo.uomPressure(ts.CompressionInitialStress,'ksf')
       , MajorPrincipalStress_SI = dbo.uomPressure(ts.PeakStressMajorPrincipalEffectiveStress,'kPa')
       , MajorPrincipalStress_IP = dbo.uomPressure(ts.PeakStressMinorPrincipalEffectiveStress,'ksf')
       , MembraneCorrection_SI = dbo.uomPressure(ts.PeakStressRubberMembraneCorrection,'kPa')
       , MembraneCorrection_IP = dbo.uomPressure(ts.PeakStressRubberMembraneCorrection,'ksf')
       , MinorPrincipalStress_SI = dbo.uomPressure(ts.PeakStressMinorPrincipalEffectiveStress,'kPa')
       , MinorPrincipalStress_IP = dbo.uomPressure(ts.PeakStressMinorPrincipalEffectiveStress,'ksf')
       , PrincipalStressRatio = ts.PeakStressPrincipalStressRatio
       , SecantModulus_SI = dbo.uomPressure(ts.PeakStressSecantModulus,'MPa')
       , SecantModulus_IP = dbo.uomPressure(ts.PeakStressSecantModulus,'ksf')
       , ShearExcessPorePressure_SI = dbo.uomPressure(ts.PeakStressExcessPorePressure,'kPa')
       , ShearExcessPorePressure_IP = dbo.uomPressure(ts.PeakStressExcessPorePressure,'ksf')
       , ShearInitialEffectiveCellPressure_SI = dbo.uomPressure(ts.CompressionInitialEffectiveCellPressure,'kPa')
       , ShearInitialEffectiveCellPressure_IP = dbo.uomPressure(ts.CompressionInitialEffectiveCellPressure,'ksf')
       , ShearInitialPorePressure_SI = dbo.uomPressure(ts.CompressionInitialPorePressure,'kPa')
       , ShearInitialPorePressure_IP = dbo.uomPressure(ts.CompressionInitialPorePressure,'ksf')
       , Strain10CorrectedFailureStress_SI = dbo.uomPressure(ts.AtStrainStress,'kPa')
       , Strain10CorrectedFailureStress_IP = dbo.uomPressure(ts.AtStrainStress,'ksf')
       , Strain10DrainCorrection_SI = dbo.uomPressure(ts.AtStrainDrainCorrection,'kPa')
       , Strain10DrainCorrection_IP = dbo.uomPressure(ts.AtStrainDrainCorrection,'ksf')
       , Strain10FailureStrain = ts.AtStrainStrain
       , Strain10MajorPrincipalStress_SI = dbo.uomPressure(ts.AtStrainMajorPrincipalEffectiveStress,'kPa')
       , Strain10MajorPrincipalStress_IP = dbo.uomPressure(ts.AtStrainMajorPrincipalEffectiveStress,'ksf')
       , Strain10MinorPrincipalStress_SI = dbo.uomPressure(ts.AtStrainMinorPrincipalEffectiveStress,'kPa')
       , Strain10MinorPrincipalStress_IP = dbo.uomPressure(ts.AtStrainMinorPrincipalEffectiveStress,'ksf')
       , Strain10PrincipalStressRatio = ts.AtStrainPrincipalStressRatio
       , Strain10RubberMembraneCorrection_SI = dbo.uomPressure(ts.AtStrainRubberMembraneCorrection,'kPa')
       , Strain10RubberMembraneCorrection_IP = dbo.uomPressure(ts.AtStrainRubberMembraneCorrection,'ksf')
       , Strain10ShearExcessPorePressure_SI = dbo.uomPressure(ts.AtStrainExcessPorePressure,'kPa')
       , Strain10ShearExcessPorePressure_IP = dbo.uomPressure(ts.AtStrainExcessPorePressure,'ksf')
       , StrainRate = dbo.uomRate(Coalesce(ts.StrainRate, t.DataFileRateOfStrain,ts.RequestedRateOfStrain),'/hr')
  from @TableSetData tsd
    inner join DocumentTriaxial t on tsd.QestUUID = t.TestAnalysisUUID
    inner join DocumentTriaxialSingle ts on ts.QestUniqueParentID = t.QestUniqueID and ts.QestID = 111024
  order by tsd.BoreholeCode, tsd.Depth, tsd.SampleArticleID, tsd.QestUUID, ts.StageNumber, ts.QestUUID
  
  --Table 5 - Saturation
  declare @NullTime bit
  set @NullTime = 0

  IF EXISTS(select 1 from @TableSetData tsd
      inner join DocumentTriaxial t on tsd.QestUUID = t.TestAnalysisUUID
      inner join DocumentTriaxialSingle ts on ts.QestUniqueParentID = t.QestUniqueID and ts.QestID = 111024
	  inner join DocumentTriaxialSingleReading cr on cr.QestUniqueParentID = ts.QestUniqueID and cr.QestID = 111021
      WHERE cr.ElapsedTime is null)
  BEGIN
	  set @NullTime = 1
  END
  
  select tsd.QestUUID 
       , cr.QestID
       , ts.QestUniqueID
       , tsd.StageType
       , BoreholeCode = tsd.BoreholeCode
       , Depth = tsd.Depth
       , SampleArticleID = tsd.SampleArticleID
       , TestUUID = t.QestUUID
       , BezierTension = 0
       , CellPressure_SI = dbo.uomPressure(cr.CellPressure,'kPa')
       , CellPressure_IP = dbo.uomPressure(cr.CellPressure,'ksf')
       , PorePressure_SI = dbo.uomPressure(cr.PoreWaterPressure,'kPa')
       , PorePressure_IP = dbo.uomPressure(cr.PoreWaterPressure,'ksf')
  from @TableSetData tsd
    inner join DocumentTriaxial t on tsd.QestUUID = t.TestAnalysisUUID
    inner join DocumentTriaxialSingle ts on ts.QestUniqueParentID = t.QestUniqueID and ts.QestID = 111024
	left join DocumentTriaxialSingleReading cr on cr.QestUniqueParentID = ts.QestUniqueID and cr.QestID = 111021
      WHERE ISNULL(cr.Exclude,0) <> 1 and ISNULL(cr.Rezero,0) <> 1
  order by tsd.BoreholeCode, tsd.Depth, tsd.SampleArticleID, tsd.QestUUID, ts.StageNumber, ts.QestUUID,
    CASE WHEN @NullTime = 1 THEN cr.Idx ELSE cr.ElapsedTime END,
  CASE WHEN @NullTime = 1 THEN cr.ElapsedTime ELSE cr.Idx END, cr.QestCreatedDate
  --Table 6 - Consolidation. 1 set per single. 3 sets of stages per multi-stage. 3 set per specimen for multi-specimen
  select tsd.QestUUID 
       , ts.QestUniqueID
       , tsd.StageType
       , BoreholeCode = tsd.BoreholeCode
       , Depth = tsd.Depth
       , SampleArticleID = tsd.SampleArticleID
       , TestUUID = ts.QestUUID
       , StageNumber = ts.StageNumber
       , BezierTension = 0
       , RootTime = SQRT(dbo.uomTime(cr.ElapsedTime,'min'))
       , VolumeChange = cr.VolumetricStrain
       , AnisotropicFlag = 0
  from @TableSetData tsd
    inner join DocumentTriaxial t on tsd.QestUUID = t.TestAnalysisUUID
    inner join DocumentTriaxialSingle ts on ts.QestUniqueParentID = t.QestUniqueID and ts.QestID = 111024
	left join DocumentTriaxialSingleReading cr on cr.QestUniqueParentID = ts.QestUniqueID and cr.QestID = 111022
	  WHERE ISNULL(cr.Exclude,0) <> 1 and ISNULL(cr.Rezero,0) <> 1
  UNION ALL
  select tsd.QestUUID 
       , ts.QestUniqueID
       , tsd.StageType
       , BoreholeCode = tsd.BoreholeCode
       , Depth = tsd.Depth
       , SampleArticleID = tsd.SampleArticleID
       , TestUUID = ts.QestUUID
       , StageNumber = ts.StageNumber
       , BezierTension = 0
       , RootTime = SQRT(dbo.uomTime(cr.ElapsedTime,'min'))
       , VolumeChange = cr.VolumeDiv
       , AnisotropicFlag = 1
  from @TableSetData tsd
    inner join DocumentTriaxial t on tsd.QestUUID = t.TestAnalysisUUID
    inner join DocumentTriaxialSingle ts on ts.QestUniqueParentID = t.QestUniqueID and ts.QestID = 111024
	left join DocumentTriaxialSingleReading cr on cr.QestUniqueParentID = ts.QestUniqueID and cr.QestID = 111023
      WHERE ISNULL(cr.Exclude,0) <> 1 and ISNULL(cr.Rezero,0) <> 1
  order by BoreholeCode, Depth, SampleArticleID, QestUUID, StageNumber, TestUUID, AnisotropicFlag, RootTime
  
   --Table 7 - Stress-Strain PQ chart data
  select tsd.QestUUID
       , ts.QestUniqueID
	   , t.QestID
       , tsd.StageType
	   , BezierTension = ts.BezierTension
	   , AdjustedStrain = cr.AxialStrain
	   , AdjustedStress_SI = dbo.uomPressure(cr.AxialStress,'kPa')
	   , AdjustedStress_IP = dbo.uomPressure(cr.AxialStress,'ksf')
	   , ExcessPorePressure_SI = dbo.uomPressure(cr.ExcessPoreWaterPressure,'kPa')
	   , ExcessPorePressure_IP = dbo.uomPressure(cr.ExcessPoreWaterPressure,'ksf')
	   , VolumeChange = cr.VolumetricStrain
	   , P_Value_SI = dbo.uomPressure(cr.P,'kPa')
	   , P_Value_IP = dbo.uomPressure(cr.P,'ksf')
	   , PrincipalEffectiveStressRatio = cr.PrincipalEffectiveStressRatio
	   , Q_Value_SI = dbo.uomPressure(cr.Q,'kPa')
	   , Q_Value_IP = dbo.uomPressure(cr.Q,'ksf')
	   , S_value_SI = dbo.uomPressure(cr.S,'kPa')
	   , S_value_IP = dbo.uomPressure(cr.S,'ksf')
	   , T_value_SI = dbo.uomPressure(cr.T,'kPa')
	   , T_value_IP = dbo.uomPressure(cr.T,'ksf')
	   , InterpretationNotPerformed = COALESCE(ta.InterpretationNotPerformed,1)
	   , StopStrainUsed = case when (ts.StopStrainUsed < isnull(ts.EndPlotStrain,999)) then ts.StopStrainUsed else ts.EndPlotStrain end
  from @TableSetData tsd
    inner join DocumentTriaxial t on tsd.QestUUID = t.TestAnalysisUUID
    inner join DocumentTriaxialSingle ts on ts.QestUniqueParentID = t.QestUniqueID and ts.QestID = 111024
	left join DocumentTriaxialSingleReading cr on cr.QestUniqueParentID = ts.QestUniqueID and cr.QestID = 111020
    left JOIN TestAnalysisTriaxial ta on ta.QestUUID = tsd.QestUUID
	  WHERE ISNULL(cr.Exclude,0) <> 1 and ISNULL(cr.Rezero,0) <> 1
  order by tsd.BoreholeCode, tsd.Depth, tsd.SampleArticleID, tsd.QestUUID, ts.StageNumber, ts.QestUUID, cr.ElapsedTime, cr.Idx, cr.QestCreatedDate
  
   --Table 8 - Get Images Stored Proc
  select PathAndFileName = I.FilePath+'\'+I.FileName
       , tsd.QestUUID
       , t.QestUniqueID
       , Borehole = s.BoreholeCode
       , Sample = s.SampleArticleID
       , Depth = [dbo].[qest_GetDepth](s.Depth, s.Length, @sampleDepthMode, @IPUnits)
  from @TableSetData tsd
    inner join DocumentTriaxial t on tsd.QestUUID = t.TestAnalysisUUID
    inner join qestReverseLookup rl on t.QestUUID = rl.QestUUID
    inner join Samples s on s.QestUUID = rl.SampleArticleUUID 
    inner join DocumentImage I on I.QestParentID = t.QestID and I.QestUniqueParentID = t.QestUniqueID and I.QestID = 111019
  order by tsd.BoreholeCode, tsd.Depth, tsd.SampleArticleID, tsd.QestUUID
  
   --Table 9 - Mohr Chart
  select tsd.QestUUID
	   , tsd.StageType
       , ts.QestUniqueID
	   , t.QestID
	   , EffectiveStressCohesion_SI = dbo.uomPressure(ta.CohesionEffective,'kPa')
	   , EffectiveStressCohesion_IP = dbo.uomPressure(ta.CohesionEffective,'ksf')
	   , EffectiveStressFrictionAngle = dbo.uomAngle(ta.FrictionAngleEffective,'deg')
	   , TotalStressCohesion_SI = dbo.uomPressure(ta.CohesionTotal,'kPa')
	   , TotalStressCohesion_IP = dbo.uomPressure(ta.CohesionTotal,'ksf')
	   , TotalStressFrictionAngle = dbo.uomAngle(ta.FrictionAngleTotal,'deg')
	   , MohrCircleEffectiveCentre_SI = dbo.uomPressure(ts.MohrCircleEffectiveCentre,'kPa')
	   , MohrCircleEffectiveCentre_IP = dbo.uomPressure(ts.MohrCircleEffectiveCentre,'ksf')
	   , MohrCircleEffectiveRadius_SI = dbo.uomPressure(ts.MohrCircleEffectiveRadius,'kPa')
	   , MohrCircleEffectiveRadius_IP = dbo.uomPressure(ts.MohrCircleEffectiveRadius,'ksf')
	   , MohrCircleTotalCentre_SI = dbo.uomPressure(ts.MohrCircleTotalCentre,'kPa')
	   , MohrCircleTotalCentre_IP = dbo.uomPressure(ts.MohrCircleTotalCentre,'ksf')
	   , MohrCircleTotalRadius_SI = dbo.uomPressure(ts.MohrCircleTotalRadius,'kPa')
	   , MohrCircleTotalRadius_IP = dbo.uomPressure(ts.MohrCircleTotalRadius,'ksf')
	   , InterpretationNotPerformed = COALESCE(ta.InterpretationNotPerformed,1)
  from @TableSetData tsd
    inner join DocumentTriaxial t on tsd.QestUUID = t.TestAnalysisUUID
    inner join DocumentTriaxialSingle ts on ts.QestUniqueParentID = t.QestUniqueID and ts.QestID = 111024
    inner join TestAnalysisTriaxial ta on ta.QestUUID = tsd.QestUUID and ta.QestID = 111027
  order by tsd.BoreholeCode, tsd.Depth, tsd.SampleArticleID, tsd.QestUUID, ts.StageNumber, ts.QestUUID

GO


----------------------------------------------------------------------------------------------------

-- 3.19 Oedometer

if not exists (select * from sys.objects where object_id = object_id(N'[dbo].[qest_plate_oedometer]') and type in (N'P', N'PC'))
  exec ('create proc [dbo].[qest_plate_oedometer] as select 0 tmp');
GO
ALTER proc [dbo].[qest_plate_oedometer]
  @reportUUID uniqueidentifier
as
  set nocount on;
  ---------------------
  DECLARE @OedometerAnalysisModel table (QestUUID uniqueidentifier, SampleArticleUUID uniqueidentifier, ConsolidationCasagrande int, ConsolidationTaylor int, PreconsolidationCasagrande int, PreconsolidationBecker int, StartTime datetime, EndTime dateTime);
  INSERT INTO @OedometerAnalysisModel(QestUUID, SampleArticleUUID, ConsolidationCasagrande, ConsolidationTaylor, PreconsolidationCasagrande, PreconsolidationBecker, StartTime, EndTime)
  select t.QestUUID  
  ,SampleArticleUUID = rl.SampleArticleUUID 
  ,ConsolidationCasagrande = case when exists(select * from DocumentIncrementalOedometerLoadStage s inner join TestAnalysisConsolidationCasagrande a on a.QestUniqueParentID = s.QestUniqueID where s.QestUniqueParentID = t.qestuniqueid) then 1 else 0 end
  ,ConsolidationTaylor = case when exists(select * from DocumentIncrementalOedometerLoadStage s inner join TestAnalysisConsolidationTaylor a on a.QestUniqueParentID = s.QestUniqueID where s.QestUniqueParentID = t.qestuniqueid) then 1 else 0 end
  ,PreconsolidationCasagrande = case when exists(select * from DocumentIncrementalOedometer s inner join TestAnalysisOedPreconsolidationCasagrande a on a.QestUniqueParentID = s.QestUniqueID where s.QestUniqueID = t.qestuniqueid) then 1 else 0 end
  ,PreconsolidationBecker = case when exists(select * from DocumentIncrementalOedometer s inner join TestAnalysisOedPreconsolidationBecker a on a.QestUniqueParentID = s.QestUniqueID where s.QestUniqueID = t.QestUniqueID) then 1 else 0 end
  ,StartTime = (select MIN(ls.DateTimeStarted) from DocumentIncrementalOedometer s left join DocumentIncrementalOedometerLoadStage ls on ls.QestUniqueParentID = t.QestUniqueID)
  ,EndTime = (select MAX(ls.DateTimeFinished) from DocumentIncrementalOedometer s left join DocumentIncrementalOedometerLoadStage ls on ls.QestUniqueParentID = t.QestUniqueID)
  from DocumentCertificates c  
    inner join qestPlateReportMapping m on c.QestUUID = m.ReportUUID
    inner join qestReverseLookup rl on m.TestUUID = rl.QestUUID
    inner join DocumentIncrementalOedometer t on rl.QestUUID = t.QestUUID 
  where c.QestUUID = @reportUUID

  declare @sampleDepthMode nvarchar(10), @IPUnits bit;
  exec [dbo].[qest_plate_GetReportProperties] @reportUUID = @reportUUID, @sampleDepthMode = @sampleDepthMode out, @IPUnits = @IPUnits out;

   --Table 1 - Summary data - one row per test
  select t.QestID
       , t.QestUniqueID
       , t.QestUUID
       , IsTestChecked = case when t.QestCheckedDate is not null then 1 else 0 end
       , RowNumber = row_number() over (order by s.BoreholeCode, s.Depth, s.SampleArticleID, s.QestUUID, t.QestUUID)
       , Borehole = s.BoreholeCode
       , Sample = s.SampleArticleID
       , Depth = [dbo].[qest_GetDepth](s.Depth, s.Length, @sampleDepthMode, @IPUnits)
       , SampleType = [dbo].[qest_Plate_GetSampleTypeDescription](t.SampleType)
       , Diameter_SI = dbo.uomLength(t.InitialDiameter,'mm')
       , Diameter_IP = dbo.uomLength(t.InitialDiameter,'in')
       , Height_SI = dbo.uomLength(t.InitialHeight,'mm')
       , Height_IP = dbo.uomLength(t.InitialHeight,'in')
       , VisualDescription = t.VisualDescription
       , SwellPressure_SI = dbo.uomPressure(t.SwellingPressure,'kPa')
       , SwellPressure_IP = dbo.uomPressure(t.SwellingPressure,'psi')
       , ParticleSpecificGravity = t.SpecificGravity
       , ParticleDensity_SI = dbo.uomDensity(t.ParticleDensity,'Mg/m³')
       , ParticleDensity_IP = dbo.uomDensity(t.ParticleDensity,'pcf')
       , AssumedParticleSpecificGravity = case when t.IsSpecificGravityAssumed = 1 then 'Assumed' else 'Measured' end
       , AssumedParticleDensity = case when t.IsParticleDensityAssumed = 1 then 'Assumed' else 'Measured' end
       , TimeFittingMethod = t.MethodTimeFitting
       , Temperature_SI = dbo.uomTemperature(t.LabTemperature,'C')
       , Temperature_IP = dbo.uomTemperature(t.LabTemperature,'F')
       , Technician = ppl.Name
       , TestingApparatus = t.IncrementalOedometerMachineCode
       , InitialBulkDensity_SI = dbo.uomDensity(t.InitialWetDensity,'Mg/m³')
       , InitialBulkDensity_IP = dbo.uomDensity(t.InitialWetDensity,'pcf')
       , InitialDryDensity_SI = dbo.uomDensity(t.InitialDryDensity,'Mg/m3')
       , InitialDryDensity_IP = dbo.uomDensity(t.InitialDryDensity,'pcf')
       , InitialVoidRatio = t.InitialVoidRatio
       , InitialSaturation = t.InitialSaturation
       , InitialMoistureContent = t.InitialMoistureContentForCalculation
       , FinalBulkDensity_SI = dbo.uomDensity(t.FinalWetDensity,'Mg/m³')
       , FinalBulkDensity_IP = dbo.uomDensity(t.FinalWetDensity,'pcf')
       , FinalDryDensity_SI = dbo.uomDensity(t.FinalDryDensity,'Mg/m³')
       , FinalDryDensity_IP = dbo.uomDensity(t.FinalDryDensity,'pcf')
       , FinalVoidRatio = t.FinalVoidRatio
       , FinalSaturation = t.FinalSaturation
       , FinalMoistureContent = t.InitialMoistureContentForCalculation
       , PreparationProcedure = t.PreparationProcedure
       , TestCondition = t.TestCondition
       , TestMethod = t.TestMethod
       , StartDate = oam.StartTime
       , EndDate = oam.EndTime
       , DiffHeight_SI = dbo.uomLength(t.FinalHeight - t.InitialHeight,'mm')
       , DiffHeight_IP = dbo.uomLength(t.FinalHeight - t.InitialHeight,'in')
  from @OedometerAnalysisModel oam
    inner join DocumentIncrementalOedometer t on oam.QestUUID = t.QestUUID 
    inner join Samples s on s.QestUUID = oam.SampleArticleUUID
	left join Users usr on t.QestTestedBy = usr.QESTUniqueID
	left join People ppl on ppl.QestUniqueID = usr.PersonID
order by s.BoreholeCode, s.Depth, s.SampleArticleID, t.QestUUID
  
  select t.QestUUID , s.BoreholeCode, s.Depth, s.SampleArticleID, ls.StageNumber
    , RowNumber = ls.StageNumber
    , BezierTension = 5
    , Strain = ls.AxialStrain
    , VoidRatio = ls.VoidRatio
    , InvertYAxis = case when t.MethodTimeFitting = 'Log Time' then cc.InvertYAxis when t.MethodTimeFitting = 'Root Time' then ct.InvertYAxis else null end
    , Pressure_SI = dbo.uomPressure(ls.FinalLoad, 'kPa')
    , Pressure_IP = dbo.uomPressure(ls.FinalLoad, 'ksf')
    , ConsolidationCoefficient_SI = case when t.MethodTimeFitting = 'Log Time' then dbo.uomMiscellaneous(cc.CoefficientConsolidation,'m²/yr') when t.MethodTimeFitting = 'Root Time' then dbo.uomMiscellaneous(ct.CoefficientConsolidation,'m²/yr') else null end
    , ConsolidationCoefficient_IP = case when t.MethodTimeFitting = 'Log Time' then dbo.uomMiscellaneous(cc.CoefficientConsolidation,'ft²/yr') when t.MethodTimeFitting = 'Root Time' then dbo.uomMiscellaneous(ct.CoefficientConsolidation,'ft²/yr') else null end
    , VolumeCoefficient_SI = dbo.uomMiscellaneous(ls.CoefficientVolumeCompressibility,'m²/MN')
    , VolumeCoefficient_IP = dbo.uomMiscellaneous(ls.CoefficientVolumeCompressibility,'ft²/lbf')
    , SecondaryConsolidationCoefficient = case when t.MethodTimeFitting = 'Log Time' then cc.CoefficientSecondaryConsolidation when t.MethodTimeFitting = 'Root Time' then ct.CoefficientSecondaryConsolidation else null end
    , WorkPerUnitVolume_SI = dbo.uomPressure(ls.WorkPerUnitVolume,'kPa')
    , WorkPerUnitVolume_IP = dbo.uomPressure(ls.WorkPerUnitVolume,'ksf')
    , InitialVoidRatio = t.InitialVoidRatio
    , PreconsolidationStrain = pcc.PreconsolidationStrain
    , PreconsolidationWork_SI = dbo.uomPressure(pcb.PreconsolidationWork,'kPa')
    , PreconsolidationWork_IP = dbo.uomPressure(pcb.PreconsolidationWork,'ksf')
    , BeckerStressEstimate_SI = dbo.uomPressure(pcb.PreconsolidationStress, 'kPa')
    , BeckerStressEstimate_IP = dbo.uomPressure(pcb.PreconsolidationStress, 'ksf')
    , CasagrandeStressEstimate_SI = dbo.uomPressure(pcc.PreconsolidationStress, 'kPa')
    , CasagrandeStressEstimate_IP = dbo.uomPressure(pcc.PreconsolidationStress, 'ksf')
    , PreconsolidationStressEstimate_SI = dbo.uomPressure(coalesce(pcc.PreconsolidationStress,pcb.PreconsolidationStress), 'kPa')
    , PreconsolidationStressEstimate_IP = dbo.uomPressure(coalesce(pcc.PreconsolidationStress,pcb.PreconsolidationStress), 'ksf')
    , Casa_C_X1_SI = dbo.uomPressure(pcc.TangentCPoint1X, 'kPa')
    , Casa_C_X1_IP = dbo.uomPressure(pcc.TangentCPoint1X, 'ksf')
    , Casa_C_X2_SI = dbo.uomPressure(pcc.TangentCPoint2X, 'kPa')
    , Casa_C_X2_IP = dbo.uomPressure(pcc.TangentCPoint2X, 'ksf')
    , Casa_C_Y1 = pcc.TangentCPoint1Y
    , Casa_C_Y2 = pcc.TangentCPoint2Y
    , Casa_C_X_SI = dbo.uomPressure(pcc.TangentCPointX, 'kPa')
    , Casa_C_X_IP = dbo.uomPressure(pcc.TangentCPointX, 'ksf')
    , Casa_C_Y = pcc.TangentCPointY
    , Casa_F_X1_SI = dbo.uomPressure(pcc.TangentFPoint1X, 'kPa')
    , Casa_F_X1_IP = dbo.uomPressure(pcc.TangentFPoint1X, 'ksf')
    , Casa_F_X2_SI = dbo.uomPressure(pcc.TangentFPoint2X, 'kPa')
    , Casa_F_X2_IP = dbo.uomPressure(pcc.TangentFPoint2X, 'ksf')
    , Casa_F_Y1 = pcc.TangentFPoint1Y
    , Casa_F_Y2 = pcc.TangentFPoint2Y
    , Casa_H_X_SI = dbo.uomPressure(pcc.TangentCPointX, 'kPa')
    , Casa_H_X_IP = dbo.uomPressure(pcc.TangentCPointX, 'ksf')
    , Casa_H_Y = pcc.TangentCPointY
    , Beck_1_X1_SI = dbo.uomPressure(pcb.Tangent1Point1X, 'kPa')
    , Beck_1_Y1_SI = dbo.uomPressure(pcb.Tangent1Point1Y, 'kPa') --Work per volume
    , Beck_1_X2_SI = dbo.uomPressure(pcb.Tangent1Point2X, 'kPa')
    , Beck_1_Y2_SI = dbo.uomPressure(pcb.Tangent1Point2Y, 'kPa') --Work per volume
    , Beck_2_X1_SI = dbo.uomPressure(pcb.Tangent2Point1X, 'kPa')
    , Beck_2_Y1_SI = dbo.uomPressure(pcb.Tangent2Point1Y, 'kPa') --Work per volume
    , Beck_2_X2_SI = dbo.uomPressure(pcb.Tangent2Point2X, 'kPa')
    , Beck_2_Y2_SI = dbo.uomPressure(pcb.Tangent2Point2Y, 'kPa') --Work per volume
    , Beck_1_X1_IP = dbo.uomPressure(pcb.Tangent1Point1X, 'ksf')
    , Beck_1_Y1_IP = dbo.uomPressure(pcb.Tangent1Point1Y, 'ksf') --Work per volume
    , Beck_1_X2_IP = dbo.uomPressure(pcb.Tangent1Point2X, 'ksf')
    , Beck_1_Y2_IP = dbo.uomPressure(pcb.Tangent1Point2Y, 'ksf') --Work per volume
    , Beck_2_X1_IP = dbo.uomPressure(pcb.Tangent2Point1X, 'ksf')
    , Beck_2_Y1_IP = dbo.uomPressure(pcb.Tangent2Point1Y, 'ksf') --Work per volume
    , Beck_2_X2_IP = dbo.uomPressure(pcb.Tangent2Point2X, 'ksf')
    , Beck_2_Y2_IP = dbo.uomPressure(pcb.Tangent2Point2Y, 'ksf') --Work per volume
  from @OedometerAnalysisModel oam
    inner join DocumentIncrementalOedometer t on oam.QestUUID = t.QestUUID 
    inner join Samples s on s.QestUUID = oam.SampleArticleUUID 
    inner join DocumentIncrementalOedometerLoadStage ls on ls.QestParentID = t.QestID and ls.QestUniqueParentID = t.QestUniqueID
	left join TestAnalysisConsolidationCasagrande cc on cc.QestUniqueParentID = ls.QestUniqueID and cc.QestParentID = ls.QestID
	left join TestAnalysisConsolidationTaylor ct on ct.QestUniqueParentID = ls.QestUniqueID and ct.QestParentID = ls.QestID
  	left join TestAnalysisOedPreconsolidationCasagrande pcc on pcc.QestUniqueParentID = t.QestUniqueID and pcc.QestParentID = t.QestID and oam.PreconsolidationCasagrande = 1
	left join TestAnalysisOedPreconsolidationBecker pcb on pcb.QestUniqueParentID = t.QestUniqueID and pcb.QestParentID = t.QestID and oam.PreconsolidationBecker = 1
  where ISNULL(ls.ExcludeFromReport,0) = 0
  order by s.BoreholeCode, s.Depth, s.SampleArticleID, t.QestUUID, ls.StageNumber ASC

   --Table 3 - Summary data - one row per test
  select t.QestID
       , t.QestUniqueID
       , t.QestUUID
       , s.BoreholeCode
       , Sample = s.SampleArticleID
       , Depth = [dbo].[qest_GetDepth](s.Depth, s.Length, @sampleDepthMode, @IPUnits)
       , PreconsolidationStressEstimate_SI = dbo.uomPressure(pcc.PreconsolidationStress, 'kPa')
       , PreconsolidationStressEstimate_IP = dbo.uomPressure(pcc.PreconsolidationStress, 'ksf')
       , PreconsolidationStressEstimateMethod = 'Casagrande'
  from @OedometerAnalysisModel oam
    inner join DocumentIncrementalOedometer t on oam.QestUUID = t.QestUUID 
    inner join Samples s on s.QestUUID = oam.SampleArticleUUID 
	inner join TestAnalysisOedPreconsolidationCasagrande pcc on pcc.QestUniqueParentID = t.QestUniqueID and pcc.QestParentID = t.QestID and oam.PreconsolidationCasagrande = 1
  UNION ALL
  select t.QestID
       , t.QestUniqueID
       , t.QestUUID
       , s.BoreholeCode
       , Sample = s.SampleArticleID
       , Depth = [dbo].[qest_GetDepth](s.Depth, s.Length, @sampleDepthMode, @IPUnits)
       , PreconsolidationStressEstimate_SI = dbo.uomPressure(pcb.PreconsolidationStress, 'kPa')
       , PreconsolidationStressEstimate_IP = dbo.uomPressure(pcb.PreconsolidationStress, 'ksf')
       , PreconsolidationStressEstimateMethod = 'Becker'
  from @OedometerAnalysisModel oam
    inner join DocumentIncrementalOedometer t on oam.QestUUID = t.QestUUID 
    inner join Samples s on s.QestUUID = oam.SampleArticleUUID 
	inner join TestAnalysisOedPreconsolidationBecker pcb on pcb.QestUniqueParentID = t.QestUniqueID and pcb.QestParentID = t.QestID and oam.PreconsolidationBecker = 1
  order by BoreholeCode, Depth, Sample, QestUUID, PreconsolidationStressEstimateMethod
  
GO
