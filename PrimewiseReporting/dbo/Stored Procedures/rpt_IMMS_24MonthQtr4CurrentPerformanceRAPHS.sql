CREATE PROCEDURE [dbo].[rpt_IMMS_24MonthQtr4CurrentPerformanceRAPHS]
as

/*
AUTHOR:						Justin Sherborne
CREATE DATE:				7-3-2025										
 		
*/
with Patients
as
(
Select Cohort, PracticeID, NHI, Ethnicity , SLM_Age_24_Months_Qtr4, Numerator_24_Months_Qtr4, MonthNo, YearNo, ReportingDate, DateLabel
from IMMS_24MonthQtr4SummaryRAPHS
where cohort = 'RAPHS Network'
)
select ReportingDate,DateLabel, Cohort, Ethnicity, Sum(SLM_Age_24_Months_Qtr4) as Denominator, Sum(Numerator_24_Months_Qtr4) as Numerator,
Cast(Sum(Numerator_24_Months_Qtr4) as decimal(7,2))/Cast(Sum(SLM_Age_24_Months_Qtr4) as decimal(7,2)) as Performance, 0.72 as Target
from Patients
group by ReportingDate,DateLabel, Cohort, Ethnicity
union all 
select ReportingDate,DateLabel, Cohort, 'All Patients' as 'Ethnicity', Sum(SLM_Age_24_Months_Qtr4) as Denominator, Sum(Numerator_24_Months_Qtr4) as Numerator,
Cast(Sum(Numerator_24_Months_Qtr4) as decimal(7,2))/Cast(Sum(SLM_Age_24_Months_Qtr4) as decimal(7,2)) as Performance, 0.72 as Target
from Patients
group by ReportingDate,DateLabel, Cohort  