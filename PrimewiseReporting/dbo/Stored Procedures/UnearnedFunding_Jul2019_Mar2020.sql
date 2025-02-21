CREATE Procedure [dbo].[UnearnedFunding_Jul2019_Mar2020] @PracticeIDs VARCHAR(MAX)
as
SET NOCOUNT ON	
/*
	Author:  Justin Sherborne
	Date: 31_May_2019
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

 Select p.PracticeID,YearNo, MonthNo, FundingAllocationGroup as MeasureGroup,p.FundingAllocationID, Allocation as Measure, 
 Sum(PracticeMaxGrandTotal) as TotalAvailableFunding,
 Sum(PracticeEarnedBase + PracticeEarnedIncentive) as TotalFundingEarned,Sum(PracticeUnearnedTotal) as MonthlyUnearnedTotal
 from 
  @AuthorisedPracticeIDList AS PID
		INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
 join FundingPayment as p on p.PracticeID = PID.PracticeID
 where ((YearNo = 2019 and MonthNo in(7,8,9,10,11,12)) or (YearNo = 2020 and Monthno in(1,2,3)))
 group by p.PracticeID, YearNo, MonthNo, FundingAllocationGroup,p.FundingAllocationID, Allocation
 order by MeasureGroup, FundingAllocationID