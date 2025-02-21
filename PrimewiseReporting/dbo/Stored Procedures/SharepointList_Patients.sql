Create proc [dbo].[SharepointList_Patients] @PracticeID int
as
select 
	SourcePatientID
	,  Practice.PracticeID
	, NHI
	, case 
		When DOB = NULL then ''
		when Cast(DOB as Date) = '1899-12-30' then ''
		else convert(varchar, cast(DOB as Date), 120) 
	  end  DateOfBirth
	,case
		when Patient.NHI IS null and Patient.surname is null then
			cast(Patient.PatientID AS varchar)
		when Patient.NHI IS null and Patient.Firstname is null then
			Patient.Surname
		when Patient.NHI IS null then
			Patient.Surname + ', ' + Patient.firstName
		when Patient.surname is null then
			Patient.NHI
		when patient.Firstname is null then
			Patient.NHI + ' - ' + Patient.Surname
		else
			Patient.NHI + ' - ' + Patient.Surname + ', ' + Patient.Firstname
	end as Title
	, Surname
	, Firstname as Givenname
	, Gender
	, Ethnicity1Description as Ethnicity
	, Quintile
	, Age
	, CurrentRecordedLincScore as LatestRecordedLincScore
	, case 
		When Cast(CurrentIntensityMeasurementDate as date)= NULL then Null
		when Cast(CurrentIntensityMeasurementDate as date)= '1899-12-30' then NUll
		else convert(varchar, Cast(CurrentIntensityMeasurementDate as date),  120)
	  end  
	  DateOfIntensityLevel
	, CurrentIntensityLevel
	, CalculatedLincScore
	, NeedsIndicator as HighNeeds
	, case when LTCEnrolmentIndicator = 1 then Cast(1 as int) else Null end as LTCPatient
	, SurgeryName
	, ProviderCode as GP
	, case when Patient.DiabetesIndicator = 1 then Cast(1 as int) else Null end  as Diabetic
	,  case 
		When Patient.LTCEnrolmentExpiryDate = NULL then Null
		when Patient.LTCEnrolmentExpiryDate = '1899-12-30' then Null
		when Patient.LTCEnrolmentExpiryDate = '1900-01-01' then Null
		else convert(varchar, Patient.LTCEnrolmentExpiryDate , 120)
	end as LTCEndDate
	, EnrolledInPMS EnrolmentStatus
	
from Patient
left  join ReportingPatientByPractice 
on ReportingPatientByPractice.PatientID = Patient.PatientID 
and ReportingPatientByPractice.PracticeID = Patient.PracticeID
left join Practice on Practice.PracticeID = Patient.PracticeID
where Practice.PracticeID = @PracticeID