
if not exists (select * from sys.objects where object_id = object_id('[dbo].[qest_ConfigureSuitabilityRule]') and type in (N'P', N'PC'))
  exec('create proc [dbo].[qest_ConfigureSuitabilityRule] as select 0 tmp;')
GO
alter proc [dbo].[qest_ConfigureSuitabilityRule]
  @testTypeQestID int
  , @idx int = null
  , @ruleUUID uniqueidentifier = null
  , @requiresUnalteredStructure bit = 0
  , @requiresUnalteredWaterContent bit = 0
  , @requiresUnalteredMineralogy bit = 0
  , @altersStructure bit = 0
  , @altersWaterContent bit = 0
  , @altersMineralogy bit = 0
  , @minimumMass float = null
  , @minimumDiameter float = null
  , @minimumLength float = null
  , @recommendedMass float = null
  , @recommendedDiameter float = null
  , @recommendedLength float = null
  , @trimmingTolerance float = null
  , @minimumAbsoluteLength float = null
  , @tcField0 nvarchar(50) = null
  , @tcField1 nvarchar(50) = null
  , @tcField2 nvarchar(50) = null
  , @tcField3 nvarchar(50) = null
  , @tcValue0 nvarchar(50) = null
  , @tcValue1 nvarchar(50) = null
  , @tcValue2 nvarchar(50) = null
  , @tcValue3 nvarchar(50) = null
  , @deleted bit = 0
