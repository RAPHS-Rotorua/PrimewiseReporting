CREATE TABLE [dbo].[PaymentWorking_QuarterlyUnearnedAchieved](
	[PracticeID] [int] NULL,
	[FundingStream] [varchar](250) NULL,
	[FundingAllocation] [varchar](500) NULL,
	[YearNo] [smallint] NOT NULL,
	[Monthno] [tinyint] NOT NULL,
	[Quarterly_Unearned_Achieved] [decimal](17, 2) NOT NULL,
	[FinancialYearID] [smallint] NULL
) ON [PRIMARY]