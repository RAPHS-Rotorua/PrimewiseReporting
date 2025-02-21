CREATE Procedure [dbo].[rpt_ProviderParameter_DAR] @PracticeIDs VARCHAR(MAX)
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
Prov
FROM Stage_Dar_Reporting as d
INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = d.PracticeID
where d.PatientUnenrolled = 0