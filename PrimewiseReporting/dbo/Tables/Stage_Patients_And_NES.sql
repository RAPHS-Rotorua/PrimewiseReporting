﻿CREATE TABLE [dbo].[Stage_Patients_And_NES](
	[PracticeID] [int] NULL,
	[Practice] [varchar](100) NULL,
	[NHI] [varchar](50) NULL,
	[Firstname] [varchar](50) NULL,
	[Surname] [varchar](50) NULL,
	[Patient] [varchar](120) NULL,
	[DOB] [datetime] NULL,
	[Gender] [varchar](50) NULL,
	[Ethnicity] [varchar](255) NULL,
	[Quintile] [int] NULL,
	[Postal_Address] [varchar](350) NULL,
	[HomePhone] [varchar](50) NULL,
	[CellPhone] [varchar](50) NULL,
	[EnrolledInPMS] [varchar](50) NULL,
	[Funding] [varchar](50) NULL,
	[Enrolled_In_NES] [bit] NULL,
	[NES_Start] [datetime] NULL,
	[NES_End] [datetime] NULL,
	[NES_Expiry] [datetime] NULL,
	[NES_Status] [varchar](50) NOT NULL,
	[NES_End_ReportDate] [datetime] NULL
) ON [PRIMARY]