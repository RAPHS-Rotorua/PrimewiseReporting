﻿--Select * from IPIF_Performance_CVD
--drop view IPIF_Performance_CVD
CREATE View [dbo].[IPIF_Performance_CVD]
as
(Select PracticeID,
Case PracticeID
	when 1 then 'KMC'
	when 2 then 'OW'
	when 4 then 'TMC'
	--when 5 then 'WB'
	when 8 then 'WHHC'
	--when 9 then 'HH'
	when 14 then 'NGO'
	when 15 then 'EMC'
	when 16 then 'WEMC'
	when 17 then 'RAMC'
	when 18 then 'RMG'
	when 24 then 'MURU'
	when 25 then 'MHS'
	when 26 then 'TLC'
	when 27 then 'RTM'
	When 28 then 'THMC'
	when 30 then 'KAH'
	when 32 then 'NP'
	else '#NA'
End as Practice,
Sum(case CVDRA_Status
	when 'Risk Recorded' then 1
else 0
End) as Risk_Recorded,

Sum(case 
	when CVDRA_Status = 'Risk Recorded' and Gender = 'M' and Age_As_At between 35 and 44 and Eth1 = 21 then 1
else 0
End)  as Risk_Recorded_M_3544,

Sum(case CVDRA_Status
	when 'Due' then 1
else 0
End) as Overdue,

Sum(case 
	when CVDRA_Status = 'Due' and Gender = 'M' and Age_As_At between 35 and 44 and Eth1 = 21 then 1
else 0
End)  as Overdue_M_3544,

count(*) as Total_Eligible,

sum(Case
		when  Gender = 'M' and Age_As_At between 35 and 44 and Eth1 = 21 then 1
	else 0
	End) as Total_Eligible_M_3544,

Cast(Sum(case CVDRA_Status
	when 'Risk Recorded' then 1
else 0
End) as decimal(10,2))/Cast(Count(*) as decimal(10,2)) as Performance,

Cast(Sum(case 
	when CVDRA_Status = 'Risk Recorded' and Gender = 'M' and Age_As_At between 35 and 44 and Eth1 = 21 then 1
else 0
End) as decimal(10,2))/Cast(sum(Case
		when  Gender = 'M' and Age_As_At between 35 and 44 and Eth1 = 21 then 1
	else 0
	End) as decimal(10,2)) as Performance_M_3544,

0.90 as National_Target,

Case when
cast((0.90 * count(*)) as decimal(10,0)) - 
Sum(case CVDRA_Status
	when 'Risk Recorded' then 1
else 0
End) < 0 then 0
else
cast((0.90 * count(*)) as decimal(10,0)) - 
Sum(case CVDRA_Status
	when 'Risk Recorded' then 1
else 0
End)
End
as No_Required_To_Target,

Case when
cast((0.90 * sum(Case
		when  Gender = 'M' and Age_As_At between 35 and 44 and Eth1 = 21 then 1
	else 0
	End)) as decimal(10,0)) - 
Sum(case 
	when CVDRA_Status = 'Risk Recorded' and Gender = 'M' and Age_As_At between 35 and 44 and Eth1 = 21 then 1
else 0
End)  < 0 then 0
else
cast((0.90 * sum(Case
		when  Gender = 'M' and Age_As_At between 35 and 44 and Eth1 = 21 then 1
	else 0
	End)) as decimal(10,0)) - 
Sum(case 
	when CVDRA_Status = 'Risk Recorded' and Gender = 'M' and Age_As_At between 35 and 44 and Eth1 = 21 then 1
else 0
End)
End
as No_Required_To_Target_M_3544,


(Select Cast(Sum(case CVDRA_Status
	when 'Risk Recorded' then 1
else 0
End) as decimal(10,2)) from Stage_CVDRA_Report where PatientUnenrolled = 0) 
/(Select Cast(Count(*) as decimal(10,2)) from Stage_CVDRA_Report where PatientUnenrolled = 0) as RAPHS_Performance,

(Select Cast(Sum(case CVDRA_Status
	when 'Risk Recorded' then 1
else 0
End) as decimal(10,2)) from Stage_CVDRA_Report where Gender = 'M' and Age_As_At between 35 and 44 and Eth1 = 21 and PatientUnenrolled = 0) 
/(Select Cast(Count(*) as decimal(10,2)) from Stage_CVDRA_Report where Gender = 'M' and Age_As_At between 35 and 44 and Eth1 = 21 and PatientUnenrolled = 0) as RAPHS_Performance_M_3544

from Stage_CVDRA_Report as r
where r.PatientUnenrolled = 0
group by PracticeID,
Case PracticeID
	when 1 then 'KMC'
	when 2 then 'OW'
	when 4 then 'TMC'
	--when 5 then 'WB'
	when 8 then 'WHHC'
	--when 9 then 'HH'
	when 14 then 'NGO'
	when 15 then 'EMC'
	when 16 then 'WEMC'
	when 17 then 'RAMC'
	when 18 then 'RMG'
	when 24 then 'MURU'
	when 25 then 'MHS'
	when 26 then 'TLC'
	when 27 then 'RTM'
	When 28 then 'THMC'
	when 30 then 'KAH'
	else '#NA'
End
--
union
--  and Gender = 'M' and Age_As_At between 35 and 44 and Eth1 = 21
Select
99 as PracticeID,
 'RAPHS' as Practice,

(Select Sum(case CVDRA_Status
	when 'Risk Recorded' then 1
else 0
End) from Stage_CVDRA_Report where PatientUnenrolled = 0)  as Risk_Recorded,

(Select Sum(case CVDRA_Status
	when 'Risk Recorded' then 1
else 0
End) from Stage_CVDRA_Report where Gender = 'M' and Age_As_At between 35 and 44 and Eth1 = 21 and PatientUnenrolled = 0)  as Risk_Recorded_M_3544,

(Select Sum(case CVDRA_Status
	when 'Due' then 1
else 0
End) from Stage_CVDRA_Report where PatientUnenrolled = 0) as Overdue,

(Select Sum(case CVDRA_Status
	when 'Due' then 1
else 0
End) from Stage_CVDRA_Report where Gender = 'M' and Age_As_At between 35 and 44 and Eth1 = 21 and PatientUnenrolled = 0) as Overdue_M_3544,

(Select count(*) from Stage_CVDRA_Report where PatientUnenrolled = 0) as Total_Eligible,

(Select count(*) from Stage_CVDRA_Report where Gender = 'M' and Age_As_At between 35 and 44 and Eth1 = 21 and PatientUnenrolled = 0) as Total_Eligible_M_3544,

(Select Cast(Sum(case CVDRA_Status
	when 'Risk Recorded' then 1
else 0
End) as decimal(10,2)) from Stage_CVDRA_Report where PatientUnenrolled = 0)
/(Select Cast(Count(*) as decimal(10,2)) from Stage_CVDRA_Report where PatientUnenrolled = 0) as Performance,

(Select Cast(Sum(case CVDRA_Status
	when 'Risk Recorded' then 1
else 0
End) as decimal(10,2)) from Stage_CVDRA_Report where Gender = 'M' and Age_As_At between 35 and 44 and Eth1 = 21 and PatientUnenrolled = 0)
/(Select Cast(Count(*) as decimal(10,2)) from Stage_CVDRA_Report where Gender = 'M' and Age_As_At between 35 and 44 and Eth1 = 21 and PatientUnenrolled = 0) as Performance_M_3544,


0.90 as National_Target,

Case when
cast(((0.90 * (Select count(*) from Stage_CVDRA_Report where PatientUnenrolled = 0))  - 
(Select Sum(case CVDRA_Status
	when 'Risk Recorded' then 1
else 0
End) from Stage_CVDRA_Report where PatientUnenrolled = 0)) as decimal(10,0)) < 0 then 0
else
cast(((0.90 * (Select count(*) from Stage_CVDRA_Report where PatientUnenrolled = 0))  - 
(Select Sum(case CVDRA_Status
	when 'Risk Recorded' then 1
else 0
End) from Stage_CVDRA_Report where PatientUnenrolled = 0)) as decimal(10,0))
End
as No_Required_To_Target,

Case when
cast(((0.90 * (Select count(*) from Stage_CVDRA_Report where Gender = 'M' and Age_As_At between 35 and 44 and Eth1 = 21 and PatientUnenrolled = 0))  - 
(Select Sum(case CVDRA_Status
	when 'Risk Recorded' then 1
else 0
End) from Stage_CVDRA_Report where Gender = 'M' and Age_As_At between 35 and 44 and Eth1 = 21 and PatientUnenrolled = 0)) as decimal(10,0)) < 0 then 0
else
cast(((0.90 * (Select count(*) from Stage_CVDRA_Report where Gender = 'M' and Age_As_At between 35 and 44 and Eth1 = 21 and PatientUnenrolled = 0))  - 
(Select Sum(case CVDRA_Status
	when 'Risk Recorded' then 1
else 0
End) from Stage_CVDRA_Report where Gender = 'M' and Age_As_At between 35 and 44 and Eth1 = 21 and PatientUnenrolled = 0)) as decimal(10,0)) 
End
as No_Required_To_Target_M_3544,

(Select Cast(Sum(case CVDRA_Status
	when 'Risk Recorded' then 1
else 0
End) as decimal(10,2)) from Stage_CVDRA_Report where PatientUnenrolled = 0)
/(Select Cast(Count(*) as decimal(10,2)) from Stage_CVDRA_Report where PatientUnenrolled = 0) as RAPHS_Performance,

(Select Cast(Sum(case CVDRA_Status
	when 'Risk Recorded' then 1
else 0
End) as decimal(10,2)) from Stage_CVDRA_Report  where Gender = 'M' and Age_As_At between 35 and 44 and Eth1 = 21 and PatientUnenrolled = 0)
/(Select Cast(Count(*) as decimal(10,2)) from Stage_CVDRA_Report  where Gender = 'M' and Age_As_At between 35 and 44 and Eth1 = 21 and PatientUnenrolled = 0) as RAPHS_Performance_M_3544
)