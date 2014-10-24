/* Due to the weird symbiosis between UserDocumentBase and the individual UserDocumentN
tables, records in the UserDocumentBase table may originate either in UserDocumentBase table itself
or from a UserDocumentN table. This means that we may get non-unique QestID & QestUniqueID combinations.
We can prevent conflicts by reserving:
* the range 1 - 50000000 for documents that are initially created in
  UsedDocumentN and then synced to UserDocumentBase
* the range 50000001 - 99999999 for documents that are initially created in
  UserDocumentBase and then synced to UserDocumentN
NOTE: Though the range of the int type means we should actually be able to take the ranges 0 - 1073741823
and 1073741824 - 2147483647, the 8-digit allocation for QestUniqueID as part of a QESTLab object key means
that in reality we're limited to a total range of 99,999,999.
In practice, this means that we have to ensure UserDocumentBase has a QestUniqueID
with an identity field of 1073741824.
*/
-- a few possibilities for the pre-existing state of indexes to account for
begin tran

if exists (select * from sys.indexes i where i.object_id = OBJECT_ID('UserDocumentBase') and i.name = 'IX_UserDocumentBase_QestUniqueID' and i.is_unique_constraint = 1)
begin
  raiserror('Dropping existing unique constrained index on UserDocumentBase QestUniqueID', 0, 1)
  alter table UserDocumentBase drop constraint IX_UserDocumentBase_QestUniqueID
end
go
if exists (select * from sys.indexes i where i.object_id = OBJECT_ID('UserDocumentBase') and i.name = 'IX_UserDocumentBase_QestUniqueID' and i.is_unique_constraint = 0 and i.is_unique = 1)
begin
  raiserror('Dropping existing unique index on UserDocumentBase QestUniqueID', 0, 1)
  drop index UserDocumentBase.IX_UserDocumentBase_QestUniqueID
end
go
if exists (select 1 from sys.indexes i where i.object_id = OBJECT_ID('UserDocumentBase') and i.name = 'IX_UserDocumentBase_QestUniqueID_QestID' and i.is_unique_constraint = 1)
begin
  raiserror('Dropping existing unique index on UserDocumentBase.QestID and QestUniqueID', 0, 1)
  alter table UserDocumentBase drop constraint IX_UserDocumentBase_QestUniqueID_QestID
end
go

if isnull(IDENT_SEED('UserDocumentBase'),0) < 50000001
begin
  raiserror('Resetting seed on UserDocumentBase to 50000001 to accomodate sharing with UserDocumentN tables', 0, 1)
  truncate table UserDocumentBase
  alter table UserDocumentBase add QestUniqueID_tmp int identity (50000001, 1) not null
  alter table UserDocumentBase drop column QestUniqueID
  exec sp_rename 'UserDocumentBase.QestUniqueID_tmp', 'QestUniqueID', 'column'
end
else
begin
  raiserror('UserDocumentBase already seeded to 50000001.', 0, 1)
end
go
  
if not exists (select 1 from sys.indexes i where i.object_id = OBJECT_ID('UserDocumentBase') and i.name = 'IX_UserDocumentBase_QestUniqueID')
begin
  raiserror('Creating nonclustered index on UserDocumentBase.QestUniqueID', 0, 1)
  create nonclustered index IX_UserDocumentBase_QestUniqueID on UserDocumentBase (QestUniqueID) -- this needs to be explicitly non-unique
end

if not exists (select 1 from sys.indexes i where i.object_id = OBJECT_ID('UserDocumentBase') and i.name = 'IX_UserDocumentBase_QestUniqueID_QestID')
begin
  raiserror('Creating unique nonclustered index on UserDocumentBase.QestID and QestUniqueID', 0, 1)
  create unique nonclustered index IX_UserDocumentBase_QestUniqueID_QestID on UserDocumentBase (QestID, QestUniqueID)
end
go

commit
