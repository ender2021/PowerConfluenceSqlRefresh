CREATE TABLE [dbo].[tbl_stg_Confluence_Space_Permission]
(
[Permission_Id] [int] NOT NULL,
[Space_Id] [int] NOT NULL,
[Subject_Type] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Subject_Id] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Operation] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Target_Type] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Anonymous_Access] [bit] NOT NULL,
[Unlicensed_Access] [bit] NOT NULL,
[Refresh_Id] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_stg_Confluence_Space_Permission] ADD CONSTRAINT [PK_tbl_stg_Confluence_Space_Permission] PRIMARY KEY CLUSTERED  ([Permission_Id]) ON [PRIMARY]
GO
GRANT INSERT ON  [dbo].[tbl_stg_Confluence_Space_Permission] TO [ConfluenceRefreshRole]
GO
