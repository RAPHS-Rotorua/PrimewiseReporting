/*
AUTHOR:						Justin Sherborne
CREATE DATE:				4 Jul 2017
												
 		
*/
--[rpt_CMIParameter_CX] '30'

CREATE Procedure [dbo].[rpt_CMIParameter_CX] @PracticeIDs VARCHAR(MAX)
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


Select distinct Last_Result as 'CMI',
Case Last_Result
	when 'H' then 1
	When 'L' then 2
	when 'U' then 3
	when 'N' then 4
	when 'CXN' then 5
	when 'NR' then 6
	when 'CIN1' then 7
	when 'NPA' then 8
when 'HYST' then 9
when '' then 20
Else 10
End as CMI_Sort 
from Stage_CX_Reporting as x
INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = x.PracticeID 
where x.PatientUnenrolled = 0
ORDER BY CMI_Sort