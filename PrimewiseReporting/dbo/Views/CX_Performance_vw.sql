--Select * from CX_Performance_vw --where PracticeID = 26 ;
--Select sum(CX_Denominator_Adjustor) from [dbo].[Stage_CX_Reporting] where practiceID = 26 and ethnicity ='NZ Maori' and AgeBand <> '20-24' and PatientUnenrolled = 0;

----Select * from [dbo].[Stage_CX_Reporting]
--Select sum(In_Numerator_All) from [dbo].[Stage_CX_Reporting] where practiceID = 26 and ethnicity ='NZ Maori' and AgeBand <> '20-24' and PatientUnenrolled = 0;


CREATE view [dbo].[CX_Performance_vw]  --drop view CX_Performance_vw
as
Select c.PracticeID, 
Case c.PracticeID
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
	When 28 then 'THMC'
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
End) as Overdue_All,
count(*) as Cohort_All,
sum
(Case
	when c.Ethnicity = 'NZ Maori'
	then In_Denominator
	else 0
	end) as Cohort_Maori,
Sum(CX_Denominator_Adjustor) as Denominator_All,
sum
(Case
	when c.Ethnicity = 'NZ Maori'
	then CX_Denominator_Adjustor
	else 0
	end) as Denominator_Maori,
Cast(
Cast(Sum(Cast(In_Numerator_All as int)) as decimal(15,4))/Cast(Sum(c.CX_Denominator_Adjustor) as decimal(15,4))
as decimal(5,4)) as Performance_Total,
Cast(
Cast(sum
(Case
	when c.Ethnicity = 'NZ Maori'
	then Cast(In_Numerator_All as int)
	else 0
	end)
as decimal(15,4))
/Cast(Sum
(Case
	when c.Ethnicity = 'NZ Maori'
	then CX_Denominator_Adjustor
	else 0
	end) as decimal(15,4))
	as decimal(5,4)) as Performance_Maori,
0.80 as National_Target,
Case when
ceiling((0.80 * Sum(c.CX_Denominator_Adjustor))) - 
Sum(Cast(In_Numerator_All as int)) < 0 then 0
else
ceiling((0.80 * Sum(c.CX_Denominator_Adjustor))) - 
Sum(Cast(In_Numerator_All as int))
End
as No_Required_To_Target,
Case when
ceiling((0.80 * (Select Sum(CX_Denominator_Adjustor) from [Stage_CX_Reporting] 
where ethnicity = 'NZ Maori' and In_Denominator = 1 and PracticeID = c.PracticeID and PatientUnenrolled = 0))) - 
(Select Sum(Cast(In_Numerator_All as int)) from [Stage_CX_Reporting] 
where ethnicity = 'NZ Maori' and In_Denominator = 1 and PracticeID = c.PracticeID and PatientUnenrolled = 0) < 0 then 0
else
ceiling((0.80 * (Select Sum(CX_Denominator_Adjustor) from [Stage_CX_Reporting] 
where ethnicity = 'NZ Maori' and In_Denominator = 1 and practiceID = c.PracticeID and PatientUnenrolled = 0))) - 
(Select Sum(Cast(In_Numerator_All as int)) from [Stage_CX_Reporting] 
where ethnicity = 'NZ Maori' and In_Denominator = 1  and PracticeID = c.PracticeID and PatientUnenrolled = 0)
End
as No_Required_To_Target_Maori,
--MAX(LastUpdated) as Last_Updated,
Cast(
(Select Cast(Sum(Cast(In_Numerator_All as int)) as decimal(15,4)) from [Stage_CX_Reporting] where In_Denominator = 1 and PatientUnenrolled = 0)
/(Select Cast(Sum(CX_Denominator_Adjustor) as decimal(15,4)) from [Stage_CX_Reporting] where In_Denominator = 1 and PatientUnenrolled = 0)
as decimal(5,4)) as RAPHS_Performace,
Cast(
(Select Cast(Sum(Cast(In_Numerator_All as int)) as decimal(15,4)) from [Stage_CX_Reporting] where Ethnicity = 'NZ Maori' and In_Denominator = 1 and PatientUnenrolled = 0)
/(Select Cast(Sum(CX_Denominator_Adjustor) as decimal(15,4)) from [Stage_CX_Reporting] where Ethnicity = 'NZ Maori' and In_Denominator = 1 and PatientUnenrolled = 0)
as decimal(5,4)) as RAPHS_Performace_Maori
from [dbo].[Stage_CX_Reporting] as c
where c.In_Denominator = 1 and PatientUnenrolled = 0
group by c.PracticeID,
Case c.PracticeID
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
	When 28 then 'THMC'
	else '#NA'
End
--
union
--
Select
99 as PracticeID,
 'RAPHS' as Practice,
