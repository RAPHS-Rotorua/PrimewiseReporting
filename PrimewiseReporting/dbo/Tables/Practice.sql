CREATE TABLE [dbo].[Practice](
	[SurgeryKey] [int] NOT NULL,
	[PracticeID] [int] NULL,
	[SurgeryPrefix] [varchar](50) NULL,
	[SurgeryName] [varchar](100) NULL,
	[DistrictHealthBoard] [varchar](100) NULL,
	[PrimaryHealthOrganisation] [varchar](100) NULL,
	[ManagementServiceOrganisation] [varchar](100) NULL,
	[PracticeManagementSystem] [varchar](100) NULL,
	[Address] [varchar](255) NULL,
	[Suburb] [varchar](100) NULL,
	[City] [varchar](100) NULL,
	[PhoneNumber] [varchar](100) NULL,
	[HealthlinkEDI] [varchar](255) NULL,
	[HealthlinkFolder] [varchar](255) NULL,
	[FlatFileSource] [varchar](255) NULL,
	[Datestamp] [smalldatetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Practice] ADD  CONSTRAINT [DF_Practice_Datestamp]  DEFAULT (getdate()) FOR [Datestamp]