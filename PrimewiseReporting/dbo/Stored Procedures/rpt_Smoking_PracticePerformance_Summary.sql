--Exec rpt_Smoking_PracticePerformance_Summary '17'
CREATE Procedure [dbo].[rpt_Smoking_PracticePerformance_Summary] @PracticeIDs VARCHAR(MAX)
as
SET NOCOUNT ON	

/*
	Author:  Justin Sherborne
	Date: 28 Mar 2017
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

Select p.SurgeryName as 'Practice', h.Performance, h.No_Required_To_Target,
h.Performance_Maori, h.No_Required_To_Target_Maori
FROM 
@AuthorisedPracticeIDList AS PID
		INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
	join  [dbo].[Smoking_Performance_vw] as h on PID.practiceID = h.PracticeID
	left join Practice as p on h.PracticeID = p.PracticeID