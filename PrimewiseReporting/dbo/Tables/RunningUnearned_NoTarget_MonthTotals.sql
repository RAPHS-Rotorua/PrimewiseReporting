CREATE TABLE [dbo].[RunningUnearned_NoTarget_MonthTotals](
	[PracticeID] [int] NULL,
	[FinancialYearID] [smallint] NULL,
	[YearNo] [smallint] NULL,
	[MonthNo] [tinyint] NULL,
	[MonthOrder] [tinyint] NULL,
	[FundingStream] [varchar](500) NULL,
	[FundingAllocation] [varchar](500) NULL,
	[RollingUnearnedTotal] [decimal](17, 2) NULL,
	[RollingUnearnedAchieved] [decimal](17, 2) NULL,
	[RollingPaidTotal] [decimal](17, 2) NULL,
	[MeasureTarget] [decimal](5, 4) NULL,
	[Denominator] [decimal](20, 4) NULL,
	[Numerator] [decimal](20, 4) NULL,
	[Performance] [decimal](5, 4) NULL,
	[No_Required_To_Target] [int] NULL
) ON [PRIMARY]