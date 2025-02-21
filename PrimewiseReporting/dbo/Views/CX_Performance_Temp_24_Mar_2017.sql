Create view [dbo].[CX_Performance_Temp_24_Mar_2017]  --drop view CX_Performance_Temp_24_Mar_2017
as
Select c.Cohort_PracticeID as 'PracticeID', 
Case c.Cohort_PracticeID
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
	when 30 then 'KAH'
	When 32 then 'NP'
	else '#NA'
End
	as Practice,
	Sum(Cast(In_Numerator_All as int)) as CX_Complete,
sum
(Case
	when c.Ethnicity = 'NZ Maori'
	then In_Numerator_All
	else 0
	end) as CX_Complete_Maori,
Sum(case In_Numerator_All
	when 0 then 1
else 0
End) as Overdue,
count(*) as Total_Eligible,
Cast(Sum(Cast(In_Numerator_All as int)) as decimal(10,2))/Cast(Sum(c.CX_Denominator_Adjustor) as decimal(10,2)) as Performance_Total,
Cast(sum
(Case
	when c.Ethnicity = 'NZ Maori'
	then Cast(In_Numerator_All as int)
	else 0
	end)
as decimal(10,2))
/Cast(Sum
(Case
	when c.Ethnicity = 'NZ Maori'
	then CX_Denominator_Adjustor
	else 0
	end) as decimal(10,2)) as Performance_Maori,
0.80 as National_Target,
Case when
cast((0.80 * Sum(c.CX_Denominator_Adjustor)) as decimal(10,0)) - 
Sum(Cast(In_Numerator_All as int)) < 0 then 0
else
cast((0.80 * Sum(c.CX_Denominator_Adjustor)) as decimal(10,0)) - 
Sum(Cast(In_Numerator_All as int))
End
as No_Required_To_Target,
Case when
cast((0.80 * (Select Sum(CX_Denominator_Adjustor) from [Stage_CX_Temp_24Mar2017_ToDelete] where ethnicity = 'NZ Maori' and cohort_PracticeID = c.Cohort_PracticeID)) as decimal(10,0)) - 
(Select Sum(Cast(In_Numerator_All as int)) from [Stage_CX_Temp_24Mar2017_ToDelete] where ethnicity = 'NZ Maori'  and Cohort_PracticeID = c.Cohort_PracticeID) < 0 then 0
else
cast((0.80 * (Select Sum(CX_Denominator_Adjustor) from [Stage_CX_Temp_24Mar2017_ToDelete] where ethnicity = 'NZ Maori' and practiceID = c.Cohort_PracticeID)) as decimal(10,0)) - 
(Select Sum(Cast(In_Numerator_All as int)) from [Stage_CX_Temp_24Mar2017_ToDelete] where ethnicity = 'NZ Maori'  and PracticeID = c.Cohort_PracticeID)
End
as No_Required_To_Target_Maori,
--MAX(LastUpdated) as Last_Updated,
(Select Cast(Sum(Cast(In_Numerator_All as int)) as decimal(10,2)) from [Stage_CX_Temp_24Mar2017_ToDelete])
/(Select Cast(Sum(CX_Denominator_Adjustor) as decimal(10,2)) from [Stage_CX_Temp_24Mar2017_ToDelete]) as RAPHS_Performace,
(Select Cast(Sum(Cast(In_Numerator_All as int)) as decimal(10,2)) from [Stage_CX_Temp_24Mar2017_ToDelete] where Ethnicity = 'NZ Maori')
/(Select Cast(Sum(CX_Denominator_Adjustor) as decimal(10,2)) from [Stage_CX_Temp_24Mar2017_ToDelete] where Ethnicity = 'NZ Maori') as RAPHS_Performace_Maori
from [dbo].[Stage_CX_Temp_24Mar2017_ToDelete] as c
group by c.Cohort_PracticeID,
Case c.Cohort_PracticeID
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
(Select Sum(Cast(In_Numerator_All as int)) from [Stage_CX_Temp_24Mar2017_ToDelete]) as CX_Complete,
(Select Sum(Cast(In_Numerator_All as int)) from [Stage_CX_Temp_24Mar2017_ToDelete] where Ethnicity = 'NZ Maori') as CX_Complete_Maori,
(Select Sum(case In_Numerator_All
	when 1 then 0
else 1
End) from [Stage_CX_Temp_24Mar2017_ToDelete]) as Overdue,
(Select count(*) from [Stage_CX_Temp_24Mar2017_ToDelete]) as Total_Eligible,
(Select Cast(Sum(Cast(In_Numerator_All as int)) as decimal(10,2)) from [Stage_CX_Temp_24Mar2017_ToDelete])
/(Select Cast(sum(CX_Denominator_Adjustor) as decimal(10,2)) from [Stage_CX_Temp_24Mar2017_ToDelete]) as Performance,
(Select Cast(Sum(Cast(In_Numerator_All as int)) as decimal(10,2)) from [Stage_CX_Temp_24Mar2017_ToDelete] where Ethnicity = 'NZ Maori')
/(Select Cast(sum(CX_Denominator_Adjustor) as decimal(10,2)) from [Stage_CX_Temp_24Mar2017_ToDelete]  where Ethnicity = 'NZ Maori') as Performance_Maori,
0.80 as National_Target,
Case when
cast((0.80 * (Select sum(CX_Denominator_Adjustor) from [Stage_CX_Temp_24Mar2017_ToDelete])) as decimal(10,0)) - 
(Select Sum(Cast(In_Numerator_All as int)) from [Stage_CX_Temp_24Mar2017_ToDelete]) < 0 then 0
else
cast((0.80 * (Select sum(CX_Denominator_Adjustor) from [Stage_CX_Temp_24Mar2017_ToDelete])) as decimal(10,0)) - 
(Select Sum(Cast(In_Numerator_All as int)) from [Stage_CX_Temp_24Mar2017_ToDelete])
End
as No_Required_To_Target,
Case when
cast((0.80 * (Select Sum(CX_Denominator_Adjustor) from [Stage_CX_Temp_24Mar2017_ToDelete] where ethnicity = 'NZ Maori')) as decimal(10,0)) - 
(Select Sum(Cast(In_Numerator_All as int)) from [Stage_CX_Temp_24Mar2017_ToDelete] where ethnicity = 'NZ Maori') < 0 then 0
else
cast((0.80 * (Select Sum(CX_Denominator_Adjustor) from [Stage_CX_Temp_24Mar2017_ToDelete] where ethnicity = 'NZ Maori')) as decimal(10,0)) - 
(Select Sum(Cast(In_Numerator_All as int)) from [Stage_CX_Temp_24Mar2017_ToDelete] where ethnicity = 'NZ Maori')
End
as No_Required_To_Target_Maori,
--(Select MAX(LastUpdated) from Stage_Smoking_Register) as Last_Updated,
(Select Cast(Sum(Cast(In_Numerator_All as int)) as decimal(10,2)) from [Stage_CX_Temp_24Mar2017_ToDelete])
/(Select cast(sum(CX_Denominator_Adjustor)as decimal(10,2)) from [Stage_CX_Temp_24Mar2017_ToDelete]) as RAPHS_Performace,
(Select Cast(Sum(Cast(In_Numerator_All as int)) as decimal(10,2)) from [Stage_CX_Temp_24Mar2017_ToDelete] where Ethnicity = 'NZ Maori')
/(Select Cast(sum(CX_Denominator_Adjustor) as decimal(10,2)) from [Stage_CX_Temp_24Mar2017_ToDelete]  where Ethnicity = 'NZ Maori') as RAPHS_Performance_Maori
;