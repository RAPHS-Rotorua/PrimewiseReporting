USE [PrimewiseReporting]
GO

/****** Object:  StoredProcedure [dbo].[rpt_IMMS_8M_24M_Summary]    Script Date: 7/03/2025 11:34:01 am ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[rpt_IMMS_8M24MSummaryRAPHS]
as

/*
AUTHOR:						Justin Sherborne
CREATE DATE:				7 Mar 2025												
*/

SET ARITHABORT OFF;  --need this otherwise divide by zero fails report.  If this is off divide by zero defaults to null
SET ANSI_WARNINGS OFF; --Don't want any warnings displayed

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

SET ARITHABORT On;
SET ANSI_WARNINGS on;
GO


