--Test condition configuration

if not exists (select 1 from information_schema.routines where routine_name = 'qest_AddTestCondition' and specific_schema = 'dbo' and routine_type = 'PROCEDURE')
begin
    exec('create procedure [dbo].[qest_AddTestCondition] as return 0');
end
GO

alter proc [dbo].[qest_AddTestCondition] 
  @qestID int, @fieldName nvarchar(50), @fieldCaption nvarchar(100), @uom_SI nvarchar(20) = null, @uom_US nvarchar(20) = null, 
  @inputType int = 2, @defaultValue nvarchar(50) = null, @isMandatory bit = 0, @order int = null, @isArray bit = 0,
  @defaultValueSI real = null, @defaultValueUS real = null, @isMandatoryWhenFieldName nvarchar(50) = null, @isMandatoryWhenRegExp nvarchar(50) = null
as
  set nocount on;
  --see if there is an existing test condition field.
  declare @testConditionFieldId int;
  select @testConditionFieldId = f.TestConditionFieldID 
      from TestConditions tc 
      inner join TestConditionField f on tc.QestUUID = f.TestConditionUUID
      inner join TestConditionMapping m on tc.QestUUID = m.TestConditionUUID
      where m.QestObjectTypeID = @qestID and f.Name = @fieldName;
  
  declare @isMandatoryWhenConditionUUID uniqueidentifier;
  if @isMandatoryWhenFieldName is not null
  begin
    set @isMandatory=1;
    select @isMandatoryWhenConditionUUID = f.TestConditionUUID 
      from TestConditions tc 
      inner join TestConditionField f on tc.QestUUID = f.TestConditionUUID
      inner join TestConditionMapping m on tc.QestUUID = m.TestConditionUUID
      where m.QestObjectTypeID = @qestID and f.Name = @isMandatoryWhenFieldName;
  end

  if @isMandatoryWhenConditionUUID is null and @isMandatoryWhenRegExp is not null
  begin
    raiserror('ERROR: Cannot set conditional mandatory for %d.%s to "%s=%s".  The test condition %d.%s could not be found.', 16, 1, @qestID, @fieldName, @isMandatoryWhenFieldName, @isMandatoryWhenRegExp, @qestID, @isMandatoryWhenFieldName);
    return -1;
  end

  if @testConditionFieldId is null
  begin
    -- no existing test condition field, we create all the records needed to represent a single test condition field for a test.
    raiserror('Creating new test condition %d.%s', 10, 1, @qestID, @fieldName);

    if @order is null
    begin
      select @order = max(f.[Order]) + 1
        from TestConditions tc 
        inner join TestConditionField f on tc.QestUUID = f.TestConditionUUID
        inner join TestConditionMapping m on tc.QestUUID = m.TestConditionUUID
        where m.QestObjectTypeID = @qestID;
      if @order is null
      begin
        set @order = 0;
      end
    end

    declare @testConditionUUID uniqueidentifier;
    set @testConditionUUID = NEWID();
    insert into TestConditions (QestUUID) 
      values (@testConditionUUID);
    insert into TestConditionField (TestConditionUUID, Name, Caption, DefaultValue, DefaultValue_SI, DefaultValue_IP, InputType, Mandatory, MandatoryWhenTestConditionUUID, MandatoryWhenRegExp, Unit_SI, Unit_IP, [Order], IsArray)
      values (@testConditionUUID, @fieldName, @fieldCaption, @defaultValue, @defaultValueSI, @defaultValueUS, @inputType, @isMandatory, @isMandatoryWhenConditionUUID, @isMandatoryWhenRegExp, @uom_SI, @uom_US, @order, @isArray)
    insert into TestConditionMapping (QestObjectTypeID, TestConditionUUID)
      values (@qestID, @testConditionUUID);
  end 
  else
  begin
    --found an existing field, update the various properties.
    raiserror('Updating existing test condition %d.%s', 10, 1, @qestID, @fieldName);
    update TestConditionField 
      set Caption = @fieldCaption,
          DefaultValue = @defaultValue,
          DefaultValue_SI = @defaultValueSI,
          DefaultValue_IP = @defaultValueUS,
          InputType = @inputType,
          Mandatory = @isMandatory,
          MandatoryWhenTestConditionUUID = @isMandatoryWhenConditionUUID,
          MandatoryWhenRegExp = @isMandatoryWhenRegExp,
          [Order] = coalesce(@order, [Order]),
          Unit_SI = @uom_SI,
          Unit_IP = @uom_US
      where TestConditionFieldID = @testConditionFieldId
  end

GO

if not exists (select 1 from information_schema.routines where routine_name = 'qest_AddTestConditionListItem' and specific_schema = 'dbo' and routine_type = 'PROCEDURE')
begin
    exec('create procedure [dbo].[qest_AddTestConditionListItem] as return 0');
end
GO

alter proc dbo.qest_AddTestConditionListItem @qestID int, @fieldName nvarchar(50), @itemValue nvarchar(50), @itemCaption nvarchar(50) = null, @order int = null
as
  set nocount on;
  --find the test condition field that we're adding a list item to
  declare @testConditionFieldId int;
  select @testConditionFieldId = f.TestConditionFieldID 
      from TestConditions tc 
      inner join TestConditionField f on tc.QestUUID = f.TestConditionUUID
      inner join TestConditionMapping m on tc.QestUUID = m.TestConditionUUID
      where m.QestObjectTypeID = @qestID and f.Name = @fieldName;
  
  --if we can't find it, throw an error
  if @testConditionFieldId is null
  begin
    raiserror('Unable to find test condition field %d.%s', 16, 1, @qestId, @fieldName);
    return
  end
  
  --if no caption is specified, use the value as the caption
  if @itemCaption is null
    set @itemCaption = @itemValue;

  --if no order is specified, place this item after any others that exist
  if @order is null
  begin
    select @order = MAX([Order]) + 1 from TestConditionFieldListValue where TestConditionFieldID = @testConditionFieldId
    if @order is null 
    begin
      set @order = 0;
    end
  end
  
  --if there's an existing item with the same value, update it, otherwise add a new one.
  if not exists (select * from TestConditionFieldListValue where TestConditionFieldID = @testConditionFieldId and Value = @itemValue)
  begin
    raiserror('Creating new test condition list item %d.%s [%s]', 10, 1, @qestId, @fieldName, @itemValue);
    insert into TestConditionFieldListValue (TestConditionFieldID, Value, Caption, [Order])
    values (@testConditionFieldId, @itemValue, @itemCaption, @order);
  end
  else
  begin
    raiserror('Updating existing test condition list item %d.%s [%s]', 10, 1, @qestId, @fieldName, @itemValue);
    update TestConditionFieldListValue set Caption = @itemCaption, [Order] = @order 
      where TestConditionFieldListValue.TestConditionFieldID = @testConditionFieldId and TestConditionFieldListValue.Value = @itemValue;
  end
