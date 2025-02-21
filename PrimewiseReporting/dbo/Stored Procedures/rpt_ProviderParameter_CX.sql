--exec rpt_ProviderParameter_CX '8'

/*
AUTHOR:						Justin Sherborne
CREATE DATE:				18/11/2016												
 		
*/
CREATE Procedure [dbo].[rpt_ProviderParameter_CX] @PracticeIDs VARCHAR(MAX)
as

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
c.ProviderCode as Prov
FROM Stage_CX_Reporting AS c
INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = c.PracticeID
where c.PatientUnenrolled = 0