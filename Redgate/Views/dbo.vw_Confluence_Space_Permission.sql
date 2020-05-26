SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_Confluence_Space_Permission] AS
SELECT [Permission_Id],
       [Space_Id],
       [Subject_Type],
       [Subject_Id],
       [Operation],
       [Target_Type],
       [Anonymous_Access],
       [Unlicensed_Access],
       [Refresh_Id]
FROM [dbo].[tbl_Confluence_Space_Permission]
GO
GRANT SELECT ON  [dbo].[vw_Confluence_Space_Permission] TO [ConfluenceRefreshRole]
GO
