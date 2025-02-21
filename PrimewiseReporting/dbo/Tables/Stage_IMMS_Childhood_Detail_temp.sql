﻿CREATE TABLE [dbo].[Stage_IMMS_Childhood_Detail_temp](
	[PracticeID] [int] NULL,
	[Practice] [varchar](100) NULL,
	[NHI] [varchar](255) NULL,
	[Full_Name] [varchar](511) NOT NULL,
	[ProviderCode] [varchar](50) NULL,
	[Date_of_Birth] [datetime] NULL,
	[Child_Age] [varchar](11) NULL,
	[Eligibility_Age] [datetime] NULL,
	[Ethnicity] [varchar](255) NULL,
	[Quintile] [int] NULL,
	[Gender] [varchar](255) NULL,
	[Phone] [varchar](50) NULL,
	[CSC_Number] [varchar](255) NULL,
	[CSC_Expiry_Date] [datetime] NULL,
	[CSC_Current] [int] NOT NULL,
	[Age_8_Months] [datetime] NULL,
	[Milestone_Age_8_Months] [int] NOT NULL,
	[Numerator_8_Months] [int] NOT NULL,
	[Age_24_Months] [datetime] NULL,
	[Milestone_Age_24_Months] [int] NOT NULL,
	[Numerator_24_Months] [int] NOT NULL,
	[Milestone_Age_8_24_Months] [varchar](9) NULL,
	[SLM_Age_24_Months_Qtr4] [int] NOT NULL,
	[Numerator_24_Months_Qtr4] [int] NOT NULL,
	[Completed_24_Months_Qtr4] [varchar](9) NULL,
	[Immunisation_Schedule] [varchar](50) NULL,
	[Immunisation_Schedule_sort] [int] NOT NULL,
	[Schedule_Status] [varchar](18) NOT NULL,
	[Schedule_Status_sort] [int] NOT NULL,
	[Due_Group] [varchar](17) NOT NULL,
	[Due_Group_Sort] [int] NOT NULL,
	[Scheduled_Vaccine_Age] [varchar](50) NULL,
	[Scheduled_Vaccine] [varchar](50) NULL,
	[Scheduled_Age] [varchar](50) NULL,
	[WhenImm] [date] NULL,
	[dose] [int] NULL,
	[ImmunisationStatus] [varchar](80) NULL,
	[VaccineOutcome] [varchar](250) NULL,
	[Patient_Unenrolled] [int] NULL,
	[NES_Source] [varchar](20) NULL,
	[OrderByNumber] [int] NULL,
	[DateStamp] [datetime] NULL
) ON [PRIMARY]