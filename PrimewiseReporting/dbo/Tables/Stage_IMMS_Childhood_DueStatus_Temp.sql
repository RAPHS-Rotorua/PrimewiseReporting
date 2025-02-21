CREATE TABLE [dbo].[Stage_IMMS_Childhood_DueStatus_Temp](
	[PracticeID] [int] NULL,
	[NHI] [varchar](255) NULL,
	[Date_of_Birth] [datetime] NULL,
	[Due_Group] [varchar](17) NOT NULL,
	[Due_Group_Sort] [int] NOT NULL,
	[Immunisation_Schedule] [varchar](50) NULL,
	[Immunisation_Schedule_sort] [int] NOT NULL,
	[Schedule_Status] [varchar](18) NOT NULL,
	[Schedule_Status_sort] [int] NOT NULL,
	[Decline_Status] [varchar](18) NULL,
	[TotalChildren] [int] NOT NULL,
	[FullyDeclined] [int] NULL,
	[PartiallyDeclined] [int] NULL
) ON [PRIMARY]