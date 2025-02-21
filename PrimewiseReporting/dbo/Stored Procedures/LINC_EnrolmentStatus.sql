CREATE Procedure [dbo].[LINC_EnrolmentStatus] @PracticeIDs VARCHAR(MAX)
as
SET NOCOUNT ON	

/*
	Author:  Justin Sherborne
	Date: 10 Sep 2017

	changes:
	1. 2024-7-8: JS removed the logic in the LTCEnrolmentIndicator_Text:  
		iif(h.PracticeID = 17 and LTCEnrolmentIndicator_Text = 'Expired','Expired This Qtr',LTCEnrolmentIndicator_Text) as 'LTCEnrolmentIndicator_Text'  --only for Ranolf at this stage 
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

Select NHI, LTCEnrolmentIndicator_Text
, LTCEnrolmentIndicator_Sort
from @AuthorisedPracticeIDList AS PID
		INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
	join Stage_LINC_Reporting as h on PID.practiceID = h.PracticeID
	where h.PatientUnenrolled = 0 and h.In_Denominator = 1