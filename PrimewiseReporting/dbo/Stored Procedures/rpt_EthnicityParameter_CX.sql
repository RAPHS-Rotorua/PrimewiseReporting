/*
AUTHOR:						Justin Sherborne
CREATE DATE:				26/2/2019
												
 		
*/
--rpt_EthnicityParameter_CX '30'

CREATE Procedure [dbo].[rpt_EthnicityParameter_CX] @PracticeIDs VARCHAR(MAX)
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
                      ISNULL(Ethnicity, 'Not Stated') AS 'Ethnicity', 
                      CASE Ethnicity WHEN 'NZ Maori' THEN 1 WHEN 'NZ European/Pakeha' THEN 2 WHEN 'Other European' THEN 3 WHEN 'European (not further defined)' THEN
                       4 WHEN 'Cook Island Maori' THEN 5 WHEN 'Other Pacific' THEN 6 WHEN 'Pacific Island (not further defined)' THEN 7 WHEN 'Samoan' THEN 8 WHEN 'Tokelauan' THEN
                       9 WHEN 'Tongan' THEN 10 WHEN 'Niuean' THEN 11 WHEN 'Fijian' THEN 12 WHEN 'Indian' THEN 13 WHEN 'Asian (not further defined)' THEN 14 WHEN 'Other Asian'
                       THEN 15 WHEN 'Chinese' THEN 16 WHEN 'Southeast Asian' THEN 17 WHEN 'Latin American / Hispanic' THEN 18 WHEN 'Middle Eastern' THEN 19 WHEN 'African' THEN
                       20 ELSE 21 END AS Sort_Order
FROM         Stage_CX_Reporting AS p
INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = p.PracticeID 
where p.PatientUnenrolled = 0
ORDER BY Sort_Order