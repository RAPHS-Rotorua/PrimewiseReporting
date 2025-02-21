CREATE Procedure [dbo].[Temp_rpt_MondayOfWeek_ApptMeasure] @PracticeIDs VARCHAR(MAX)
as

/*
AUTHOR:						Justin Sherborne
CREATE DATE:				21 May 2018												
 		
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

SELECT DISTINCT 
d.MondayApptDate, convert(char(11),d.MondayApptDate, 106) as MondayDate_Label
FROM PrimewiseReporting.dbo.Temp_Appointment_Measurement_Report_Data as d
INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = d.PracticeID
order by d.MondayApptDate