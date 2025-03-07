use PrimewiseReporting
go
CREATE TABLE [dbo].[IMMS_24MonthQtr4SummaryRAPHS]
(
	[IMMS_24MonthQtr4SummaryID] [int] IDENTITY(1,1) NOT NULL,  --Not using identity in sql08\instance2 as want to keep same as SQL09
	[Cohort] [varchar](100) NULL,
	[PracticeID] [int] NULL,
	[NHI] [varchar](255) NULL,
	[Ethnicity] [varchar](9) NOT NULL,
	SLM_Age_24_Months_Qtr4 [int] NOT NULL,
	Numerator_24_Months_Qtr4 [int] NOT NULL,
	[MonthNo] [int] NOT NULL,
	[YearNo] [int] NOT NULL,
	[ReportingDate] [int] NOT NULL,
	[DateLabel] [varchar](8) NOT NULL,
	[DateStamp] [datetime] NOT NULL,
 CONSTRAINT [PK_IMMS_24MonthQtr4SummaryRAPHS] PRIMARY KEY CLUSTERED 
(
	[IMMS_24MonthQtr4SummaryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
--Not using DF constraint in SQL08\Instance2 as want the same as SQL09
ALTER TABLE [dbo].[IMMS_24MonthQtr4SummaryRAPHS] ADD  CONSTRAINT [DF_IMMS_24MonthQtr4SummaryRAPHS_DateStamp]  DEFAULT (getdate()) FOR [DateStamp]

