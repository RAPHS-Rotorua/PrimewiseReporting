﻿CREATE Procedure [dbo].[ED_FA_Summary] @PracticeIDs VARCHAR(MAX)
as

/*
	Author:  Justin Sherborne
	Date: 26 Apr 2018

*/	
SET NOCOUNT ON;
	
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
	SELECT NUMBER FROM PrimeWiseReporting.[dbo].[fn_SplitInt] (@PracticeIDs, ',');

Select 
e.PracticeID, Practice, NHI, Patient, DOB,Gender, Ethnicity, ProvCode, EnrolledInPMS,
LINC_Complete, TPOC52_Complete, Max(Departure) as LastED_Discharge,
Count(*) as No_Admissions
FROM @AuthorisedPracticeIDList AS PID
	INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
join Stage_ED_Frequent_Attendee as e on e.PracticeID = SL.PracticeID
where e. EnrolledInPMS = 'Enrolled' and Active = 1
group by e.PracticeID, Practice, NHI, Patient, DOB,Gender, Ethnicity, ProvCode, EnrolledInPMS,
LINC_Complete, TPOC52_Complete
order by NHI