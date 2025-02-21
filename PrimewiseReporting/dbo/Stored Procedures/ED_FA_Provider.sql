CREATE Procedure [dbo].[ED_FA_Provider] @PracticeIDs VARCHAR(MAX)
as

/*
	Author:  Justin Sherborne
	Date: 26 Apr 2018

*/	
SET NOCOUNT ON;
	
	-- find the authorised Practicec IDs
	DECLARE @AuthorisedPracticeIDList TABLE
		(
		PracticeID INT
		)		
	INSERT INTO	@AuthorisedPracticeIDList(PracticeID)
	EXEC [dbo].[Report_GetAuthorisedPracticeIDs]

	--- Get the selected ID's
	DECLARE @SelectedPracticeIDList TABLE
		(
		PracticeID INT
		)		
	INSERT INTO	@SelectedPracticeIDList(PracticeID)
	SELECT NUMBER FROM PrimeWiseReporting.[dbo].[fn_SplitInt] (@PracticeIDs, ',');

Select 
distinct ProvCode as Provider
FROM @AuthorisedPracticeIDList AS PID
	INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
join Stage_ED_Frequent_Attendee as e on e.PracticeID = SL.PracticeID
where e. EnrolledInPMS = 'Enrolled' and e.Active = 1