CREATE Procedure [dbo].[rpt_IMMS_24M_Q4_Summary] @PracticeIDs VARCHAR(MAX)
as

/*
AUTHOR:						Justin Sherborne
CREATE DATE:				17 Sep 2024											
 		
*/

DECLARE @AuthorisedPracticeIDList TABLE
		(
		PracticeID INT
		)		
	INSERT INTO	@AuthorisedPracticeIDList(PracticeID)
	EXEC [dbo].[Report_GetAuthorisedPracticeIDs];

	
	--- Get the selected ID's
	DECLARE @SelectedPracticeIDList TABLE
		(
		PracticeID INT
		)		
	INSERT INTO	@SelectedPracticeIDList(PracticeID)
	SELECT NUMBER FROM PrimeWiseReporting.[dbo].[fn_SplitInt] (@PracticeIDs, ',');

With RAPHS_Cohort
as
(
Select Cohort, Ethnicity,Sum(Denominator) as 'Denominator', Sum(Numerator) as Completed,
cast(Sum(Numerator) as decimal(10,2))/cast(Sum(Denominator) as decimal(10,2)) as performance,
0.682 as Target, ceiling((0.682 * cast(Sum(Denominator) as decimal(10,2))) - cast(Sum(Numerator) as decimal(10,2))) as Gap, 1 as orderby
from
(Select 
distinct
PracticeID, 'RAPHS Network' as Cohort, NHI,iif(Ethnicity = 'NZ Maori', 'Maori','Non-Maori') as 'Ethnicity',
1 as Denominator, Numerator_24_Months_Qtr4 as Numerator
from IMMS_Childhood_Detail  --Select * from IMMS_Childhood_Detail
where SLM_Age_24_Months_Qtr4 = 1) as z
group by Cohort, Ethnicity
)
,
Practice_Cohort
as
(
Select Cohort, Ethnicity,Sum(Denominator) as 'Denominator', Sum(Numerator) as Completed,
cast(Sum(Numerator) as decimal(10,2))/cast(Sum(Denominator) as decimal(10,2)) as performance,
0.682 as Target, ceiling((0.682 * cast(Sum(Denominator) as decimal(10,2))) - cast(Sum(Numerator) as decimal(10,2))) as Gap, 2 as orderby
from
(
Select 
distinct
Practice as Cohort,NHI, iif(Ethnicity = 'NZ Maori', 'Maori','Non-Maori') as Ethnicity,
1 as Denominator, Numerator_24_Months_Qtr4 as Numerator
from IMMS_Childhood_Detail as i
JOIN @SelectedPracticeIDList as p on p.PracticeID = i.PracticeID
where SLM_Age_24_Months_Qtr4 = 1
) as z
Group by Cohort, Ethnicity
)
Select * from RAPHS_Cohort
union all
Select * from Practice_Cohort;