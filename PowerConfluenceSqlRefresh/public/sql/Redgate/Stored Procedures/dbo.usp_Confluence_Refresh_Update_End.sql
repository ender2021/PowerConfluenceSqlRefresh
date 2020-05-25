SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-12
-- Description:	Sets the end time of a Confluence refresh
-- =============================================
CREATE PROCEDURE [dbo].[usp_Confluence_Refresh_Update_End]
	@Refresh_Id AS INT,
	@Status AS CHAR(1) = 'C'
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @currDate AS DATETIME = GETDATE()
    
	UPDATE [dbo].[tbl_Confluence_Refresh]
	SET [Refresh_End] = @currDate
	   ,[Refresh_End_Unix] = DATEDIFF(s, '1970-01-01', @currDate)
	   ,[Status] = @Status
	WHERE [Refresh_ID] = @Refresh_Id
END
GO
GRANT EXECUTE ON  [dbo].[usp_Confluence_Refresh_Update_End] TO [ConfluenceRefreshRole]
GO
