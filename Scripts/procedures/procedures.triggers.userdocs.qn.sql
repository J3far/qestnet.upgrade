IF OBJECT_ID('TR_UserDocumentBase_TableSync_Insert', 'TR') IS NOT NULL
	DROP TRIGGER TR_UserDocumentBase_TableSync_Insert
GO

CREATE TRIGGER TR_UserDocumentBase_TableSync_Insert
ON UserDocumentBase AFTER INSERT
AS
  set nocount on
  
  create table #tmpTableSync_Insert
  (
    QestID int null,
    QestTier smallint null,
    QestParentID int null,
    QestUniqueParentID int null,
    QestUniqueID int not null,
    QestComplete bit null,
    QestCreatedBy int null,
    QestCreatedDate datetime null,
    QestModifiedBy int null,
    QestModifiedDate datetime null,
    QestOwnerLabNo int null,
    QestLabNo int null,
    QestTestedBy int null,
    QestTestedDate datetime null,
    QestCheckedBy int null,
    QestCheckedDate datetime null,
    QestOutOfSpecification bit null,
    QestSpecification nvarchar(50),
    QestStatusFlags int null,
    QestUrgent bit null,
    QestUUID uniqueidentifier not null primary key,
    TableName nvarchar(128) not null
  )
  
  insert into #tmpTableSync_Insert (
    QestID,
    QestTier,
    QestParentID,
    QestUniqueParentID,
    QestUniqueID,
    QestComplete,
    QestCreatedBy,
    QestCreatedDate,
    QestModifiedBy,
    QestModifiedDate,
    QestOwnerLabNo,
    QestTestedBy,
    QestTestedDate,
    QestCheckedBy,
    QestCheckedDate,
    QestOutOfSpecification,
    QestSpecification,
    QestStatusFlags,
    QestUrgent,
    QestLabNo,
    QestUUID,
    TableName
  )
  select
    i.QestID,
    i.QestTier,
    i.QestParentID,
    i.QestUniqueParentID,
    i.QestUniqueID,
    i.QestComplete,
    i.QestCreatedBy,
    i.QestCreatedDate,
    i.QestModifiedBy,
    i.QestModifiedDate,
    i.QestOwnerLabNo,
    i.QestTestedBy,
    i.QestTestedDate,
    i.QestCheckedBy,
    i.QestCheckedDate,
    i.QestOutOfSpecification,
    i.QestSpecification,
    i.QestStatusFlags,
    i.QestUrgent,
    i.QestLabNo,
    i.QestUUID,
    qo_table.Value as TableName
  from
    inserted i
  inner join qestObjects qo_table on qo_table.QestID = i.QestID and qo_table.Property = 'TableName'
  where isnull(i.SuppressSyncTrigger,0) = 0 and i.QestUUID is not null
    
  declare @sqlexec table
  (
    ID int not null identity(1,1) primary key,
    SQLText nvarchar(4000) not null,
    TableName nvarchar(128) not null
  )
    
  insert into @sqlexec (SQLText, TableName)
  select N'set identity_insert ' + TableName + N' on;
    insert into ' + TableName + N' (
      QestID,
      QestTier,
      QestParentID,
      QestUniqueParentID,
      QestUniqueID,
      QestComplete,
      QestCreatedBy,
      QestCreatedDate,
      QestModifiedBy,
      QestModifiedDate,
      QestOwnerLabNo,
      QestTestedBy,
      QestTestedDate,
      QestCheckedBy,
      QestCheckedDate,
      QestOutOfSpecification,
      QestSpecification,
      QestStatusFlags,
      QestUrgent,
      QestLabNo,
      QestUUID,
      SuppressSyncTrigger)
    select QestID,
      QestTier,
      QestParentID,
      QestUniqueParentID,
      QestUniqueID,
      QestComplete,
      QestCreatedBy,
      QestCreatedDate,
      QestModifiedBy,
      QestModifiedDate,
      QestOwnerLabNo,
      QestTestedBy,
      QestTestedDate,
      QestCheckedBy,
      QestCheckedDate,
      QestOutOfSpecification,
      QestSpecification,
      QestStatusFlags,
      QestUrgent,
      QestLabNo,
      QestUUID,
      1 as SuppressSyncTrigger
    from #tmpTableSync_Insert i
    where not exists (select 1 from ' + TableName + N' u where u.QestUUID = i.QestUUID);'
    , TableName
  from #tmpTableSync_Insert i
  group by i.TableName
	
	declare @id int
	declare @rowcount int
	declare @table_name nvarchar(128)
	declare @sql nvarchar(4000)
	while (select count(*) from @sqlexec s) > 0
	begin
	  select top 1 @id = ID, @sql = SQLText, @table_name = TableName from @sqlexec
	  exec sp_executesql @sql
	  set @rowcount = @@ROWCOUNT
	  set @sql = 'set identity_insert '+ @table_name + N' off;'
	  exec sp_executesql @sql
	  if @rowcount > 0
	    raiserror(N'Synced table %s from UserDocumentBase, %i records inserted.', 0, 1, @table_name, @rowcount)
	  delete from @sqlexec where ID = @id
	end
