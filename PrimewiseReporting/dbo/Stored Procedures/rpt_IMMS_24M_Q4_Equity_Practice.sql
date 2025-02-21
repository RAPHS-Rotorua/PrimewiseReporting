CREATE Procedure [dbo].[rpt_IMMS_24M_Q4_Equity_Practice] @PracticeIDs VARCHAR(MAX)
as

/*
AUTHOR:						Justin Sherborne
CREATE DATE:				18 Sep 2024											
 		
*/
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

Select  
Cast((Select cast(Sum(Numerator) as decimal(10,2))/cast(Sum(Denominator) as decimal(10,2))
from (Select 
distinct
i.PracticeID, NHI,--iif(Ethnicity = 'NZ Maori', 'Maori','Non-Maori') as 'Ethnicity',
SLM_Age_24_Months_Qtr4 as Denominator, Numerator_24_Months_Qtr4 as Numerator
from IMMS_Childhood_Detail as i
JOIN @SelectedPracticeIDList as p on p.PracticeID = i.PracticeID
where SLM_Age_24_Months_Qtr4 = 1 and (Ethnicity <> 'NZ Maori' or Ethnicity is null)) as z2)/
(Select cast(Sum(Numerator) as decimal(10,2))/cast(Sum(denominator) as decimal(10,2))
from (Select 
distinct
i.PracticeID, NHI,--iif(Ethnicity = 'NZ Maori', 'Maori','Non-Maori') as 'Ethnicity',
SLM_Age_24_Months_Qtr4 as Denominator, Numerator_24_Months_Qtr4 as Numerator
from IMMS_Childhood_Detail as i
JOIN @SelectedPracticeIDList as p on p.PracticeID = i.PracticeID
where SLM_Age_24_Months_Qtr4 = 1 and Ethnicity = 'NZ Maori') as z1) as decimal(5,2)) as Equity

SET ARITHABORT ON;
SET ANSI_WARNINGS ON;