--Select * from Stage_Dar_Reporting
--where in_Denominator = 1;
--go
--Select distinct HbA1c_Bands from Stage_Dar_Reporting
--where in_Denominator = 1

--test
--Select * from DAR_Performance_vw

CREATE view [dbo].[DAR_Performance_vw]  
as
Select d.PracticeID, 
Case d.PracticeID
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
	Sum(Cast(In_Numerator as int)) as DAR_Complete,
Sum(
Case when HBa1c <= 64 then Cast(In_Numerator as int)
else 0
End) as DAR_Complete_HbA1c64mmol,
Sum(case In_Numerator
	when 0 then 1
else 0
End) as Overdue,
count(*) as Total_Eligible,
Sum(
Case when Hba1c <=64 then 1
else 0
End) as Total_Hba1c64mmol,
Cast(Sum(Cast(In_Numerator as int)) as decimal(10,2))/Cast(Sum(Cast(In_Denominator as int)) as decimal(10,2)) as Performance_Total,
Cast(sum
(Case
	when Ethnicity = 'NZ Maori'
	then Cast(In_Numerator as int)
	else 0
	end)
as decimal(10,2))
/Cast(Sum
(Case
	when Ethnicity = 'NZ Maori'
	then Cast(In_Denominator as int)
	else 0
	end) as decimal(10,2)) as Performance_Maori,
0.85 as National_Target,
Case when
Ceiling(cast((0.85 * Sum(In_Denominator)) as decimal(10,2)) - 
Sum(Cast(In_Numerator as decimal(10,2)))) < 0 then 0
else
Ceiling(cast((0.85 * Sum(In_Denominator)) as decimal(10,2)) - 
Sum(Cast(In_Numerator as decimal(10,2))))
End
as No_Required_To_Target,
(Select Cast(Sum(Cast(In_Numerator as int)) as decimal(10,2)) from Stage_Dar_Reporting where PatientUnenrolled = 0)
/(Select Cast(Sum(Cast(In_Denominator as int)) as decimal(10,2)) from Stage_Dar_Reporting where PatientUnenrolled = 0) as RAPHS_Performance,
(Select Cast(Sum(Cast(In_Numerator as int)) as decimal(10,2)) from Stage_Dar_Reporting where Ethnicity = 'NZ Maori'  and PatientUnenrolled = 0)
/(Select Cast(Sum(Cast(In_Denominator as int)) as decimal(10,2)) from Stage_Dar_Reporting  where Ethnicity = 'NZ Maori' and PatientUnenrolled = 0) as RAPHS_Performance_Maori,
Case when
(Select ceiling((0.85 * Sum(h2.In_Denominator))) - Sum(h2.In_Numerator)
from Stage_Dar_Reporting as h2 where h2.Ethnicity = 'NZ Maori' and h2.PatientUnenrolled = 0 and h2.PracticeID = d.PracticeID) < 0 
then 0
else
(Select ceiling((0.85 * Sum(h3.In_Denominator))) - Sum(h3.In_Numerator)
from Stage_Dar_Reporting as h3 where h3.Ethnicity = 'NZ Maori' and h3.PatientUnenrolled = 0 and h3.PracticeID = d.PracticeID)
End as No_Required_To_Target_Maori,
Cast(sum
(Case
	when HbA1c_Bands = '<=64mmol/mol'
	then Cast(In_Numerator as int)
	else 0
	end)
as decimal(10,2))
/Cast(Sum
(Case
	when HbA1c_Bands = '<=64mmol/mol'
	then Cast(In_Denominator as int)
	else 0
	end) as decimal(10,2)) as Performance_HbA1c64,
Case when
(Select ceiling((0.85 * Sum(h5.In_Denominator))) - Sum(h5.In_Numerator)
from Stage_Dar_Reporting as h5 where h5.HbA1c_Bands = '<=64mmol/mol' and h5.PatientUnenrolled = 0 and h5.PracticeID = d.PracticeID) < 0 
then 0
else
(Select ceiling((0.85 * Sum(h6.In_Denominator))) - Sum(h6.In_Numerator)
from Stage_Dar_Reporting as h6 where h6.HbA1c_Bands = '<=64mmol/mol' and h6.PatientUnenrolled = 0 and h6.PracticeID = d.PracticeID)
End as No_Required_To_Target_HbA1c64
from [dbo].[Stage_Dar_Reporting] as d  --Select distinct HbA1c_Bands from [dbo].[Stage_Dar_Reporting]
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
	When 28 then 'THMC'
	else '#NA'
End
--
union
--
Select
99 as PracticeID,
 'RAPHS' as Practice,
