﻿CREATE TABLE [dbo].[POAC_ServiceDelivery](
	[ServiceProvider] [varchar](255) NULL,
	[PracticeID] [int] NULL,
	[NHI] [varchar](100) NULL,
	[DOB] [datetime] NULL,
	[Age_LastMonthEnd] [int] NULL,
	[LastName] [varchar](100) NULL,
	[Firstname] [varchar](100) NULL,
	[Provider] [varchar](101) NULL,
	[Provider_Code] [varchar](50) NULL,
	[SubService] [varchar](150) NULL,
	[PaymentFlag] [varchar](10) NOT NULL,
	[Code] [varchar](50) NULL,
	[ServiceDescription] [varchar](500) NULL,
	[DateObserved] [datetime] NULL,
	[ProviderPayment] [decimal](8, 2) NULL,
	[Qty] [int] NULL,
	[Total] [decimal](8, 2) NULL,
	[Status] [varchar](50) NULL,
	[DateModified] [datetime] NULL,
	[Comment] [varchar](500) NULL,
	[ProcessStatus] [varchar](30) NULL,
	[InProcessDate] [datetime] NULL,
	[ProcessedDate] [datetime] NULL,
	[Ethnicity_Code] [int] NULL,
	[Ethnicity] [varchar](150) NULL,
	[Gender] [varchar](50) NULL,
	[Quintile] [int] NULL,
	[CSC_Number] [varchar](255) NULL,
	[CSC_Indicator] [int] NULL,
	[CSC_Start_Date] [datetime] NULL,
	[CSC_End_Date] [datetime] NULL,
	[CSC_Expiry_Date] [datetime] NULL,
	[Funded_byNHIandPracticeID] [int] NULL,
	[Funded_byNHI] [int] NULL
) ON [PRIMARY]