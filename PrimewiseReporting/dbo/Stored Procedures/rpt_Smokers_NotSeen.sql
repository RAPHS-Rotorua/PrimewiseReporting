Create proc [dbo].[rpt_Smokers_NotSeen] @PracticeIDs VARCHAR(MAX)
as
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
Case when h.Cess_Problem = 'Yes' then 1 else 0 end as CessByProblem,
Case When h.Cess_Profile_Enc = 'Yes' then 1 else 0 End as CessByProfileEnc,
Case when h.Cess_Drug = 'Yes' then 1 else 0 end as CessByDrug,
Case when h.Cess_Measure = 'Yes' then 1 else 0 end as CessByScreen,
 Cast((SELECT Max(v) 
   FROM (VALUES (h.Cess_Drug_Date),(h.Cess_Problem_Date),(h.Cess_Profile_Date),(h.Cess_Measure_Date)) AS value(v)) as Date)  as CessLastScreen,
Case when Numerator_1 = 'Yes' then 'Cessation Recorded' else 'Due' End as Smoking_Status, --NCHAR(0x207A) is * and NCHAR(178) is 2 if required
p.SurgeryName
FROM 
@AuthorisedPracticeIDList AS PID
		INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
	join Stage_Smoking_Register as h on PID.practiceID = h.PracticeID
	left join Practice as p on h.PracticeID = p.PracticeID
	left join Patient as pt on h.nhi = pt.nhi and h.PracticeID = pt.PracticeID
	where h.SmokingStatus in('Current Smoker','Ex Smoker with SMO Code As At 15 Months',
'Other Smok Coded within 15 Months') and Denominator_1 = 'No'