GO

IF OBJECT_ID('TR_UserDocumentBase_TableSync_Update', 'TR') IS NOT NULL
	DROP TRIGGER TR_UserDocumentBase_TableSync_Update
GO

CREATE TRIGGER TR_UserDocumentBase_TableSync_Update
ON UserDocumentBase AFTER UPDATE
AS
  set nocount on
  
  create table #tmpTableSync_Update
  (
    QestID int null,
    QestTier smallint null,
    QestParentID int null,
    QestUniqueParentID int null,
    QestUniqueID int not null,
    QestComplete bit null,
    QestCreatedBy int null,
    QestCreatedDate datetime null,
    QestModifiedBy int null,
    QestModifiedDate datetime null,
    QestOwnerLabNo int null,
    QestLabNo int null,
    QestTestedBy int null,
    QestTestedDate datetime null,
    QestCheckedBy int null,
    QestCheckedDate datetime null,
    QestOutOfSpecification bit null,
    QestSpecification nvarchar(50),
    QestStatusFlags int null,
    QestUrgent bit null,
    QestUUID uniqueidentifier not null primary key,
    TableName nvarchar(128) not null
  )
  
  insert into #tmpTableSync_Update (
    QestID,
    QestTier,
    QestParentID,
    QestUniqueParentID,
    QestUniqueID,
    QestComplete,
    QestCreatedBy,
    QestCreatedDate,
    QestModifiedBy,
    QestModifiedDate,
    QestOwnerLabNo,
    QestTestedBy,
    QestTestedDate,
    QestCheckedBy,
    QestCheckedDate,
    QestOutOfSpecification,
    QestSpecification,
    QestStatusFlags,
    QestUrgent,
    QestLabNo,
    QestUUID,
    TableName
  )
  select
    i.QestID,
    i.QestTier,
    i.QestParentID,
    i.QestUniqueParentID,
    i.QestUniqueID,
    i.QestComplete,
    i.QestCreatedBy,
    i.QestCreatedDate,
    i.QestModifiedBy,
    i.QestModifiedDate,
    i.QestOwnerLabNo,
    i.QestTestedBy,
    i.QestTestedDate,
    i.QestCheckedBy,
    i.QestCheckedDate,
    i.QestOutOfSpecification,
    i.QestSpecification,
    i.QestStatusFlags,
    i.QestUrgent,
    i.QestLabNo,
    i.QestUUID,
    qo_table.Value as TableName
  from 
    inserted i
  inner join qestObjects qo_table on qo_table.QestID = i.QestID and qo_table.Property = 'TableName'
  where isnull(i.SuppressSyncTrigger,0) = 0 and i.QestUUID is not null
  
  declare @sqlexec table
  (
    ID int not null identity(1,1) primary key,
    SQLText nvarchar(4000) not null,
    TableName nvarchar(128) not null
  )
    
  insert into @sqlexec (SQLText, TableName)
  select N'update ' + TableName + N'
    set QestID = i.QestID,
		  QestTier = i.QestTier,
      QestParentID = i.QestParentID,
      QestUniqueParentID = i.QestUniqueParentID,
      QestComplete = i.QestComplete,
      QestCreatedBy = i.QestCreatedBy,
      QestCreatedDate = i.QestCreatedDate,
      QestModifiedBy = i.QestModifiedBy,
      QestModifiedDate = i.QestModifiedDate,
      QestOwnerLabNo = i.QestOwnerLabNo,
      QestTestedBy = i.QestTestedBy,
      QestTestedDate = i.QestTestedDate,
      QestCheckedBy = i.QestCheckedBy,
      QestCheckedDate = i.QestCheckedDate,
      QestOutOfSpecification = i.QestOutOfSpecification,
      QestSpecification = i.QestSpecification,
      QestStatusFlags = i.QestStatusFlags,
      QestUrgent = i.QestUrgent,
      QestLabNo = i.QestLabNo,
      QestUUID = i.QestUUID,
      SuppressSyncTrigger = 1
    from ' + TableName + ' u
      inner join #tmpTableSync_Update i on i.QestUUID = u.QestUUID',
    TableName
  from #tmpTableSync_Update i
  group by i.TableName
  
	declare @id int
	declare @rowcount int
	declare @table_name nvarchar(128)
	declare @sql nvarchar(4000)
	while (select count(*) from @sqlexec s) > 0
	begin
	  select top 1 @id = ID, @sql = SQLText, @table_name = TableName from @sqlexec
	  exec sp_executesql @sql
	  set @rowcount = @@ROWCOUNT
	  if @rowcount > 0
	    raiserror(N'Synced table %s from UserDocumentBase, %i records updated.', 0, 1, @table_name, @rowcount)
	  delete from @sqlexec where ID = @id
	end
