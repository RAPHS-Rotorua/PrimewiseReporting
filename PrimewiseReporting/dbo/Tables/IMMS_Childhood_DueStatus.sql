CREATE TABLE [dbo].[IMMS_Childhood_DueStatus](
	[IMMS_Childhood_DueStatusID] [int] IDENTITY(1,1) NOT NULL,
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
	[PartiallyDeclined] [int] NULL,
	[DateStamp] [datetime] NULL,
 CONSTRAINT [PK_IMMS_Childhood_DueStatusID] PRIMARY KEY CLUSTERED 
(
	[IMMS_Childhood_DueStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]