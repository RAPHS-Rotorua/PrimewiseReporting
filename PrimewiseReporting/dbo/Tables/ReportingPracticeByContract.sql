CREATE TABLE [dbo].[ReportingPracticeByContract](
	[PracticeID] [int] NULL,
	[CalendarDateKey] [int] NULL,
	[ParticipatingPracticeIndicator] [smallint] NULL,
	[ContractCode] [varchar](10) NULL,
	[CapitatedPatientCount] [int] NULL,
	[QuaterlyDiabeticPatientCount] [int] NULL,
	[CurrentDiabeticPatientCount] [int] NULL,
	[DiabeticLTCPatientCount] [int] NULL,
	[LTCPatientCount] [int] NULL,
	[DateStamp] [smalldatetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ReportingPracticeByContract] ADD  CONSTRAINT [DF_ProviderWisePracticeByContract_DateStamp]  DEFAULT (getdate()) FOR [DateStamp]