GO

IF OBJECT_ID('TR_UserDocumentBase_TableSync_Delete', 'TR') IS NOT NULL
	DROP TRIGGER TR_UserDocumentBase_TableSync_Delete
GO

CREATE TRIGGER TR_UserDocumentBase_TableSync_Delete
ON UserDocumentBase AFTER DELETE
AS
  set nocount on
  
  create table #tmpTableSync_Delete
  (
    QestUUID uniqueidentifier not null primary key,
    TableName nvarchar(128) not null
  )
  
  insert into #tmpTableSync_Delete (QestUUID, TableName)
  select 
    QestUUID, 
    qo_table.Value as TableName
  from 
    deleted d
  inner join qestObjects qo_table on qo_table.QestID = d.QestID and qo_table.Property = 'TableName'
  where d.QestUUID is not null
 
  declare @sqlexec table
  (
    ID int not null identity(1,1) primary key,
    SQLText nvarchar(4000) not null,
    TableName nvarchar(128) not null
  )
    
  insert into @sqlexec (SQLText, TableName)
  select N'delete ' + TableName + N'
    from ' + TableName + ' u
      inner join #tmpTableSync_Delete d on d.QestUUID = u.QestUUID',
    TableName
  from #tmpTableSync_Delete d
  group by d.TableName
  
  declare @id int
	declare @rowcount int
	declare @table_name nvarchar(128)
	declare @sql nvarchar(4000)
	while (select count(*) from @sqlexec s) > 0
	begin
	  select top 1 @id = ID, @sql = SQLText, @table_name = TableName from @sqlexec
	  exec sp_executesql @sql
	  set @rowcount = @@ROWCOUNT
	  if @rowcount > 0
	    raiserror(N'Synced table %s from UserDocumentBase, %i records deleted.', 0, 1, @table_name, @rowcount)
	  delete from @sqlexec where ID = @id
	end
 
go

if exists (select 1 from INFORMATION_SCHEMA.ROUTINES r where r.ROUTINE_SCHEMA = 'dbo' and r.ROUTINE_NAME = 'qest_UserDocumentBaseInitialise')
begin
  drop proc dbo.qest_UserDocumentBaseInitialise
end
go

create proc dbo.qest_UserDocumentBaseInitialise @QestID int = 0
as
set nocount on

declare @table_name nvarchar(128)
if not (@QestID = 0 or @QestID between 19000 and 19999)
begin
  raiserror(N'QestID parameter must be 0 to apply to all tables, or between 19000 and 19999 to target a specific user document.', 16, 1)
  return
end
else
begin
  select @table_name = Value from qestObjects where QestID = @QestID and Property = 'TableName'
end

declare @sqlexec table
(
  ID int not null identity(1,1),
  SQLText_Schema nvarchar(4000) null,
  SQLText_TR_I_Drop nvarchar(4000) null,
  SQLText_TR_I_Create nvarchar(4000) null,
  SQLText_TR_U_Drop nvarchar(4000) null,
  SQLText_TR_U_Create nvarchar(4000) null,
  SQLText_TR_D_Drop nvarchar(4000) null,
  SQLText_TR_D_Create nvarchar(4000) null,
  SQLText_Insert nvarchar(4000) null,
  TableName nvarchar(128) not null
)

