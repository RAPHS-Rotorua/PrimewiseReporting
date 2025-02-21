--Test
--exec [rpt_Palliative_Care] '15'

CREATE Procedure [dbo].[rpt_Palliative_Care] @PracticeIDs VARCHAR(MAX)
as
SET NOCOUNT ON	

/*
	Author:  Justin Sherborne
	Date: 16 Oct 2016

*/	
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

	Select p.SurgeryName,  (Select top 1 Firstname + ' ' + Surname as PatientName from Patient as p1  --Only a few rows so will always be ok performance wise
	where p1.NHI = s.NHI and p1.PracticeID = s.PracticeID
			order by 
				Case EnrolledInPMS
					when 'Deceased' then 1
					when 'Enrolled' then 2
					else 3
				End asc) as PatientName, s.* 
	FROM @AuthorisedPracticeIDList AS PID
	INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
	INNER JOIN PalliativeCare s On s.PracticeID = PID.PracticeID
	INNER JOIN Practice AS P ON P.PracticeID = PID.PracticeID