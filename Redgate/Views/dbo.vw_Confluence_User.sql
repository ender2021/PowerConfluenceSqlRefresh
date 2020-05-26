SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_Confluence_User] AS
SELECT [Account_Id]
      ,[Account_Type]
      ,[Display_Name]
      ,[Public_Name]
      ,[Profile_Picture_Url]
      ,[Profile_Picture_Height]
      ,[Profile_Picture_Width]
      ,[Email]
	  ,CASE WHEN [Display_Name] LIKE '%(Unlicensed)%' OR [Display_Name] LIKE '%(Deactivated)%' THEN 0
	        ELSE 1
	   END AS [Active]
      ,[Refresh_Id]
  FROM [dbo].[tbl_Confluence_User]
GO
GRANT SELECT ON  [dbo].[vw_Confluence_User] TO [ConfluenceRefreshRole]
GO