(Select Sum(Cast(In_Numerator as int)) from [Stage_Dar_Reporting] where PatientUnenrolled = 0) as DAR_Complete,
(Select Sum(Cast(In_Numerator as int)) from [Stage_Dar_Reporting] where Hba1c <= 64 and PatientUnenrolled = 0) as DAR_Complete_Hba1c64mmol,
(Select Sum(case In_Numerator
	when 1 then 0
else 1
End) from [Stage_Dar_Reporting] where PatientUnenrolled = 0) as Overdue,
(Select count(*) from [Stage_Dar_Reporting] where PatientUnenrolled = 0) as Total_Eligible,
(Select sum(In_Denominator) from Stage_Dar_Reporting where HbA1c <= 64 and PatientUnenrolled = 0) as Total_Hba1c64mmol,
(Select Cast(Sum(Cast(In_Numerator as int)) as decimal(10,2)) from [Stage_Dar_Reporting] where PatientUnenrolled = 0)
/(Select Cast(Sum(Cast(In_Denominator as int)) as decimal(10,2)) from [Stage_Dar_Reporting] where PatientUnenrolled = 0) as Performance_Total,
(Select Cast(Sum(Cast(In_Numerator as int)) as decimal(10,2)) from [Stage_Dar_Reporting] where ethnicity = 'NZ Maori' and PatientUnenrolled = 0)
/(Select Cast(Sum(Cast(In_Denominator as int)) as decimal(10,2)) from [Stage_Dar_Reporting] where ethnicity = 'NZ Maori' and PatientUnenrolled = 0) as Performance_Maori,
0.85 as National_Target,
Case when
Ceiling(cast((0.85 * (Select Sum(Cast(In_Denominator as int)) from [Stage_Dar_Reporting] where PatientUnenrolled = 0)) as decimal(10,2)) - 
(Select Sum(Cast(In_Numerator as decimal(10,2))) from [Stage_Dar_Reporting] where PatientUnenrolled = 0)) < 0 then 0
else
Ceiling(cast((0.85 * (Select Sum(Cast(In_Denominator as int)) from [Stage_Dar_Reporting] where PatientUnenrolled = 0)) as decimal(10,2)) - 
(Select Sum(Cast(In_Numerator as decimal(10,2))) from [Stage_Dar_Reporting] where PatientUnenrolled = 0))
End
as No_Required_To_Target,
(Select Cast(Sum(Cast(In_Numerator as int)) as decimal(10,2)) from [Stage_Dar_Reporting] where PatientUnenrolled = 0)
/(Select cast(Sum(Cast(In_Denominator as int))as decimal(10,2)) from [Stage_Dar_Reporting] where PatientUnenrolled = 0) as RAPHS_Performance,
(Select Cast(Sum(Cast(In_Numerator as int)) as decimal(10,2)) from Stage_Dar_Reporting where Ethnicity = 'NZ Maori' and PatientUnenrolled = 0)
/(Select Cast(Sum(Cast(In_Denominator as int)) as decimal(10,2)) from Stage_Dar_Reporting  where Ethnicity = 'NZ Maori' and PatientUnenrolled = 0) as RAPHS_Performance_Maori,
Case when
(Select ceiling((0.85 * Sum(In_Denominator))) - Sum(In_Numerator)
from Stage_Dar_Reporting where Ethnicity = 'NZ Maori' and PatientUnenrolled = 0) < 0 
then 0
else
(Select ceiling((0.85 * Sum(In_Denominator))) - Sum(In_Numerator)
from Stage_Dar_Reporting where Ethnicity = 'NZ Maori' and PatientUnenrolled = 0)
End as No_Required_To_Target_Maori,
(Select Cast(Sum(Cast(In_Numerator as int)) as decimal(10,2)) from [Stage_Dar_Reporting] where HbA1c_Bands = '<=64mmol/mol' and PatientUnenrolled = 0)
/(Select Cast(Sum(Cast(In_Denominator as int)) as decimal(10,2)) from [Stage_Dar_Reporting] where HbA1c_Bands = '<=64mmol/mol' and PatientUnenrolled = 0) as Performance_HbA1c64,
Case when
(Select ceiling((0.85 * Sum(In_Denominator))) - Sum(In_Numerator)
from Stage_Dar_Reporting where HbA1c_Bands = '<=64mmol/mol' and PatientUnenrolled = 0) < 0 
then 0
else
(Select ceiling((0.85 * Sum(In_Denominator))) - Sum(In_Numerator)
from Stage_Dar_Reporting where HbA1c_Bands = '<=64mmol/mol' and PatientUnenrolled = 0)
End as No_Required_To_Target_Maori;