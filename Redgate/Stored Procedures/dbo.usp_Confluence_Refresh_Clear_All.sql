SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




-- =============================================
-- Author:		Justin Mead
-- Create date: 2020-05-24
-- Description:	Clears all data from the Confluence Refresh tables, and sets all batches to deleted (except the baseline record)
-- =============================================

CREATE PROCEDURE [dbo].[usp_Confluence_Refresh_Clear_All]
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE [dbo].[tbl_Confluence_Refresh]
	SET [Deleted] = 1

	TRUNCATE TABLE [dbo].[tbl_Confluence_Group]
	TRUNCATE TABLE [dbo].[tbl_Confluence_Space]
	TRUNCATE TABLE [dbo].[tbl_Confluence_User]
	TRUNCATE TABLE [dbo].[tbl_Confluence_User_Group]

END




GO
GRANT EXECUTE ON  [dbo].[usp_Confluence_Refresh_Clear_All] TO [ConfluenceRefreshRole]
GO
