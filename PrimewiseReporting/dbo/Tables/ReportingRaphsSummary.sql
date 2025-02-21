CREATE TABLE [dbo].[ReportingRaphsSummary](
	[FiscalQuarterKey] [int] NULL,
	[FiscalYearKey] [int] NULL,
	[CapitatedPatientCount] [int] NULL,
	[QuarterlyDiabeticPatientCount] [int] NULL,
	[CurrentDiabeticPatientCount] [int] NULL,
	[LTCPatientCount] [int] NULL,
	[DiabetesLTCPatientCount] [int] NULL,
	[GrossDALYValue] [int] NULL,
	[QuaterlyLINCFundingPool] [decimal](18, 2) NULL,
	[QuaterlyDiabetesFundingPool] [decimal](18, 2) NULL,
	[QuarterlyLINCIncentivePool] [decimal](18, 2) NULL,
	[QuarterlyDIABIncentivePool] [decimal](18, 2) NULL,
	[QuarterlyAdminSalaryPool] [decimal](18, 2) NULL,
	[DateStamp] [smalldatetime] NULL,
	[QuarterlyDIAB_06IncentivePool] [decimal](18, 2) NULL,
	[QuarterlyDIAB_MMCFundingPool] [decimal](18, 2) NULL,
	[QuarterlyDIAB_MMCIncentivePool] [decimal](18, 2) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ReportingRaphsSummary] ADD  CONSTRAINT [DF_PrimeWiseRaphsSummary_DateStamp]  DEFAULT (getdate()) FOR [DateStamp]