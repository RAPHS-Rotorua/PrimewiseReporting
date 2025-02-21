CREATE TABLE [dbo].[IMMS_24Month_Summary](
	[IMMS_24Month_SummaryID] [int] IDENTITY(1,1) NOT NULL,
	[Cohort] [varchar](100) NULL,
	[PracticeID] [int] NULL,
	[NHI] [varchar](255) NULL,
	[Ethnicity] [varchar](9) NOT NULL,
	[Milestone_Age_24_Months] [int] NOT NULL,
	[Numerator_24_Months] [int] NOT NULL,
	[MonthNo] [int] NOT NULL,
	[YearNo] [int] NOT NULL,
	[ReportingDate] [int] NOT NULL,
	[DateLabel] [varchar](8) NOT NULL,
	[DateStamp] [datetime] NOT NULL,
 CONSTRAINT [PK_IMMS_24Month_Summary] PRIMARY KEY CLUSTERED 
(
	[IMMS_24Month_SummaryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[IMMS_24Month_Summary] ADD  CONSTRAINT [DF_IMMS_24Month_Summary_DateStamp]  DEFAULT (getdate()) FOR [DateStamp]