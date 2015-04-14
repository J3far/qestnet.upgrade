--Stored Procs

if exists (select * from sys.objects where object_id = object_id(N'[dbo].[qest_TypeBrand_GetTestMethodList]') and type in (N'P', N'PC'))
  exec ('drop proc qest_TypeBrand_GetTestMethodList');
go
if exists (select * from sys.objects where object_id = object_id(N'[dbo].[qest_TypeBrand_GetTypeMetaSizeList]') and type in (N'P', N'PC'))
  exec ('drop proc qest_TypeBrand_GetTypeBrandSizeList');
GO
if exists (select * from sys.objects where object_id = object_id(N'[dbo].[qest_TypeBrand_GetTemplateBrandNotesList]') and type in (N'P', N'PC'))
  exec ('drop proc qest_TypeBrand_GetTemplateBrandNotesList');
GO
if exists (select 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'QestSpecimenTypeBrandMap') 
  exec ('drop table QestSpecimenTypeBrandMap');
GO


if not exists (select * from sys.objects where object_id = object_id(N'[dbo].[qest_TypeMeta_GetTestMethodList]') and type in (N'P', N'PC'))
  exec ('create proc [dbo].[qest_TypeMeta_GetTestMethodList] as select 0 tmp');
GO
alter proc [dbo].qest_TypeMeta_GetTestMethodList
  @SampleQestID int
as
    declare @TestMethodActivityParent nvarchar(8)
    if @SampleQestID = 1602
       begin set @TestMethodActivityParent = '66000' end
    else
       begin
       if @SampleQestID = 1605
          begin set @TestMethodActivityParent = '66500' end
       else
          begin set @TestMethodActivityParent = '-1' end
	   end
	
    
	select o1.Value as 'Method', o3.Value as 'Metas', o4.Value as 'Size' 
    from            qestObjects o1 
         inner join qestObjects o2 on o1.QestID = o2.QestID 
         inner join qestObjects o3 on o1.QestID = o3.QestID 
         left join  qestObjects o4 on o1.QestID = o4.QestID and o4.Property = 'Size' 
    where     o1.Property = 'Method' 
          and o2.Property = 'ActivityParent' and o2.Value = @TestMethodActivityParent 
          and o3.Property = 'Metas' 

GO


if not exists (select * from sys.objects where object_id = object_id(N'[dbo].[qest_TypeMeta_GetTypeMetaSizeList]') and type in (N'P', N'PC'))
  exec ('create proc [dbo].[qest_TypeMeta_GetTypeMetaSizeList] as select 0 tmp');
GO
alter proc [dbo].qest_TypeMeta_GetTypeMetaSizeList
  @SampleQestID int
as

    Select T.TypeName, B.MetaID, T.Size 
    From 
       (SELECT o2.Value AS 'BaseType', o2.QestID AS 'MetaID' 
        FROM           qestObjects o1 
            inner join qestObjects o2 on o1.QestID = o2.QestID 
            inner join qestObjects o3 on o1.QestID = o3.QestID 
        WHERE     o1.Property = 'ActivityParent' and o1.Value = 67000 
              and o2.Property = 'Basetype' 
              and o3.Property = 'ActivityDependency' and o3.Value = @SampleQestID) B 
        left join 
        (SELECT o4.Value AS 'SpecimenBaseType', o6.Value AS 'TypeName', CAST(o7.Value AS INT) AS 'Size' 
        FROM           qestObjects o4 
             inner join qestObjects o5 on o4.QestID = o5.QestID 
             inner join qestObjects o6 on o4.QestID = o6.QestID 
             left join  qestObjects o7 on o4.QestID = o7.QestID and o7.Property = 'Size' and ISNUMERIC(o7.Value) = 1 
         WHERE o4.Property = 'SpecimenBaseType' 
           and o5.Property = 'ActivityParent' and o5.Value = 16100 
           and o6.Property = 'Name') T on T.SpecimenBaseType = B.BaseType 
    Order By T.SpecimenBaseType, T.Size
GO


if not exists (select * from sys.objects where object_id = object_id(N'[dbo].[qest_TypeMeta_GetTemplateMetaNotesList]') and type in (N'P', N'PC'))
  exec ('create proc [dbo].[qest_TypeMeta_GetTemplateMetaNotesList] as select 0 tmp');
GO
alter proc [dbo].qest_TypeMeta_GetTemplateMetaNotesList
  @SampleQestID int, @TemplateUniqueID int
as
    select distinct O.Notes, O.NoteFamily, O.BaseType
    from (select o1.value as 'Notes', o1.Property as 'NoteFamily', o1.QestID as 'MetaID', o3.Value as 'BaseType' 
          from            qestObjects o1
               inner join qestObjects o2 on o1.QestID = o2.QestID
               inner join qestObjects o3 on o1.QestID = o3.QestID
          where     o1.Property like 'Note%' 
                and o2.Property = 'ActivityParent' and o2.Value = 67000
                and o3.Property = 'BaseType'
         ) O     
         inner join QestSpecimenTypeMetaMap M on M.MetaQestID = O.MetaID     
    where M.TemplateQestUniqueID = @TemplateUniqueID and M.SampleQestID = @SampleQestID
    
GO

if not exists (select * from sys.objects where object_id = object_id(N'[dbo].[qest_TypeMeta_GetTemplateList]') and type in (N'P', N'PC'))
  exec ('create proc [dbo].[qest_TypeMeta_GetTemplateList] as select 0 tmp');
GO
alter proc [dbo].qest_TypeMeta_GetTemplateList
  @SampleQestID int, @LabNo int
as
  if @LabNo = 0 
  begin
	select distinct TemplateQestUniqueID, TemplateName, IsDefaultTemplate from QestSpecimenTypeMetaMap where SampleQestID = @SampleQestID and isnull(QestOwnerLabNo,0) = @LabNo
  end
  else
  begin
	Select Coalesce(a.TemplateName, b.TemplateName) as 'TemplateName', Coalesce(a.TemplateQestUniqueID, b.TemplateQestUniqueID) as 'TemplateQestUniqueID', Coalesce(a.IsDefaultTemplate, b.IsDefaultTemplate) as 'IsDefaultTemplate' from 
	(select distinct TemplateQestUniqueID, TemplateName, IsDefaultTemplate from QestSpecimenTypeMetaMap where SampleQestID = @SampleQestID and isnull(QestOwnerLabNo,0) = 0) a
	full join
	(select distinct TemplateQestUniqueID, TemplateName, IsDefaultTemplate from QestSpecimenTypeMetaMap where SampleQestID = @SampleQestID and QestOwnerLabNo = @LabNo) b
	on a.TemplateName = b.TemplateName
  end

GO