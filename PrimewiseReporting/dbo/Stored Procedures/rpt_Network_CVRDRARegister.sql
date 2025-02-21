--Exec [dbo].[rpt_CVRDRARegister] '17'
CREATE Procedure [dbo].[rpt_Network_CVRDRARegister]
as
	

/*
	Author:  Justin Sherborne
	Date: 10 July 2014

*/	


with patient_CTE
as
(Select NHI,CellPhone, HomePhone, ProviderCode, practiceID,
ROW_NUMBER() over (partition by nhi, PracticeID order by cellphone desc) as row_num from Patient
where NHI is not null
)

	
Select h.PracticeID, p.SurgeryPrefix,
h.NHI , 
h.FullName as 'Full_Name', 
h.DOB ,
h.Age_As_At as Age,
h.Gender, 
pt.CellPhone, pt.HomePhone,
p.SurgeryName,
h.Quintile,  --Quintile at the time the Programme 1 and 2 were developed
h.Ethnicity1Description as Ethnicity, --Ethnicity at the time the Programme 1 and 2 were developed
h.Eth1, h.Eth2, h.Eth3,
pt.ProviderCode as 'Provider', --Provider at time = Now
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
h.CVDRisk,
h.CVDRisk_Bands,
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
FROM 
 Stage_CVDRA_Report as h 
	left join Practice as p on h.PracticeID = p.PracticeID
	left join patient_CTE as pt on h.nhi = pt.nhi and h.PracticeID = pt.PracticeID and pt.PracticeID <> 0 
	and pt.row_num = 1




--Select * from Stage_CVDRA_Report where PracticeID is null

















--GO
--with patient_CTE
--as
--(Select NHI,CellPhone, HomePhone, ProviderCode, practiceID,
--ROW_NUMBER() over (partition by nhi, PracticeID order by cellphone desc) as row_num from Patient
--)


--Select * from patient where PracticeID is null