SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_Confluence_Group] AS
SELECT [Group_Name],
       [Group_Id],
       [Refresh_Id]
FROM [dbo].[tbl_Confluence_Group]
GO
GRANT SELECT ON  [dbo].[vw_Confluence_Group] TO [ConfluenceRefreshRole]
GO
