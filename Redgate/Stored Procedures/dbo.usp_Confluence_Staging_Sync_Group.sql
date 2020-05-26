SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2020-05-25
-- Description:	Synchronize Groups table from staging to production
-- =============================================
CREATE PROCEDURE [dbo].[usp_Confluence_Staging_Sync_Group] 
AS
BEGIN
	DELETE FROM [dbo].[tbl_Confluence_Group]

	INSERT INTO [dbo].[tbl_Confluence_Group]
	(
	    [Group_Name],
	    [Group_Id],
	    [Refresh_Id]
	)
	SELECT [Group_Name],
           [Group_Id],
           [Refresh_Id]
	FROM [dbo].[tbl_stg_Confluence_Group]
END
GO
GRANT EXECUTE ON  [dbo].[usp_Confluence_Staging_Sync_Group] TO [ConfluenceRefreshRole]
GO
