﻿CREATE TABLE [dbo].[Temp_FinancialPractice_Test](
	[MeasureGroup] [varchar](100) NULL,
	[MeasureFriendlyDescription] [varchar](100) NULL,
	[MaintenanceTarget] [decimal](3, 2) NOT NULL,
	[IncentiveTarget] [decimal](3, 2) NOT NULL,
	[Performance] [decimal](3, 2) NOT NULL,
	[MaintenanceQuarterlyMax] [decimal](38, 5) NULL,
	[IncentiveQuarterlyMax] [decimal](38, 5) NULL,
	[QuarterlyMaxTotal] [decimal](38, 5) NULL,
	[PracticeID] [int] NULL,
	[Financial_Year] [smallint] NULL,
	[Quarter_No] [tinyint] NULL,
	[MeasureCode] [varchar](20) NULL,
	[ActualQuarterTotal] [decimal](38, 5) NULL,
	[Month_1_Of_Qtr_ActualTotal] [decimal](38, 2) NULL,
	[Month_2_Of_Qtr_ActualTotal] [decimal](38, 2) NULL,
	[Month_3_Of_Qtr_ActualTotal] [decimal](38, 2) NULL,
	[Month_1_Complete] [int] NULL,
	[Month_2_Complete] [int] NULL,
	[Month_3_Complete] [bit] NULL,
	[Quarter_CarryFwd] [decimal](38, 2) NULL
) ON [PRIMARY]