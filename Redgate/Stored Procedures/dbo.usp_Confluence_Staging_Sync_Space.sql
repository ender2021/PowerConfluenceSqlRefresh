SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2020-05-26
-- Description:	Synchronize Space table from staging to production
-- =============================================
CREATE PROCEDURE [dbo].[usp_Confluence_Staging_Sync_Space] 
AS
BEGIN
	DELETE FROM [dbo].[tbl_Confluence_Space]

	INSERT INTO [dbo].[tbl_Confluence_Space]
	(
	    [Space_Id],
	    [Space_Key],
	    [Name],
	    [Type],
	    [Status],
	    [Icon_Url],
	    [Icon_Height],
	    [Icon_Width],
	    [Refresh_Id]
	)
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
END
GO
GRANT EXECUTE ON  [dbo].[usp_Confluence_Staging_Sync_Space] TO [ConfluenceRefreshRole]
GO
