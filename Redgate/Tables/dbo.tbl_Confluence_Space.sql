CREATE TABLE [dbo].[tbl_Confluence_Space]
(
[Space_Id] [int] NOT NULL,
[Space_Key] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Type] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Icon_Url] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Icon_Height] [int] NULL,
[Icon_Width] [int] NULL,
[Refresh_Id] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_Confluence_Space] ADD CONSTRAINT [PK_tbl_Confluence_Space] PRIMARY KEY CLUSTERED  ([Space_Id]) ON [PRIMARY]
GO
