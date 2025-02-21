CREATE TABLE [dbo].[Stage_CarriedFWD](
	[OrderByQtr] [int] NOT NULL,
	[Qtr] [varchar](17) NOT NULL,
	[Financial_Year] [smallint] NULL,
	[PracticeID] [int] NULL,
	[Qtr_DateRange] [varchar](32) NULL,
	[Qtr_CarriedFwd] [decimal](38, 2) NULL
) ON [PRIMARY]