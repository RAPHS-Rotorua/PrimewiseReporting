CREATE TABLE [dbo].[Stage_CVDRA_Performance_history](
	[CVDRA_History_ID] [int] IDENTITY(1,1) NOT NULL,
	[PracticeID] [int] NULL,
	[Practice] [varchar](5) NOT NULL,
	[Risk_Recorded] [int] NULL,
	[Risk_Recorded_M_3544] [int] NULL,
	[Overdue] [int] NULL,
	[Overdue_M_3544] [int] NULL,
	[Total_Eligible] [int] NULL,
	[Total_Eligible_M_3544] [int] NULL,
	[Performance] [decimal](23, 13) NULL,
	[Performance_M_3544] [decimal](23, 13) NULL,
	[National_Target] [numeric](2, 2) NOT NULL,
	[No_Required_To_Target] [decimal](11, 0) NULL,
	[No_Required_To_Target_M_3544] [decimal](11, 0) NULL,
	[RAPHS_Performance] [decimal](23, 13) NULL,
	[RAPHS_Performance_M_3544] [decimal](23, 13) NULL,
	[DateStamp] [datetime] NULL,
	[CVDRA_Cohort_Count] [int] NULL,
 CONSTRAINT [CVDRA_History_ID_PK] PRIMARY KEY CLUSTERED 
(
	[CVDRA_History_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]