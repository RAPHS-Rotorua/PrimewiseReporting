--Exec CX_Register '17'
CREATE Procedure [dbo].[CX_Register] @PracticeIDs VARCHAR(MAX)
as
SET NOCOUNT ON	

/*
	Author:  Justin Sherborne
	Date: 31 Oct 2016
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

Select p.SurgeryName as 'Practice',
h.NHI, h.PatientName, h.DOB, h.Age_Qtr_End, h.Ethnicity, h.Last_Screen, h.CellPhone, h.HomePhone, h.ProviderCode, h.Mamm_Due, h.Complete_Status, h.CX_Status,
h.CMI, h.LOCATION_OF_LAST_SCREEN,
(Select Max(Last_Screen) from Stage_CX) as MaxScreen,
h.PriorityGroup
FROM 
@AuthorisedPracticeIDList AS PID
		INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
	join Stage_CX as h on PID.practiceID = h.PracticeID
	left join Practice as p on h.PracticeID = p.PracticeID