CREATE Procedure [dbo].[rpt_IMMS_First6WeekRAPHS]
as

/*
AUTHOR:						Justin Sherborne
CREATE DATE:				10 mar 2025										
 		
*/
With ESU_Imms
as
(Select distinct e.PracticeID, e.PracticePrefix, NHI, Ethnicity, Gender, Quintile, Date_Of_Birth, Full_Name, ProviderCode,
CSC_Number, CSC_Expiry_Date, CSC_Current
from IMMS_Childhood_Detail as e
)
,Status_6Weeks
as
(
Select coalesce(d.PracticeID, p.PracticeID, m.PracticeID) as 'PracticeID', 
coalesce(d.NHI, p.NHI, m.NHI) as 'NHI', coalesce(d.Child_Age, p.Child_Age, m.Child_Age) as 'Child_Age',
(Select Min(WhenImm) from (Values (d.WhenImm), (p.WhenImm), (m.WhenIMM)) as v (WhenImm)) as Min_6Week_Imm,
iif(d.Completed_Vaccines is not null,d.Completed_Vaccines + '; ','') + iif(p.Completed_Vaccines is not null,p.completed_Vaccines + '; ','') + isnull(m.Completed_Vaccines,'') as Vaccines_Completed,
isNull(d.NoRows_Completed,0) + isNull(p.NoRows_Completed,0) + isNull(m.NoRows_Completed,0) as 'NoRows_Completed'
from
(Select i1.PracticeID,  NHI, WhenImm, Child_Age,
Scheduled_Vaccine as Completed_Vaccines, Cast(1 as int) as NoRows_Completed
from IMMS_Childhood_Detail as i1 
where Scheduled_Vaccine = 'DTaP-IPV-Hep B/Hib' and Scheduled_Vaccine_Age = '6-Week' and ImmunisationStatus = 'completed') as d
full outer join
(Select i2.PracticeID, NHI, WhenImm,  Child_Age,
Scheduled_Vaccine as Completed_Vaccines, Cast(1 as int) as NoRows_Completed
from IMMS_Childhood_Detail as i2
where Scheduled_Vaccine = 'PCV' and Scheduled_Vaccine_Age = '6-Week' and ImmunisationStatus = 'completed') as p
on p.NHI = d.NHI
full outer join
(Select i3.PracticeID, NHI, WhenImm,  Child_Age,
Scheduled_Vaccine as Completed_Vaccines, Cast(1 as int) as NoRows_Completed
from IMMS_Childhood_Detail as i3
where Scheduled_Vaccine = 'Rotavirus'  and Scheduled_Vaccine_Age = '6-Week' and ImmunisationStatus = 'completed') as m
on m.NHI = d.NHI
)
,
prior_done
as
(
Select NHI, Min_6Week_Imm
from Status_6Weeks
where  Min_6Week_Imm < DateAdd(Month,-3,GetDate())
)
Select e.PracticeID, e.PracticePrefix, e.NHI, e.Full_Name, e.Date_Of_Birth, s.Child_Age, e.Ethnicity, e.Gender, e.Quintile, e.CSC_Current, e.CSC_Number, e.CSC_Expiry_Date, 
s.Min_6Week_Imm as First_6week_Imm, s.Vaccines_Completed from 
Status_6Weeks as s
join ESU_Imms as e on e.NHI = s.NHI 
where Min_6Week_Imm >= dateadd(month,-3,GetDate()) and s.NHI not in (Select NHI from prior_done)
