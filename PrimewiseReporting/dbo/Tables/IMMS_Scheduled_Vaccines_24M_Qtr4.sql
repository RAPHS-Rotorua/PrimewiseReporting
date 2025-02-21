CREATE TABLE [dbo].[IMMS_Scheduled_Vaccines_24M_Qtr4](
	[Imms_Schedule_ID] [int] IDENTITY(1,1) NOT NULL,
	[Scheduled_Age_Group] [varchar](50) NOT NULL,
	[Scheduled_Age] [varchar](50) NOT NULL,
	[Scheduled_Vaccine_Age] [varchar](50) NOT NULL,
	[Scheduled_Vaccine] [varchar](50) NOT NULL,
	[Dose] [int] NOT NULL,
	[OrderByNumber] [int] NOT NULL,
	[DateStamp] [datetime] NOT NULL
) ON [PRIMARY]