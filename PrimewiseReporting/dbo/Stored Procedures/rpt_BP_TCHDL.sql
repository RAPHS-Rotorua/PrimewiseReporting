CREATE Proc [dbo].[rpt_BP_TCHDL] @PracticeIDs VARCHAR(MAX), @NHI varchar(50)
as
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
	
Select bp.NHI, bp.Code, bp.Result, bp.DateRecorded
from
@AuthorisedPracticeIDList AS PID
		INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
 join 
 Patient as p on PID.PracticeID = p.PracticeID
 join Stage_BP_TCHDL as bp on p.PracticeID = bp.PracticeID and p.NHI = bp.NHI
 where bp.NHI = @NHI