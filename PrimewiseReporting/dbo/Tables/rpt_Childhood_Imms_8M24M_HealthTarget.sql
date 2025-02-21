CREATE TABLE [dbo].[rpt_Childhood_Imms_8M24M_HealthTarget](
	[MilestoneAge] [varchar](9) NOT NULL,
	[Denominator] [int] NULL,
	[Numerator] [int] NULL,
	[Performance] [decimal](17, 10) NULL,
	[Target] [numeric](1, 1) NOT NULL,
	[Required_Numerator] [numeric](12, 0) NULL,
	[Gap_To_Target] [numeric](13, 0) NULL
) ON [PRIMARY]