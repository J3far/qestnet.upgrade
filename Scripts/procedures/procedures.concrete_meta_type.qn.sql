--Stored Procs

if not exists (select * from sys.objects where object_id = object_id(N'[dbo].[qest_TypeMeta_GetTestMethodList]') and type in (N'P', N'PC'))
  exec ('create proc [dbo].[qest_TypeMeta_GetTestMethodList] as select 0 tmp');
go
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
    
	select o1.QestID as QestID, o1.Value as Method, o3.Value as Metas, o4.Value as Sizes
    from            qestObjects o1
         inner join qestObjects o2 on o1.QestID = o2.QestID
         inner join qestObjects o3 on o1.QestID = o3.QestID
         left join  qestObjects o4 on o1.QestID = o4.QestID and o4.Property = 'Size' 
         inner join qestObjects o5 on o1.QestID = o5.QestID 
		 inner join Activities a   on a.QestID  = o1.QestID and isnull(a.Inactive, 0) = 0
    where     o1.Property = 'Method' 
          and o2.Property = 'ActivityParent' and o2.Value = @TestMethodActivityParent 
          and o3.Property = 'Metas' 
          and o5.Property = 'Sortable'
    order by o5.Value
go


if not exists (select * from sys.objects where object_id = object_id(N'[dbo].[qest_TypeMeta_GetTypeMetaSizeList]') and type in (N'P', N'PC'))
  exec ('create proc [dbo].[qest_TypeMeta_GetTypeMetaSizeList] as select 0 tmp');
go
alter proc [dbo].qest_TypeMeta_GetTypeMetaSizeList
  @SampleQestID int, @TemplateUniqueID int, @LabNo int
as
	select M.[Type], M.MetaQestID, O.Size
	from
	(
		select distinct TemplateQestUniqueID, TemplateName, MetaQestID, [Type]
		from QestSpecimenTypeMetaMap m
			left join Activities a on a.QestID = m.MetaQestID
		where SampleQestID = @SampleQestID 
			and TemplateQestUniqueID = @TemplateUniqueID 
			and isnull(QestOwnerLabNo, 0) in (0, @LabNo)
			and isnull(a.Inactive, 0) = 0
	) M
    left join
	(
		select o1.Value as [Type], cast(o3.Value as int) as Size
		from qestObjects o1
			inner join qestObjects o2 
				on o2.QestID = o1.QestID 
				and o2.Property = 'ActivityParent' 
				and o2.Value = '16100'
			left join qestObjects o3
				on o3.QestID = o1.QestID
				and o3.Property = 'Size'
		where o1.Property = 'Name'
			and isnumeric(o3.Value) = 1
    ) O
    on M.[Type] = O.[Type]
go


if not exists (select * from sys.objects where object_id = object_id(N'[dbo].[qest_TypeMeta_GetTemplateMetaNotesList]') and type in (N'P', N'PC'))
  exec ('create proc [dbo].[qest_TypeMeta_GetTemplateMetaNotesList] as select 0 tmp');
GO
alter proc [dbo].qest_TypeMeta_GetTemplateMetaNotesList
  @SampleQestID int, @TemplateUniqueID int, @LabNo int
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
         inner join 
         (Select Coalesce(a.TemplateQestUniqueID, b.TemplateQestUniqueID) as 'TemplateQestUniqueID', Coalesce(a.MetaQestID, b.MetaQestID) as 'MetaQestID' from 
	     (select distinct TemplateQestUniqueID, TemplateName, MetaQestID from QestSpecimenTypeMetaMap where SampleQestID = @SampleQestID and QestOwnerLabNo = @LabNo) a
	     full join
	     (select distinct TemplateQestUniqueID, TemplateName, MetaQestID from QestSpecimenTypeMetaMap where SampleQestID = @SampleQestID and isnull(QestOwnerLabNo,0) = 0) b
	      on a.TemplateName = b.TemplateName
	     ) M on M.MetaQestID = O.MetaID     
    where M.TemplateQestUniqueID = @TemplateUniqueID
    
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
	(select distinct TemplateQestUniqueID, TemplateName, IsDefaultTemplate from QestSpecimenTypeMetaMap where SampleQestID = @SampleQestID and QestOwnerLabNo = @LabNo) a
	full join
	(select distinct TemplateQestUniqueID, TemplateName, IsDefaultTemplate from QestSpecimenTypeMetaMap where SampleQestID = @SampleQestID and isnull(QestOwnerLabNo,0) = 0) b
	on a.TemplateName = b.TemplateName
  end

GO

if not exists (select * from sys.objects where object_id = object_id(N'[dbo].[qest_TypeMeta_GetMetaID]') and type in (N'P', N'PC'))
  exec ('create proc [dbo].[qest_TypeMeta_GetMetaID] as select 0 tmp');
GO
alter proc [dbo].qest_TypeMeta_GetMetaID
  @Type nvarchar(8), @TemplateID int, @SampleQestID int, @LabNo int
as
  if @LabNo = 0 
  begin
	select MetaQestID from QestSpecimenTypeMetaMap where SampleQestID = @SampleQestID and isnull(QestOwnerLabNo,0) = @LabNo and [Type] = @Type and TemplateQestUniqueID = @TemplateID
  end
  else
  begin
	Select Coalesce(a.MetaQestID, b.MetaQestID) as 'MetaQestID' from 
	(select distinct MetaQestID from QestSpecimenTypeMetaMap where SampleQestID = @SampleQestID and QestOwnerLabNo = @LabNo and [Type] = @Type and TemplateQestUniqueID = @TemplateID) a
	full join
	(select distinct MetaQestID from QestSpecimenTypeMetaMap where SampleQestID = @SampleQestID and isnull(QestOwnerLabNo,0) = 0 and [Type] = @Type and TemplateQestUniqueID = @TemplateID) b
	on a.MetaQestID = b.MetaQestID
  end

GO