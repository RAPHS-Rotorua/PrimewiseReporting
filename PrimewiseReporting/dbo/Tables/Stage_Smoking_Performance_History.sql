CREATE TABLE [dbo].[Stage_Smoking_Performance_History](
	[Smoking_History_ID] [int] IDENTITY(1,1) NOT NULL,
	[PracticeID] [int] NULL,
	[Practice] [varchar](5) NOT NULL,
	[Cessation_Recorded] [int] NULL,
	[Cessation_Recorded_Maori] [int] NULL,
	[Overdue] [int] NULL,
	[Overdue_Maori] [int] NULL,
	[Total_Eligible] [int] NULL,
	[Total_Eligible_Maori] [int] NULL,
	[Performance] [decimal](23, 13) NULL,
	[Performance_Maori] [decimal](23, 13) NULL,
	[Programme_Goal] [numeric](2, 2) NOT NULL,
	[No_Required_To_Target] [decimal](11, 0) NULL,
	[No_Required_To_Target_Maori] [decimal](11, 0) NULL,
	[Last_Updated] [datetime] NULL,
	[RAPHS_Performance] [decimal](23, 13) NULL,
	[RAPHS_Performance_Maori] [decimal](23, 13) NULL,
	[DateStamp] [datetime] NULL,
	[Smoking_Cohort_Count] [int] NULL,
 CONSTRAINT [Smoking_History_ID_PK] PRIMARY KEY CLUSTERED 
(
	[Smoking_History_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]