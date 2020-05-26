SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
BEGIN TRANSACTION
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating role ConfluenceRefreshRole'
GO
CREATE ROLE [ConfluenceRefreshRole]
AUTHORIZATION [dbo]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating schemas'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_lk_Confluence_Refresh_Status]'
GO
CREATE TABLE [dbo].[tbl_lk_Confluence_Refresh_Status]
(
[Refresh_Status_Code] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Refresh_Status] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_lk_Confluence_Refresh_Status] on [dbo].[tbl_lk_Confluence_Refresh_Status]'
GO
ALTER TABLE [dbo].[tbl_lk_Confluence_Refresh_Status] ADD CONSTRAINT [PK_tbl_lk_Confluence_Refresh_Status] PRIMARY KEY CLUSTERED  ([Refresh_Status_Code])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_Confluence_Refresh]'
GO
CREATE TABLE [dbo].[tbl_Confluence_Refresh]
(
[Refresh_ID] [int] NOT NULL IDENTITY(1, 1),
[Refresh_Start] [datetime] NOT NULL,
[Refresh_Start_Unix] [int] NOT NULL,
[Refresh_End] [datetime] NULL,
[Refresh_End_Unix] [int] NULL,
[Status] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_tbl_Confluence_Refresh_Status] DEFAULT (' '),
[Deleted] [bit] NOT NULL CONSTRAINT [DF_tbl_Confluence_Refresh_Deleted] DEFAULT ((0))
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_Confluence_Refresh] on [dbo].[tbl_Confluence_Refresh]'
GO
ALTER TABLE [dbo].[tbl_Confluence_Refresh] ADD CONSTRAINT [PK_tbl_Confluence_Refresh] PRIMARY KEY CLUSTERED  ([Refresh_ID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[vw_lk_Confluence_Refresh_Status]'
GO

CREATE VIEW [dbo].[vw_lk_Confluence_Refresh_Status] AS
SELECT [Refresh_Status_Code]
      ,[Refresh_Status]
  FROM [dbo].[tbl_lk_Confluence_Refresh_Status]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_Confluence_Refresh_Update_End]'
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-12
-- Description:	Sets the end time of a Confluence refresh
-- =============================================
CREATE PROCEDURE [dbo].[usp_Confluence_Refresh_Update_End]
	@Refresh_Id AS INT,
	@Status AS CHAR(1) = 'C'
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @currDate AS DATETIME = GETDATE()
    
	UPDATE [dbo].[tbl_Confluence_Refresh]
	SET [Refresh_End] = @currDate
	   ,[Refresh_End_Unix] = DATEDIFF(s, '1970-01-01', @currDate)
	   ,[Status] = @Status
	WHERE [Refresh_ID] = @Refresh_Id
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_Confluence_Refresh_Get_Max]'
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-12
-- Description:	Get the most recent Confluence refresh record
-- =============================================
CREATE PROCEDURE [dbo].[usp_Confluence_Refresh_Get_Max]
	AS
BEGIN
	SET NOCOUNT ON;

	SELECT TOP 1
		   [Refresh_ID]
		  ,[Refresh_Start]
		  ,[Refresh_Start_Unix]
	FROM [dbo].[tbl_Confluence_Refresh]
	WHERE [Deleted] = 0
	ORDER BY [Refresh_Start] DESC
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_Confluence_Refresh_Start]'
GO

-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-28
-- Description:	Creates a new refresh record
-- =============================================

-- =============================================
-- Update Author:	Justin Mead
-- Update date:		2020-05-25
-- Description:		Remove un-needed type field
-- =============================================
CREATE PROCEDURE [dbo].[usp_Confluence_Refresh_Start]
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @currDate AS DATETIME = GETDATE()
    
	INSERT INTO [dbo].[tbl_Confluence_Refresh]
	(
	    [Refresh_Start],
	    [Refresh_Start_Unix],
		[Status]
	)
	VALUES
	(   @currDate,
	    DATEDIFF(s, '1970-01-01', @currDate),
		'S'
	    )

	SELECT @@IDENTITY AS [Refresh_Id]
END

GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_Confluence_User_Group]'
GO
CREATE TABLE [dbo].[tbl_Confluence_User_Group]
(
[Account_Id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Group_Name] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Refresh_Id] [int] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_Confluence_User]'
GO
CREATE TABLE [dbo].[tbl_Confluence_User]
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
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_Confluence_Group]'
GO
CREATE TABLE [dbo].[tbl_Confluence_Group]
(
[Group_Name] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Group_Id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Refresh_Id] [int] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_Confluence_Refresh_Clear_All]'
GO




-- =============================================
-- Author:		Justin Mead
-- Create date: 2020-05-24
-- Description:	Clears all data from the Confluence Refresh tables, and sets all batches to deleted (except the baseline record)
-- =============================================

CREATE PROCEDURE [dbo].[usp_Confluence_Refresh_Clear_All]
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE [dbo].[tbl_Confluence_Refresh]
	SET [Deleted] = 1

	TRUNCATE TABLE [dbo].[tbl_Confluence_Group]
	TRUNCATE TABLE [dbo].[tbl_Confluence_User]
	TRUNCATE TABLE [dbo].[tbl_Confluence_User_Group]

END




GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[vw_Confluence_Refresh]'
GO

CREATE VIEW [dbo].[vw_Confluence_Refresh]
AS
SELECT [Refresh_ID]
      ,[Refresh_Start]
      ,[Refresh_Start_Unix]
      ,[Refresh_End]
      ,[Refresh_End_Unix]
	  ,CAST(DATEDIFF(SECOND, [Refresh_Start], [Refresh_End]) AS FLOAT) / 60 AS [Duration_Minutes]
      ,[Type]
      ,[Status]
      ,[Deleted]
  FROM [dbo].[tbl_Confluence_Refresh]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_stg_Confluence_User_Group]'
GO
CREATE TABLE [dbo].[tbl_stg_Confluence_User_Group]
(
[Account_Id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Group_Name] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Refresh_Id] [int] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_stg_Confluence_User]'
GO
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
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_stg_Confluence_Group]'
GO
CREATE TABLE [dbo].[tbl_stg_Confluence_Group]
(
[Group_Name] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Group_Id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Refresh_Id] [int] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_Confluence_Staging_Clear]'
GO


-- =============================================
-- Author:		Justin Mead
-- Create date: 2020-05-24
-- Description:	Clears the Confluence staging tables
-- =============================================

CREATE PROCEDURE [dbo].[usp_Confluence_Staging_Clear]
AS
BEGIN
	SET NOCOUNT ON;

    TRUNCATE TABLE [dbo].[tbl_stg_Confluence_Group]
    TRUNCATE TABLE [dbo].[tbl_stg_Confluence_User]
    TRUNCATE TABLE [dbo].[tbl_stg_Confluence_User_Group]


END


GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_Confluence_Staging_Sync_User_Group]'
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2020-05-26
-- Description:	Synchronize Users' Groups table from staging to production
-- =============================================
CREATE PROCEDURE [dbo].[usp_Confluence_Staging_Sync_User_Group] 
AS
BEGIN
	DELETE FROM [dbo].[tbl_Confluence_User_Group]

	INSERT	INTO	[dbo].[tbl_Confluence_User_Group]
	(
	    [Account_Id],
	    [Group_Name],
	    [Refresh_Id]
	)
	SELECT [Account_Id],
           [Group_Name],
           [Refresh_Id]
	FROM [dbo].[tbl_stg_Confluence_User_Group]
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_Confluence_Staging_Sync_User]'
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2020-05-25
-- Description:	Synchronize Users table from staging to production
-- =============================================
CREATE PROCEDURE [dbo].[usp_Confluence_Staging_Sync_User] 
AS
BEGIN
	DELETE FROM [dbo].[tbl_Confluence_User]

	INSERT INTO [dbo].[tbl_Confluence_User]
	(
	    [Account_Id],
	    [Account_Type],
	    [Display_Name],
	    [Public_Name],
	    [Profile_Picture_Url],
	    [Profile_Picture_Height],
	    [Profile_Picture_Width],
	    [Email],
	    [Refresh_Id]
	)
	SELECT [Account_Id],
           [Account_Type],
           [Display_Name],
           [Public_Name],
           [Profile_Picture_Url],
           [Profile_Picture_Height],
           [Profile_Picture_Width],
           [Email],
           [Refresh_Id]
	FROM [dbo].[tbl_stg_Confluence_User]
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_Confluence_Staging_Sync_Group]'
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2020-05-25
-- Description:	Synchronize Groups table from staging to production
-- =============================================
CREATE PROCEDURE [dbo].[usp_Confluence_Staging_Sync_Group] 
AS
BEGIN
	DELETE FROM [dbo].[tbl_Confluence_Group]

	INSERT INTO [dbo].[tbl_Confluence_Group]
	(
	    [Group_Name],
	    [Group_Id],
	    [Refresh_Id]
	)
	SELECT [Group_Name],
           [Group_Id],
           [Refresh_Id]
	FROM [dbo].[tbl_stg_Confluence_Group]
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_Confluence_Staging_Synchronize]'
GO

