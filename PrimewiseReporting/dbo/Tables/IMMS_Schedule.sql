CREATE TABLE [dbo].[IMMS_Schedule](
	[Imms_Schedule_ID] [int] IDENTITY(1,1) NOT NULL,
	[Scheduled_Age_Group] [varchar](50) NOT NULL,
	[Scheduled_Age] [varchar](50) NOT NULL,
	[Scheduled_Vaccine] [varchar](50) NOT NULL,
	[Dose] [int] NOT NULL
) ON [PRIMARY]