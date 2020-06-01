CREATE TABLE [dbo].[tbl_stg_Confluence_User_Group]
(
[Account_Id] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Group_Name] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Refresh_Id] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_stg_Confluence_User_Group] ADD CONSTRAINT [PK_tbl_stg_Confluence_User_Group] PRIMARY KEY CLUSTERED  ([Account_Id], [Group_Name]) ON [PRIMARY]
GO
GRANT INSERT ON  [dbo].[tbl_stg_Confluence_User_Group] TO [ConfluenceRefreshRole]
GO
