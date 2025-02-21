Create proc [dbo].[rpt_BCTI] @PracticeIDs VARCHAR(MAX)
as
/*
	Author:  Justin Sherborne
	Date: 15 Nov 2017

*/	
SET NOCOUNT ON;

	-- find the authorised Practicec IDs
	DECLARE @AuthorisedPracticeIDList TABLE
		(
		PracticeID INT
		)		
	INSERT INTO	@AuthorisedPracticeIDList(PracticeID)
	EXEC [dbo].[Report_GetAuthorisedPracticeIDs]

	--- Get the selected ID's
	DECLARE @SelectedPracticeIDList TABLE
		(
		PracticeID INT
		)		
	INSERT INTO	@SelectedPracticeIDList(PracticeID)
	SELECT NUMBER FROM PrimeWiseReporting.[dbo].[fn_SplitInt] (@PracticeIDs, ',')

	--select * from @AuthorisedPracticeIDList

Select b.Month_No, b.Month_Name, b.Financial_Year,b.PracticeID, b.Payee, b.Practice, b.Address2, b.Address3, b.ird_no, b.EndOfMonth,
	b.MeasureCodeGrouping,
Case 
	when b.MeasureCodeGrouping = 'RAPHS Clinical Services (POAC)' then 'RAPHS Clinical Services (POAC)'
	else
		b.MeasureFriendlyDescription
End as Measure,
b.MeasureOrderBy,
Sum(b.PaymentTotal_GSTExcl) as 'PaymentTotal_GSTExcl'
from 
	@AuthorisedPracticeIDList AS PID
	INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
	join Stage_BCTI_Report as b on b.PracticeID = SL.PracticeID
	where EndOfMonth > '2017-10-1'  --Don't have all the POAC data for dates before this - in this table
	group by b.Month_No, b.Month_Name, b.Financial_Year,b.PracticeID, b.Payee, b.Practice, b.Address2, b.Address3, b.ird_no, b.EndOfMonth,
	b.MeasureCodeGrouping,
Case 
	when b.MeasureCodeGrouping = 'RAPHS Clinical Services (POAC)' then 'RAPHS Clinical Services (POAC)'
	else
		b.MeasureFriendlyDescription
End,
b.MeasureOrderBy
order by b.MeasureOrderBy