--select * from  [dbo].[SLM_Performance_CX]
CREATE View [dbo].[SLM_Performance_CX]
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
	when 30 then 'KAH'
	when 32 then 'NP'
	else '#NA'
End as Practice,
Sum(Cast(CX_Numerator as int)) as CX_Complete,
sum
(Case
	when r.Ethnicity = 'NZ Maori'
	then cx_Numerator
	else 0
	end) as CX_Complete_Maori,
Sum(case cx_Numerator
	when 0 then 1
else 0
End) as Overdue,
count(*) as Total_Eligible,
Cast(Sum(Cast(CX_Numerator as int)) as decimal(10,2))/Cast(Sum(r.CX_Denominator_Adjustor) as decimal(10,2)) as Performance_Total,
Cast(sum
(Case
	when r.Ethnicity = 'NZ Maori'
	then Cast(CX_Numerator as int)
	else 0
	end)
as decimal(10,2))
/Cast(Sum
(Case
	when r.Ethnicity = 'NZ Maori'
	then CX_Denominator_Adjustor
	else 0
	end) as decimal(10,2)) as Performance_Maori,
0.80 as National_Target,
Case when
cast((0.80 * Sum(r.CX_Denominator_Adjustor)) as decimal(10,0)) - 
Sum(Cast(CX_Numerator as int)) < 0 then 0
else
cast((0.80 * Sum(r.CX_Denominator_Adjustor)) as decimal(10,0)) - 
Sum(Cast(CX_Numerator as int))
End
as No_Required_To_Target,
Case when
cast((0.80 * (Select Sum(CX_Denominator_Adjustor) from Stage_CX where ethnicity = 'NZ Maori' and PracticeID = r.PracticeID)) as decimal(10,0)) - 
(Select Sum(Cast(CX_Numerator as int)) from Stage_CX where ethnicity = 'NZ Maori'  and PracticeID = r.PracticeID) < 0 then 0
else
cast((0.80 * (Select Sum(CX_Denominator_Adjustor) from Stage_CX where ethnicity = 'NZ Maori' and practiceID = r.PracticeID)) as decimal(10,0)) - 
(Select Sum(Cast(CX_Numerator as int)) from Stage_CX where ethnicity = 'NZ Maori'  and PracticeID = r.PracticeID)
End
as No_Required_To_Target_Maori,
--MAX(LastUpdated) as Last_Updated,
(Select Cast(Sum(Cast(CX_Numerator as int)) as decimal(10,2)) from Stage_CX)
/(Select Cast(Sum(CX_Denominator_Adjustor) as decimal(10,2)) from Stage_CX) as RAPHS_Performace,
(Select Cast(Sum(Cast(CX_Numerator as int)) as decimal(10,2)) from Stage_CX where Ethnicity = 'NZ Maori')
/(Select Cast(Sum(CX_Denominator_Adjustor) as decimal(10,2)) from Stage_CX where Ethnicity = 'NZ Maori') as RAPHS_Performace_Maori
from Stage_CX as r
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
(Select Sum(Cast(CX_Numerator as int)) from Stage_CX) as CX_Complete,
(Select Sum(Cast(CX_Numerator as int)) from Stage_CX where Ethnicity = 'NZ Maori') as CX_Complete_Maori,
(Select Sum(case CX_Numerator
	when 1 then 0
else 1
End) from Stage_CX) as Overdue,
(Select count(*) from Stage_CX) as Total_Eligible,
(Select Cast(Sum(Cast(CX_Numerator as int)) as decimal(10,2)) from Stage_CX)
/(Select Cast(sum(CX_Denominator_Adjustor) as decimal(10,2)) from Stage_CX) as Performance,
(Select Cast(Sum(Cast(CX_Numerator as int)) as decimal(10,2)) from Stage_CX where Ethnicity = 'NZ Maori')
/(Select Cast(sum(CX_Denominator_Adjustor) as decimal(10,2)) from Stage_CX  where Ethnicity = 'NZ Maori') as Performance_Maori,
0.80 as National_Target,
Case when
cast((0.80 * (Select sum(CX_Denominator_Adjustor) from Stage_CX)) as decimal(10,0)) - 
(Select Sum(Cast(CX_Numerator as int)) from Stage_CX) < 0 then 0
else
cast((0.80 * (Select sum(CX_Denominator_Adjustor) from Stage_CX)) as decimal(10,0)) - 
(Select Sum(Cast(CX_Numerator as int)) from Stage_CX)
End
as No_Required_To_Target,
Case when
cast((0.80 * (Select Sum(CX_Denominator_Adjustor) from Stage_CX where ethnicity = 'NZ Maori')) as decimal(10,0)) - 
(Select Sum(Cast(CX_Numerator as int)) from Stage_CX where ethnicity = 'NZ Maori') < 0 then 0
else
cast((0.80 * (Select Sum(CX_Denominator_Adjustor) from Stage_CX where ethnicity = 'NZ Maori')) as decimal(10,0)) - 
(Select Sum(Cast(CX_Numerator as int)) from Stage_CX where ethnicity = 'NZ Maori')
End
as No_Required_To_Target_Maori,
--(Select MAX(LastUpdated) from Stage_Smoking_Register) as Last_Updated,
(Select Cast(Sum(Cast(CX_Numerator as int)) as decimal(10,2)) from Stage_CX)
/(Select cast(sum(CX_Denominator_Adjustor)as decimal(10,2)) from Stage_CX) as RAPHS_Performace,
(Select Cast(Sum(Cast(CX_Numerator as int)) as decimal(10,2)) from Stage_CX where Ethnicity = 'NZ Maori')
/(Select Cast(sum(CX_Denominator_Adjustor) as decimal(10,2)) from Stage_CX  where Ethnicity = 'NZ Maori') as RAPHS_Performance_Maori)