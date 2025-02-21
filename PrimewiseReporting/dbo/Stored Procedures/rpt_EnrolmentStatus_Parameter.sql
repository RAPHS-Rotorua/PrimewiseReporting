/* Test
--exec [rpt_LINCRegister] '14'
--Patient table contains LTC Expiry Date
--Select * from Patient
--go
--alter stored proc rpt_DiabetesRegister
*/
CREATE Procedure [dbo].[rpt_EnrolmentStatus_Parameter] @PracticeIDs VARCHAR(MAX)
as
SET NOCOUNT ON	

/*
	Author:  Justin Sherborne
	Date: 28 Apr 2014

*/	
	
	-- find the authorised Practicec IDs
	DECLARE @AuthorisedPracticeIDList TABLE
		(
		PracticeID INT
		)		
	INSERT INTO	@AuthorisedPracticeIDList(PracticeID)
	EXEC [dbo].[Report_GetAuthorisedPracticeIDs]




	--- Get the selected ID's
	DECLARE @SelectedPracticeIDList TABLE
		(
		PracticeID INT
		)		
	INSERT INTO	@SelectedPracticeIDList(PracticeID)
	SELECT NUMBER FROM PrimeWiseReporting.[dbo].[fn_SplitInt] (@PracticeIDs, ',')

Select distinct 
Case
	When PBP.FormPresent = 0 then 'No Form'
	when PBP.FormPresent = 1 and pbp.ValidForm = 0 then 'Invalid'
	when pbp.ValidForm = 1 and Cast(pbp.EnrolmentDate AS Date) > DATEADD(YEAR,-3,Cast(GETDATE() AS Date))
	then 'Valid (< 3 years)'
	when pbp.ValidForm = 1 and Cast(pbp.EnrolmentDate AS Date) <= DATEADD(YEAR,-3,Cast(GETDATE() AS Date))
	then 'Valid (>= 3 years)'
	else 'Uncertain'
End as Enrolment_Status
	FROM @AuthorisedPracticeIDList AS PID
	INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
	JOIN dbo.Reporting_Enrolment AS PBP ON PID.PracticeID = pbp.PracticeID --inner join as these already only contain enrolled patients.  uSING nhi IN JOIN for now as ran the load before the etl ran and the patientID's can change each night