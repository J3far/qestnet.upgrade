-- Patch existing Concrete Samples with Template ID
----Patch US Concrete and Masonry Samples with Template ID
if exists(select TypeMetaTemplateID from (select top 10 TypeMetaTemplateID from DocumentConcreteDestructive order by QestUniqueID asc) T where T.TypeMetaTemplateID is null)
begin 
	declare @QStep int
	declare @QIndex int
	declare @QTotal int
	select @QTotal = COUNT(*) from DocumentConcreteDestructive
	set @QIndex = 1
	set @QStep = 50000
	while @QIndex <= @QTotal
	begin
		if @QTotal < @QIndex
			print 'US Concrete and Masonry Samples Updated With Type-Meta Template ID'
		else
			print 'US Concrete and Masonry Samples Updated With Type-Meta Template ID... ' + cast(@QIndex * 100 / @qtotal as nvarchar(2)) + '%'
		update c
		set TypeMetaTemplateID = case 
								 when c.CrushingMethod = 'RILEM CPC11.1-82' then 10
								 when c.CrushingMethod = 'RILEM CPC11.3-84' then 10
								 when c.CrushingMethod = 'BS 1881 Part 12' then 11
								 when c.CrushingMethod = 'BS EN 12504-1:00' then 11
								 when c.CrushingMethod = 'BS 6717' then 11
								 when c.CrushingMethod = 'BS 6073' then 11
								 when c.CrushingMethod = 'AASHTO T 22' then 8
								 when c.CrushingMethod = 'AASHTO T 97' then 8
								 when c.CrushingMethod = 'AASHTO T 177' then 8
								 when c.CrushingMethod = 'Tex-418-A' then 7
								 when c.CrushingMethod = 'Tex-424-A' then 7
								 when c.CrushingMethod = 'Tex-448-A' then 7
								 else 3 end
		from DocumentConcreteDestructive c
		where c.QestID in (1602,1605) and (QestUniqueID between @QIndex and @QIndex + @QStep) and TypeMetaTemplateID is null
		set @QIndex = @QIndex+@QStep
		continue
	end
	----Patch AU Concrete Samples with Template ID
	print 'AU Concrete Samples Updated With Type-Meta Template ID'
	update c
	set TypeMetaTemplateID = case when rlt.QestID = 18965 then 4
							 when rlt.QestID = 18945 then 5
							 when not cs.qestuniqueid is null then 13
							 else 14 end
	from DocumentConcreteDestructive c 
		 inner join qestReverseLookup rls on rls.QestUniqueID = c.qestuniqueid and rls.qestid = c.qestid
		 inner join qestReverseLookup rlw on rls.qestparentid = rlw.QestID and rls.QestUniqueParentID = rlw.QestUniqueID
		 left join qestReverseLookup rlt on rlt.QestParentID = rlw.QestID and rlt.QestUniqueParentID = rlw.QestUniqueID and rlt.QestID in (18965, 18945)
		 left join DocumentConcreteDestructiveSpecimen cs on cs.qestuniqueparentid = c.qestuniqueid and cs.qestparentid = c.qestid and cs.[Type] = 'GROCUBE'
	where c.QestID = 1604 and TypeMetaTemplateID is null

	----Patch NZ Concrete Samples with Template ID
	print 'NZ Concrete Samples Updated With Type-Meta Template ID'
	update c
	set TypeMetaTemplateID = 6
	from DocumentConcreteDestructive c 
	where c.QestID = 1603 and TypeMetaTemplateID is null
end

go



