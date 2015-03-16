
EXEC qest_EnableDocumentForQestnet 'WorkOrders' -- PSI: 00:03:05
GO
EXEC qest_EnableDocumentForQestnet 'SampleRegister' -- PSI: 00:08:33
GO
EXEC qest_EnableDocumentForQestnet 'Equipment' -- PSI: 00:00:10
GO
EXEC qest_EnableDocumentForQestnet_TableNameLike 'TestAnalysis%'
GO
EXEC qest_EnableDocumentForQestnet_TableNameLike 'Inspection%'
GO

---- The A-Z of Document Tables - these groups vary in runtime greatly
EXEC qest_EnableDocumentForQestnet_TableNameLike 'DocumentAg%' -- 00:14:43
GO
EXEC qest_EnableDocumentForQestnet_TableNameLike 'DocumentAs%' -- 00:02:46
GO
EXEC qest_EnableDocumentForQestnet_TableNameLike 'DocumentA[^gs]%' -- 00:02:23
GO
EXEC qest_EnableDocumentForQestnet_TableNameLike 'DocumentB%' 
GO
EXEC qest_EnableDocumentForQestnet_TableNameLike 'DocumentCa%' -- 00:03:00?
GO
EXEC qest_EnableDocumentForQestnet_TableNameLike 'DocumentCo%' -- slow
GO
EXEC qest_EnableDocumentForQestnet_TableNameLike 'DocumentCh%' -- 00:30:00?
GO
EXEC qest_EnableDocumentForQestnet_TableNameLike 'DocumentC[^aho]%' --
GO
EXEC qest_EnableDocumentForQestnet_TableNameLike 'DocumentD%' --
GO
EXEC qest_EnableDocumentForQestnet_TableNameLike 'DocumentEx%' -- 00:04:28
GO
EXEC qest_EnableDocumentForQestnet_TableNameLike 'DocumentE[^x]%' --
GO
EXEC qest_EnableDocumentForQestnet_TableNameLike 'DocumentF%' --
GO
EXEC qest_EnableDocumentForQestnet_TableNameLike 'DocumentG%' --
GO
EXEC qest_EnableDocumentForQestnet_TableNameLike 'DocumentH%' --
GO
EXEC qest_EnableDocumentForQestnet_TableNameLike 'DocumentI%' --
GO
EXEC qest_EnableDocumentForQestnet_TableNameLike 'DocumentJ%' --
GO
EXEC qest_EnableDocumentForQestnet_TableNameLike 'DocumentK%' --
GO
EXEC qest_EnableDocumentForQestnet_TableNameLike 'DocumentL%' --
GO
EXEC qest_EnableDocumentForQestnet_TableNameLike 'DocumentM%' -- 00:02:55
GO
EXEC qest_EnableDocumentForQestnet_TableNameLike 'DocumentN%' --
GO
EXEC qest_EnableDocumentForQestnet_TableNameLike 'DocumentO%' --
GO
EXEC qest_EnableDocumentForQestnet_TableNameLike 'DocumentP%' -- 00:02:41
GO
EXEC qest_EnableDocumentForQestnet_TableNameLike 'DocumentQ%' --
GO
EXEC qest_EnableDocumentForQestnet_TableNameLike 'DocumentR%' --
GO
EXEC qest_EnableDocumentForQestnet_TableNameLike 'DocumentS%' --
GO
EXEC qest_EnableDocumentForQestnet_TableNameLike 'DocumentT%' --
GO
EXEC qest_EnableDocumentForQestnet_TableNameLike 'DocumentU%' --
GO
EXEC qest_EnableDocumentForQestnet_TableNameLike 'DocumentV%' --
GO
EXEC qest_EnableDocumentForQestnet_TableNameLike 'DocumentW%' --
GO
EXEC qest_EnableDocumentForQestnet_TableNameLike 'Document[XYZ]%' --
GO


