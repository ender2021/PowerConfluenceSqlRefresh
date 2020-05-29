CREATE TABLE [dbo].[tbl_Confluence_User]
(
[Account_Id] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Account_Type] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Display_Name] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Public_Name] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Profile_Picture_Url] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Profile_Picture_Height] [int] NULL,
[Profile_Picture_Width] [int] NULL,
[Email] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Refresh_Id] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_Confluence_User] ADD CONSTRAINT [PK_tbl_Confluence_User] PRIMARY KEY CLUSTERED  ([Account_Id]) ON [PRIMARY]
GO
