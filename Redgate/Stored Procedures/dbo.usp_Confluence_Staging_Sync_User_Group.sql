SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2020-05-26
-- Description:	Synchronize Users' Groups table from staging to production
-- =============================================
CREATE PROCEDURE [dbo].[usp_Confluence_Staging_Sync_User_Group] 
AS
BEGIN
	DELETE FROM [dbo].[tbl_Confluence_User_Group]

	INSERT	INTO	[dbo].[tbl_Confluence_User_Group]
	(
	    [Account_Id],
	    [Group_Name],
	    [Refresh_Id]
	)
	SELECT [Account_Id],
           [Group_Name],
           [Refresh_Id]
	FROM [dbo].[tbl_stg_Confluence_User_Group]
END
GO
GRANT EXECUTE ON  [dbo].[usp_Confluence_Staging_Sync_User_Group] TO [ConfluenceRefreshRole]
GO
