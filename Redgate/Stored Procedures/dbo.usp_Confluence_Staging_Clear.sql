SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		Justin Mead
-- Create date: 2020-05-24
-- Description:	Clears the Confluence staging tables
-- =============================================

CREATE PROCEDURE [dbo].[usp_Confluence_Staging_Clear]
AS
BEGIN
	SET NOCOUNT ON;

    TRUNCATE TABLE [dbo].[tbl_stg_Confluence_User]
    TRUNCATE TABLE [dbo].[tbl_stg_Confluence_Group]


END


GO
GRANT EXECUTE ON  [dbo].[usp_Confluence_Staging_Clear] TO [ConfluenceRefreshRole]
GO
