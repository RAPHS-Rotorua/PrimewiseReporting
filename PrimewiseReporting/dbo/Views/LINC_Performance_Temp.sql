--test
--Select * from LINC_Performance_Temp

CREATE view [dbo].[LINC_Performance_Temp]  --drop view DAR_Performance_Temp
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
0.90 as National_Target,
Case when
cast((0.90 * Sum(d.In_Denominator)) as decimal(10,0)) - 
Sum(Cast(In_Numerator as int)) < 0 then 0
else
cast((0.90 * Sum(d.In_Denominator)) as decimal(10,0)) - 
Sum(Cast(In_Numerator as int))
End
as No_Required_To_Target,
--MAX(LastUpdated) as Last_Updated,
(Select Cast(Sum(Cast(In_Numerator as int)) as decimal(10,2)) from LINC_Reporting_TempTest where LTCEnrolmentIndicator = 1)
/(Select Cast(Sum(Cast(In_Denominator as int)) as decimal(10,2)) from LINC_Reporting_TempTest where LTCEnrolmentIndicator = 1) as RAPHS_Performance
from [dbo].LINC_Reporting_TempTest as d
where d.LTCEnrolmentIndicator = 1
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
(Select Sum(Cast(In_Numerator as int)) from [LINC_Reporting_TempTest] where LTCEnrolmentIndicator = 1) as LINC_Complete,
(Select Sum(case In_Numerator
	when 1 then 0
else 1
End) from LINC_Reporting_TempTest where LTCEnrolmentIndicator = 1) as Overdue,
(Select count(*) from LINC_Reporting_TempTest) as Total_Eligible,
(Select Cast(Sum(Cast(In_Numerator as int)) as decimal(10,2)) from LINC_Reporting_TempTest where LTCEnrolmentIndicator = 1)
/(Select Cast(Sum(Cast(In_Denominator as int)) as decimal(10,2)) from LINC_Reporting_TempTest where LTCEnrolmentIndicator = 1) as Performance_Total,
0.90 as National_Target,
Case when
cast((0.90 * (Select Sum(Cast(In_Denominator as int)) from LINC_Reporting_TempTest where LTCEnrolmentIndicator = 1)) as decimal(10,0)) - 
(Select Sum(Cast(In_Numerator as int)) from LINC_Reporting_TempTest where LTCEnrolmentIndicator = 1) < 0 then 0
else
cast((0.90 * (Select Sum(Cast(In_Denominator as int)) from LINC_Reporting_TempTest where LTCEnrolmentIndicator = 1)) as decimal(10,0)) - 
(Select Sum(Cast(In_Numerator as int)) from LINC_Reporting_TempTest where LTCEnrolmentIndicator = 1)
End
as No_Required_To_Target,
--(Select MAX(LastUpdated) from Stage_Smoking_Register) as Last_Updated,
(Select Cast(Sum(Cast(In_Numerator as int)) as decimal(10,2)) from LINC_Reporting_TempTest where LTCEnrolmentIndicator = 1)
/(Select cast(Sum(Cast(In_Denominator as int))as decimal(10,2)) from LINC_Reporting_TempTest where LTCEnrolmentIndicator = 1) as RAPHS_Performance
;