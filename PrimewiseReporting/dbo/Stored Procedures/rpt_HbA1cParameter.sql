CREATE Procedure [dbo].[rpt_HbA1cParameter] @PracticeIDs VARCHAR(MAX)
as

/*
AUTHOR:						Justin Sherborne
CREATE DATE:				21 Aug 2017												
 		
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
HbA1c_Bands, HBa1c_Bands_sort
FROM Stage_Dar_Reporting as d
INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = d.PracticeID
where d.PatientUnenrolled = 0
order by HBa1c_Bands_sort