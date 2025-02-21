--Exec rpt_IMMS_Childhood_ScheduledStatus '17';
CREATE Procedure [dbo].[rpt_IMMS_Childhood_ScheduledStatus] @PracticeIDs VARCHAR(MAX)
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

Select *
from IMMS_Childhood_DueStatus as s  
	JOIN @SelectedPracticeIDList as p on p.PracticeID = s.PracticeID