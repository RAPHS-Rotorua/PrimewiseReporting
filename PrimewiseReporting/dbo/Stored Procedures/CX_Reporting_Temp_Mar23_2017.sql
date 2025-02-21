CREATE proc [dbo].[CX_Reporting_Temp_Mar23_2017]  @PracticeIDs VARCHAR(MAX)
as

/*
	Author:  Justin Sherborne
	Date: 24 Mar 2017
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
h.NHI, h.Surname + ', ' + h.Firstname as PatientName, h.DOB, h.Age_Qtr_End, h.Ethnicity, h.CellPhone, h.HomePhone, h.ProviderCode, h.Mamm_Due, 
Case when h.In_Numerator_All = 1 then 'Complete' else 'Due' End as Complete_Status, 
h.CX_CarePlan_Status, h.cx_Status, h.CX_CarePlan_Status_sort ,
h.Collections_Last_Screen,
h.PMS_LastScreen,
Case
	when h.Collections_Last_Screen is null and h.PMS_LastScreen is null then Null
	when h.Collections_Last_Screen is null and h.PMS_LastScreen is not null then 'PMS'
	when h.Collections_Last_Screen is not null and h.PMS_LastScreen is null then 'NCSP'
	when isNull(h.Collections_Last_Screen,'1900-01-01') >= isNull(h.PMS_LastScreen,'1900-01-01') then 'NCSP'
else
	'PMS'
End as Data_Origin,
Case
	when h.Collections_Last_Screen is null and h.PMS_LastScreen is null then 'No screen (PMS or NCSP)'
	when Cast(h.Collections_Last_Screen as date) = Cast(h.PMS_LastScreen as date) then 'Screens Match'
	when h.Collections_Last_Screen is not null and h.PMS_LastScreen is null then 'No screen in PMS'
	when h.PMS_LastScreen is not null and h.Collections_Last_Screen is null then 'No screen in NCSP'
	When Datediff(day, h.Collections_Last_Screen, h.PMS_LastScreen) between -30 and 30 then (char(177) + '30 days difference between screen dates')
	--When Datediff(day, h.Collections_Last_Screen, h.PMS_LastScreen) between -50 and 50 then (char(177) + '31-50 days')
	--When Datediff(day, h.Collections_Last_Screen, h.PMS_LastScreen) between -100 and 100 then (char(177) + '51-100 days')
	--When Datediff(day, h.Collections_Last_Screen, h.PMS_LastScreen) between -365 and 365 then (char(177) + '1 year')
	--When Datediff(day, h.Collections_Last_Screen, h.PMS_LastScreen) < -365 or Datediff(day, h.Collections_Last_Screen, h.PMS_LastScreen) > 365 then ('> ' + char(177) + '1 year')
else 
	'Screen dates don''t match'
End 
	as PMS_Collections_Compare,
Case
	when h.Collections_Last_Screen is null and h.PMS_LastScreen is null then 6
	when Cast(h.Collections_Last_Screen as date) = Cast(h.PMS_LastScreen as date) then 5
	when h.Collections_Last_Screen is not null and h.PMS_LastScreen is null then 2
	when h.PMS_LastScreen is not null and h.Collections_Last_Screen is null then 1
	When Datediff(day, h.Collections_Last_Screen, h.PMS_LastScreen) between -30 and 30 then 3
	--When Datediff(day, h.Collections_Last_Screen, h.PMS_LastScreen) between -50 and 50 then (char(177) + '31-50 days')
	--When Datediff(day, h.Collections_Last_Screen, h.PMS_LastScreen) between -100 and 100 then (char(177) + '51-100 days')
	--When Datediff(day, h.Collections_Last_Screen, h.PMS_LastScreen) between -365 and 365 then (char(177) + '1 year')
	--When Datediff(day, h.Collections_Last_Screen, h.PMS_LastScreen) < -365 or Datediff(day, h.Collections_Last_Screen, h.PMS_LastScreen) > 365 then ('> ' + char(177) + '1 year')
else 
	4
End 
	as PMS_Collections_Compare_Sort,
Case
	when isNull(h.Collections_Last_Screen,'1900-01-01') >= isNull(h.PMS_LastScreen,'1900-01-01') then h.CMI
else
	h.PMS_Outcome
End as Result,	
Case
	when isNull(h.Collections_Last_Screen,'1900-01-01') >= isNull(h.PMS_LastScreen,'1900-01-01') then h.Collections_Last_Screen
else
	h.PMS_LastScreen
End as Last_Screen,
h.Next_Recall,
h.CMI,h.PMS_Outcome, 
Case
	when h.Collections_Last_Screen is null and h.PMS_LastScreen is null then Null
	when h.Collections_Last_Screen is null and h.PMS_LastScreen is not null then h.Cohort_PMS
	when h.Collections_Last_Screen is not null and h.PMS_LastScreen is null then h.LOCATION_OF_LAST_SCREEN
	when isnull(h.Collections_Last_Screen,'1900-01-01') >= isNull(h.PMS_LastScreen,'1900-01-01') then h.LOCATION_OF_LAST_SCREEN
	else
		h.Cohort_PMS
	End as 'LOCATION_OF_LAST_SCREEN',
(Select Max(Last_Screen) from Stage_CX) as MaxScreen,
h.PriorityGroup
FROM 
@AuthorisedPracticeIDList AS PID
		INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
	join Stage_CX_Temp_24Mar2017_ToDelete as h on PID.practiceID = h.cohort_PracticeID
	left join Practice as p on p.PracticeID = h.cohort_PracticeID