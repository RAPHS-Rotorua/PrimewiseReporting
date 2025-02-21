Create proc [dbo].[rpt_IMMS_Childhood_Detail_proc] @PracticeIDs VARCHAR(MAX), @ScheduleStatus varchar(100)
as

/*
AUTHOR:						Justin Sherborne
CREATE DATE:				8 Oct 2024											
 		
*/
--Declare @PracticeIDs Varchar(Max); --testing
--set @PracticeIDs = '17';
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

Select s.*
from IMMS_Childhood_Detail as s  
	JOIN @SelectedPracticeIDList as p on p.PracticeID = s.PracticeID
	where Immunisation_Schedule is not null and Schedule_Status = @ScheduleStatus