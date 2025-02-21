CREATE Procedure [dbo].[Funding_PracticeTotal_Test] @PracticeIDs VARCHAR(MAX), @Month tinyint, @Year smallint
as
SET NOCOUNT ON	
/*
	Author:  Justin Sherborne
	Date: 31_May_2019
*/	
DECLARE @AuthorisedPracticeIDList TABLE
		(
		PracticeID INT
		)		
	INSERT INTO	@AuthorisedPracticeIDList(PracticeID)
	EXEC [dbo].[Report_GetAuthorisedPracticeIDs];

	--- Get the selected ID's
	DECLARE @SelectedPracticeIDList TABLE
		(
		PracticeID INT
		)		
	INSERT INTO	@SelectedPracticeIDList(PracticeID)
	SELECT NUMBER FROM PrimeWiseReporting.[dbo].[fn_SplitInt] (@PracticeIDs, ',');

Select p.SurgeryName as 'Practice',
h.*
FROM 
@AuthorisedPracticeIDList AS PID
		INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
	join FundingPracticeTotals_Test as h on h.practiceID = PID.PracticeID
	left join Practice as p on p.PracticeID = h.PracticeID
	where h.MonthNo = @Month and h.YearNo = h.YearNo