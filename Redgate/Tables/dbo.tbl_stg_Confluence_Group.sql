CREATE TABLE [dbo].[tbl_stg_Confluence_Group]
(
[Group_Name] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Group_Id] [char] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Refresh_Id] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_stg_Confluence_Group] ADD CONSTRAINT [PK_tbl_stg_Confluence_Group] PRIMARY KEY CLUSTERED  ([Group_Name]) ON [PRIMARY]
GO
GRANT INSERT ON  [dbo].[tbl_stg_Confluence_Group] TO [ConfluenceRefreshRole]
GO