-- =============================================
-- Author:		Justin Mead
-- Create date: 2020-05-24
-- Description:	Synchronize staging tables with the live tables
-- =============================================

-- =============================================
CREATE PROCEDURE [dbo].[usp_Confluence_Staging_Synchronize]
	
AS
BEGIN
	SET NOCOUNT ON;

	EXEC [dbo].[usp_Confluence_Staging_Sync_Group]
	EXEC [dbo].[usp_Confluence_Staging_Sync_User]
	EXEC [dbo].[usp_Confluence_Staging_Sync_User_Group]

END


GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[vw_Confluence_User]'
GO

CREATE VIEW [dbo].[vw_Confluence_User] AS
SELECT [Account_Id]
      ,[Account_Type]
      ,[Display_Name]
      ,[Public_Name]
      ,[Profile_Picture_Url]
      ,[Profile_Picture_Height]
      ,[Profile_Picture_Width]
      ,[Email]
	  ,CASE WHEN [Display_Name] LIKE '%(Unlicensed)%' OR [Display_Name] LIKE '%(Deactivated)%' THEN 0
	        ELSE 1
	   END AS [Active]
      ,[Refresh_Id]
  FROM [dbo].[tbl_Confluence_User]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[vw_Confluence_Group]'
GO

CREATE VIEW [dbo].[vw_Confluence_Group] AS
SELECT [Group_Name],
       [Group_Id],
       [Refresh_Id]
FROM [dbo].[tbl_Confluence_Group]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[vw_Confluence_User_Group]'
GO

CREATE VIEW [dbo].[vw_Confluence_User_Group] AS
SELECT [Account_Id],
       [Group_Name],
       [Refresh_Id]
