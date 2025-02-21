CREATE TABLE [dbo].[Funding_Summary](
	[PracticeID] [int] NULL,
	[MonthNo] [int] NULL,
	[FinancialYearID] [int] NULL,
	[TotalFundingAvailable] [decimal](38, 2) NULL,
	[TotalFundingEarned] [decimal](38, 2) NULL,
	[CapitationFunding] [decimal](38, 2) NULL,
	[TotalQualityFunds] [decimal](38, 2) NULL,
	[FlexibleFundingEarned] [decimal](38, 2) NULL,
	[IncentiveAvailable] [decimal](38, 2) NULL,
	[IncentiveEarned] [decimal](38, 2) NULL,
	[QualityMonthlyTotalUnearned] [decimal](38, 2) NULL,
	[RCS_Funding] [decimal](38, 2) NULL,
	[QuarterlyUnearnedAvailable] [decimal](38, 2) NULL,
	[QuarterlyUnearnedAchieved] [decimal](38, 2) NULL,
	[RollingUnearned] [decimal](38, 2) NULL,
	[RollingPaid] [decimal](38, 2) NULL
) ON [PRIMARY]