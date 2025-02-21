CREATE TABLE [dbo].[FundingTotals_Test](
	[PracticeID] [int] NULL,
	[MonthNo] [tinyint] NOT NULL,
	[YearNo] [smallint] NOT NULL,
	[TotalFundingAvailable] [decimal](38, 2) NULL,
	[TotalFundingEarned] [decimal](38, 2) NULL,
	[CapitationFunding] [decimal](38, 2) NULL,
	[TotalQualityFunds] [decimal](38, 2) NULL,
	[FlexibleFundingOriginal] [decimal](38, 2) NULL,
	[FlexibleFundingEarned] [decimal](38, 2) NULL,
	[IncentiveAvailable] [decimal](38, 2) NULL,
	[IncentiveEarned] [decimal](38, 2) NULL,
	[TotalUnearned] [decimal](38, 2) NULL
) ON [PRIMARY]