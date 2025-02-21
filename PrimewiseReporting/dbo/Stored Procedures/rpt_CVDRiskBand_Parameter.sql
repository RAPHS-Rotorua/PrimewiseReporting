/*
AUTHOR:						Justin Sherborne
CREATE DATE:				13/9/2015

--Test:  Exec rpt_CVDRiskBand_Parameter '17'										
 		
*/
Create Procedure [dbo].[rpt_CVDRiskBand_Parameter] @PracticeIDs VARCHAR(MAX)
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

SELECT DISTINCT CVDRisk_Bands, CVDRisk_Bands_Sort
FROM         Stage_CVDRA_Report as c
INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = c.PracticeID 
ORDER BY CVDRisk_Bands_Sort