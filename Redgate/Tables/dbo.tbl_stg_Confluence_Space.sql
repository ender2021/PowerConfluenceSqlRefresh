CREATE TABLE [dbo].[tbl_stg_Confluence_Space]
(
[Space_Id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Space_Key] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Type] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Icon_Url] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Icon_Height] [bigint] NULL,
[Icon_Width] [bigint] NULL,
[Refresh_Id] [int] NULL
) ON [PRIMARY]
GO
GRANT INSERT ON  [dbo].[tbl_stg_Confluence_Space] TO [ConfluenceRefreshRole]
GO
