CREATE TABLE [dbo].[PalliativeCare](
	[PalliativeCareID] [int] NOT NULL,
	[PracticeID] [int] NULL,
	[NHI] [varchar](255) NULL,
	[START_DATE] [datetime] NULL,
	[Funding_Used] [money] NULL,
	[STATUS] [varchar](255) NULL,
	[Date_Deceased] [datetime] NULL,
	[Funding_InProcess] [money] NULL,
	[Funding_Requested] [money] NULL,
	[Funding_Total_Interim] [money] NULL,
	[ReportingPeriod_Finished] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PalliativeCare] ADD  CONSTRAINT [DF_PalliativeCare_ReportingPeriod_Finished]  DEFAULT ((0)) FOR [ReportingPeriod_Finished]