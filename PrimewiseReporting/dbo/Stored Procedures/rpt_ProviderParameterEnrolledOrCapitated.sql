/*
AUTHOR:						Justin Sherborne
CREATE DATE:				17/6/2015
Note this has enrolled or capitated												
 		
*/
CREATE Procedure [dbo].[rpt_ProviderParameterEnrolledOrCapitated] @PracticeIDs VARCHAR(MAX)
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
p.ProviderCode as Prov
FROM         Patient AS p
INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = p.PracticeID 
INNER JOIN ReportingPatientByPractice AS r ON p.PatientID = r.PatientID
where p.EnrolledInPMS = 'Enrolled' or p.Funding = 'Capitated'