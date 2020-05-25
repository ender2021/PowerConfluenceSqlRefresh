SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-12
-- Description:	Get the most recent Confluence refresh record
-- =============================================
CREATE PROCEDURE [dbo].[usp_Confluence_Refresh_Get_Max]
	AS
BEGIN
	SET NOCOUNT ON;

	SELECT TOP 1
		   [Refresh_ID]
		  ,[Refresh_Start]
		  ,[Refresh_Start_Unix]
	FROM [dbo].[tbl_Confluence_Refresh]
	WHERE [Deleted] = 0
	ORDER BY [Refresh_Start] DESC
END
GO
GRANT EXECUTE ON  [dbo].[usp_Confluence_Refresh_Get_Max] TO [ConfluenceRefreshRole]
GO
