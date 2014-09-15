
-- Updating GetWorkflow
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_do_GetWorkflow' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
    DROP PROCEDURE [dbo].[qest_do_GetWorkflow]
END
GO

CREATE procedure [dbo].[qest_do_GetWorkflow]
  @workflowID uniqueidentifier
AS
BEGIN
	SELECT TOP 1 W.[WorkflowUUID], W.[OwnerQestID], E.[TypeName] As OwnerEntityTypeName, W.[Name], W.[Caption], W.[Location], W.[WorkTemplateName], W.[DisplayIndex], W.[Style], W.[Group]
	FROM [dbo].[qestWorkflow] W
	LEFT JOIN [dbo].[qestEntity] E ON W.OwnerQestEntityUUID = E.QestEntityUUID
	WHERE W.[WorkflowUUID] = @workflowID
	ORDER BY W.[Caption], W.[DisplayIndex]
END
GO

-- Updating GetWorkflows
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_do_GetWorkflows' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
    DROP PROCEDURE [dbo].[qest_do_GetWorkflows]
END
GO

create procedure [dbo].[qest_do_GetWorkflows]
  @qestID int,
  @locationID int
as
begin
	select distinct
		w.WorkflowUUID
		, w.OwnerQestID
		, e.TypeName as OwnerEntityTypeName
		, w.Name
		, w.Caption
		, w.Location
		, w.WorkTemplateName
		, w.DisplayIndex
		, w.Style
		, w.[Group]
	from qestWorkflow w
		inner join qestWorkflowSettings ws on w.WorkflowUUID = ws.WorkflowUUID
		inner join qestViewConfiguration cfg on ws.ViewConfigurationUniqueID = cfg.qestUniqueID
		left join qestEntity e on w.OwnerQestEntityUUID = e.QestEntityUUID
		left join qestWorkflowLocationMapping m on m.WorkflowUUID = w.WorkflowUUID
	where ws.IsEnabled = 1
		and cfg.Active = 1
		and w.OwnerQestID = @qestID
		and (coalesce(m.LocationID, w.Location) = 0 or coalesce(m.LocationID, w.Location) in (select LocationID from dbo.qest_GetLocationAndAncestors(@locationID)))
	order by w.DisplayIndex, w.Caption
end
go


-- Updating getWorkflowStages
-- Procedure for returning workflow stages of a workflow
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_do_GetWorkflowStages' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
    DROP PROCEDURE [dbo].[qest_do_GetWorkflowStages]
END
GO

CREATE procedure [dbo].[qest_do_GetWorkflowStages]
  @workflowID uniqueidentifier
AS
BEGIN
	SELECT WS.[QestViewID] as ViewID, V.[Name] as ViewName, V.[QestID], E.[TypeName] As QestEntityType, WS.[Stage], WS.[Caption], WS.[ReadOnly], WS.[ProcedureDescription]
	FROM [dbo].[qestWorkflowStage] WS
	LEFT JOIN [dbo].[qestView] V on WS.[QestViewID] = V.[ViewUUID]
	LEFT JOIN [dbo].[qestEntity] E on E.[QestEntityUUID] = v.[QestEntityUUID]
	WHERE WS.[WorkflowUUID] = @workflowID
	ORDER BY WS.[Stage]
END
GO


-- GetViewDetails
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_do_GetViewDetails' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
    DROP PROCEDURE [dbo].[qest_do_GetViewDetails]
END
GO

CREATE procedure [dbo].[qest_do_GetViewDetails]
  @viewUUID uniqueidentifier
AS
BEGIN
	SELECT V.[Name] as ViewName, V.[QestID], E.[TypeName] As QestEntityType, V.[Caption]
	FROM [dbo].[qestView] V
	LEFT OUTER JOIN [dbo].[qestEntity] E ON E.[QestEntityUUID] = v.[QestEntityUUID]
	WHERE V.[ViewUUID] = @viewUUID
END
GO

-- GetDisplayObjectCollectionByViewID
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_do_GetDisplayObjectCollectionByViewID' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
    DROP PROCEDURE [dbo].[qest_do_GetDisplayObjectCollectionByViewID]
END
GO

CREATE PROCEDURE [dbo].[qest_do_GetDisplayObjectCollectionByViewID]
	@viewID uniqueidentifier,
	@locationID int = -1
