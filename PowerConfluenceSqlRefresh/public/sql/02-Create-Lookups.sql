/*
Run this script on:

Script created by SQL Data Compare version 13.1.1.5299 from Red Gate Software Ltd at 9/28/2019 4:57:31 PM

*/
		
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS, NOCOUNT ON
GO
SET DATEFORMAT YMD
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
BEGIN TRANSACTION

PRINT(N'Drop constraints from [dbo].[tbl_lk_Confluence_Refresh_Status]')
ALTER TABLE [dbo].[tbl_lk_Confluence_Refresh_Status] NOCHECK CONSTRAINT [FK_tbl_lk_Confluence_Refresh_Status_tbl_lk_Confluence_Refresh_Status]

PRINT(N'Add 4 rows to [dbo].[tbl_lk_Confluence_Refresh_Status]')
INSERT INTO [dbo].[tbl_lk_Confluence_Refresh_Status] ([Refresh_Status_Code], [Refresh_Status]) VALUES (' ', 'Unset')
INSERT INTO [dbo].[tbl_lk_Confluence_Refresh_Status] ([Refresh_Status_Code], [Refresh_Status]) VALUES ('A', 'Aborted')
INSERT INTO [dbo].[tbl_lk_Confluence_Refresh_Status] ([Refresh_Status_Code], [Refresh_Status]) VALUES ('C', 'Completed')
INSERT INTO [dbo].[tbl_lk_Confluence_Refresh_Status] ([Refresh_Status_Code], [Refresh_Status]) VALUES ('S', 'Started')

PRINT(N'Add constraints to [dbo].[tbl_lk_Confluence_Refresh_Status]')
ALTER TABLE [dbo].[tbl_lk_Confluence_Refresh_Status] WITH CHECK CHECK CONSTRAINT [FK_tbl_lk_Confluence_Refresh_Status_tbl_lk_Confluence_Refresh_Status]
COMMIT TRANSACTION
GO