-- Patch existing Specimen Type Permissions to Meta Permissions
if exists(select 1 from RolePermissions rp inner join Activities a on rp.ActivityID = a.QestUniqueID inner join qestObjects o on o.QestID = a.QestID where o.Property = 'ActivityParent' and o.Value = '16100')
begin 
	----US Concrete (1602) Roles
	print 'Convert US Concrete Specimen Types Permission to Specimen Meta Permissions'
	if exists(
				select 1
				from Roles r
					 inner join RolePermissions rp on r.QestUniqueID = rp.RoleID
					 inner join Activities a on a.QestUniqueID = rp.ActivityID
				where a.QestID in (1602)
			)
	begin
	insert into RolePermissions (RoleID, LocationID, ActivityID, InstanceID, AllowRead, AllowEdit, AllowAdd, AllowDelete, AllowAuthorise, PermissionMap)
	select OldRP.RoleID, OldRP.locationID, 
		   NewRP.ActivityID, OldRP.instanceID, OldRP.Allowread, 
		   OldRP.AllowEdit, OldRP.AllowAdd, OldRP.AllowDelete, 
		   OldRP.AllowAuthorise, OldRP.PermissionMap
	from (select distinct rp.RoleID, am.QestUniqueID as 'ActivityID', rp.QestUniqueID
		  from RolePermissions rp 
			   inner join Activities at on at.QestUniqueID = rp.ActivityID 
			   inner join Activities atp on atp.QestUniqueID = at.QestUniqueParentID and atp.QestID = 16100
			   inner join QestObjects ot on at.QestID = ot.qestid and ot.Property = 'SpecimenBaseType'
			   inner join QestObjects om on om.Property = 'BaseType' and om.value = ot.Value
			   inner join QestObjects omd on omd.QestID = om.QestID and omd.Property = 'ActivityDependency' and omd.value = '1602'
			   inner join Activities am on am.QestID = om.qestid
		 ) NewRP
		 inner join RolePermissions OldRP on NewRP.QestUniqueID = OldRP.QestUniqueID and newrp.roleid = oldrp.roleid
	end
	----NZ Concrete (1603) Roles
	print 'Convert NZ Concrete Specimen Types Permission to Specimen Meta Permissions'
	if exists(
				select 1
				from Roles r
					 inner join RolePermissions rp on r.QestUniqueID = rp.RoleID
					 inner join Activities a on a.QestUniqueID = rp.ActivityID
				where a.QestID in (1603)
			)
	begin
	insert into RolePermissions (RoleID, LocationID, ActivityID, InstanceID, AllowRead, AllowEdit, AllowAdd, AllowDelete, AllowAuthorise, PermissionMap)
	select OldRP.RoleID, OldRP.locationID, 
		   NewRP.ActivityID, OldRP.instanceID, OldRP.Allowread, 
		   OldRP.AllowEdit, OldRP.AllowAdd, OldRP.AllowDelete, 
		   OldRP.AllowAuthorise, OldRP.PermissionMap
	from (select distinct rp.RoleID, am.QestUniqueID as 'ActivityID', rp.QestUniqueID
		  from RolePermissions rp 
			   inner join Activities at on at.QestUniqueID = rp.ActivityID 
			   inner join Activities atp on atp.QestUniqueID = at.QestUniqueParentID and atp.QestID = 16100
			   inner join QestObjects ot on at.QestID = ot.qestid and ot.Property = 'SpecimenBaseType'
			   inner join QestObjects om on om.Property = 'BaseType' and om.value = ot.Value
			   inner join QestObjects omd on omd.QestID = om.QestID and omd.Property = 'ActivityDependency' and omd.value = '1603'
			   inner join Activities am on am.QestID = om.qestid
		 ) NewRP
		 inner join RolePermissions OldRP on NewRP.QestUniqueID = OldRP.QestUniqueID and newrp.roleid = oldrp.roleid
	end

	----AU Concrete (1604) Roles
	print 'Convert AU Concrete Specimen Types Permission to Specimen Meta Permissions'
	if exists(
				select 1
				from Roles r
					 inner join RolePermissions rp on r.QestUniqueID = rp.RoleID
					 inner join Activities a on a.QestUniqueID = rp.ActivityID
				where a.QestID in (1604)
			)
	begin
	insert into RolePermissions (RoleID, LocationID, ActivityID, InstanceID, AllowRead, AllowEdit, AllowAdd, AllowDelete, AllowAuthorise, PermissionMap)
	select OldRP.RoleID, OldRP.locationID, 
		   NewRP.ActivityID, OldRP.instanceID, OldRP.Allowread, 
		   OldRP.AllowEdit, OldRP.AllowAdd, OldRP.AllowDelete, 
		   OldRP.AllowAuthorise, OldRP.PermissionMap
	from (select distinct rp.RoleID, am.QestUniqueID as 'ActivityID', rp.QestUniqueID
		  from RolePermissions rp 
			   inner join Activities at on at.QestUniqueID = rp.ActivityID 
			   inner join Activities atp on atp.QestUniqueID = at.QestUniqueParentID and atp.QestID = 16100
			   inner join QestObjects ot on at.QestID = ot.qestid and ot.Property = 'SpecimenBaseType'
			   inner join QestObjects om on om.Property = 'BaseType' and om.value = ot.Value
			   inner join QestObjects omd on omd.QestID = om.QestID and omd.Property = 'ActivityDependency' and omd.value = '1604'
			   inner join Activities am on am.QestID = om.qestid
		 ) NewRP
		 inner join RolePermissions OldRP on NewRP.QestUniqueID = OldRP.QestUniqueID and newrp.roleid = oldrp.roleid
	end

	----US Masonry (1605) Roles
	print 'Convert US Masonry Specimen Types Permission to Specimen Meta Permissions'
	if exists(
				select 1
				from Roles r
					 inner join RolePermissions rp on r.QestUniqueID = rp.RoleID
					 inner join Activities a on a.QestUniqueID = rp.ActivityID
				where a.QestID in (1605)
			)
	begin
	insert into RolePermissions (RoleID, LocationID, ActivityID, InstanceID, AllowRead, AllowEdit, AllowAdd, AllowDelete, AllowAuthorise, PermissionMap)
	select OldRP.RoleID, OldRP.locationID, 
		   NewRP.ActivityID, OldRP.instanceID, OldRP.Allowread, 
		   OldRP.AllowEdit, OldRP.AllowAdd, OldRP.AllowDelete, 
		   OldRP.AllowAuthorise, OldRP.PermissionMap
	from (select distinct rp.RoleID, am.QestUniqueID as 'ActivityID', rp.QestUniqueID
		  from RolePermissions rp 
			   inner join Activities at on at.QestUniqueID = rp.ActivityID 
			   inner join Activities atp on atp.QestUniqueID = at.QestUniqueParentID and atp.QestID = 16100
			   inner join QestObjects ot on at.QestID = ot.qestid and ot.Property = 'SpecimenBaseType'
			   inner join QestObjects om on om.Property = 'BaseType' and om.value = ot.Value
			   inner join QestObjects omd on omd.QestID = om.QestID and omd.Property = 'ActivityDependency' and omd.value = '1605'
			   inner join Activities am on am.QestID = om.qestid
		 ) NewRP
		 inner join RolePermissions OldRP on NewRP.QestUniqueID = OldRP.QestUniqueID and newrp.roleid = oldrp.roleid
	end

	----Delete all type permissions
	print 'Delete All Now Defunct Specimen Types Permission'
	delete rp from RolePermissions rp 
				   inner join Activities a on a.QestUniqueID = rp.ActivityID
				   inner join QestObjects ot on a.QestID = ot.qestid and ot.Property = 'ActivityParent'
				where ot.Value = '16100'