AS
BEGIN
	SELECT D.FieldName, D.DisplayType, D.FormatString, D.Caption, D.ReadOnly, D.Hidden, D.Width, D.AutoFill, 
	D.ListField, D.RestrictField, COALESCE(D.ChildID, D.ListID, D.EquipmentID) As QestID, D.List, D.AdditionalData, D.ElementType, 
	D.FilterBy, D.Mask, D.Description
 	FROM qestDisplayObjectCollection C
 	INNER JOIN qestDisplayObjectDetails D ON C.QestUniqueID = D.QestUniqueParentID
 	WHERE C.QestUniqueID = 
     (                      
 	  --find the display object collection
 	  select top 1 doc.[QestUniqueID]
 		from [dbo].[qestView] v
		  inner join [dbo].[qestViewDetails] vd on v.[QestUniqueID] = vd.[QestUniqueParentID] 
		  inner join [dbo].[qestDisplayObjectCollection] doc on vd.[QestUniqueID] = doc.[QestUniqueParentID] 
		where v.[ViewUUID] = @viewID
		and coalesce(doc.ForRecord, 0) = 0
		and coalesce(v.ForRecord, 0) = 0
		order by vd.[DisplayOrder]
 	)
 	AND (@locationID < 0 OR CHARINDEX('C_', D.FieldName) <> 1 OR D.FieldName IN
	(
		SELECT DISTINCT 'C' + F.FieldName
		FROM dbo.CustomFieldSets S
		INNER JOIN dbo.CustomFieldSetDocTypes T ON T.CustomSetID = S.CustomSetID
		INNER JOIN CustomFieldSetFields F ON F.CustomSetID = S.CustomSetID
		INNER JOIN dbo.CustomFieldSetLabs L ON L.CustomSetID = S.CustomSetID
		WHERE  T.QestID = (SELECT TOP 1 QestID FROM [dbo].[qestView] v WHERE v.[ViewUUID] = @viewID)  AND ISNULL(S.Inactive, 0) = 0
		AND L.LabNo IN ( SELECT LocationID FROM dbo.qest_GetLocationAndAncestors(@locationID) )
	))
	ORDER BY D.DisplayOrder
END
GO

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_do_GetDisplayObjectCollectionByViewID_WithLength' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
    DROP PROCEDURE [dbo].qest_do_GetDisplayObjectCollectionByViewID_WithLength
END
GO
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[qest_do_GetDisplayObjectCollectionByViewID_WithLength]
	@viewID uniqueidentifier,
	@locationID int = -1
AS
BEGIN
	SELECT D.FieldName, D.DisplayType, D.FormatString, D.Caption, D.ReadOnly, D.Hidden, D.Width, D.AutoFill, 
	D.ListField, D.RestrictField, COALESCE(D.ChildID, D.ListID, D.EquipmentID) As QestID, D.List, D.AdditionalData, D.ElementType, 
	D.FilterBy, D.Mask, D.Description, I.CHARACTER_MAXIMUM_LENGTH as MaxLength
 	FROM qestDisplayObjectCollection C
 		INNER JOIN qestDisplayObjectDetails D ON C.QestUniqueID = D.QestUniqueParentID
		LEFT JOIN qestObjects O ON C.QestID = O.QestID AND O.Property = ''TableName''
		LEFT JOIN INFORMATION_SCHEMA.COLUMNS I ON (
		I.TABLE_NAME = O.[Value]
		AND (I.COLUMN_NAME = D.FieldName OR (LEFT(I.COLUMN_NAME, 1) = ''_'' AND ''C'' + I.COLUMN_NAME = D.FieldName))
	)
 	WHERE C.QestUniqueID = 
     (                      
 		--find the display object collection
 		select top 1 doc.[QestUniqueID]
 		from [dbo].[qestView] v
			inner join [dbo].[qestViewDetails] vd on v.[QestUniqueID] = vd.[QestUniqueParentID] 
			inner join [dbo].[qestDisplayObjectCollection] doc on vd.[QestUniqueID] = doc.[QestUniqueParentID] 
		where v.[ViewUUID] = @viewID
		and coalesce(doc.ForRecord, 0) = 0
		and coalesce(v.ForRecord, 0) = 0
		order by vd.[DisplayOrder]
 	)
 	AND (@locationID < 0 OR CHARINDEX(''C_'', D.FieldName) <> 1 OR D.FieldName IN
	(
		SELECT DISTINCT ''C'' + F.FieldName
		FROM dbo.CustomFieldSets S
		INNER JOIN dbo.CustomFieldSetDocTypes T ON T.CustomSetID = S.CustomSetID
		INNER JOIN CustomFieldSetFields F ON F.CustomSetID = S.CustomSetID
		INNER JOIN dbo.CustomFieldSetLabs L ON L.CustomSetID = S.CustomSetID
		WHERE  T.QestID = (SELECT TOP 1 QestID FROM [dbo].[qestView] v WHERE v.[ViewUUID] = @viewID)  AND ISNULL(S.Inactive, 0) = 0
		AND L.LabNo IN ( SELECT LocationID FROM dbo.qest_GetLocationAndAncestors(@locationID) )
	))
	ORDER BY D.DisplayOrder
END
' 
GO

-- GetViewByName
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'qest_do_GetViewByName' AND SPECIFIC_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
BEGIN
    DROP PROCEDURE [dbo].[qest_do_GetViewByName]
END
GO

CREATE procedure [dbo].[qest_do_GetViewByName]
	@qestID int,
	@name nvarchar(200)
AS
BEGIN
	SELECT TOP 1 V.[ViewUUID]
 	FROM [qestView] V
	  inner join [dbo].[qestViewSettings] vs on v.[ViewUUID] = vs.[ViewUUID]
	  inner join [dbo].[qestViewLookup] vl on v.[ViewUUID] = vl.[ViewUUID]
	  inner join [dbo].[qestViewConfiguration] cfg on vs.[ViewConfigurationUniqueID] = cfg.qestUniqueID and vl.[ViewConfigurationUniqueID] = cfg.[qestUniqueID] 
	WHERE v.[qestID] = @qestID
	  and vs.[IsEnabled] = 1
	  and @name like vl.[NamePattern]
	  and cfg.[Active] = 1
	  order by vl.[Priority]
END
GO
