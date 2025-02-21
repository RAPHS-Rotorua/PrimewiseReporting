CREATE TABLE [dbo].[ReportingPracticeConnectionInformation](
	[PracticeID] [int] NOT NULL,
	[ADUsergroup] [varchar](100) NULL,
	[DataConnectionsUserName] [varchar](100) NULL,
	[DateStamp] [smalldatetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ReportingPracticeConnectionInformation] ADD  DEFAULT (getdate()) FOR [DateStamp]