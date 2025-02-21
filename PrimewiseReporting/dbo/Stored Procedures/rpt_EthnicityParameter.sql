/*
AUTHOR:						Justin Sherborne
CREATE DATE:				16/6/2015
												
 		
*/
Create Procedure [dbo].[rpt_EthnicityParameter] @PracticeIDs VARCHAR(MAX)
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
isNull(p.Ethnicity1Description,'Not Stated') as 'Ethnicity1Description', 
CASE Ethnicity1Description 
	WHEN 'NZ Maori' THEN 1 
	WHEN 'NZ European' THEN 2 
	WHEN 'European not further defined' THEN 3 
	WHEN 'Other European' THEN 4 
	WHEN 'Cook Island Maori' THEN 5 
	WHEN 'Other Pacific Island' THEN 6 
	WHEN 'Pacific Island not further defined' THEN 7 
	WHEN 'Samoan' THEN 8 
	WHEN 'Tokelauan' THEN 9
	WHEN 'Tongan' THEN 10 
	WHEN 'Niuean' THEN 11 
	WHEN 'Fijian' THEN 12 
	WHEN 'Indian' THEN 13 
	WHEN 'Asian not further defined' THEN 14 
	WHEN 'Other Asian' THEN 15 
	WHEN 'Chinese' THEN 16 
	WHEN 'Southeast Asian' THEN 17 
	WHEN 'Latin American / Hispanic' THEN 18 
	WHEN 'Middle Eastern' THEN 19 
	WHEN 'African' THEN 20
	WHEN 'Not stated' THEN 21 
		ELSE 22 
END AS Sort_Order
FROM         Patient AS p
INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = p.PracticeID 
INNER JOIN ReportingPatientByPractice AS r ON p.PatientID = r.PatientID
where p.EnrolledInPMS = 'Enrolled' 
ORDER BY Sort_Order