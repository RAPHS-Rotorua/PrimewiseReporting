/*
AUTHOR:						Justin Sherborne
CREATE DATE:				16/6/2015
												
 		
*/
CREATE Procedure [dbo].[rpt_LincIntensityParameter] @PracticeIDs VARCHAR(MAX)
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

SELECT DISTINCT 
p.IntensityLevel, 
CASE p.IntensityLevel
	WHEN 'High' THEN 1 
	WHEN 'Moderate' THEN 2 
	WHEN 'Low' THEN 3 
		ELSE 4 
END AS IntensitySort
FROM         SharepointIntensityLevels AS p
INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = p.PracticeID 
ORDER BY IntensitySort