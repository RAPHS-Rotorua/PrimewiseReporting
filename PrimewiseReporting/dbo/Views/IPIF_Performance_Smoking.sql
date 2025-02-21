--select * from  IPIF_Performance_Smoking
CREATE View [dbo].[IPIF_Performance_Smoking]
as
(
Select PracticeID,
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
Sum(case Numerator_15M_EOQ
	when 1 then 1
else 0
End) as Cessation_Recorded,
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
Cast(Sum(case Numerator_15M_EOQ
	when 1 then 1
else 0
End) as decimal(10,2))/Cast(Count(*) as decimal(10,2)) as Performance,
Cast(Sum(case 
	when Numerator_15M_EOQ = 1 and Eth = 21 then 1
else 0
End) as decimal(10,2))/Cast(Sum(
Case 
	when eth = 21 then 1 
else 0 
End) as decimal(10,2)) as Performance_Maori,
0.90 as Programme_Goal,
Case when
cast((0.90 * count(*)) as decimal(10,0)) - 
Sum(case Numerator_15M_EOQ
	when 1 then 1
else 0
End) < 0 then 0
else
cast((0.90 * count(*)) as decimal(10,0)) - 
Sum(case Numerator_15M_EOQ
	when 1 then 1
else 0
End)
End
as No_Required_To_Target,
Case when
cast((0.90 * Sum(
Case 
	when eth = 21 then 1 
else 0 
End)) as decimal(10,0)) - 
Sum(case 
	when Numerator_15M_EOQ = 1 and Eth = 21 then 1
else 0
End) < 0 then 0
else
cast((0.90 * Sum(
Case 
	when eth = 21 then 1 
else 0 
End)) as decimal(10,0)) - 
Sum(case 
	when Numerator_15M_EOQ = 1 and eth = 21 then 1
else 0
End)
End
as No_Required_To_Target_Maori,
MAX(LastUpdated) as Last_Updated,
(Select Cast(Sum(case Numerator_15M_EOQ
	when 1 then 1
else 0
End) as decimal(10,2)) from Stage_Smoking_Register)
/(Select Cast(Count(*) as decimal(10,2)) from Stage_Smoking_Register) as RAPHS_Performance,
(Select Cast(Sum(case 
	when Numerator_15M_EOQ = 1 and eth = 21 then 1
else 0
End) as decimal(10,2)) from Stage_Smoking_Register)
/(Select Cast(Sum(case 
	when eth = 21 then 1
else 0
End) as decimal(10,2)) from Stage_Smoking_Register) as RAPHS_Performance_Maori
from Stage_Smoking_Register as r
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
	When 32 then 'NP'
	else '#NA'
End
--
union
--
Select
99 as PracticeID,
 'RAPHS' as Practice,
(Select Sum(case Numerator_15M_EOQ
	when 1 then 1
else 0
End) from Stage_Smoking_Register) as Cessation_Recorded,
(Select Sum(case 
	when Numerator_15M_EOQ = 1 and eth = 21 then 1
else 0
End) from Stage_Smoking_Register) as Cessation_Recorded_Maori,
(Select Sum(case Numerator_15M_EOQ
	when 0 then 1
else 0
End) from Stage_Smoking_Register) as Overdue,
(Select Sum(case 
	when Numerator_15M_EOQ = 0 and eth = 21 then 1
else 0
End) from Stage_Smoking_Register) as Overdue_Maori,
(Select count(*) from Stage_Smoking_Register) as Total_Eligible,
(Select Sum(
Case 
	when eth = 21 then 1 
else 0 
End) from Stage_Smoking_Register) as Total_Eligible_Maori,
(Select Cast(Sum(case Numerator_15M_EOQ
	when 1 then 1
else 0
End) as decimal(10,2)) from Stage_Smoking_Register)
/(Select Cast(Count(*) as decimal(10,2)) from Stage_Smoking_Register) as Performance,
(Select Cast(Sum(case 
	when Numerator_15M_EOQ = 1 and eth = 21 then 1
else 0
End) as decimal(10,2)) from Stage_Smoking_Register)
/(Select Cast(Sum(
Case 
	when eth = 21 then 1 
else 0 
End) as decimal(10,2)) from Stage_Smoking_Register) as Performance_Maori,
0.90 as Programme_Goal,
Case when
cast((0.90 * (Select count(*) from Stage_Smoking_Register)) as decimal(10,0)) - 
(Select Sum(case Numerator_15M_EOQ
	when 1 then 1
else 0
End) from Stage_Smoking_Register) < 0 then 0
else
cast((0.90 * (Select count(*) from Stage_Smoking_Register)) as decimal(10,0)) - 
(Select Sum(case Numerator_15M_EOQ
	when 1 then 1
else 0
End) from Stage_Smoking_Register)
End
as No_Required_To_Target,
Case when
cast((0.90 * (Select Sum(
Case 
	when eth = 21 then 1 
else 0 
End) from Stage_Smoking_Register)) as decimal(10,0)) - 
(Select Sum(case 
	when Numerator_15M_EOQ = 1 and Eth = 21 then 1
else 0
End) from Stage_Smoking_Register) < 0 then 0
else
cast((0.90 * (Select Sum(
Case 
	when eth = 21 then 1 
else 0 
End) from Stage_Smoking_Register)) as decimal(10,0)) - 
(Select Sum(case 
	when Numerator_15M_EOQ = 1 and eth = 21 then 1
else 0
End) from Stage_Smoking_Register)
End
as No_Required_To_Target_Maori,
(Select MAX(LastUpdated) from Stage_Smoking_Register) as Last_Updated,
(Select Cast(Sum(case Numerator_15M_EOQ
	when 1 then 1
else 0
End) as decimal(10,2)) from Stage_Smoking_Register)
/(Select Cast(Count(*) as decimal(10,2)) from Stage_Smoking_Register) as RAPHS_Performance,
(Select Cast(Sum(case 
	when Numerator_15M_EOQ = 1 and Eth = 21 then 1
else 0
End) as decimal(10,2)) from Stage_Smoking_Register)
/(Select Cast(Sum(
Case 
	when eth = 21 then 1 
else 0 
End) as decimal(10,2)) from Stage_Smoking_Register) as RAPHS_Performance_Maori )