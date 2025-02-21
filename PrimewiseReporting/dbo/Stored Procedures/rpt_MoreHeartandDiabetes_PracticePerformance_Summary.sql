--Exec rpt_MoreHeartandDiabetes_PracticePerformance_Summary '17'
CREATE Procedure [dbo].[rpt_MoreHeartandDiabetes_PracticePerformance_Summary] @PracticeIDs VARCHAR(MAX)
as
SET NOCOUNT ON	

/*
	Author:  Justin Sherborne
	Date: 14 Nov 2016
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

Select p.SurgeryName as 'Practice', h.Performance, h.Performance_M_3544, h.No_Required_To_Target, h.No_Required_To_Target_M_3544
FROM 
@AuthorisedPracticeIDList AS PID
		INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
	join CVD_Performance_vw as h on PID.practiceID = h.PracticeID
	left join Practice as p on h.PracticeID = p.PracticeID