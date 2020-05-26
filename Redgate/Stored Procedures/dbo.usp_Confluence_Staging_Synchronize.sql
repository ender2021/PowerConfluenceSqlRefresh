SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Justin Mead
-- Create date: 2020-05-24
-- Description:	Synchronize staging tables with the live tables
-- =============================================

-- =============================================
CREATE PROCEDURE [dbo].[usp_Confluence_Staging_Synchronize]
	
AS
BEGIN
	SET NOCOUNT ON;

	EXEC [dbo].[usp_Confluence_Staging_Sync_Group]
	EXEC [dbo].[usp_Confluence_Staging_Sync_User]
	EXEC [dbo].[usp_Confluence_Staging_Sync_User_Group]

END


GO
GRANT EXECUTE ON  [dbo].[usp_Confluence_Staging_Synchronize] TO [ConfluenceRefreshRole]
GO
