CREATE TABLE [dbo].[tbl_stg_Confluence_User_Group]
(
[Account_Id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Group_Name] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Refresh_Id] [int] NULL
) ON [PRIMARY]
GO
GRANT INSERT ON  [dbo].[tbl_stg_Confluence_User_Group] TO [ConfluenceRefreshRole]
GO
