CREATE TABLE [dbo].[Stage_IMMS_24Month_Summary_temp](
	[Cohort] [varchar](100) NULL,
	[PracticeID] [int] NULL,
	[NHI] [varchar](255) NULL,
	[Ethnicity] [varchar](9) NOT NULL,
	[Milestone_Age_24_Months] [int] NOT NULL,
	[Numerator_24_Months] [int] NOT NULL,
	[MonthNo] [int] NOT NULL,
	[YearNo] [int] NOT NULL,
	[ReportingDate] [int] NOT NULL,
	[DateLabel] [varchar](8) NOT NULL
) ON [PRIMARY]