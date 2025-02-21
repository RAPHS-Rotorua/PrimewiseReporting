CREATE proc [dbo].[CX_Reporting]  @PracticeIDs VARCHAR(MAX)
as

/*
	Author:  Justin Sherborne
	Date: 29 May 2017
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
c.NHI, c.PatientName, c.DOB, c.Age_Qtr_End, c.AgeBand, 
Case when c.Ethnicity = 'NZ European/Pakeha' then
	'NZ European'
	else
		c.Ethnicity
End as 'Ethnicity', c.Quintile, c.CellPhone, c.HomePhone, c.ProviderCode, c.Mamm_Due, 
c.In_Numerator_All,
c.In_Denominator,
c.CX_Denominator_Adjustor,
c.cx_Status,c.CX_CarePlan_Status,  c.CX_CarePlan_Status_sort ,
c.Collections_Last_Screen,
c.PMS_LastScreen,
c.Last_Screen,
c.Data_Origin,
c.PMS_Collections_Compare,
c.PMS_Collections_Compare_Sort,
c.CMI, c.Last_PMS_OutcomeCode,
c.Last_Result,	
c.Next_Recall,
c.Last_Complete_CarePlan,
c.LOCATION_OF_LAST_SCREEN,
c.PriorityGroup
FROM 
@AuthorisedPracticeIDList AS PID
		INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
	join Stage_CX_Reporting as c on c.practiceID = PID.PracticeID
	left join Practice as p on p.PracticeID = c.PracticeID
	where c.In_Denominator = 1 and c.PatientUnenrolled = 0