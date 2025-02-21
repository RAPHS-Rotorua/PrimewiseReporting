CREATE TABLE [dbo].[IMMS_Scheduled_Vaccines](
	[Imms_Schedule_ID] [int] IDENTITY(1,1) NOT NULL,
	[Scheduled_Age_Group] [varchar](50) NOT NULL,
	[Scheduled_Age] [varchar](50) NOT NULL,
	[Scheduled_Vaccine_Age] [varchar](50) NOT NULL,
	[Scheduled_Vaccine] [varchar](50) NOT NULL,
	[Dose] [int] NOT NULL,
	[OrderByNumber] [int] NOT NULL,
	[DateStamp] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Imms_Schedule_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[IMMS_Scheduled_Vaccines] ADD  CONSTRAINT [DF_IMMS_Scheduled_Vaccines_DateStamp]  DEFAULT (getdate()) FOR [DateStamp]