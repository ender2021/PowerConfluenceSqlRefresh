CREATE TABLE [dbo].[tbl_stg_Confluence_User]
(
[Account_Id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Account_Type] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Display_Name] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Public_Name] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Profile_Picture_Url] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Profile_Picture_Height] [bigint] NULL,
[Profile_Picture_Width] [bigint] NULL,
[Email] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Refresh_Id] [int] NULL
) ON [PRIMARY]
GO
GRANT INSERT ON  [dbo].[tbl_stg_Confluence_User] TO [ConfluenceRefreshRole]
GO
