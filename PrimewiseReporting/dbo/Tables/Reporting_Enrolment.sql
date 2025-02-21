CREATE TABLE [dbo].[Reporting_Enrolment](
	[PatientID] [int] NULL,
	[NHI] [varchar](255) NULL,
	[EnrolmentDate] [datetime] NULL,
	[Form_Type] [varchar](255) NULL,
	[Validity] [varchar](255) NULL,
	[Comment] [varchar](255) NULL,
	[Batch] [varchar](255) NULL,
	[FormPresent] [bit] NULL,
	[ValidForm] [bit] NULL,
	[DateStamp] [smalldatetime] NULL,
	[SourceSurgeryID] [int] NULL,
	[PracticeID] [int] NULL,
	[EnteredBy] [varchar](255) NULL,
	[ProcessDate] [date] NULL,
	[EnrolledInPMS] [varchar](50) NULL,
	[Funding] [varchar](50) NULL,
	[ID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Reporting_Enrolment] ADD  CONSTRAINT [DF_Reporting_Enrolment_DateStamp]  DEFAULT (getdate()) FOR [DateStamp]