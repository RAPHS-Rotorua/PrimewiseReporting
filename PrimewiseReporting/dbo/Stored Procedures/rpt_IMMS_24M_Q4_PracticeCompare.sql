--Select * from IMMS_Childhood_Detail
--where SLM_Age_24_Months_Qtr4 = 1

CREATE Procedure [dbo].[rpt_IMMS_24M_Q4_PracticeCompare]
as

/*
AUTHOR:						Justin Sherborne
CREATE DATE:				14 Oct 2024											
 		
*/

With Practice_Cohort
as
(Select Practice, Ethnicity,Scheduled_Status, Scheduled_Status_Sort, Denominator, Completed, performance, Gap, Denominator -(completed + Gap) as Remaining
from
(
Select Practice, Ethnicity,Scheduled_Status, Scheduled_Status_Sort, Sum(Denominator) as 'Denominator', Sum(Numerator) as Completed,
cast(Sum(Numerator) as decimal(10,2))/cast(Sum(Denominator) as decimal(10,2)) as performance,
0.72 as Target, iif(ceiling((0.72 * cast(Sum(Denominator) as decimal(10,2))) - cast(Sum(Numerator) as decimal(10,2))) < 0,0,
	ceiling((0.72 * cast(Sum(Denominator) as decimal(10,2))) - cast(Sum(Numerator) as decimal(10,2)))) as Gap, 2 as orderby
from
(
Select 
distinct
i.PracticePrefix as 'Practice',NHI, iif(Ethnicity = 'NZ Maori', 'Maori','Non-Maori') as Ethnicity,iif(Schedule_Status_sort in(4,5),'Declined', Schedule_Status) as 'Scheduled_Status',
iif(Schedule_Status_sort in(4,5),4, Schedule_Status_sort) as 'Scheduled_Status_Sort',
1 as Denominator, isnull(Numerator_24_Months_Qtr4,0) as Numerator
from IMMS_Childhood_Detail as i  --Select * from practice
where SLM_Age_24_Months_Qtr4 = 1
) as z
Group by Practice, Ethnicity, Scheduled_Status, Scheduled_Status_Sort
) as y
)
Select * from Practice_Cohort
order by Practice, Ethnicity;