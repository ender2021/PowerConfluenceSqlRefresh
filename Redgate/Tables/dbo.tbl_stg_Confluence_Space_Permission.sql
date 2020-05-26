CREATE TABLE [dbo].[tbl_stg_Confluence_Space_Permission]
(
[Permission_Id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Space_Id] [int] NULL,
[Subject_Type] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Subject_Id] [sql_variant] NULL,
[Operation] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Target_Type] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Anonymous_Access] [bit] NULL,
[Unlicensed_Access] [bit] NULL,
[Refresh_Id] [int] NULL
) ON [PRIMARY]
GO
GRANT INSERT ON  [dbo].[tbl_stg_Confluence_Space_Permission] TO [ConfluenceRefreshRole]
GO
