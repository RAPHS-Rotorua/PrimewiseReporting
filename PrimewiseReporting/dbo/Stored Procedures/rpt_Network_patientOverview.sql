--Test Exec dbo.rpt_patientOverview '9'
Create Procedure [dbo].[rpt_Network_patientOverview] 
as
SET NOCOUNT ON	

/*
	Author:  Justin Sherborne
	Date: 17 Jul 2014

*/	
	

	
	
Select
p.NHI, p.Surname + ', ' + p.Firstname as FullName, p.CellPhone, p.HomePhone, p.WorkPhone,
isnull(p.Ethnicity1Description, 'Not Stated') as Ethnicity, DOB, p.PracticeID,
Age, Quintile, 
Case
	when p.DiabetesIndicator = 1 
		then 'Yes' 
	else 'No' 
end as PatientWithDiabetes,
Case 
			when LTCEnrolmentIndicator = 0 then 'Not Enrolled'
			when LTCEnrolmentIndicator = 1 and DATEDIFF(day,GetDate(),P.LTCEnrolmentExpiryDate) < 0 then 'Expired'
			when LTCEnrolmentIndicator = 1 and DATEDIFF(day,GetDate(),p.LTCEnrolmentExpiryDate) < 90 then 'Due To Expire'
			when LTCEnrolmentIndicator = 1 and DATEDIFF(day,GetDate(),p.LTCEnrolmentExpiryDate) >= 90 then 'Enrolled'
			else 'Not Enrolled'
		End as LTCEnrolmentIndicator_Text,
pp.LTCAnnualReviewEnrolmentDate,
p.LTCEnrolmentExpiryDate,
pp.LTCAnnualReviewLastCompletedDate,
pp.LTCAnnualReviewNextPlanDate,
pp.LTCAnnualReviewStatus,
pp.[ACEi or A2],
pp.[Alb Creat Ratio],
pp.HBa1c,
pp.DAREnrolmentDate,
pp.DARLastCompletedDate,
pp.DARNextPlanDate,
pp.DARStatus,
pp.[Diabetes Type],
Case
	when pp.RSReferred = 1 
		then 'Yes'
	else	
		'No'
End as 'RSReferred' ,
pp.RSAnnualReviewLastCompletedDate,
pp.RSAnnaulReviewNextPlanDate,
Case
	when pp.CVDRA_EligibilityProgramme IS Null OR pp.CVDRA_EligibilityProgramme = 'Not Eligible'
		then 'Not Eligible'
	Else	
		pp.CVDRA_EligibilityProgramme
End as 'CVDRA_EligibilityProgramme',
pp.CVDRA_LastScreenedDate,
pp.CVDRA_Status,
pp.CVDRA_Screen_Status,
pp.CVDRA_FundedScreen_Complete,
pp.CVDRisk,
isnull(pp.CVD_cvd,0) as CVD_Presumptive,
isnull(pp.CVD_DIAB,0) as CVD_DiabPresumptive
	from Patient as p
		left join ReportingPatientByPractice as pp on p.PatientID = pp.PatientID and p.PracticeID = pp.PracticeID