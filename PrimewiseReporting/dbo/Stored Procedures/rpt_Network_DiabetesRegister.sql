--Test
--exec rpt_DiabetesRegister '15'

CREATE Procedure [dbo].[rpt_Network_DiabetesRegister] 
as
SET NOCOUNT ON	

/*
	Author:  Justin Sherborne
	Date: 17 Jul 2014

*/	
	



	SELECT
		PAT.PracticeID
		,P.SurgeryName
		,NHI
		,Surname
		,Firstname
		,DOB
		,Age
		,Gender
		,isNull(Ethnicity1Description,'Not Stated') as 'Ethnicity1Description'
		,Quintile
		,CellPhone, HomePhone
		,CalculatedLincScore
		,CurrentRecordedLincScore 
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
		,PBP.DARStatus
		,Case PBP.DARStatus 
	When 'Overdue' then 1
	When 'Due This Month' then 2
	When 'No Recall' then 3
	When 'No Review Planned' then 4
	When 'Not Complete' then 5
	When 'OK' then 6
	Else 99
End as Dar_Status_Sort_Order
		,DAREnrolmentDate
		,DARLastCompletedDate as 'Diabetes Last Completed'
		,DARNextPlanDate as 'Diabetes Next Planned Review Date'	
		,LTCEnrolmentIndicator
		,Case 
			when LTCEnrolmentIndicator = 1 and DATEDIFF(day,GetDate(),PAT.LTCEnrolmentExpiryDate) < 0 then 'Expired'
			when LTCEnrolmentIndicator = 1 and DATEDIFF(day,GetDate(),PAT.LTCEnrolmentExpiryDate) < 90 then 'Due To Expire'
			when LTCEnrolmentIndicator = 1 and DATEDIFF(day,GetDate(),PAT.LTCEnrolmentExpiryDate) >= 90 then 'Enrolled'
			else 'Expired'  --changed Sep 8 2014 as 'Not Enrolled' didn't make sense when they had an enrolment date
		End as LTCEnrolmentIndicator_Text,
		Case 
			when LTCEnrolmentIndicator = 1 and DATEDIFF(day,GetDate(),PAT.LTCEnrolmentExpiryDate) < 0 then 3
			when LTCEnrolmentIndicator = 1 and DATEDIFF(day,GetDate(),PAT.LTCEnrolmentExpiryDate) < 90 then 2
			when LTCEnrolmentIndicator = 1 and DATEDIFF(day,GetDate(),PAT.LTCEnrolmentExpiryDate) >= 90 then 1
			else 3  --changed Sep 8 2014 as 'Not Enrolled' didn't make sense when they had an enrolment date
		End as LTCEnrolmentIndicator_Sort
		,'Network' as Network_Group
		,Case PBP.RSReferred
			when 1 then 'Yes'
			else 'No'
		End as RS_Referred
		,PBP.RSAnnaulReviewNextPlanDate
		,PBP.RSAnnualReviewLastCompletedDate
		,PBP.RSAnnualReviewLastExcludedDate
		,PBP.RSEnrolmentDate
		,HBa1c
		,[Alb Creat Ratio]
		,[ACEi or A2]
		,[Diabetes Type]
		,
		Case When HBa1c IS null then 'No Result'
			when HBa1c > 75.00 then '>75'   
			when HBa1c >= 65 then '65-74'
			when HBa1c >= 50 then '50-64'
			else '<50'
		End as HBa1c_Bands
		,
		Case when HBa1c > 75.00 then 1   
			when HBa1c >= 65 then 2
			when HBa1c >= 50 then 3
			when HBa1c < 50 then 4
			else 5
		End as HBa1c_Bands_sort
		,1 as WholeGroup
	FROM 
	Patient PAT 
	LEFT OUTER JOIN dbo.ReportingPatientByPractice AS PBP ON PBP.PatientId = PAT.PatientId 
	INNER JOIN Practice AS P ON P.PracticeID = PAT.PracticeID
	
	
	WHERE PAT.DiabetesIndicator = 1 and Pat.EnrolledInPMS = 'Enrolled'  --Enrolled patients only