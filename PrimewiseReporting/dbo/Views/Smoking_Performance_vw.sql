--Test
--select * from  Smoking_Performance_vw
--select * from  IPIF_Performance_Smoking

CREATE View [dbo].[Smoking_Performance_vw]
as
(
Select PracticeID,
Case PracticeID
	when 1 then 'KMC'
	when 2 then 'OW'
	when 4 then 'TMC'
	when 8 then 'WHHC'
	when 14 then 'NGO'
	when 15 then 'EMC'
	when 16 then 'WEMC'
	when 17 then 'RAMC'
	when 18 then 'RMG'
	when 24 then 'MURU'
	when 25 then 'MHS'
	when 26 then 'TLC'
	when 27 then 'RTM'
	when 30 then 'KAH'
	when 32 then 'NP'
	when 28 then 'THMC'
	else '#NA'
End as Practice,
Sum(Numerator_15M_EOQ) as Cessation_Recorded,
Sum(case
	when Numerator_15M_EOQ = 1 and eth = 21  then 1
else 0
End) as Cessation_Recorded_Maori,
Sum(case Numerator_15M_EOQ
	when 0 then 1
else 0
End) as Overdue,
Sum(case 
	when Numerator_15M_EOQ = 0 and eth = 21 then 1
else 0
End) as Overdue_Maori,
count(*) as Total_Eligible,
Sum(
Case 
	when eth = 21 then 1 
else 0 
End) as Total_Eligible_Maori,
Cast(Cast(Sum(Numerator_15M_EOQ) as decimal(15,4))/Cast(Count(*) as decimal(15,4)) as decimal(5,4)) as Performance,
Cast(
Cast(Sum(case 
	when Numerator_15M_EOQ = 1 and Eth = 21 then 1
else 0
End) as decimal(15,4))/Cast(Sum(
Case 
	when eth = 21 then 1 
else 0 
End) as decimal(15,4))
as decimal(5,4)) as Performance_Maori,
0.90 as Programme_Goal,
Case when
ceiling((0.90 * count(*))) - 
Sum(Numerator_15M_EOQ) < 0 then 0
else
ceiling((0.90 * count(*))) - 
Sum(Numerator_15M_EOQ)
End
as No_Required_To_Target,
Case when
ceiling((0.90 * Sum(
Case 
	when eth = 21 then 1 
else 0 
End))) - 
Sum(case 
	when Numerator_15M_EOQ = 1 and Eth = 21 then 1
else 0
End) < 0 then 0
else
ceiling((0.90 * Sum(
Case 
	when eth = 21 then 1 
else 0 
End))) - 
Sum(case 
	when Numerator_15M_EOQ = 1 and eth = 21 then 1
else 0
End)
End
as No_Required_To_Target_Maori,
MAX(LastUpdated) as Last_Updated,
Cast(
(Select Cast(Sum(Numerator_15M_EOQ) as decimal(15,4)) from Stage_Smoking_Register where PatientUnenrolled = 0)
/(Select Cast(Count(*) as decimal(15,4)) from Stage_Smoking_Register where PatientUnenrolled = 0)
as decimal(5,4)) as RAPHS_Performance,
Cast(
(Select Cast(Sum(case 
	when Numerator_15M_EOQ = 1 and eth = 21 then 1
else 0
End) as decimal(15,4)) from Stage_Smoking_Register where PatientUnenrolled = 0)
/(Select Cast(Sum(case 
	when eth = 21 then 1
else 0
End) as decimal(15,4)) from Stage_Smoking_Register where PatientUnenrolled = 0)
as decimal(5,4)) as RAPHS_Performance_Maori
from Stage_Smoking_Register as r
where PatientUnenrolled = 0
group by PracticeID,
Case PracticeID
	when 1 then 'KMC'
	when 2 then 'OW'
	when 4 then 'TMC'
	when 8 then 'WHHC'
	when 14 then 'NGO'
	when 15 then 'EMC'
	when 16 then 'WEMC'
	when 17 then 'RAMC'
	when 18 then 'RMG'
	when 24 then 'MURU'
	when 25 then 'MHS'
	when 26 then 'TLC'
	when 27 then 'RTM'
	when 30 then 'KAH'
	When 32 then 'NP'
	when 28 then 'THMC'
	else '#NA'
End
--
union
--
Select
99 as PracticeID,
 'RAPHS' as Practice,
(Select Sum(Numerator_15M_EOQ) from Stage_Smoking_Register where PatientUnenrolled = 0) as Cessation_Recorded,
(Select Sum(case 
	when Numerator_15M_EOQ = 1 and eth = 21 then 1
else 0
End) from Stage_Smoking_Register where PatientUnenrolled = 0) as Cessation_Recorded_Maori,
(Select Sum(case Numerator_15M_EOQ
	when 0 then 1
else 0
End) from Stage_Smoking_Register where PatientUnenrolled = 0) as Overdue,
(Select Sum(case 
	when Numerator_15M_EOQ = 0 and eth = 21 then 1
else 0
End) from Stage_Smoking_Register where PatientUnenrolled = 0) as Overdue_Maori,
(Select count(*) from Stage_Smoking_Register where PatientUnenrolled = 0) as Total_Eligible,
(Select Sum(
Case 
	when eth = 21 then 1 
else 0 
End) from Stage_Smoking_Register where PatientUnenrolled = 0) as Total_Eligible_Maori,
Cast(
(Select Cast(Sum(Numerator_15M_EOQ) as decimal(15,4)) from Stage_Smoking_Register where PatientUnenrolled = 0)
/(Select Cast(Count(*) as decimal(15,4)) from Stage_Smoking_Register where PatientUnenrolled = 0)
as decimal(5,4)) as Performance,
Cast(
(Select Cast(Sum(case 
	when Numerator_15M_EOQ = 1 and eth = 21 then 1
else 0
End) as decimal(15,4)) from Stage_Smoking_Register where PatientUnenrolled = 0)
/(Select Cast(Sum(
Case 
	when eth = 21 then 1 
else 0 
End) as decimal(15,4)) from Stage_Smoking_Register where PatientUnenrolled = 0)
as decimal(5,4)) as Performance_Maori,
0.90 as Programme_Goal,
Case when
ceiling((0.90 * (Select count(*) from Stage_Smoking_Register where PatientUnenrolled = 0))) - 
(Select Sum(Numerator_15M_EOQ) from Stage_Smoking_Register where PatientUnenrolled = 0) < 0 then 0
else
ceiling((0.90 * (Select count(*) from Stage_Smoking_Register where PatientUnenrolled = 0))) - 
(Select Sum(Numerator_15M_EOQ) from Stage_Smoking_Register where PatientUnenrolled = 0)
End
as No_Required_To_Target,
Case when
ceiling((0.90 * (Select Sum(
Case 
	when eth = 21 then 1 
else 0 
End) from Stage_Smoking_Register where PatientUnenrolled = 0))) - 
(Select Sum(case 
	when Numerator_15M_EOQ = 1 and Eth = 21 then 1
else 0
End) from Stage_Smoking_Register where PatientUnenrolled = 0) < 0 then 0
else
ceiling((0.90 * (Select Sum(
Case 
	when eth = 21 then 1 
else 0 
End) from Stage_Smoking_Register where PatientUnenrolled = 0))) - 
(Select Sum(case 
	when Numerator_15M_EOQ = 1 and eth = 21 then 1
else 0
End) from Stage_Smoking_Register where PatientUnenrolled = 0)
End
as No_Required_To_Target_Maori,
(Select MAX(LastUpdated) from Stage_Smoking_Register where PatientUnenrolled = 0) as Last_Updated,
Cast(
(Select Cast(Sum(Numerator_15M_EOQ) as decimal(15,4)) from Stage_Smoking_Register where PatientUnenrolled = 0)
/(Select Cast(Count(*) as decimal(15,4)) from Stage_Smoking_Register where PatientUnenrolled = 0)
as decimal(5,4)) as RAPHS_Performance,
Cast(
(Select Cast(Sum(case 
	when Numerator_15M_EOQ = 1 and Eth = 21 then 1
else 0
End) as decimal(15,4)) from Stage_Smoking_Register where PatientUnenrolled = 0)
/(Select Cast(Sum(
Case 
	when eth = 21 then 1 
else 0 
End) as decimal(15,4)) from Stage_Smoking_Register where PatientUnenrolled = 0)
as decimal(5,4)) as RAPHS_Performance_Maori )