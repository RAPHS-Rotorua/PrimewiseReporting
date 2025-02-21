--Test Exec dbo.rpt_patientOverview '9'
Create Procedure [dbo].[rpt_patientOverview_LINC] @PracticeIDs VARCHAR(MAX)
as
SET NOCOUNT ON	

/*
	Author:  Justin Sherborne
	Date: 17 Jul 2014

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
	from @AuthorisedPracticeIDList AS PID
	INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
	join Patient as p on PID.PracticeID = p.PracticeID
		left join ReportingPatientByPractice as pp on p.PatientID = pp.PatientID and p.PracticeID = pp.PracticeID
	where EnrolledInPMS = 'Enrolled' and
	(LTCAnnualReviewEnrolmentDate is not null  --JS added this bracketed or clause so get anyone who has a plan or screen so can report those not enrolled in LINC yet with a screen
		or LTCAnnualReviewLastCompletedDate is not null
		or LTCAnnualReviewNextPlanDate is not null
		or LTCEnrolmentIndicator = 1) ;