end

go



-- Patch for new field "CrushingMethodQestID"
--Masonry
if exists(select CrushingMethodQestID from (select top 10 CrushingMethodQestID from DocumentConcreteDestructive where QestID = 1605 order by QestUniqueID asc) T where T.CrushingMethodQestID is null)
begin 
	update C
	set CrushingMethodQestID = TM.CrushingMethodQestID
	from DocumentConcreteDestructive C
	     left join 
	     (
			select o1.QestID as 'CrushingMethodQestID',  o3.Value as 'CrushingMethod'
			from qestObjects o1 
				 inner join qestObjects o2 on o1.QestID = o2.QestID
				 inner join qestObjects o3 on o1.QestID = o3.QestID
			where o1.Property = 'ActivityParent' and o1.Value = '66500' and o2.Property = 'ActivityDependency' and o2.Value = '1605'
			and o3.Property = 'Method'
		 ) TM on C.CrushingMethod = TM.CrushingMethod
	where C.QestID = 1605 and C.CrushingMethodQestID is null and not C.CrushingMethod is null
end
--Concrete
if exists(select CrushingMethodQestID from (select top 10 CrushingMethodQestID from DocumentConcreteDestructive where QestID = 1602 order by QestUniqueID asc) T where T.CrushingMethodQestID is null)
begin 
	update C
	set CrushingMethodQestID = TM.CrushingMethodQestID
	from DocumentConcreteDestructive C
	     left join 
	     (
			select o1.QestID as 'CrushingMethodQestID',  o3.Value as 'CrushingMethod'
			from qestObjects o1 
				 inner join qestObjects o2 on o1.QestID = o2.QestID
				 inner join qestObjects o3 on o1.QestID = o3.QestID
			where o1.Property = 'ActivityParent' and o1.Value = '66000' and o2.Property = 'ActivityDependency' and o2.Value = '1602'
			and o3.Property = 'Method'
		 ) TM on C.CrushingMethod = TM.CrushingMethod
	where C.QestID = 1602 and C.CrushingMethodQestID is null and not C.CrushingMethod is null
end

go


--Patch to convert existing Masonry Samples over to use "ASTM (2007)" (id = 17) instead of "ASTM" (id = 3)
if exists(select TypeMetaTemplateID from (select top 10 TypeMetaTemplateID from DocumentConcreteDestructive where QestID = 1605 order by QestUniqueID asc) T where T.TypeMetaTemplateID = 3)
begin 
	update C
	set TypeMetaTemplateID = 17
	from DocumentConcreteDestructive C
	where C.QestID = 1605 and C.TypeMetaTemplateID = 3
end

go
