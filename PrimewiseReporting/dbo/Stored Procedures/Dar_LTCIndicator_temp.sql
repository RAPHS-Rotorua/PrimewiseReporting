/***
Exec [Dar_LTCIndicator_temp] '15'
***/
Create Procedure [dbo].[Dar_LTCIndicator_temp] @PracticeIDs VARCHAR(MAX)
as
SET NOCOUNT ON	

/*
	Author:  Justin Sherborne
	Date: 26 Jul 2017
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


Select h.LTCEnrolmentIndicator_Text, h.LTCEnrolmentIndicator_Sort, count(*) as no_rows
from @AuthorisedPracticeIDList AS PID
		INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
	join Dar_Reporting_TempTest as h on PID.practiceID = h.PracticeID
	group by h.LTCEnrolmentIndicator_Text, h.LTCEnrolmentIndicator_Sort