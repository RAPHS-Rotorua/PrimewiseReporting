USE [PrimewiseReporting]
GO

/****** Object:  StoredProcedure [dbo].[rpt_IMMS_24M_Q4_Equity_Practice]    Script Date: 7/03/2025 11:52:13 am ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[rpt_IMMS_24MQ4EquityRAPHS]
as

/*
AUTHOR:						Justin Sherborne
CREATE DATE:				7 Mar 2025										
 		
*/
SET ARITHABORT OFF;  --need this otherwise divide by zero fails report.  If this is off divide by zero defaults to null
SET ANSI_WARNINGS OFF; --Don't want any warnings displayed

Select  'RAPHS Network' as Cohort,
Cast((Select cast(Sum(Numerator) as decimal(10,2))/cast(Sum(Denominator) as decimal(10,2))
from (Select 
distinct
i.PracticeID, NHI,--iif(Ethnicity = 'NZ Maori', 'Māori','Non-Māori') as 'Ethnicity',
SLM_Age_24_Months_Qtr4 as Denominator, Numerator_24_Months_Qtr4 as Numerator
from IMMS_Childhood_Detail as i
where SLM_Age_24_Months_Qtr4 = 1 and (Ethnicity <> 'NZ Maori' or Ethnicity is null)) as z2)/
(Select cast(Sum(Numerator) as decimal(10,2))/cast(Sum(denominator) as decimal(10,2))
from (Select 
distinct
i.PracticeID, NHI,--iif(Ethnicity = 'NZ Maori', 'Māori','Non-Māori') as 'Ethnicity',
SLM_Age_24_Months_Qtr4 as Denominator, Numerator_24_Months_Qtr4 as Numerator
from IMMS_Childhood_Detail as i
where SLM_Age_24_Months_Qtr4 = 1 and Ethnicity = 'NZ Maori') as z1) as decimal(5,2)) as Equity

SET ARITHABORT ON;
SET ANSI_WARNINGS ON;

GO


