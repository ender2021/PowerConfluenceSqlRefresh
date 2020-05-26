SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2020-05-26
-- Description:	Synchronize Space Permission table from staging to production
-- =============================================
CREATE PROCEDURE [dbo].[usp_Confluence_Staging_Sync_Space_Permission] 
AS
BEGIN
	DELETE FROM [dbo].[tbl_Confluence_Space_Permission]

	INSERT INTO [dbo].[tbl_Confluence_Space_Permission]
	(
	    [Permission_Id],
	    [Space_Id],
	    [Subject_Type],
	    [Subject_Id],
	    [Operation],
	    [Target_Type],
	    [Anonymous_Access],
	    [Unlicensed_Access],
	    [Refresh_Id]
	)
	SELECT [Permission_Id],
           [Space_Id],
           [Subject_Type],
           [Subject_Id],
           [Operation],
           [Target_Type],
           [Anonymous_Access],
           [Unlicensed_Access],
           [Refresh_Id]
	FROM [dbo].[tbl_stg_Confluence_Space_Permission]
END
GO
GRANT EXECUTE ON  [dbo].[usp_Confluence_Staging_Sync_Space_Permission] TO [ConfluenceRefreshRole]
GO