(Select Sum(Cast(In_Numerator_All as int)) from [Stage_CX_Reporting] where In_Denominator = 1 and PatientUnenrolled = 0) as CX_Complete,
(Select Sum(Cast(In_Numerator_All as int)) from [Stage_CX_Reporting] where Ethnicity = 'NZ Maori' and In_Denominator = 1 and PatientUnenrolled = 0) as CX_Complete_Maori,
(Select Sum(case In_Numerator_All
	when 1 then 0
else 1
End) from [Stage_CX_Reporting] where In_Denominator = 1 and PatientUnenrolled = 0) as Overdue_All,
(Select count(*) from [Stage_CX_Reporting] where In_Denominator = 1 and PatientUnenrolled = 0) as Cohort_All,
(Select Sum(In_Denominator) from [Stage_CX_Reporting] where Ethnicity = 'NZ Maori' and In_Denominator = 1 and PatientUnenrolled = 0) as Cohort_Maori,
(Select Sum(CX_Denominator_Adjustor) from [Stage_CX_Reporting] where In_Denominator = 1 and PatientUnenrolled = 0) as Denominator_All,
(Select Sum(CX_Denominator_Adjustor) from [Stage_CX_Reporting] where Ethnicity = 'NZ Maori' and In_Denominator = 1 and PatientUnenrolled = 0) as Denominator_Maori,
Cast(
(Select Cast(Sum(Cast(In_Numerator_All as int)) as decimal(15,4)) from [Stage_CX_Reporting] where In_Denominator = 1 and PatientUnenrolled = 0)
/(Select Cast(sum(CX_Denominator_Adjustor) as decimal(15,4)) from [Stage_CX_Reporting] where In_Denominator = 1 and PatientUnenrolled = 0)
as decimal(5,4)) as Performance,
Cast(
(Select Cast(Sum(Cast(In_Numerator_All as int)) as decimal(15,4)) from [Stage_CX_Reporting] where Ethnicity = 'NZ Maori' and In_Denominator = 1 and PatientUnenrolled = 0)
/(Select Cast(sum(CX_Denominator_Adjustor) as decimal(15,4)) from [Stage_CX_Reporting] where Ethnicity = 'NZ Maori' and In_Denominator = 1 and PatientUnenrolled = 0) 
as decimal(5,4)) as Performance_Maori,
0.80 as National_Target,
Case when
ceiling((0.80 * (Select sum(CX_Denominator_Adjustor) from [Stage_CX_Reporting] where In_Denominator = 1 and PatientUnenrolled = 0))) - 
(Select Sum(Cast(In_Numerator_All as int)) from [Stage_CX_Reporting] where In_Denominator = 1 and PatientUnenrolled = 0) < 0 then 0
else
ceiling((0.80 * (Select sum(CX_Denominator_Adjustor) from [Stage_CX_Reporting] where In_Denominator = 1 and PatientUnenrolled = 0))) - 
(Select Sum(Cast(In_Numerator_All as int)) from [Stage_CX_Reporting] where In_Denominator = 1 and PatientUnenrolled = 0)
End
as No_Required_To_Target,
Case when
ceiling((0.80 * (Select Sum(CX_Denominator_Adjustor) from [Stage_CX_Reporting] where ethnicity = 'NZ Maori' and In_Denominator = 1 and PatientUnenrolled = 0))) - 
(Select Sum(Cast(In_Numerator_All as int)) from [Stage_CX_Reporting] where ethnicity = 'NZ Maori' and In_Denominator = 1 and PatientUnenrolled = 0) < 0 then 0
else
ceiling((0.80 * (Select Sum(CX_Denominator_Adjustor) from [Stage_CX_Reporting] where ethnicity = 'NZ Maori' and In_Denominator = 1 and PatientUnenrolled = 0))) - 
(Select Sum(Cast(In_Numerator_All as int)) from [Stage_CX_Reporting] where ethnicity = 'NZ Maori' and In_Denominator = 1 and PatientUnenrolled = 0)
End
as No_Required_To_Target_Maori,
--(Select MAX(LastUpdated) from Stage_Smoking_Register) as Last_Updated,
Cast(
(Select Cast(Sum(Cast(In_Numerator_All as int)) as decimal(15,4)) from [Stage_CX_Reporting] where In_Denominator = 1 and PatientUnenrolled = 0)
/(Select cast(sum(CX_Denominator_Adjustor)as decimal(15,4)) from [Stage_CX_Reporting] where In_Denominator = 1 and PatientUnenrolled = 0)
as decimal(5,4)) as RAPHS_Performace,
Cast(
(Select Cast(Sum(Cast(In_Numerator_All as int)) as decimal(15,4)) from [Stage_CX_Reporting] where Ethnicity = 'NZ Maori' and In_Denominator = 1 and PatientUnenrolled = 0)
/(Select Cast(sum(CX_Denominator_Adjustor) as decimal(15,4)) from [Stage_CX_Reporting]  where Ethnicity = 'NZ Maori' and In_Denominator = 1 and PatientUnenrolled = 0)
as decimal(5,4)) as RAPHS_Performance_Maori
;