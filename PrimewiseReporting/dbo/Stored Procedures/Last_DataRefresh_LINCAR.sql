Create proc [dbo].[Last_DataRefresh_LINCAR] @PracticeIDs varchar(max)  --drop proc exec Last_DataRefresh
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

Select max(h.Last_Completed) as Last_Data_Refresh
from @AuthorisedPracticeIDList AS PID
		INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
	join Stage_LINC_Reporting as h on PID.practiceID = h.PracticeID
	where h.PatientUnenrolled = 0 and h.In_Denominator = 1;