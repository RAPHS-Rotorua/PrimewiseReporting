CREATE TABLE [dbo].[Stage_BCTI_Report](
	[Quarter_No] [tinyint] NOT NULL,
	[Month_No] [tinyint] NOT NULL,
	[Month_Name] [nvarchar](30) NULL,
	[Financial_Year] [smallint] NOT NULL,
	[FinancialYear_Range] [varchar](9) NULL,
	[PracticeID] [int] NULL,
	[Payee] [varchar](255) NULL,
	[Practice] [varchar](100) NULL,
	[Address2] [varchar](255) NULL,
	[Address3] [varchar](255) NULL,
	[ird_no] [varchar](255) NULL,
	[EndOfMonth] [date] NULL,
	[MeasureCodeGrouping] [varchar](120) NULL,
	[MeasureFriendlyDescription] [varchar](120) NULL,
	[MeasureOrderBy] [int] NULL,
	[PaymentTotal_GSTExcl] [decimal](38, 2) NULL
) ON [PRIMARY]