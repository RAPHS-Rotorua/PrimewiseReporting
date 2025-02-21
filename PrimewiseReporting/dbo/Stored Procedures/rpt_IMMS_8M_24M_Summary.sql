CREATE Procedure [dbo].[rpt_IMMS_8M_24M_Summary] @PracticeIDs VARCHAR(MAX)
as

/*
AUTHOR:						Justin Sherborne
CREATE DATE:				23 Sep 2024												
*/
--Declare @PracticeIDs Varchar(Max); --testing
--set @PracticeIDs = '17'
SET ARITHABORT OFF;  --need this otherwise divide by zero fails report.  If this is off divide by zero defaults to null
SET ANSI_WARNINGS OFF; --Don't want any warnings displayed

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

with Patients
as
(
Select distinct PracticeID, Practice, NHI,Ethnicity, Child_Age, Milestone_Age_8_Months, Numerator_8_Months, Milestone_Age_24_Months, Numerator_24_Months
from IMMS_Childhood_Detail
)
,
Equity 
as
(
Select distinct PracticeID, NHI,Ethnicity, Child_Age, Milestone_Age_8_Months, Numerator_8_Months, Milestone_Age_24_Months, Numerator_24_Months
from IMMS_Childhood_Detail
)
Select 'RAPHS' as Cohort, '8-Month' as Milestone_Age, iif(Ethnicity = 'NZ Maori','Maori','Non-Maori') as 'Ethnicity',
Sum(Milestone_Age_8_Months) as Denominator, Sum(Numerator_8_Months) as Numerator, Cast(Sum(Numerator_8_Months) as decimal(5,2))/Cast(Sum(Milestone_Age_8_Months) as decimal(5,2)) as Performance,
(Select (Select Cast(Sum(Numerator_8_Months) as decimal(5,2))/Cast(Sum(Milestone_Age_8_Months) as decimal(5,2)) from Equity where (Ethnicity <> 'NZ Maori' or Ethnicity is null))/
(Select Cast(Sum(Numerator_8_Months) as decimal(5,2))/Cast(Sum(Milestone_Age_8_Months) as decimal(5,2)) from Equity where Ethnicity = 'NZ Maori')) as Equity_Ratio
from Patients
group by iif(Ethnicity = 'NZ Maori','Maori','Non-Maori')
union all
Select 'RAPHS' as Cohort, '24-Month' as Milestone_Age, iif(Ethnicity = 'NZ Maori','Maori','Non-Maori') as 'Ethnicity',
Sum(Milestone_Age_24_Months) as Denominator_24_Months, Sum(Numerator_24_Months) as Numerator_24_Months,  Cast(Sum(Numerator_24_Months) as decimal(5,2))/Cast(Sum(Milestone_Age_24_Months) as decimal(5,2)),
(Select (Select Cast(Sum(Numerator_24_Months) as decimal(5,2))/Cast(Sum(Milestone_Age_24_Months) as decimal(5,2)) from Equity where (Ethnicity <> 'NZ Maori' or Ethnicity is null))/
(Select Cast(Sum(Numerator_24_Months) as decimal(5,2))/Cast(Sum(Milestone_Age_24_Months) as decimal(5,2)) from Equity where Ethnicity = 'NZ Maori')) as Equity_Ratio
from Patients
group by iif(Ethnicity = 'NZ Maori','Maori','Non-Maori')
union all
Select Practice as Cohort, '8-Month' as Milestone_Age, iif(Ethnicity = 'NZ Maori','Maori','Non-Maori') as 'Ethnicity',
Sum(Milestone_Age_8_Months) as Denominator, Sum(Numerator_8_Months) as Numerator,  Cast(Sum(Numerator_8_Months) as decimal(5,2))/Cast(Sum(Milestone_Age_8_Months) as decimal(5,2)),
(Select (Select Cast(Sum(Numerator_8_Months) as decimal(5,2))/Cast(Sum(Milestone_Age_8_Months) as decimal(5,2)) 
	from Equity as e
	JOIN @SelectedPracticeIDList as p1 on p1.PracticeID = e.PracticeID
 where (Ethnicity <> 'NZ Maori' or Ethnicity is null))/
(Select Cast(Sum(Numerator_8_Months) as decimal(5,2))/Cast(Sum(Milestone_Age_8_Months) as decimal(5,2)) 
from Equity as e
	JOIN @SelectedPracticeIDList as p2 on p2.PracticeID = e.PracticeID where Ethnicity = 'NZ Maori')) as Equity_Ratio
from Patients as p
	JOIN @SelectedPracticeIDList as p3 on p3.PracticeID = p.PracticeID
group by Practice, iif(Ethnicity = 'NZ Maori','Maori','Non-Maori')
union all
Select Practice as Cohort, '24-Month' as Milestone_Age, iif(Ethnicity = 'NZ Maori','Maori','Non-Maori') as 'Ethnicity',
Sum(Milestone_Age_24_Months) as Denominator_24_Months, Sum(Numerator_24_Months) as Numerator_24_Months,  Cast(Sum(Numerator_24_Months) as decimal(5,2))/Cast(Sum(Milestone_Age_24_Months) as decimal(5,2)),
(Select (Select Cast(Sum(Numerator_24_Months) as decimal(5,2))/Cast(Sum(Milestone_Age_24_Months) as decimal(5,2)) 
	from Equity as e
	JOIN @SelectedPracticeIDList as p4 on p4.PracticeID = e.PracticeID
 where (Ethnicity <> 'NZ Maori' or Ethnicity is null))/
(Select Cast(Sum(Numerator_24_Months) as decimal(5,2))/Cast(Sum(Milestone_Age_24_Months) as decimal(5,2)) 
from Equity as e
	JOIN @SelectedPracticeIDList as p5 on p5.PracticeID = e.PracticeID where Ethnicity = 'NZ Maori')) as Equity_Ratio
from Patients as p6
	JOIN @SelectedPracticeIDList as p7 on p7.PracticeID = p6.PracticeID
group by Practice, iif(Ethnicity = 'NZ Maori','Maori','Non-Maori')

SET ARITHABORT On;
SET ANSI_WARNINGS on;