GO
--not needed for now.
if exists (select 1 from INFORMATION_SCHEMA.ROUTINES r where r.ROUTINE_NAME = 'qest_AddTestConditionMapping' and r.ROUTINE_SCHEMA = 'dbo')
begin
  drop proc dbo.qest_AddTestConditionMapping
end
go


if not exists (select 1 from information_schema.routines where routine_name = 'qest_RemoveTestCondition' and specific_schema = 'dbo' and routine_type = 'PROCEDURE')
begin
    exec('create procedure [dbo].[qest_RemoveTestCondition] as return 0');
end
GO

alter proc [dbo].[qest_RemoveTestCondition] 
  @qestID int, 
  @fieldName nvarchar(50),
  @removeTestConditionValues bit = 0
as
  begin transaction
  begin try
  --see if there is an existing test condition field.
  declare @testConditionUUID uniqueidentifier;
  select @testConditionUUID = tc.QestUUID
      from TestConditions tc 
      inner join TestConditionField f on tc.QestUUID = f.TestConditionUUID
      inner join TestConditionMapping m on tc.QestUUID = m.TestConditionUUID
      where m.QestObjectTypeID = @qestID and f.Name = @fieldName;

  if @testConditionUUID is not null
  begin
    if @removeTestConditionValues = 1
    begin
      raiserror('Removing test condition values for %d.%s', 10, 1, @qestID, @fieldName);
      delete LTP_PlannedTestConditions where TestConditionUUID = @testConditionUUID;
      delete SuitabilityRuleConfigurationTestConditions where TestConditionUUID = @testConditionUUID
    end

    raiserror('Removing test condition %d.%s', 10, 1, @qestID, @fieldName);
    delete TestConditionMapping where TestConditionUUID = @testConditionUUID
    delete TestConditionField where TestConditionUUID = @testConditionUUID
    delete TestConditions where QestUUID = @testConditionUUID
  end 
  commit
  end try
  begin catch
    declare @errMessage nvarchar(max), @errSeverity int, @errState int;
    select @errMessage = ERROR_MESSAGE(), @errSeverity = ERROR_SEVERITY(), @errState = ERROR_STATE()
    rollback
    raiserror('Failed to delete test condition %d.%s
  Error Message: %s', @errSeverity, @errState, @qestID, @fieldName, @errMessage)
  end catch
GO

if not exists (select 1 from information_schema.routines where routine_name = 'qest_InfoTestConditions' and specific_schema = 'dbo' and routine_type = 'PROCEDURE')
begin
    exec('create procedure [dbo].[qest_InfoTestConditions] as return 0');
end
GO

alter proc [dbo].[qest_InfoTestConditions]
as
set nocount on;
select [QestID] = m.QestObjectTypeID, 
  [Test Name] = n.Value,
  [Idx] = f.[Order],
  [Field Name] = f.Name, 
  [Field Caption] = f.Caption + coalesce(' (' + f.Unit_SI + ') | (' + f.Unit_IP + ')', ''),
  [UOM (SI)] = coalesce(f.Unit_SI, ''),
  [UOM (US)] = coalesce(f.Unit_IP, ''),
  [Data Type] = case f.InputType when 0 then 'list' when 1 then 'number' when 2 then 'text' when 3 then 'boolean' else 'unknown' end,
  [Default Value] = coalesce(f.DefaultValue, cast(f.DefaultValue_SI as nvarchar(10)) + f.Unit_SI + ' | ' + cast(f.DefaultValue_IP as nvarchar(10)) + f.Unit_IP, ''),
  [Is Mandatory] = f.Mandatory,
  [Is Mandatory When] = fm.Name + '=' + f.MandatoryWhenRegExp,
  [Is Array] = f.IsArray,
  [ListItems] = coalesce(fv0.Value, '')
    + coalesce(', ' + fv1.Value, '')
    + coalesce(', ' + fv2.Value, '')
    + coalesce(', ' + fv3.Value, '')
    + coalesce(', ' + fv4.Value, '')
    + coalesce(', ' + fv5.Value, '')
    + coalesce(', ' + fv6.Value, '')
    + coalesce(', ' + fv7.Value, '')
    + coalesce(', ' + fv8.Value, '')
    + coalesce(', ' + fv9.Value, '')
  from TestConditionMapping m
    left join qestObjects n on m.QestObjectTypeID = n.QestID and n.Property = 'Name'
    inner join TestConditions tc on m.TestConditionUUID = tc.QestUUID 
    inner join TestConditionField f on tc.QestUUID = f.TestConditionUUID
    left join TestConditionFieldListValue fv0 on fv0.TestConditionFieldID = f.TestConditionFieldID and fv0.[Order] = 0
    left join TestConditionFieldListValue fv1 on fv1.TestConditionFieldID = f.TestConditionFieldID and fv1.[Order] = 1
    left join TestConditionFieldListValue fv2 on fv2.TestConditionFieldID = f.TestConditionFieldID and fv2.[Order] = 2
    left join TestConditionFieldListValue fv3 on fv3.TestConditionFieldID = f.TestConditionFieldID and fv3.[Order] = 3
    left join TestConditionFieldListValue fv4 on fv4.TestConditionFieldID = f.TestConditionFieldID and fv4.[Order] = 4
    left join TestConditionFieldListValue fv5 on fv5.TestConditionFieldID = f.TestConditionFieldID and fv5.[Order] = 5
    left join TestConditionFieldListValue fv6 on fv6.TestConditionFieldID = f.TestConditionFieldID and fv6.[Order] = 6
    left join TestConditionFieldListValue fv7 on fv7.TestConditionFieldID = f.TestConditionFieldID and fv7.[Order] = 7
    left join TestConditionFieldListValue fv8 on fv8.TestConditionFieldID = f.TestConditionFieldID and fv8.[Order] = 8
    left join TestConditionFieldListValue fv9 on fv9.TestConditionFieldID = f.TestConditionFieldID and fv9.[Order] = 9
    left join TestConditionField fm on f.MandatoryWhenTestConditionUUID = fm.TestConditionUUID
order by [Test Name], [QestID], f.[Order], [Field Name];
GO

set nocount on;
declare @tList int = 0, @tNumber int = 1, @tText int = 2, @tBoolean int = 3;

--Triaxial UU Undisturbed [ASTM D 2850] -- OLD test from Houston Pilot
exec dbo.qest_AddTestCondition         @qestID = 110816, @fieldName = 'ConfiningPressure'                  , @order = 0, @fieldCaption = 'Confining Pressure'        , @InputType = @tNumber , @uom_SI = 'kPa', @uom_US = 'psi', @IsMandatory = 1
exec dbo.qest_AddTestCondition         @qestID = 110816, @fieldName = 'FailureCriterion'                   , @order = 1, @fieldCaption = 'Failure Criterion (%)'     , @InputType = @tNumber , @DefaultValue = '20'

--Triaxial UU Remolded [ASTM D 2850] -- OLD test from Houston Pilot
exec dbo.qest_AddTestCondition         @qestID = 110817, @fieldName = 'ConfiningPressure'                  , @order = 0, @fieldCaption = 'Confining Pressure'        , @InputType = @tNumber , @uom_SI = 'kPa', @uom_US = 'psi', @IsMandatory = 1
exec dbo.qest_AddTestCondition         @qestID = 110817, @fieldName = 'TargetDensityMode'                  , @order = 1, @fieldCaption = 'Target Density'            , @InputType = @tList   , @DefaultValue = 'Natural Density'
exec dbo.qest_AddTestConditionListItem @qestID = 110817, @fieldName = 'TargetDensityMode'                  , @order = 0, @itemValue = 'Natural Density'
exec dbo.qest_AddTestConditionListItem @qestID = 110817, @fieldName = 'TargetDensityMode'                  , @order = 1, @itemValue = 'Specific Value'
exec dbo.qest_AddTestConditionListItem @qestID = 110817, @fieldName = 'TargetDensityMode'                  , @order = 2, @itemValue = 'Relative Value'
exec dbo.qest_AddTestCondition         @qestID = 110817, @fieldName = 'TargetDensity'                      , @order = 2, @fieldCaption = 'Target Density'            , @InputType = @tNumber , @uom_SI = 'Mg/m³', @uom_US = 'lb/ft³'
exec dbo.qest_AddTestCondition         @qestID = 110817, @fieldName = 'TargetDensityRelativePercent'       , @order = 3, @fieldCaption = 'Relative %'                , @InputType = @tNumber
exec dbo.qest_AddTestCondition         @qestID = 110817, @fieldName = 'TargetDensityRelativeTo'            , @order = 4, @fieldCaption = 'Relative To'               , @InputType = @tText
exec dbo.qest_AddTestCondition         @qestID = 110817, @fieldName = 'TargetMoistureContentMode'          , @order = 5, @fieldCaption = 'Target Water Content'      , @InputType = @tList   , @DefaultValue = 'Natural Water Content'
exec dbo.qest_AddTestConditionListItem @qestID = 110817, @fieldName = 'TargetMoistureContentMode'          , @order = 0, @itemValue = 'Natural Water Content'
exec dbo.qest_AddTestConditionListItem @qestID = 110817, @fieldName = 'TargetMoistureContentMode'          , @order = 1, @itemValue = 'Specific Value'
exec dbo.qest_AddTestConditionListItem @qestID = 110817, @fieldName = 'TargetMoistureContentMode'          , @order = 2, @itemValue = 'Relative Value'
exec dbo.qest_AddTestCondition         @qestID = 110817, @fieldName = 'TargetWaterContent'                 , @order = 6, @fieldCaption = 'Target Water Content (%)'  , @InputType = @tNumber
exec dbo.qest_AddTestCondition         @qestID = 110817, @fieldName = 'TargetWaterContentRelativePercent'  , @order = 7, @fieldCaption = 'Relative %'                , @InputType = @tNumber
exec dbo.qest_AddTestCondition         @qestID = 110817, @fieldName = 'TargetWaterContentRelativeTo'       , @order = 8, @fieldCaption = 'Relative To'               , @InputType = @tText
exec dbo.qest_AddTestCondition         @qestID = 110817, @fieldName = 'FailureCriterion'                   , @order = 9, @fieldCaption = 'Failure Criterion (%)'     , @InputType = @tNumber , @DefaultValue = '20'
	

--Triaxial UU Undisturbed [BS 1377 Part 7, cl.8] -- OLD test from Houston Pilot
exec dbo.qest_AddTestCondition         @qestID = 110820, @fieldName = 'ConfiningPressure'                  , @order = 0, @fieldCaption = 'Confining Pressure'        , @InputType = @tNumber , @uom_SI = 'kPa', @uom_US = 'psi', @IsMandatory = 1
exec dbo.qest_AddTestCondition         @qestID = 110820, @fieldName = 'FailureCriterion'                   , @order = 1, @fieldCaption = 'Failure Criterion (%)'     , @InputType = @tNumber , @DefaultValue = '20'

--Triaxial UU Remolded [BS 1377 Part 7, cl.8] -- OLD test from Houston Pilot
exec dbo.qest_AddTestCondition         @qestID = 110821, @fieldName = 'ConfiningPressure'                  , @order = 0, @fieldCaption = 'Confining Pressure'        , @InputType = @tNumber , @uom_SI = 'kPa', @uom_US = 'psi', @IsMandatory = 1
exec dbo.qest_AddTestCondition         @qestID = 110821, @fieldName = 'TargetDensityMode'                  , @order = 1, @fieldCaption = 'Target Density'            , @InputType = @tList   , @DefaultValue = 'Natural Density'
exec dbo.qest_AddTestConditionListItem @qestID = 110821, @fieldName = 'TargetDensityMode'                  , @order = 0, @itemValue = 'Natural Density'
exec dbo.qest_AddTestConditionListItem @qestID = 110821, @fieldName = 'TargetDensityMode'                  , @order = 1, @itemValue = 'Specific Value'
exec dbo.qest_AddTestConditionListItem @qestID = 110821, @fieldName = 'TargetDensityMode'                  , @order = 2, @itemValue = 'Relative Value'
exec dbo.qest_AddTestCondition         @qestID = 110821, @fieldName = 'TargetDensity'                      , @order = 2, @fieldCaption = 'Target Density'            , @InputType = @tNumber , @uom_SI = 'Mg/m³', @uom_US = 'lb/ft³'
exec dbo.qest_AddTestCondition         @qestID = 110821, @fieldName = 'TargetDensityRelativePercent'       , @order = 3, @fieldCaption = 'Relative %'                , @InputType = @tNumber
exec dbo.qest_AddTestCondition         @qestID = 110821, @fieldName = 'TargetDensityRelativeTo'            , @order = 4, @fieldCaption = 'Relative To'               , @InputType = @tText
exec dbo.qest_AddTestCondition         @qestID = 110821, @fieldName = 'TargetMoistureContentMode'          , @order = 5, @fieldCaption = 'Target Water Content'      , @InputType = @tList   , @DefaultValue = 'Natural Water Content'
exec dbo.qest_AddTestConditionListItem @qestID = 110821, @fieldName = 'TargetMoistureContentMode'          , @order = 0, @itemValue = 'Natural Water Content'
exec dbo.qest_AddTestConditionListItem @qestID = 110821, @fieldName = 'TargetMoistureContentMode'          , @order = 1, @itemValue = 'Specific Value'
exec dbo.qest_AddTestConditionListItem @qestID = 110821, @fieldName = 'TargetMoistureContentMode'          , @order = 2, @itemValue = 'Relative Value'
exec dbo.qest_AddTestCondition         @qestID = 110821, @fieldName = 'TargetWaterContent'                 , @order = 6, @fieldCaption = 'Target Water Content (%)'  , @InputType = @tNumber
exec dbo.qest_AddTestCondition         @qestID = 110821, @fieldName = 'TargetWaterContentRelativePercent'  , @order = 7, @fieldCaption = 'Relative %'                , @InputType = @tNumber
exec dbo.qest_AddTestCondition         @qestID = 110821, @fieldName = 'TargetWaterContentRelativeTo'       , @order = 8, @fieldCaption = 'Relative To'               , @InputType = @tText
exec dbo.qest_AddTestCondition         @qestID = 110821, @fieldName = 'FailureCriterion'                   , @order = 9, @fieldCaption = 'Failure Criterion (%)'     , @InputType = @tNumber , @DefaultValue = '20'


--Oedometer tests
--Incremental Oedometer [ASTM D 2435]
declare @captionCa nvarchar(50);
set @captionCa = 'C' + nchar(0x03b1);  --(lower-case alpha)
exec dbo.qest_AddTestCondition         @qestID = 110920, @fieldName = 'SampleType'                         , @order = 0,  @fieldCaption = 'Sample Type'               , @InputType = @tList   , @DefaultValue = 'undisturbed', @IsMandatory = 1
exec dbo.qest_AddTestConditionListItem @qestID = 110920, @fieldName = 'SampleType'                         , @order = 0,  @itemValue = 'undisturbed'                  , @itemCaption = 'Undisturbed'
exec dbo.qest_AddTestConditionListItem @qestID = 110920, @fieldName = 'SampleType'                         , @order = 1,  @itemValue = 'remoulded'                    , @itemCaption = 'Remoulded'
exec dbo.qest_AddTestConditionListItem @qestID = 110920, @fieldName = 'SampleType'                         , @order = 2,  @itemValue = 'reconstituted'                , @itemCaption = 'Reconstituted'
exec dbo.qest_AddTestCondition         @qestID = 110920, @fieldName = 'TargetDensityType'                  , @order = 4,  @fieldCaption = 'Target Density'            , @InputType = @tList   , @DefaultValue = 'natural', @IsMandatoryWhenFieldName = 'SampleType', @isMandatoryWhenRegExp = '(?i)^reconstituted$'
exec dbo.qest_AddTestConditionListItem @qestID = 110920, @fieldName = 'TargetDensityType'                  , @order = 0,  @itemValue = 'natural'                      , @itemCaption = 'Natural Density'
exec dbo.qest_AddTestConditionListItem @qestID = 110920, @fieldName = 'TargetDensityType'                  , @order = 1,  @itemValue = 'specific'                     , @itemCaption = 'Specific Value'
exec dbo.qest_AddTestConditionListItem @qestID = 110920, @fieldName = 'TargetDensityType'                  , @order = 2,  @itemValue = 'relative'                     , @itemCaption = 'Relative Value'
exec dbo.qest_AddTestCondition         @qestID = 110920, @fieldName = 'TargetDensitySpecific'              , @order = 5,  @fieldCaption = 'Target Density'            , @InputType = @tNumber , @uom_SI = 'Mg/m³', @uom_US = 'lb/ft³', @IsMandatoryWhenFieldName = 'TargetDensityType', @isMandatoryWhenRegExp = '(?i)^specific$'
exec dbo.qest_AddTestCondition         @qestID = 110920, @fieldName = 'TargetDensityRelativePercent'       , @order = 6,  @fieldCaption = 'Relative %'                , @InputType = @tNumber, @IsMandatoryWhenFieldName = 'TargetDensityType', @isMandatoryWhenRegExp = '(?i)^relative$'
exec dbo.qest_AddTestCondition         @qestID = 110920, @fieldName = 'TargetDensityRelativeTo'            , @order = 7,  @fieldCaption = 'Relative To'               , @InputType = @tText, @IsMandatoryWhenFieldName = 'TargetDensityType', @isMandatoryWhenRegExp = '(?i)^relative$'
exec dbo.qest_AddTestCondition         @qestID = 110920, @fieldName = 'TargetWaterContentType'             , @order = 8,  @fieldCaption = 'Target Water Content'      , @InputType = @tList   , @DefaultValue = 'natural', @IsMandatoryWhenFieldName = 'SampleType', @isMandatoryWhenRegExp = '(?i)^reconstituted$'
exec dbo.qest_AddTestConditionListItem @qestID = 110920, @fieldName = 'TargetWaterContentType'             , @order = 0,  @itemValue = 'natural'                      , @itemCaption = 'Natural Water Content'
exec dbo.qest_AddTestConditionListItem @qestID = 110920, @fieldName = 'TargetWaterContentType'             , @order = 1,  @itemValue = 'specific'                     , @itemCaption = 'Specific Value'
exec dbo.qest_AddTestConditionListItem @qestID = 110920, @fieldName = 'TargetWaterContentType'             , @order = 2,  @itemValue = 'relative'                     , @itemCaption = 'Relative Value'
exec dbo.qest_AddTestCondition         @qestID = 110920, @fieldName = 'TargetWaterContentSpecific'         , @order = 9,  @fieldCaption = 'Target Water Content (%)'  , @InputType = @tNumber, @IsMandatoryWhenFieldName = 'TargetWaterContentType', @isMandatoryWhenRegExp = '(?i)^specific$'
exec dbo.qest_AddTestCondition         @qestID = 110920, @fieldName = 'TargetWaterContentRelativePercent'  , @order = 10, @fieldCaption = 'Relative %'                , @InputType = @tNumber, @IsMandatoryWhenFieldName = 'TargetWaterContentType', @isMandatoryWhenRegExp = '(?i)^relative$'
exec dbo.qest_AddTestCondition         @qestID = 110920, @fieldName = 'TargetWaterContentRelativeTo'       , @order = 11, @fieldCaption = 'Relative To'               , @InputType = @tText, @IsMandatoryWhenFieldName = 'TargetWaterContentType', @isMandatoryWhenRegExp = '(?i)^relative$'
exec dbo.qest_AddTestCondition         @qestID = 110920, @fieldName = 'VerticalEffectiveStress'            , @order = 12, @fieldCaption = 'Vertical Effective Stress' , @InputType = @tNumber , @uom_SI = 'kPa', @uom_US = 'ksf', @IsMandatory = 1, @DefaultValueSI = 5, @DefaultValueUS = 0.1
exec dbo.qest_AddTestCondition         @qestID = 110920, @fieldName = 'PreconsolidationPressure'           , @order = 13, @fieldCaption = 'Estimated Pre-Consolidation Pressure (In-situ)' , @InputType = @tNumber , @uom_SI = 'kPa', @uom_US = 'ksf'
exec dbo.qest_AddTestCondition         @qestID = 110920, @fieldName = 'StageLoad'                          , @order = 14, @fieldCaption = 'Load'                      , @InputType = @tNumber , @uom_SI = 'kPa', @uom_US = 'ksf', @IsMandatory = 1, @IsArray = 1
exec dbo.qest_AddTestCondition         @qestID = 110920, @fieldName = 'StageCalculateCv'                   , @order = 15, @fieldCaption = 'Cv'                        , @InputType = @tBoolean, @IsMandatory = 0, @IsArray = 1
exec dbo.qest_AddTestCondition         @qestID = 110920, @fieldName = 'StageCalculateCa'                   , @order = 16, @fieldCaption = @captionCa                  , @InputType = @tBoolean, @IsMandatory = 0, @IsArray = 1

--Incremental Oedometer [BS 1377-5: 1990]
exec dbo.qest_AddTestCondition         @qestID = 110921, @fieldName = 'SampleType'                         , @order = 0,  @fieldCaption = 'Sample Type'               , @InputType = @tList   , @DefaultValue = 'undisturbed', @IsMandatory = 1
exec dbo.qest_AddTestConditionListItem @qestID = 110921, @fieldName = 'SampleType'                         , @order = 0,  @itemValue = 'undisturbed'                  , @itemCaption = 'Undisturbed'
exec dbo.qest_AddTestConditionListItem @qestID = 110921, @fieldName = 'SampleType'                         , @order = 1,  @itemValue = 'remoulded'                    , @itemCaption = 'Remoulded'
exec dbo.qest_AddTestConditionListItem @qestID = 110921, @fieldName = 'SampleType'                         , @order = 2,  @itemValue = 'reconstituted'                , @itemCaption = 'Reconstituted'
exec dbo.qest_AddTestCondition         @qestID = 110921, @fieldName = 'TargetDensityType'                  , @order = 4,  @fieldCaption = 'Target Density'            , @InputType = @tList   , @DefaultValue = 'natural', @IsMandatoryWhenFieldName = 'SampleType', @isMandatoryWhenRegExp = '(?i)^reconstituted$'
exec dbo.qest_AddTestConditionListItem @qestID = 110921, @fieldName = 'TargetDensityType'                  , @order = 0,  @itemValue = 'natural'                      , @itemCaption = 'Natural Density'
exec dbo.qest_AddTestConditionListItem @qestID = 110921, @fieldName = 'TargetDensityType'                  , @order = 1,  @itemValue = 'specific'                     , @itemCaption = 'Specific Value'
exec dbo.qest_AddTestConditionListItem @qestID = 110921, @fieldName = 'TargetDensityType'                  , @order = 2,  @itemValue = 'relative'                     , @itemCaption = 'Relative Value'
exec dbo.qest_AddTestCondition         @qestID = 110921, @fieldName = 'TargetDensitySpecific'              , @order = 5,  @fieldCaption = 'Target Density'            , @InputType = @tNumber , @uom_SI = 'Mg/m³', @uom_US = 'lb/ft³', @IsMandatoryWhenFieldName = 'TargetDensityType', @isMandatoryWhenRegExp = '(?i)^specific$'
exec dbo.qest_AddTestCondition         @qestID = 110921, @fieldName = 'TargetDensityRelativePercent'       , @order = 6,  @fieldCaption = 'Relative %'                , @InputType = @tNumber, @IsMandatoryWhenFieldName = 'TargetDensityType', @isMandatoryWhenRegExp = '(?i)^relative$'
exec dbo.qest_AddTestCondition         @qestID = 110921, @fieldName = 'TargetDensityRelativeTo'            , @order = 7,  @fieldCaption = 'Relative To'               , @InputType = @tText, @IsMandatoryWhenFieldName = 'TargetDensityType', @isMandatoryWhenRegExp = '(?i)^relative$'
exec dbo.qest_AddTestCondition         @qestID = 110921, @fieldName = 'TargetWaterContentType'             , @order = 8,  @fieldCaption = 'Target Water Content'      , @InputType = @tList   , @DefaultValue = 'natural', @IsMandatoryWhenFieldName = 'SampleType', @isMandatoryWhenRegExp = '(?i)^reconstituted$'
exec dbo.qest_AddTestConditionListItem @qestID = 110921, @fieldName = 'TargetWaterContentType'             , @order = 0,  @itemValue = 'natural'                      , @itemCaption = 'Natural Water Content'
exec dbo.qest_AddTestConditionListItem @qestID = 110921, @fieldName = 'TargetWaterContentType'             , @order = 1,  @itemValue = 'specific'                     , @itemCaption = 'Specific Value'
exec dbo.qest_AddTestConditionListItem @qestID = 110921, @fieldName = 'TargetWaterContentType'             , @order = 2,  @itemValue = 'relative'                     , @itemCaption = 'Relative Value'
exec dbo.qest_AddTestCondition         @qestID = 110921, @fieldName = 'TargetWaterContentSpecific'         , @order = 9,  @fieldCaption = 'Target Water Content (%)'  , @InputType = @tNumber, @IsMandatoryWhenFieldName = 'TargetWaterContentType', @isMandatoryWhenRegExp = '(?i)^specific$'
exec dbo.qest_AddTestCondition         @qestID = 110921, @fieldName = 'TargetWaterContentRelativePercent'  , @order = 10, @fieldCaption = 'Relative %'                , @InputType = @tNumber, @IsMandatoryWhenFieldName = 'TargetWaterContentType', @isMandatoryWhenRegExp = '(?i)^relative$'
exec dbo.qest_AddTestCondition         @qestID = 110921, @fieldName = 'TargetWaterContentRelativeTo'       , @order = 11, @fieldCaption = 'Relative To'               , @InputType = @tText, @IsMandatoryWhenFieldName = 'TargetWaterContentType', @isMandatoryWhenRegExp = '(?i)^relative$'
exec dbo.qest_AddTestCondition         @qestID = 110921, @fieldName = 'VerticalEffectiveStress'            , @order = 12, @fieldCaption = 'Vertical Effective Stress' , @InputType = @tNumber , @uom_SI = 'kPa', @uom_US = 'ksf', @IsMandatory = 1, @DefaultValueSI = 5, @DefaultValueUS = 0.1
exec dbo.qest_AddTestCondition         @qestID = 110921, @fieldName = 'PreconsolidationPressure'           , @order = 13, @fieldCaption = 'Estimated Pre-Consolidation Pressure (In-situ)' , @InputType = @tNumber , @uom_SI = 'kPa', @uom_US = 'ksf'
exec dbo.qest_AddTestCondition         @qestID = 110921, @fieldName = 'StageLoad'                          , @order = 14, @fieldCaption = 'Load'                      , @InputType = @tNumber , @uom_SI = 'kPa', @uom_US = 'ksf', @IsMandatory = 1, @IsArray = 1
exec dbo.qest_AddTestCondition         @qestID = 110921, @fieldName = 'StageCalculateCv'                   , @order = 15, @fieldCaption = 'Cv'                        , @InputType = @tBoolean, @IsMandatory = 0, @IsArray = 1
exec dbo.qest_AddTestCondition         @qestID = 110921, @fieldName = 'StageCalculateCa'                   , @order = 16, @fieldCaption = @captionCa                  , @InputType = @tBoolean, @IsMandatory = 0, @IsArray = 1


--Stage 2 'Triaxial' tests -- UU, CIU, CID, CAU, CAD, UCS
declare @triaxialTests table (qestID int, isAnisotropic bit, canBeStaged bit, isUnconfined bit, name nvarchar(100))
insert into @triaxialTests (qestID, isAnisotropic, canBeStaged, isUnconfined, name)
select n.QestID
     , case when a.value in ('CAU', 'CAD') then 1 else 0 end -- isAnisotropic
     , case when a.value in ('CIU', 'CID', 'CAU', 'CAD') then 1 else 0 end -- canBeStaged
     , case when a.value in ('UCS', 'UCT') then 1 else 0 end -- isUnconfined
     , substring(n.value, 1, 100)
  from qestObjects n
  inner join qestObjects t on n.QestID = t.QestID and t.Property = 'tablename'
  inner join qestObjects a on n.QestID = a.QestID and a.Property = 'abbreviation'
  inner join qestObjects p on n.QestID = p.QestID and p.Property = 'parents'
  inner join qestObjects si_base on n.QestID = si_base.QestID and si_base.Property = 'StoreSIBaseInDatabase'
  where n.Property = 'name'
    and t.Value = 'DocumentTriaxial'
    and replace(p.Value, ' ', '') = '1801'
    and replace(si_base.Value, ' ', '') = 'true'
    and n.Value not like '%plate report%';

declare curTriaxialTests cursor fast_forward for
  select qestID, isAnisotropic, canBeStaged, isUnconfined from @triaxialTests
open curTriaxialTests

declare @qestID int, @isAnisotropic bit, @canBeStaged bit, @isUnconfined bit
fetch next from curTriaxialTests into @qestID, @isAnisotropic, @canBeStaged, @isUnconfined
while @@fetch_status = 0
begin
  exec dbo.qest_AddTestCondition         @qestID = @qestID, @fieldName = 'SampleType'                         , @order = 0,  @fieldCaption = 'Sample Type'                 , @InputType = @tList   , @DefaultValue = 'undisturbed', @IsMandatory = 1
  exec dbo.qest_AddTestConditionListItem @qestID = @qestID, @fieldName = 'SampleType'                         , @order = 0,  @itemValue = 'undisturbed'                    , @itemCaption = 'Undisturbed'
  exec dbo.qest_AddTestConditionListItem @qestID = @qestID, @fieldName = 'SampleType'                         , @order = 1,  @itemValue = 'remoulded'                      , @itemCaption = 'Remoulded'
  exec dbo.qest_AddTestConditionListItem @qestID = @qestID, @fieldName = 'SampleType'                         , @order = 2,  @itemValue = 'reconstituted'                  , @itemCaption = 'Reconstituted'
  
  if @canBeStaged = 1
  begin
    exec dbo.qest_AddTestCondition         @qestID = @qestID, @fieldName = 'Staged'                             , @order = 1,  @fieldCaption = 'Staged'                      , @InputType = @tList   , @DefaultValue = 'single', @IsMandatory = 1
    exec dbo.qest_AddTestConditionListItem @qestID = @qestID, @fieldName = 'Staged'                             , @order = 0,  @itemValue = 'single'                         , @itemCaption = 'Single'
	if @isAnisotropic = 0 
    begin
		exec dbo.qest_AddTestConditionListItem @qestID = @qestID, @fieldName = 'Staged'                         , @order = 1,  @itemValue = 'multispecimen'                  , @itemCaption = 'Multi-stage, Multi-specimen'
		exec dbo.qest_AddTestConditionListItem @qestID = @qestID, @fieldName = 'Staged'                         , @order = 2,  @itemValue = 'multistage'                     , @itemCaption = 'Multi-stage, Single Specimen'
	end
    if @isUnconfined = 0
    begin
      exec dbo.qest_AddTestCondition         @qestID = @qestID, @fieldName = 'ConfiningPressure'                  , @order = 2, @fieldCaption =  N'Horizontal Effective Stress (σh’)'     , @InputType = @tNumber , @uom_SI = 'kPa', @uom_US = 'psi', @IsMandatoryWhenFieldName = 'Staged', @isMandatoryWhenRegExp = '(?i)^single|multispecimen$'
    end
    if @isAnisotropic = 1
    begin
      exec dbo.qest_AddTestCondition         @qestID = @qestID, @fieldName = 'AnisotropicStress'                  , @order = 3,  @fieldCaption = N'Vertical Effective Stress (σv’)'       , @InputType = @tNumber , @uom_SI = 'kPa', @uom_US = 'psi', @IsMandatoryWhenFieldName = 'Staged', @isMandatoryWhenRegExp = '(?i)^single|multispecimen$'
    end
  end
  else
  begin
    if @isUnconfined = 0
    begin
      exec dbo.qest_AddTestCondition         @qestID = @qestID, @fieldName = 'ConfiningPressure'                  , @order = 2,  @fieldCaption = 'Confining Pressure'       , @InputType = @tNumber , @uom_SI = 'kPa', @uom_US = 'psi', @isMandatory = 1
    end
    if @isAnisotropic = 1
    begin
      exec dbo.qest_AddTestCondition         @qestID = @qestID, @fieldName = 'AnisotropicStress'                  , @order = 3,  @fieldCaption = 'Anisotropic Stress K0'       , @InputType = @tNumber , @uom_SI = 'kPa', @uom_US = 'psi', @isMandatory = 1
    end
  end

  exec dbo.qest_AddTestCondition         @qestID = @qestID, @fieldName = 'TargetDensityType'                  , @order = 4,  @fieldCaption = 'Target Density'              , @InputType = @tList   , @DefaultValue = 'natural', @IsMandatoryWhenFieldName = 'SampleType', @isMandatoryWhenRegExp = '(?i)^reconstituted$'
  exec dbo.qest_AddTestConditionListItem @qestID = @qestID, @fieldName = 'TargetDensityType'                  , @order = 0,  @itemValue = 'natural'                        , @itemCaption = 'Natural Density'
  exec dbo.qest_AddTestConditionListItem @qestID = @qestID, @fieldName = 'TargetDensityType'                  , @order = 1,  @itemValue = 'specific'                       , @itemCaption = 'Specific Value'
  exec dbo.qest_AddTestConditionListItem @qestID = @qestID, @fieldName = 'TargetDensityType'                  , @order = 2,  @itemValue = 'relative'                       , @itemCaption = 'Relative Value'
  exec dbo.qest_AddTestCondition         @qestID = @qestID, @fieldName = 'TargetDensitySpecific'              , @order = 5,  @fieldCaption = 'Target Density'              , @InputType = @tNumber , @uom_SI = 'Mg/m³', @uom_US = 'lb/ft³', @IsMandatoryWhenFieldName = 'TargetDensityType', @isMandatoryWhenRegExp = '(?i)^specific$'
  exec dbo.qest_AddTestCondition         @qestID = @qestID, @fieldName = 'TargetDensityRelativePercent'       , @order = 6,  @fieldCaption = 'Relative %'                  , @InputType = @tNumber, @IsMandatoryWhenFieldName = 'TargetDensityType', @isMandatoryWhenRegExp = '(?i)^relative$'
  exec dbo.qest_AddTestCondition         @qestID = @qestID, @fieldName = 'TargetDensityRelativeTo'            , @order = 7,  @fieldCaption = 'Relative To'                 , @InputType = @tText, @IsMandatoryWhenFieldName = 'TargetDensityType', @isMandatoryWhenRegExp = '(?i)^relative$'
  exec dbo.qest_AddTestCondition         @qestID = @qestID, @fieldName = 'TargetWaterContentType'             , @order = 8,  @fieldCaption = 'Target Water Content'        , @InputType = @tList   , @DefaultValue = 'natural', @IsMandatoryWhenFieldName = 'SampleType', @isMandatoryWhenRegExp = '(?i)^reconstituted$'
  exec dbo.qest_AddTestConditionListItem @qestID = @qestID, @fieldName = 'TargetWaterContentType'             , @order = 0,  @itemValue = 'natural'                        , @itemCaption = 'Natural Water Content'
  exec dbo.qest_AddTestConditionListItem @qestID = @qestID, @fieldName = 'TargetWaterContentType'             , @order = 1,  @itemValue = 'specific'                       , @itemCaption = 'Specific Value'
  exec dbo.qest_AddTestConditionListItem @qestID = @qestID, @fieldName = 'TargetWaterContentType'             , @order = 2,  @itemValue = 'relative'                       , @itemCaption = 'Relative Value'
  exec dbo.qest_AddTestCondition         @qestID = @qestID, @fieldName = 'TargetWaterContentSpecific'         , @order = 9,  @fieldCaption = 'Target Water Content (%)'    , @InputType = @tNumber, @IsMandatoryWhenFieldName = 'TargetWaterContentType', @isMandatoryWhenRegExp = '(?i)^specific$'
  exec dbo.qest_AddTestCondition         @qestID = @qestID, @fieldName = 'TargetWaterContentRelativePercent'  , @order = 10, @fieldCaption = 'Relative %'                  , @InputType = @tNumber, @IsMandatoryWhenFieldName = 'TargetWaterContentType', @isMandatoryWhenRegExp = '(?i)^relative$'
  exec dbo.qest_AddTestCondition         @qestID = @qestID, @fieldName = 'TargetWaterContentRelativeTo'       , @order = 11, @fieldCaption = 'Relative To'                 , @InputType = @tText, @IsMandatoryWhenFieldName = 'TargetWaterContentType', @isMandatoryWhenRegExp = '(?i)^relative$'
  exec dbo.qest_AddTestCondition         @qestID = @qestID, @fieldName = 'FailureCriterion'                   , @order = 12, @fieldCaption = 'Stop Criterion (%)'          , @InputType = @tNumber , @DefaultValue = '20'
  exec dbo.qest_AddTestCondition         @qestID = @qestID, @fieldName = 'ReportResultsAtStrain'              , @order = 13, @fieldCaption = 'Report Results at Strain (%)', @InputType = @tNumber , @DefaultValue = '10'
  if @canBeStaged = 1
  begin
    if @isUnconfined = 0
    begin
      exec dbo.qest_AddTestCondition         @qestID = @qestID, @fieldName = 'StageConfiningPressure'             , @order = 14, @fieldCaption = 'Confining Pressure'          , @InputType = @tNumber , @uom_SI = 'kPa', @uom_US = 'psi', @IsMandatory = 1, @isArray = 1, @IsMandatoryWhenFieldName = 'Staged', @isMandatoryWhenRegExp = '(?i)^multistage$'
    end
    if @isAnisotropic = 1
    begin
      exec dbo.qest_AddTestCondition         @qestID = @qestID, @fieldName = 'StageAnisotropicStress'             , @order = 15, @fieldCaption = 'Anisotropic Stress K0'       , @InputType = @tNumber , @uom_SI = 'kPa', @uom_US = 'psi', @IsMandatory = 1, @isArray = 1, @IsMandatoryWhenFieldName = 'Staged', @isMandatoryWhenRegExp = '(?i)^multistage$'
    end
  end

  --FIXUP - remove support for 'staging' from tests that can't be staged.
  if @canBeStaged = 0
  begin
    exec dbo.qest_RemoveTestCondition         @qestID = @qestID, @fieldName = 'Staged'                 , @removeTestConditionValues = 1
    exec dbo.qest_RemoveTestCondition         @qestID = @qestID, @fieldName = 'StageConfiningPressure' , @removeTestConditionValues = 1
    exec dbo.qest_RemoveTestCondition         @qestID = @qestID, @fieldName = 'StageAnisotropicStress' , @removeTestConditionValues = 1
  end
  
  fetch next from curTriaxialTests into @qestID, @isAnisotropic, @canBeStaged, @isUnconfined
end
close curTriaxialTests
deallocate curTriaxialTests


--Laboratory Vane [ASTM D 4648 (Method A) - 2005] (110902)
exec dbo.qest_AddTestCondition         @qestID = 110902, @fieldName = 'SampleType'                         , @order = 0,  @fieldCaption = 'Sample Type'               , @InputType = @tList   , @DefaultValue = 'undisturbed', @IsMandatory = 1
exec dbo.qest_AddTestConditionListItem @qestID = 110902, @fieldName = 'SampleType'                         , @order = 0,  @itemValue = 'undisturbed'                  , @itemCaption = 'Undisturbed'
exec dbo.qest_AddTestConditionListItem @qestID = 110902, @fieldName = 'SampleType'                         , @order = 1,  @itemValue = 'remoulded'                    , @itemCaption = 'Remoulded'
exec dbo.qest_AddTestConditionListItem @qestID = 110902, @fieldName = 'SampleType'                         , @order = 2,  @itemValue = 'reconstituted'                , @itemCaption = 'Reconstituted'
exec dbo.qest_AddTestCondition         @qestID = 110902, @fieldName = 'TargetDensityType'                  , @order = 4,  @fieldCaption = 'Target Density'            , @InputType = @tList   , @DefaultValue = 'natural', @IsMandatoryWhenFieldName = 'SampleType', @isMandatoryWhenRegExp = '(?i)^reconstituted$'
exec dbo.qest_AddTestConditionListItem @qestID = 110902, @fieldName = 'TargetDensityType'                  , @order = 0,  @itemValue = 'natural'                      , @itemCaption = 'Natural Density'
exec dbo.qest_AddTestConditionListItem @qestID = 110902, @fieldName = 'TargetDensityType'                  , @order = 1,  @itemValue = 'specific'                     , @itemCaption = 'Specific Value'
exec dbo.qest_AddTestConditionListItem @qestID = 110902, @fieldName = 'TargetDensityType'                  , @order = 2,  @itemValue = 'relative'                     , @itemCaption = 'Relative Value'
exec dbo.qest_AddTestCondition         @qestID = 110902, @fieldName = 'TargetDensitySpecific'              , @order = 5,  @fieldCaption = 'Target Density'            , @InputType = @tNumber , @uom_SI = 'Mg/m³', @uom_US = 'lb/ft³', @IsMandatoryWhenFieldName = 'TargetDensityType', @isMandatoryWhenRegExp = '(?i)^specific$'
exec dbo.qest_AddTestCondition         @qestID = 110902, @fieldName = 'TargetDensityRelativePercent'       , @order = 6,  @fieldCaption = 'Relative %'                , @InputType = @tNumber, @IsMandatoryWhenFieldName = 'TargetDensityType', @isMandatoryWhenRegExp = '(?i)^relative$'
exec dbo.qest_AddTestCondition         @qestID = 110902, @fieldName = 'TargetDensityRelativeTo'            , @order = 7,  @fieldCaption = 'Relative To'               , @InputType = @tText, @IsMandatoryWhenFieldName = 'TargetDensityType', @isMandatoryWhenRegExp = '(?i)^relative$'
exec dbo.qest_AddTestCondition         @qestID = 110902, @fieldName = 'TargetWaterContentType'             , @order = 8,  @fieldCaption = 'Target Water Content'      , @InputType = @tList   , @DefaultValue = 'natural', @IsMandatoryWhenFieldName = 'SampleType', @isMandatoryWhenRegExp = '(?i)^reconstituted$'
exec dbo.qest_AddTestConditionListItem @qestID = 110902, @fieldName = 'TargetWaterContentType'             , @order = 0,  @itemValue = 'natural'                      , @itemCaption = 'Natural Water Content'
exec dbo.qest_AddTestConditionListItem @qestID = 110902, @fieldName = 'TargetWaterContentType'             , @order = 1,  @itemValue = 'specific'                     , @itemCaption = 'Specific Value'
exec dbo.qest_AddTestConditionListItem @qestID = 110902, @fieldName = 'TargetWaterContentType'             , @order = 2,  @itemValue = 'relative'                     , @itemCaption = 'Relative Value'
exec dbo.qest_AddTestCondition         @qestID = 110902, @fieldName = 'TargetWaterContentSpecific'         , @order = 9,  @fieldCaption = 'Target Water Content (%)'  , @InputType = @tNumber, @IsMandatoryWhenFieldName = 'TargetWaterContentType', @isMandatoryWhenRegExp = '(?i)^specific$'
exec dbo.qest_AddTestCondition         @qestID = 110902, @fieldName = 'TargetWaterContentRelativePercent'  , @order = 10, @fieldCaption = 'Relative %'                , @InputType = @tNumber, @IsMandatoryWhenFieldName = 'TargetWaterContentType', @isMandatoryWhenRegExp = '(?i)^relative$'
exec dbo.qest_AddTestCondition         @qestID = 110902, @fieldName = 'TargetWaterContentRelativeTo'       , @order = 11, @fieldCaption = 'Relative To'               , @InputType = @tText, @IsMandatoryWhenFieldName = 'TargetWaterContentType', @isMandatoryWhenRegExp = '(?i)^relative$'
exec dbo.qest_AddTestCondition         @qestID = 110902, @fieldName = 'PerformResidualTest'                , @order = 12, @fieldCaption = 'Perform Residual Test'     , @InputType = @tBoolean, @DefaultValue = 'false' , @IsMandatory = 1

-- Particle Size Distribution - Wet Method & Pipette [BS 1377-2: 1990 cl 9.2, 9.4] (110950)
exec dbo.qest_AddTestCondition         @qestID = 110950, @fieldName = 'PercentRetainedWarningPercent'      , @order = 0,  @fieldCaption = 'Request Full PSD Test at Percentage Retained on Reduced Sieves [%]', @InputType = @tNumber   , @DefaultValue = '10', @IsMandatory = 1

--List all of the test conditions
--exec dbo.qest_InfoTestConditions
