CREATE TABLE [dbo].[rpt_Childhood_Imms_24M_Qtr4_HealthTarget](
	[Cohort] [varchar](5) NOT NULL,
	[MilestoneAge] [varchar](18) NOT NULL,
	[Denominator] [int] NULL,
	[Numerator] [int] NULL,
	[Performance] [decimal](17, 10) NULL,
	[Target] [numeric](2, 2) NOT NULL,
	[Required_Numerator] [numeric](13, 0) NULL,
	[Gap_To_Target] [numeric](14, 0) NULL
) ON [PRIMARY]