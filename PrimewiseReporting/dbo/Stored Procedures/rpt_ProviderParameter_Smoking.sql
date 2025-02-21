/*
AUTHOR:						Justin Sherborne
CREATE DATE:				17/6/2015
Note this has enrolled filter only												
 		
*/
CREATE Procedure [dbo].[rpt_ProviderParameter_Smoking] @PracticeIDs VARCHAR(MAX)
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
pt.ProviderCode as Prov
FROM Stage_Smoking_Register AS p
join Patient as pt on pt.NHI = p.nhi and pt.PracticeID = p.PracticeID
INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = p.PracticeID
where p.PatientUnenrolled = 0