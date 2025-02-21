﻿CREATE Procedure [dbo].[Temp_rpt_EthnicityParameter_ApptMeasure] @PracticeIDs VARCHAR(MAX)
as

/*
AUTHOR:						Justin Sherborne
CREATE DATE:				8 Feb 2018												
 		
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
iif(d.Ethnicity='NZ European/Pakeha','NZ European',iif(d.Ethnicity = 'European (not further defined)','European',d.Ethnicity)) as 'Ethnicity'
,
Case ethnicity
	when 'NZ Maori' then 1
	when 'NZ European/Pakeha' then 2
	when 'Samoan' then 3
	when 'Fijian' then 4
	when 'Tongan' then 5
	when 'Cook Island Maori' then 6
	when 'Other Pacific Island' then 7
	When 'Indian' then 8
	else 9	
End as Eth_Sort
FROM Testing_DB.dbo.Temp_Appointment_Measurement_Report_Data as d
INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = d.PracticeID
order by Eth_Sort