FROM [dbo].[tbl_Confluence_User_Group]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[tbl_Confluence_Refresh]'
GO
ALTER TABLE [dbo].[tbl_Confluence_Refresh] ADD CONSTRAINT [FK_tbl_Confluence_Refresh_tbl_lk_Confluence_Refresh_Status] FOREIGN KEY ([Status]) REFERENCES [dbo].[tbl_lk_Confluence_Refresh_Status] ([Refresh_Status_Code])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[tbl_lk_Confluence_Refresh_Status]'
GO
ALTER TABLE [dbo].[tbl_lk_Confluence_Refresh_Status] ADD CONSTRAINT [FK_tbl_lk_Confluence_Refresh_Status_tbl_lk_Confluence_Refresh_Status] FOREIGN KEY ([Refresh_Status_Code]) REFERENCES [dbo].[tbl_lk_Confluence_Refresh_Status] ([Refresh_Status_Code])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering permissions on  [dbo].[tbl_stg_Confluence_Group]'
GO
GRANT INSERT ON  [dbo].[tbl_stg_Confluence_Group] TO [ConfluenceRefreshRole]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering permissions on  [dbo].[tbl_stg_Confluence_User]'
GO
GRANT INSERT ON  [dbo].[tbl_stg_Confluence_User] TO [ConfluenceRefreshRole]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering permissions on  [dbo].[tbl_stg_Confluence_User_Group]'
GO
GRANT INSERT ON  [dbo].[tbl_stg_Confluence_User_Group] TO [ConfluenceRefreshRole]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering permissions on  [dbo].[usp_Confluence_Refresh_Clear_All]'
GO
GRANT EXECUTE ON  [dbo].[usp_Confluence_Refresh_Clear_All] TO [ConfluenceRefreshRole]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering permissions on  [dbo].[usp_Confluence_Refresh_Get_Max]'
GO
GRANT EXECUTE ON  [dbo].[usp_Confluence_Refresh_Get_Max] TO [ConfluenceRefreshRole]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering permissions on  [dbo].[usp_Confluence_Refresh_Start]'
GO
GRANT EXECUTE ON  [dbo].[usp_Confluence_Refresh_Start] TO [ConfluenceRefreshRole]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering permissions on  [dbo].[usp_Confluence_Refresh_Update_End]'
GO
GRANT EXECUTE ON  [dbo].[usp_Confluence_Refresh_Update_End] TO [ConfluenceRefreshRole]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering permissions on  [dbo].[usp_Confluence_Staging_Clear]'
GO
GRANT EXECUTE ON  [dbo].[usp_Confluence_Staging_Clear] TO [ConfluenceRefreshRole]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering permissions on  [dbo].[usp_Confluence_Staging_Sync_Group]'
GO
GRANT EXECUTE ON  [dbo].[usp_Confluence_Staging_Sync_Group] TO [ConfluenceRefreshRole]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering permissions on  [dbo].[usp_Confluence_Staging_Sync_User]'
GO
GRANT EXECUTE ON  [dbo].[usp_Confluence_Staging_Sync_User] TO [ConfluenceRefreshRole]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering permissions on  [dbo].[usp_Confluence_Staging_Sync_User_Group]'
GO
GRANT EXECUTE ON  [dbo].[usp_Confluence_Staging_Sync_User_Group] TO [ConfluenceRefreshRole]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering permissions on  [dbo].[usp_Confluence_Staging_Synchronize]'
GO
GRANT EXECUTE ON  [dbo].[usp_Confluence_Staging_Synchronize] TO [ConfluenceRefreshRole]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering permissions on  [dbo].[vw_Confluence_Group]'
GO
GRANT SELECT ON  [dbo].[vw_Confluence_Group] TO [ConfluenceRefreshRole]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering permissions on  [dbo].[vw_Confluence_Refresh]'
GO
GRANT SELECT ON  [dbo].[vw_Confluence_Refresh] TO [ConfluenceRefreshRole]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering permissions on  [dbo].[vw_Confluence_User]'
GO
GRANT SELECT ON  [dbo].[vw_Confluence_User] TO [ConfluenceRefreshRole]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering permissions on  [dbo].[vw_Confluence_User_Group]'
GO
GRANT SELECT ON  [dbo].[vw_Confluence_User_Group] TO [ConfluenceRefreshRole]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering permissions on  [dbo].[vw_lk_Confluence_Refresh_Status]'
GO
GRANT SELECT ON  [dbo].[vw_lk_Confluence_Refresh_Status] TO [ConfluenceRefreshRole]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
COMMIT TRANSACTION
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
-- This statement writes to the SQL Server Log so SQL Monitor can show this deployment.
IF HAS_PERMS_BY_NAME(N'sys.xp_logevent', N'OBJECT', N'EXECUTE') = 1
BEGIN
    DECLARE @databaseName AS nvarchar(2048), @eventMessage AS nvarchar(2048)
    SET @databaseName = REPLACE(REPLACE(DB_NAME(), N'\', N'\\'), N'"', N'\"')
    SET @eventMessage = N'Redgate SQL Compare: { "deployment": { "description": "Redgate SQL Compare deployed to ' + @databaseName + N'", "database": "' + @databaseName + N'" }}'
    EXECUTE sys.xp_logevent 55000, @eventMessage
END
GO
DECLARE @Success AS BIT
SET @Success = 1
SET NOEXEC OFF
IF (@Success = 1) PRINT 'The database update succeeded'
ELSE BEGIN
	IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
	PRINT 'The database update failed'
END
GO
