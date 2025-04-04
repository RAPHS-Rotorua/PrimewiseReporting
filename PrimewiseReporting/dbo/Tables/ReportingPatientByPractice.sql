﻿CREATE TABLE [dbo].[ReportingPatientByPractice](
	[PatientID] [int] NOT NULL,
	[PracticeID] [int] NOT NULL,
	[CalendarDateKey] [int] NOT NULL,
	[DALYRate] [int] NULL,
	[CalculatedLincScore] [int] NULL,
	[CurrentRecordedLincScore] [int] NULL,
	[PreviousRecordedLincScore] [int] NULL,
	[CurrentIntensityMeasurementDate] [datetime] NULL,
	[PreviousIntensityMeasurementDate] [datetime] NULL,
	[CurrentIntensityLevel] [varchar](50) NULL,
	[PreviousIntensityLevel] [varchar](50) NULL,
	[LTCAnnualReviewStatus] [varchar](50) NULL,
	[LTCAnnualReviewNextPlanDate] [datetime] NULL,
	[LTCAnnualReviewLastCompletedDate] [datetime] NULL,
	[LTCAnnualReviewExcludedDate] [datetime] NULL,
	[LTCAnnualReviewEnrolmentDate] [datetime] NULL,
	[DARStatus] [varchar](50) NULL,
	[DARNextPlanDate] [datetime] NULL,
	[DARLastCompletedDate] [datetime] NULL,
	[DARLastExcludedDate] [datetime] NULL,
	[DAREnrolmentDate] [datetime] NULL,
	[DateStamp] [smalldatetime] NULL,
	[RSReferred] [bit] NULL,
	[RSStatus] [varchar](50) NULL,
	[RSAnnaulReviewNextPlanDate] [datetime] NULL,
	[RSAnnualReviewLastCompletedDate] [datetime] NULL,
	[RSAnnualReviewLastExcludedDate] [datetime] NULL,
	[RSEnrolmentDate] [datetime] NULL,
	[HBa1c] [decimal](6, 2) NULL,
	[Alb Creat Ratio] [varchar](500) NULL,
	[Diabetes Type] [varchar](500) NULL,
	[ACEi or A2] [varchar](500) NULL,
	[CVDRA_LastScreenedDate] [datetime] NULL,
	[CVDRA_DateOnset] [datetime] NULL,
	[CVDRA_Status] [varchar](20) NULL,
	[CVDRA_Screen_Status] [varchar](50) NULL,
	[CVDRA_Last_Funded_Screen] [datetime] NULL,
	[CVDRA_EligibilityProgramme] [varchar](20) NULL,
	[CVDRA_Ethnicity] [varchar](50) NULL,
	[CVDRA_Quintile] [int] NULL,
	[PresumptiveRisk] [bit] NULL,
	[CVD_DIAB] [bit] NULL,
	[CVD_Renal] [bit] NULL,
	[CVD_Lipid] [bit] NULL,
	[CVD_cvd] [bit] NULL,
	[CVDRisk] [varchar](500) NULL,
	[CVDRA_Screen_PracticeID] [int] NULL,
	[CVDRA_AgeAsAt] [int] NULL,
	[CVDRA_FundedScreen_Complete] [varchar](50) NULL,
	[CVDRA_CurrentEligibility] [varchar](50) NULL,
	[HbA1c_Date] [datetime] NULL,
	[AlbCreat_Date] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ReportingPatientByPractice] ADD  CONSTRAINT [DF_ReportingPWPatient_CalculatedLincScore]  DEFAULT ((0)) FOR [CalculatedLincScore]
GO
ALTER TABLE [dbo].[ReportingPatientByPractice] ADD  CONSTRAINT [DF_ReportingPWPatient_DateStamp]  DEFAULT (getdate()) FOR [DateStamp]