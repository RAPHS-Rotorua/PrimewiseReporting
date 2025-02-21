--test
--Select * from [LINC_Performance_vw]
CREATE view [dbo].[LINC_Performance_vw]  --drop view [LINC_Performance_vw]
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
	when 28 then 'THMC'
	when 30 then 'KAH'
	When 32 then 'NP'
	else '#NA'
End
	as Practice,
	Sum(Cast(In_Numerator as int)) as LINC_Complete,
Sum(case In_Numerator
	when 0 then 1
else 0
End) as Overdue,
count(*) as Total_Eligible,
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
	0.90 as National_Target,
(Select Cast(Sum(Cast(In_Numerator as int)) as decimal(10,2)) from Stage_LINC_Reporting where LTCEnrolmentIndicator = 1 and PatientUnenrolled = 0 and In_Denominator = 1)
/(Select Cast(Sum(Cast(In_Denominator as int)) as decimal(10,2)) from Stage_LINC_Reporting where LTCEnrolmentIndicator = 1 and PatientUnenrolled = 0  and In_Denominator = 1) as RAPHS_Performance
from [dbo].Stage_LINC_Reporting as d
where d.LTCEnrolmentIndicator = 1 and PatientUnenrolled = 0 and In_Denominator = 1
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
	when 28 then 'THMC'
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
(Select Sum(Cast(In_Numerator as int)) from Stage_LINC_Reporting where LTCEnrolmentIndicator = 1 and PatientUnenrolled = 0 and In_Denominator = 1) as LINC_Complete,
(Select Sum(case In_Numerator
	when 1 then 0
else 1
End) from Stage_LINC_Reporting where LTCEnrolmentIndicator = 1 and PatientUnenrolled = 0 and In_Denominator = 1) as Overdue,
(Select count(*) from Stage_LINC_Reporting where PatientUnenrolled = 0 and In_Denominator = 1) as Total_Eligible,
(Select Cast(Sum(Cast(In_Numerator as int)) as decimal(10,2)) from Stage_LINC_Reporting where LTCEnrolmentIndicator = 1 and PatientUnenrolled = 0 and In_Denominator = 1)
/(Select Cast(Sum(Cast(In_Denominator as int)) as decimal(10,2)) from Stage_LINC_Reporting where LTCEnrolmentIndicator = 1 and PatientUnenrolled = 0 and In_Denominator = 1) as Performance_Total,
(Select Cast(Sum(Cast(In_Numerator as int)) as decimal(10,2)) from Stage_LINC_Reporting where LTCEnrolmentIndicator = 1 and Ethnicity = 'NZ Maori' and PatientUnenrolled = 0 and In_Denominator = 1)
/(Select Cast(Sum(Cast(In_Denominator as int)) as decimal(10,2)) from Stage_LINC_Reporting where LTCEnrolmentIndicator = 1
 and Ethnicity = 'NZ Maori' and PatientUnenrolled = 0 and In_Denominator = 1) as Performance_Maori,
	0.90 as National_Target,
(Select Cast(Sum(Cast(In_Numerator as int)) as decimal(10,2)) from Stage_LINC_Reporting where LTCEnrolmentIndicator = 1 and PatientUnenrolled = 0 and In_Denominator = 1)
/(Select cast(Sum(Cast(In_Denominator as int))as decimal(10,2)) from Stage_LINC_Reporting where LTCEnrolmentIndicator = 1 and PatientUnenrolled = 0 and In_Denominator = 1) as RAPHS_Performance
;