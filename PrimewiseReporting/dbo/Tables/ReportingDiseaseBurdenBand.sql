CREATE TABLE [dbo].[ReportingDiseaseBurdenBand](
	[PracticeID] [int] NULL,
	[FiscalQuarterKey] [int] NULL,
	[FiscalYearKey] [int] NULL,
	[ContractCode] [varchar](10) NULL,
	[ParticipatingPracticeIndicator] [int] NULL,
	[AgeBand] [varchar](50) NULL,
	[NeedsIndicator] [varchar](50) NULL,
	[CapitatedPatientCount] [int] NULL,
	[DALYRate] [int] NULL,
	[GrossDALYValue] [decimal](18, 2) NULL,
	[DateStamp] [smalldatetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ReportingDiseaseBurdenBand] ADD  CONSTRAINT [DF_PrimeWiseDiseaseBurdenBand_DateStamp]  DEFAULT (getdate()) FOR [DateStamp]