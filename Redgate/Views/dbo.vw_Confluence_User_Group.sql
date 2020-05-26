SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_Confluence_User_Group] AS
SELECT [Account_Id],
       [Group_Name],
       [Refresh_Id]
FROM [dbo].[tbl_Confluence_User_Group]
GO
GRANT SELECT ON  [dbo].[vw_Confluence_User_Group] TO [ConfluenceRefreshRole]
GO
