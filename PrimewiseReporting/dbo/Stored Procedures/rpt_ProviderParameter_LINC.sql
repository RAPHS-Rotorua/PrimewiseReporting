CREATE Procedure [dbo].[rpt_ProviderParameter_LINC] @PracticeIDs VARCHAR(MAX)
as

/*
AUTHOR:						Justin Sherborne
CREATE DATE:				11 Sep 2017												
 	
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

SELECT DISTINCT 
Prov
FROM Stage_LINC_Reporting as l
INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = l.PracticeID
where l.PatientUnenrolled = 0 and l.In_Denominator = 1