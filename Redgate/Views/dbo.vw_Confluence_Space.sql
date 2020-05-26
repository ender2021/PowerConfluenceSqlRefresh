SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_Confluence_Space] AS
SELECT [Space_Id],
       [Space_Key],
       [Name],
       [Type],
       [Status],
       [Icon_Url],
       [Icon_Height],
       [Icon_Width],
       [Refresh_Id]
FROM [dbo].[tbl_Confluence_Space]
GO
GRANT SELECT ON  [dbo].[vw_Confluence_Space] TO [ConfluenceRefreshRole]
GO
