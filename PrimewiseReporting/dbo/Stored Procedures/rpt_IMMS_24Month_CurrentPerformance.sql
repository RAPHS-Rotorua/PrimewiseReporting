Create proc [dbo].[rpt_IMMS_24Month_CurrentPerformance] @PracticeIDs VARCHAR(MAX)
as

/*
AUTHOR:						Justin Sherborne
CREATE DATE:				24 Sep 2024											
 		
*/
--Declare @PracticeIDs Varchar(Max); --testing
--set @PracticeIDs = '17';

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
Select Cohort, PracticeID, NHI, Ethnicity , Milestone_Age_24_Months, Numerator_24_Months, MonthNo, YearNo, ReportingDate, DateLabel
from IMMS_24Month_Summary
where cohort = 'RAPHS Network'
union all
Select Cohort, r.PracticeID, NHI, Ethnicity , Milestone_Age_24_Months, Numerator_24_Months, MonthNo, YearNo, ReportingDate, DateLabel
from IMMS_24Month_Summary as r
join @SelectedPracticeIDList as p on p.PracticeID = r.PracticeID
where Milestone_Age_24_Months = 1
)
select ReportingDate,DateLabel, Cohort, Ethnicity, Sum(Milestone_Age_24_Months) as Denominator, Sum(Numerator_24_Months) as Numerator,
Cast(Sum(Numerator_24_Months) as decimal(7,2))/Cast(Sum(Milestone_Age_24_Months) as decimal(7,2)) as Performance, 0.72 as Target
from Patients
group by ReportingDate,DateLabel, Cohort, Ethnicity