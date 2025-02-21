--Test
--exec [rpt_POAC_ServiceDelivery] '15'

CREATE Procedure [dbo].[rpt_POAC_MonthlyServiceDelivery] @PracticeIDs VARCHAR(MAX), @Year int, @Month int
as
SET NOCOUNT ON	

/*
	Author:  Justin Sherborne
	Date: 15 aug 2016

*/	
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

	Select p.SurgeryName, s.* 
	FROM @AuthorisedPracticeIDList AS PID
	INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
	INNER JOIN POAC_ServiceDelivery s On s.PracticeID = PID.PracticeID
	INNER JOIN Practice AS P ON P.PracticeID = PID.PracticeID
	WHERE Month(ProcessedDate) = Month(DateAdd(month,1,Cast((Cast(@year as char(4)) + '-' + cast(@Month as char(2)) + '-1') as date)))
	and Year(ProcessedDate) = Year(DateAdd(month,1,Cast((Cast(@year as char(4)) + '-' + cast(@Month as char(2)) + '-1') as date)))