CREATE Procedure [dbo].[FundingStream_Totals] @PracticeIDs VARCHAR(MAX), @Month tinyint, @Year smallint
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

Select p.SurgeryName as 'Practice',
h.PracticeID,FundStream, YearNo, MonthNo, 
Sum(PracticeMaxGrandTotal) as FundAvailable,
Sum(PracticeEarnedBase) as FlexibleFundingEarned,
sum(PracticeEarnedIncentive) as IncentiveFundingEarned,
Sum(PracticeUnearnedTotal) as UnearnedFunds
FROM 
@AuthorisedPracticeIDList AS PID
		INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
	join FundingPayments_Test as h on h.practiceID = PID.PracticeID
	left join Practice as p on p.PracticeID = h.PracticeID
	where h.MonthNo = @Month and h.YearNo = h.YearNo
	group by p.SurgeryName, h.PracticeID, h.FundStream, h.YearNo, h.MonthNo
 order by h.FundStream