insert into @sqlexec (
  SQLText_Schema, 
  SQLText_TR_I_Drop, 
  SQLText_TR_I_Create, 
  SQLText_TR_U_Drop, 
  SQLText_TR_U_Create, 
  SQLText_TR_D_Drop, 
  SQLText_TR_D_Create, 
  SQLText_Insert, 
  TableName)
select 
  N'if not exists (select 1 from INFORMATION_SCHEMA.COLUMNS c where c.TABLE_NAME = ''' + qo_table.Value + ''' and c.COLUMN_NAME = ''SuppressSyncTrigger'')
  begin
    alter table ' + qo_table.Value + ' add SuppressSyncTrigger bit not null default(0)
  end',
  N'IF OBJECT_ID(''TR_' + qo_table.Value + '_TableSync_Insert'', ''TR'') IS NOT NULL
	  DROP TRIGGER TR_' + qo_table.Value + '_TableSync_Insert',
  N'CREATE TRIGGER TR_' + qo_table.Value + '_TableSync_Insert
  ON ' + qo_table.Value + ' AFTER INSERT
  AS
    set nocount on
    declare @rowcount int
    
    insert into UserDocumentBase (
      QestID,
      QestTier,
      QestParentID,
      QestUniqueParentID,
      QestUniqueID,
      QestComplete,
      QestCreatedBy,
      QestCreatedDate,
      QestModifiedBy,
      QestModifiedDate,
      QestOwnerLabNo,
      QestTestedBy,
      QestTestedDate,
      QestCheckedBy,
      QestCheckedDate,
      QestOutOfSpecification,
      QestSpecification,
      QestStatusFlags,
      QestUrgent,
      QestLabNo,
      QestUUID,
      SuppressSyncTrigger)
    select
      QestID,
      QestTier,
      QestParentID,
      QestUniqueParentID,
      QestUniqueID,
      QestComplete,
      QestCreatedBy,
      QestCreatedDate,
      QestModifiedBy,
      QestModifiedDate,
      QestOwnerLabNo,
      QestTestedBy,
      QestTestedDate,
      QestCheckedBy,
      QestCheckedDate,
      QestOutOfSpecification,
      QestSpecification,
      QestStatusFlags,
      QestUrgent,
      QestLabNo,
      QestUUID,
      1 as SuppressSyncTrigger
    from inserted i
    where not exists (select 1 from UserDocumentBase udb where udb.QestUUID = i.QestUUID)
    and isnull(i.SuppressSyncTrigger, 0) = 0
    and i.QestID between 19000 and 19999
    
    set @rowcount = @@ROWCOUNT
    if @rowcount > 0
      raiserror(N''Synced table UserDocumentBase from ' + qo_table.Value + ', %i records inserted.'', 0, 1, @rowcount)',
  N'IF OBJECT_ID(''TR_' + qo_table.Value + '_TableSync_Update'', ''TR'') IS NOT NULL
	  DROP TRIGGER TR_' + qo_table.Value + '_TableSync_Update',
  N'CREATE TRIGGER TR_' + qo_table.Value + '_TableSync_Update
  ON ' + qo_table.Value + ' AFTER UPDATE
  AS
    set nocount on
    declare @rowcount int

    update UserDocumentBase
    set QestID = i.QestID,
		    QestTier = i.QestTier,
        QestParentID = i.QestParentID,
        QestUniqueParentID = i.QestUniqueParentID,
        QestComplete = i.QestComplete,
        QestCreatedBy = i.QestCreatedBy,
        QestCreatedDate = i.QestCreatedDate,
        QestModifiedBy = i.QestModifiedBy,
        QestModifiedDate = i.QestModifiedDate,
        QestOwnerLabNo = i.QestOwnerLabNo,
        QestTestedBy = i.QestTestedBy,
        QestTestedDate = i.QestTestedDate,
        QestCheckedBy = i.QestCheckedBy,
        QestCheckedDate = i.QestCheckedDate,
        QestOutOfSpecification = i.QestOutOfSpecification,
        QestSpecification = i.QestSpecification,
        QestStatusFlags = i.QestStatusFlags,
        QestUrgent = i.QestUrgent,
        QestLabNo = i.QestLabNo,
        QestUUID = i.QestUUID,
        SuppressSyncTrigger = 1
    from inserted i
    where UserDocumentBase.QestUUID = i.QestUUID 
    and isnull(i.SuppressSyncTrigger, 0) = 0
    and i.QestID between 19000 and 19999
    
    set @rowcount = @@ROWCOUNT
    if @rowcount > 0
      raiserror(N''Synced table UserDocumentBase from ' + qo_table.Value + ', %i records updated.'', 0, 1, @rowcount)',
  N'IF OBJECT_ID(''TR_' + qo_table.Value + '_TableSync_Delete'', ''TR'') IS NOT NULL
	  DROP TRIGGER TR_' + qo_table.Value + '_TableSync_Delete',
  N'CREATE TRIGGER TR_' + qo_table.Value + '_TableSync_Delete
  ON ' + qo_table.Value + ' AFTER DELETE
  AS
    set nocount on
    declare @rowcount int
    
    delete UserDocumentBase
    from deleted d
    where UserDocumentBase.QestUUID = d.QestUUID
    and d.QestID between 19000 and 19999
    
    set @rowcount = @@ROWCOUNT
    if @rowcount > 0
      raiserror(N''Synced table UserDocumentBase from ' + qo_table.Value + ', %i records deleted.'', 0, 1, @rowcount)',
  N'insert into UserDocumentBase (
    QestID,
    QestTier,
    QestParentID,
    QestUniqueParentID,
    QestUniqueID,
    QestComplete,
    QestCreatedBy,
    QestCreatedDate,
    QestModifiedBy,
    QestModifiedDate,
    QestOwnerLabNo,
    QestTestedBy,
    QestTestedDate,
    QestCheckedBy,
    QestCheckedDate,
    QestOutOfSpecification,
    QestSpecification,
    QestStatusFlags,
    QestUrgent,
    QestLabNo,
    QestUUID,
    SuppressSyncTrigger)
  select
    QestID,
    QestTier,
    QestParentID,
    QestUniqueParentID,
    QestUniqueID,
    QestComplete,
    QestCreatedBy,
    QestCreatedDate,
    QestModifiedBy,
    QestModifiedDate,
    QestOwnerLabNo,
    QestTestedBy,
    QestTestedDate,
    QestCheckedBy,
    QestCheckedDate,
    QestOutOfSpecification,
    QestSpecification,
    QestStatusFlags,
    QestUrgent,
    QestLabNo,
    QestUUID,
    1 as SuppressSyncTrigger
  from ' + qo_table.Value + N' u
  where not exists (select 1 from UserDocumentBase udb where udb.QestUUID = u.QestUUID)
  and u.QestID between 19000 and 19999',
  qo_table.Value
from qestObjects qo_table
where qo_table.QestID between 19000 and 19999
and qo_table.Property = 'TableName'
and (@QestID = 0 or qo_table.QestID = @QestID)

declare @id int
declare @sql_schema nvarchar(4000)
declare @sql_insert nvarchar(4000)
declare @sql_tr_i_drop nvarchar(4000)
declare @sql_tr_i_create nvarchar(4000)
declare @sql_tr_u_drop nvarchar(4000)
declare @sql_tr_u_create nvarchar(4000)
declare @sql_tr_d_drop nvarchar(4000)
declare @sql_tr_d_create nvarchar(4000)
declare @rowcount int
while (select count(*) from @sqlexec s) > 0
begin
  select top 1 
    @id = ID, 
    @sql_schema = SQLText_Schema, 
    @sql_tr_i_drop = SQLText_TR_I_Drop,
    @sql_tr_i_create = SQLText_TR_I_Create,
    @sql_tr_u_drop = SQLText_TR_U_Drop,
    @sql_tr_u_create = SQLText_TR_U_Create,
    @sql_tr_d_drop = SQLText_TR_D_Drop,
    @sql_tr_d_create = SQLText_TR_D_Create,
    @sql_insert = SQLText_Insert, 
    @table_name = TableName 
  from @sqlexec
  
  exec sp_executesql @sql_schema
  exec sp_executesql @sql_tr_i_drop
  exec sp_executesql @sql_tr_i_create
  exec sp_executesql @sql_tr_u_drop
  exec sp_executesql @sql_tr_u_create
  exec sp_executesql @sql_tr_d_drop
  exec sp_executesql @sql_tr_d_create
  exec sp_executesql @sql_insert
  set @rowcount = @@ROWCOUNT
  raiserror(N'Syncing records from table %s to UserDocumentBase, %i records inserted.', 0, 1, @table_name, @rowcount)
  delete from @sqlexec where ID = @id
end
GO

-- Initialise all user documents
exec dbo.qest_UserDocumentBaseInitialise @QestID = 0