--exec rpt_SmokingRegister '8'

--Exec [dbo].[rpt_CVRDRARegister] '17'
CREATE Procedure [dbo].[rpt_SmokingRegister_MissedOpportunity] @PracticeIDs VARCHAR(MAX)
as
SET NOCOUNT ON	

/*
	Author:  Justin Sherborne
	Date: 10 July 2014

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

Select pt.PatientID, pt.NHI, pt.Surname + ', ' + pt.Firstname as Fullname,
pt.DOB, pt.Ethnicity1, pt.Ethnicity1Description, pt.Gender, pt.Quintile, pt.CellPhone,
pt.HomePhone, pt.ProviderCode as Provider,
h.LastEvent,
Case when h.Cess_Problem = 'Yes' then 1 else 0 end as CessByProblem,  --if use these need to reconfigure so that only consider cess 15 M from EOQ
Case When h.Cess_Profile_Enc = 'Yes' then 1 else 0 End as CessByProfileEnc,
Case when h.Cess_Drug = 'Yes' then 1 else 0 end as CessByDrug,
Case when h.Cess_Measure = 'Yes' then 1 else 0 end as CessByScreen,
h.CessLastScreen, 
h.Cessation_when_Due, 
h.Cessation_When_Due_Sort,
Case when Numerator_15M_EOQ = 1 then 'Cessation Recorded' else 'Due This Quarter' End as Smoking_Status, --NCHAR(0x207A) is * and NCHAR(178) is 2 if required
p.SurgeryName,
1 as Whole_Data_Group,
h.LastUpdated as Last_Updated
FROM 
@AuthorisedPracticeIDList AS PID
		INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
	join Stage_Smoking_Register as h on PID.practiceID = h.PracticeID
	left join Practice as p on h.PracticeID = p.PracticeID
	left join (Select PracticeID, patientID,surname, firstname,Ethnicity1Description,CellPhone,
	HomePhone, ProviderCode, NHI, DOB,  Quintile, Ethnicity1, Gender, EnrolledInPMS,
	row_number() over (Partition by PracticeID, NHI order by
	Case EnrolledInPMS
		when 'Deceased' then 1
		when 'Enrolled' then 2
		when 'Transferred' then 3
		else 4
	End) as row_num from Patient) as pt on h.nhi = pt.nhi and h.PracticeID = pt.PracticeID and pt.row_num = 1
	where h.PatientUnenrolled = 0 and h.Numerator_15M_EOQ = 0 and h.LastEvent >= dateadd(day,-10,Cast(GetDate() as Date))