as
  set nocount on
  
  begin transaction
  begin try

  if @ruleUUID is null
  begin
    select @ruleUUID = sr.QestUUID from SuitabilityRuleConfiguration sr where sr.TestTypeQestID = @testTypeQestID and not exists (select * from SuitabilityRuleConfigurationTestConditions src where sr.QestUUID = src.SuitabilityRuleConfigurationUUID)
    if @ruleUUID is null
      SELECT @ruleUUID = CAST(CAST(NEWID() AS BINARY(10)) + cast(getutcdate() as BINARY(6)) AS UNIQUEIDENTIFIER) --guid.comb
  end
  
  if exists (select * from SuitabilityRuleConfiguration where QestUUID = @ruleUUID)
  begin
    if @idx is not null
    begin
      --if the index of the test has changed, we need to make room for it at the new index
      declare @currentIdx int
      select @currentIdx = Idx from SuitabilityRuleConfiguration where QestUUID = @ruleUUID
      if @currentIdx < @idx
      begin
        update SuitabilityRuleConfiguration 
          set Idx = case when Idx = @currentIdx then @idx else Idx - 1 end
          where TestTypeQestID = @testTypeQestID 
            and Idx between @currentIdx and @idx
      end
      else if @currentIdx > @idx
      begin
        update SuitabilityRuleConfiguration 
          set Idx = case when Idx = @currentIdx then @idx else Idx + 1 end
          where TestTypeQestID = @testTypeQestID 
            and Idx between @idx and @currentIdx;
      end 
    end
  
    update SuitabilityRuleConfiguration
      set RequiresUnalteredStructure = @requiresUnalteredStructure
        , RequiresUnalteredWaterContent = @requiresUnalteredWaterContent
        , RequiresUnalteredMineralogy = @requiresUnalteredMineralogy
        , AltersStructure = @altersStructure
        , AltersWaterContent = @altersWaterContent
        , AltersMineralogy = @altersMineralogy
        , MinimumMass = @minimumMass
        , MinimumDiameter = @minimumDiameter
        , MinimumLength = @minimumLength
        , RecommendedMass = coalesce(@recommendedMass, @minimumMass)
        , RecommendedDiameter = coalesce(@recommendedDiameter, @minimumDiameter)
        , RecommendedLength = coalesce(@recommendedLength, @minimumLength)
        , TrimmingTolerance = @trimmingTolerance
        , MinimumAbsoluteLength = @minimumAbsoluteLength
      where QestUUID = @ruleUUID
  end
  else
  begin
    if @idx is null
    begin
      select @idx = coalesce(MAX(Idx) + 1, 0) from SuitabilityRuleConfiguration where TestTypeQestID = @testTypeQestID
    end
    else
    begin
      if exists (select * from SuitabilityRuleConfiguration where TestTypeQestID = @testTypeQestID and Idx = @idx)
      begin
        update SuitabilityRuleConfiguration set Idx = Idx + 1 where TestTypeQestID = @testTypeQestID and Idx >= @idx
      end
    end

    insert SuitabilityRuleConfiguration
    (
      QestUUID
      , TestTypeQestID
      , Idx
      , RequiresUnalteredStructure
      , RequiresUnalteredWaterContent
      , RequiresUnalteredMineralogy
      , AltersStructure
      , AltersWaterContent
      , AltersMineralogy
      , MinimumMass
      , MinimumDiameter
      , MinimumLength
      , RecommendedMass
      , RecommendedDiameter
      , RecommendedLength
      , TrimmingTolerance
      , MinimumAbsoluteLength    
    )
    values
    (      
      @ruleUUID
      , @testTypeQestID
      , @idx
      , @requiresUnalteredStructure
      , @requiresUnalteredWaterContent
      , @requiresUnalteredMineralogy
      , @altersStructure
      , @altersWaterContent
      , @altersMineralogy
      , @minimumMass
      , @minimumDiameter
      , @minimumLength
      , coalesce(@recommendedMass, @minimumMass)
      , coalesce(@recommendedDiameter, @minimumDiameter)
      , coalesce(@recommendedLength, @minimumLength)
      , @trimmingTolerance
      , @minimumAbsoluteLength      
    )
  end
  
  --- Now populate suitability rule configuration test conditions as required
  declare @ruleUuidAsString nvarchar(36);
  set @ruleUuidAsString = CONVERT(nvarchar(36), @ruleUUID);
  if @tcField0 is null and @tcValue0 is not null or @tcField0 is not null and @tcValue0 is null
  begin
    raiserror('Invalid test conditions for suitability rule %s.  Field[%d] - Name: %s, Value: %s', 16, 1, @ruleUuidAsString, 0, @tcField0, @tcValue0);
  end
  if @tcField1 is not null and @tcField0 is null or @tcField1 is null and @tcValue1 is not null or @tcField1 is not null and @tcValue1 is null
  begin
    raiserror('Invalid test conditions for suitability rule %s.  Field[%d] - Name: %s, Value: %s', 16, 1, @ruleUuidAsString, 1, @tcField1, @tcValue1);
  end
  if @tcField2 is not null and @tcField1 is null or @tcField2 is null and @tcValue2 is not null or @tcField2 is not null and @tcValue2 is null
  begin
    raiserror('Invalid test conditions for suitability rule %s.  Field[%d] - Name: %s, Value: %s', 16, 1, @ruleUuidAsString, 2, @tcField2, @tcValue2);
  end
  if @tcField3 is not null and @tcField2 is null or @tcField3 is null and @tcValue3 is not null or @tcField3 is not null and @tcValue3 is null
  begin
    raiserror('Invalid test conditions for suitability rule %s.  Field[%d] - Name: %s, Value: %s', 16, 1, @ruleUuidAsString, 3, @tcField3, @tcValue3);
  end
  
  update x
    set Value = case f.name 
      when @tcField0 then @tcValue0 
      when @tcField1 then @tcValue1
      when @tcField2 then @tcValue2
      when @tcField3 then @tcValue3
      else null
    end
    from SuitabilityRuleConfigurationTestConditions x
      inner join SuitabilityRuleConfiguration sr on x.SuitabilityRuleConfigurationUUID = sr.QestUUID 
      inner join TestConditionMapping tc on sr.TestTypeQestID = tc.QestObjectTypeID and tc.TestConditionUUID = x.TestConditionUUID 
      inner join TestConditionField f on tc.TestConditionUUID = f.TestConditionUUID
    where x.SuitabilityRuleConfigurationUUID = @ruleUUID
    
  insert into SuitabilityRuleConfigurationTestConditions (SuitabilityRuleConfigurationUUID, TestConditionUUID, Value)
  select 
    SuitabilityRuleConfigurationUUID = sr.QestUUID
    , TestConditionUUID = tc.TestConditionUUID 
    , Value = case f.name 
      when @tcField0 then @tcValue0 
      when @tcField1 then @tcValue1
      when @tcField2 then @tcValue2
      when @tcField3 then @tcValue3
      else null
    end
    from SuitabilityRuleConfiguration sr
      inner join TestConditionMapping tc on sr.TestTypeQestID = tc.QestObjectTypeID
      inner join TestConditionField f on tc.TestConditionUUID = f.TestConditionUUID
    where sr.QestUUID = @ruleUUID
      and f.Name in (@tcField0, @tcField1, @tcField2, @tcField3)
      and not exists (select * from SuitabilityRuleConfigurationTestConditions x where x.SuitabilityRuleConfigurationUUID = sr.QestUUID and x.TestConditionUUID = tc.TestConditionUUID)

  delete SuitabilityRuleConfigurationTestConditions where SuitabilityRuleConfigurationUUID = @ruleUUID and Value is null

  commit
  
  end try
  begin catch
    declare @errLine int, @errMessage nvarchar(max), @errNumber int, @errProcedure sysname, @errSeverity int, @errState int
    select @errLine = ERROR_LINE(), @errMessage = ERROR_MESSAGE(), @errNumber = ERROR_NUMBER(), @errProcedure = ERROR_PROCEDURE(), @errSeverity = ERROR_SEVERITY(), @errState = ERROR_STATE();
    if @@TRANCOUNT <> 0
    begin
      rollback
    end
    
    raiserror ('Failed to configure suitability rules for test type %d.
  Error Number: %d
  Error Message: %s
  Error Procedure: %s
  Error Line: %d', @errSeverity, @errState, @testTypeQestID, @errNumber, @errMessage, @errProcedure, @errLine);
  end catch

GO 

if not exists (select * from sys.objects where object_id = object_id('[dbo].[qest_SetMaterialCategorySuitability]') and type in (N'P', N'PC'))
  exec('create proc [dbo].[qest_SetMaterialCategorySuitability] as select 0 tmp;')
GO

alter proc [dbo].[qest_SetMaterialCategorySuitability]
  @testTypeQestID int
  , @materialCategory nvarchar(300)
  , @suitability nvarchar(20)
  , @minimumMass float = null
  , @recommendedMass float = null
as
  set nocount on
  
  declare @validationError bit
  set @validationError = 0
  if not exists (select * from [dbo].[qestObjects] where QestID = @testTypeQestID)
  begin
    raiserror ('Unable to find a test type with qest id %d', 16, 1, @testTypeQestID);
    set @validationError = 1
  end

  if not exists (select * from [dbo].[ListMaterialCategory] where [Description] = @materialCategory)
  begin
    raiserror ('Unable to find a material category with description %s', 16, 1, @materialCategory);
    set @validationError = 1
  end

  if not @suitability in ('suitable', 'less suitable', 'somewhat suitable', 'maybe suitable', 'possibly suitable', 'unsuitable', 'not suitable')
  begin
    raiserror ('Invalid suitability value ''%s'' -- valid values are ''suitable'', ''unsuitable'', and ''somewhat suitable''', 16, 1, @suitability);
    set @validationError = 1
  end
  if @validationError = 1
  begin
    return -1;
  end
  
  declare @suitabilityEnum int, @materialCategoryCode nvarchar(50);
  set @suitabilityEnum = case
    when @suitability in ('suitable') then 1 
    when @suitability in ('less suitable', 'somewhat suitable', 'maybe suitable', 'possibly suitable') then 2 
    when @suitability in ('unsuitable', 'not suitable') then 3 
    else 0 end
  select @materialCategoryCode = Code from ListMaterialCategory where [Description] = @materialCategory;
  
  if exists (select * from [dbo].[SuitabilityTestTypeMaterialCategory] where TestTypeQestID = @testTypeQestID and MaterialCategoryCode = @materialCategoryCode)
  begin
    update [dbo].[SuitabilityTestTypeMaterialCategory]
      set Suitability = @suitabilityEnum, MinimumMass = @minimumMass, RecommendedMass = coalesce(@recommendedMass, @minimumMass)
      where  TestTypeQestID = @testTypeQestID and MaterialCategoryCode = @materialCategoryCode
  end
  else
  begin
    insert  [dbo].[SuitabilityTestTypeMaterialCategory] (TestTypeQestID, MaterialCategoryCode, Suitability, MinimumMass, RecommendedMass)
      values (@testTypeQestID, @materialCategoryCode, @suitabilityEnum, @minimumMass, coalesce(@recommendedMass, @minimumMass))
  end
GO

if not exists (select * from sys.objects where object_id = object_id('[dbo].[qest_Info_SuitabilityRuleConfiguration]') and type in (N'P', N'PC'))
  exec('create proc [dbo].[qest_Info_SuitabilityRuleConfiguration] as select 0 tmp;')
GO
alter proc [dbo].[qest_Info_SuitabilityRuleConfiguration]
as
select [Test] = case when sr.Idx = 0 then a.Value else '"' end
  , [Name] = case when sr.Idx = 0 then t.Value else '"' end
  , sr.Idx
  , [Test Conditions] =
    coalesce(cast(substring((
    select '; ' + c.Caption + ': ' + v.Value
    from TestConditionField c
      inner join SuitabilityRuleConfigurationTestConditions v on c.TestConditionUUID = v.TestConditionUUID
    where v.SuitabilityRuleConfigurationUUID = sr.QestUUID
    order by c.Caption asc
    for xml path('')),3,4000) as nvarchar(4000)) 
    , '-')
  , [Unaltered Structure] = sr.RequiresUnalteredStructure
  , [Unaltered Water Content] = sr.RequiresUnalteredWaterContent
  , [Unaltered Mineralogy] = sr.RequiresUnalteredMineralogy
  , [Minimum Diameter (mm)] = coalesce(convert(nvarchar(20), sr.MinimumDiameter * 1000), '-')
  , [Minimum Length (mm)] = coalesce(convert(nvarchar(20), sr.MinimumLength * 1000), '-')
  , [Minimum Mass (g)] = coalesce(convert(nvarchar(20), sr.MinimumMass * 1000), '-')
  , [Recommened Diameter (mm)] = coalesce(convert(nvarchar(20), sr.RecommendedDiameter * 1000), '-')
  , [Recommened Length (mm)] = coalesce(convert(nvarchar(20), sr.RecommendedLength * 1000), '-')
  , [Recommened Mass (g)] = coalesce(convert(nvarchar(20), sr.RecommendedMass * 1000), '-')
  
  , [Rock] = case when sr.Idx = 0 then case m_rk.Suitability when 1 then nchar(0x2713) when 2 then nchar(0x2248) when 3 then nchar(0x2717) else '' end else '"' end
  , [Gravel] = case when sr.Idx = 0 then case m_gr.Suitability when 1 then nchar(0x2713) when 2 then nchar(0x2248) when 3 then nchar(0x2717) else '' end else '"' end
  , [Sand] = case when sr.Idx = 0 then case m_sa.Suitability when 1 then nchar(0x2713) when 2 then nchar(0x2248) when 3 then nchar(0x2717) else '' end else '"' end
  , [Silt] = case when sr.Idx = 0 then case m_si.Suitability when 1 then nchar(0x2713) when 2 then nchar(0x2248) when 3 then nchar(0x2717) else '' end else '"' end
  , [Clay] = case when sr.Idx = 0 then case m_cl.Suitability when 1 then nchar(0x2713) when 2 then nchar(0x2248) when 3 then nchar(0x2717) else '' end else '"' end
  , [Peat] = case when sr.Idx = 0 then case m_pt.Suitability when 1 then nchar(0x2713) when 2 then nchar(0x2248) when 3 then nchar(0x2717) else '' end else '"' end
from QestObjects t
  inner join SuitabilityRuleConfiguration sr on t.QestID = sr.TestTypeQestID
  left join qestObjects a on a.QestID = t.QestID and a.Property = 'Abbreviation'
  left join SuitabilityTestTypeMaterialCategory m_rk on t.QestID = m_rk.TestTypeQestID and m_rk.MaterialCategoryCode = 'RK' and sr.Idx = 0
  left join SuitabilityTestTypeMaterialCategory m_gr on t.QestID = m_gr.TestTypeQestID and m_gr.MaterialCategoryCode = 'GR' and sr.Idx = 0
  left join SuitabilityTestTypeMaterialCategory m_sa on t.QestID = m_sa.TestTypeQestID and m_sa.MaterialCategoryCode = 'SA' and sr.Idx = 0
  left join SuitabilityTestTypeMaterialCategory m_si on t.QestID = m_si.TestTypeQestID and m_si.MaterialCategoryCode = 'SI' and sr.Idx = 0
  left join SuitabilityTestTypeMaterialCategory m_cl on t.QestID = m_cl.TestTypeQestID and m_cl.MaterialCategoryCode = 'CL' and sr.Idx = 0
  left join SuitabilityTestTypeMaterialCategory m_pt on t.QestID = m_pt.TestTypeQestID and m_pt.MaterialCategoryCode = 'PT' and sr.Idx = 0
where t.Property = 'Name'
order by a.Value, t.Value, t.QestID, sr.Idx
GO
