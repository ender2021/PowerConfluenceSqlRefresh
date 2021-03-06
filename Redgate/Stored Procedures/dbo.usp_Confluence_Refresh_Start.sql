SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-28
-- Description:	Creates a new refresh record
-- =============================================

-- =============================================
-- Update Author:	Justin Mead
-- Update date:		2020-05-25
-- Description:		Remove un-needed type field
-- =============================================
CREATE PROCEDURE [dbo].[usp_Confluence_Refresh_Start]
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @currDate AS DATETIME = GETDATE()
    
	INSERT INTO [dbo].[tbl_Confluence_Refresh]
	(
	    [Refresh_Start],
	    [Refresh_Start_Unix],
		[Status]
	)
	VALUES
	(   @currDate,
	    DATEDIFF(s, '1970-01-01', @currDate),
		'S'
	    )

	SELECT @@IDENTITY AS [Refresh_Id]
END

GO
GRANT EXECUTE ON  [dbo].[usp_Confluence_Refresh_Start] TO [ConfluenceRefreshRole]
GO
