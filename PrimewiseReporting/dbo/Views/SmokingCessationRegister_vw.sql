CREATE view [dbo].[SmokingCessationRegister_vw]
AS
Select p.PracticeID, p.SurgeryName,pt.PatientID, h.NHI, pt.Surname + ', ' + pt.Firstname as Fullname,
h.DOB, pt.Ethnicity1, pt.Ethnicity1Description, h.GEN as Gender, h.Quintile, pt.CellPhone,
pt.HomePhone, pt.ProviderCode as Provider,
h.LastEvent  ,
Case when h.Cess_Problem = 'Yes' then 1 else 0 end as CessByProblem,  --We are not showing these Cess fields on report yet.  if we do will need to make sure cess only 15 months back from quarter
Case When h.Cess_Profile_Enc = 'Yes' then 1 else 0 End as CessByProfileEnc,
Case when h.Cess_Drug = 'Yes' then 1 else 0 end as CessByDrug,
Case when h.Cess_Measure = 'Yes' then 1 else 0 end as CessByScreen,
h.CessLastScreen, 
h.Cessation_when_Due, 
h.Cessation_When_Due_Sort,
Case when Numerator_15M_EOQ = 1 then 'Cessation Recorded' else 'Due This Quarter' End as Smoking_Status, --NCHAR(0x207A) is * and NCHAR(178) is 2 if required
h.LastUpdated as Last_Updated,
h.Numerator_15M_EOQ,
h.Denominator_1,
h.PatientUnenrolled
FROM 

	Stage_Smoking_Register as h
	left join Practice as p on p.PracticeID = h.PracticeID
	left join (Select PracticeID, patientID,surname, firstname,Ethnicity1Description,CellPhone,
	HomePhone, ProviderCode, NHI, DOB,  Quintile, Ethnicity1, Gender, EnrolledInPMS,
	row_number() over (Partition by PracticeID, NHI order by
	Case EnrolledInPMS
		when 'Deceased' then 1
		when 'Enrolled' then 2
		when 'Transferred' then 3
		else 4
	End) as row_num from Patient) as pt on h.nhi = pt.nhi and h.PracticeID = pt.PracticeID and pt.row_num = 1