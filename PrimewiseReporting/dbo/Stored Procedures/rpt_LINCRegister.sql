/* Test
--exec [rpt_LINCRegister] '14'
--Patient table contains LTC Expiry Date
--Select * from Patient
--go
--alter stored proc rpt_DiabetesRegister
*/
CREATE Procedure [dbo].[rpt_LINCRegister] @PracticeIDs VARCHAR(MAX)
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

	SELECT
		PAT.PracticeID
		,P.SurgeryName
		,pat.NHI
		,Surname
		,Firstname
		,Pat.ProviderCode as Prov  --Added Jun 17 2015 by JS -Need to filter by this
		,DOB
		,Age
		,Gender
		,CellPhone
		,HomePhone
		,isNull(Ethnicity1Description,'Not Stated') as 'Ethnicity'
		,Quintile
		,CalculatedLincScore
		,CurrentRecordedLincScore
		,NeedsIndicator as LINC_NeedsIndicator 
		,PBP.CurrentIntensityLevel
		,isNull(sh.IntensityLevel,'Not Enrolled') as 'IntensityLevel'  --Added Dec 15 2014 by JS to account for patients not found on LINC Intensity Sharepoint List
		,PBP.LTCAnnualReviewStatus
		,CASE PBP.LTCAnnualReviewStatus 
			WHEN 'Overdue' THEN 10
			WHEN 'Due This Month' THEN 30
			WHEN 'No Recall' THEN 50
			WHEN 'No Review Planned' THEN 70
			WHEN 'Not Complete' THEN 85
			WHEN 'OK' THEN 95
			ELSE 105 END AS LTCAnnualReviewStatusOrder
	,PBP.LTCAnnualReviewEnrolmentDate as LINCEnrolmentDate
		,PBP.LTCAnnualReviewLastCompletedDate as 'LINC Last Completed'
		,PBP.LTCAnnualReviewNextPlanDate as 'LINC Next Planned Review Date'
		,
		Case when LTCEnrolmentIndicator = 1 then 1 else 0 end as 'LTCEnrolmentIndicator'
		,LTCEnrolmentExpiryDate
		,Case 
			when LTCEnrolmentIndicator = 1 and DATEDIFF(day,GetDate(),PAT.LTCEnrolmentExpiryDate) < 0 then 'Expired'
			when LTCEnrolmentIndicator = 1 and DATEDIFF(day,GetDate(),PAT.LTCEnrolmentExpiryDate) <= 40 then 'Due To Expire' --changed based on Cathy Rex input
			when LTCEnrolmentIndicator = 1 and DATEDIFF(day,GetDate(),PAT.LTCEnrolmentExpiryDate) > 40 then 'Enrolled'
			else 'Not Enrolled' 
		End as LTCEnrolmentIndicator_Text,
		Case 
			when LTCEnrolmentIndicator = 1 and DATEDIFF(day,GetDate(),PAT.LTCEnrolmentExpiryDate) < 0 then 3
			when LTCEnrolmentIndicator = 1 and DATEDIFF(day,GetDate(),PAT.LTCEnrolmentExpiryDate) < 90 then 2
			when LTCEnrolmentIndicator = 1 and DATEDIFF(day,GetDate(),PAT.LTCEnrolmentExpiryDate) >= 90 then 1
			else 4  
		End as LTCEnrolmentIndicator_Sort
		,Case PBP.RSReferred
			when 1 then 'Yes'
			else 'No'
		End as RS_Referred
		,
		case DiabetesIndicator
			when 1 then 'Yes'
			else 'No'
		End as PatientWithDiabetes
		,HBa1c
		,[Alb Creat Ratio]
		,[ACEi or A2]
		,[Diabetes Type]
		,
		Case when HBa1c > 75.00 then '>75'
			when HBa1c >= 40 then '40-74'
			when HBa1c >= 0 then '0-39'
			else 'Null'
		End as HBa1c_Bands
		,
		Case when HBa1c > 75.00 then 1
			when HBa1c >= 40 then 2
			when HBa1c >= 0 then 3
			else 4
		End as HBa1c_Bands_sort
		,1 as WholeGroup
	FROM @AuthorisedPracticeIDList AS PID
	INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
	INNER JOIN Patient PAT On PAT.PracticeID = PID.PracticeID
	LEFT OUTER JOIN dbo.ReportingPatientByPractice AS PBP ON PBP.PatientId = PAT.PatientId 
	INNER JOIN Practice AS P ON P.PracticeID = PID.PracticeID
	left join SharepointIntensityLevels as sh on pAT.NHI = SH.NHI AND PAT.PracticeID = sh.PracticeID
	where EnrolledInPMS = 'Enrolled' and
	(LTCAnnualReviewEnrolmentDate is not null  --JS added this bracketed or clause so get anyone who has a plan or screen so can report those not enrolled in LINC yet with a screen
		or LTCAnnualReviewLastCompletedDate is not null
		or LTCAnnualReviewNextPlanDate is not null
		or LTCEnrolmentIndicator = 1) ;
	--where LTCEnrolmentIndicator = 1  --Note dont filter here because on LINC dashboard want to see Patients with Diabetes enrolled and not enrolled in LINC