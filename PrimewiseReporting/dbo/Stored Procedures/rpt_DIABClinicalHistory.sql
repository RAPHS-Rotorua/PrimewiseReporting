--Exec [dbo].[rpt_CVRDRARegister] '17'
CREATE Procedure [dbo].[rpt_DIABClinicalHistory] @PracticeIDs VARCHAR(MAX)
as
SET NOCOUNT ON	

/*
	Author:  Justin Sherborne
	Date: 10 July 2014

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

Select nhi,ResultCode,
Case when ResultCode in('2019','HBa1c') then 'HBa1c'
	When ResultCode in('1033','ACR') then 'ACR'
End as Code,
Measure,  RecordedDate, Result, Result_Text, c.PracticeID
FROM 
@AuthorisedPracticeIDList AS PID
		INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
	join Stage_Diab_ClinicalHistory as c on PID.PracticeID = c.PracticeID