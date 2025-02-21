CREATE Procedure [dbo].[Funding_PracticeTotal_2_Jan2022_Network] @Month tinyint, @FinancialYearID smallint
as
SET NOCOUNT ON	
/*
	Author:  Justin Sherborne
	Date: 11 Feb 2022
*/	


Select p.SurgeryName as 'Practice',
h.*, 1 as WholeGroup
FROM 
	FundingTotals_2_Jan2022 as h
	left join Practice as p on p.PracticeID = h.PracticeID
	where h.MonthNo = @Month and h.FinancialYearID = @FinancialYearID