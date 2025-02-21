CREATE TABLE [dbo].[Stage_Diab_ClinicalHistory](
	[nhi] [varchar](50) NULL,
	[ResultCode] [varchar](32) NULL,
	[Measure] [varchar](4000) NULL,
	[RecordedDate] [datetime] NULL,
	[Result] [decimal](16, 2) NULL,
	[Result_Text] [varchar](500) NULL,
	[PracticeID] [int] NULL
) ON [PRIMARY]