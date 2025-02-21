--Exec [dbo].[rpt_CVRDRARegister] '17'
CREATE Procedure [dbo].[rpt_CVRDRARegister] @PracticeIDs VARCHAR(MAX)
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




	
Select h.PracticeID, p.SurgeryPrefix,
h.NHI , 
h.FullName as 'Full_Name', 
h.DOB ,
h.Age_As_At as Age,
h.Gender, 
h.CellPhone, h.HomePhone,  --js changed Jul 23 2015 to pick up Stage_CVDRA_Report field
p.SurgeryName,
h.Quintile,  --Quintile at the time the Programme 1 and 2 were developed
h.Ethnicity1Description as Ethnicity, --Ethnicity at the time the Programme 1 and 2 were developed
h.Eth1, h.Eth2, h.Eth3,
h.ProviderCode as 'Provider', --Provider at time = Now  --JS changed 23 Jul 2015 to pick up Stage_CVDRA_REport field
h.LastScreen as LastScreenedDate, 
h.Category as  PatientCategory ,
Case when h.InFundedProgramme = 1 then 'Programme 1' else 'Not Eligible' end as Eligibility_Programme,
Case when h.InFundedProgramme = 1 and h.FundedScreenComplete <> 1 then 1
else 0
end as 'EligibleForFunding',
h.VirtualScreen,
h.DIAB,
h.Heart,
h.Stroke,
h.Vascular,
h.CVDRisk_Text,
h.CVDRisk,
h.CVDRisk_Bands,
Case
	when h.CVDRisk < 11 then '<10'
	When h.CVDRisk < 21 then '10-20'
	When h.CVDRisk > 20 then '>20'
	else ''
End as Report_Band,
Case
	when h.CVDRisk < 11 then 2
	When h.CVDRisk < 21 then 3
	When h.CVDRisk > 20 then 4
	else 1
End as Report_Band_Sort,
1 as WholeGroup,
h.ExternalToPractice,
h.CVDRA_Status,
Case when CVDRA_Status = 'Risk Recorded' then 'Risk Recorded ' + NCHAR(0x207A) + NCHAR(185)  --This is asterisk (NCHAR(0x207A)) and 1 (NCHAR(185)) superscripted  for reports
else 'Due ' + NCHAR(0x207A) + NCHAR(178)  --NCHAR(178) is 2
end as 'CVDRA_Status_Label',
h.InFundedProgramme,
h.FundedScreenComplete,
Case when h.FundedScreenComplete = 1 then 'Screen Complete'
	else 'Screen due' end as 'FundedScreenComplete_Label'
	,h.EnrolledInPMS --JS added Jul 23 2015 (comes from Stage_CVDRA_Report)
FROM 
@AuthorisedPracticeIDList AS PID
		INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
	join Stage_CVDRA_Report as h on PID.practiceID = h.PracticeID
	left join Practice as p on h.PracticeID = p.PracticeID
	--left join Patient as pt on h.nhi = pt.nhi and h.PracticeID = pt.PracticeID  --JS removed join to Patient Jul 23 2015 as fields added during load from proc RGPGStage.dbo.CVDRA_Report