/*
AUTHOR:						Justin Sherborne
CREATE DATE:				18/3/2020
Note this has enrolled filter only												
 		
*/
CREATE Procedure [dbo].[rpt_ProviderParameter_Flu] @PracticeIDs VARCHAR(MAX)
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

Select
 DISTINCT 
p.ProviderCode as Prov
FROM 
@AuthorisedPracticeIDList AS PID
	INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
 join Patient AS p
ON p.PracticeID = PID.PracticeID 
where (p.EnrolledInPMS = 'enrolled' or p.Funding = 'Capitated')
and p.PracticeID <> 0
and
(DATEDIFF(Year,p.DOB, GetDate())
-
	Case
		When Cast(DATEADD(Year,DATEDIFF(Year,p.DOB, GetDate()),p.DOB) as date) > Cast(GetDate() as Date) then 1
		else 0
	End >= 65 or p.LTCEnrolmentIndicator = 1)