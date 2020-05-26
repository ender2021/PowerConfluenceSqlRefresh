SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2020-05-25
-- Description:	Synchronize Users table from staging to production
-- =============================================
CREATE PROCEDURE [dbo].[usp_Confluence_Staging_Sync_User] 
AS
BEGIN
	DELETE FROM [dbo].[tbl_Confluence_User]

	INSERT INTO [dbo].[tbl_Confluence_User]
	(
	    [Account_Id],
	    [Account_Type],
	    [Display_Name],
	    [Public_Name],
	    [Profile_Picture_Url],
	    [Profile_Picture_Height],
	    [Profile_Picture_Width],
	    [Email],
	    [Refresh_Id]
	)
	SELECT [Account_Id],
           [Account_Type],
           [Display_Name],
           [Public_Name],
           [Profile_Picture_Url],
           [Profile_Picture_Height],
           [Profile_Picture_Width],
           [Email],
           [Refresh_Id]
	FROM [dbo].[tbl_stg_Confluence_User]
END
GO
GRANT EXECUTE ON  [dbo].[usp_Confluence_Staging_Sync_User] TO [ConfluenceRefreshRole]
GO
