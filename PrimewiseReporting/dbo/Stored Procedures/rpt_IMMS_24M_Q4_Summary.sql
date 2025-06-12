CREATE PROCEDURE [dbo].[rpt_IMMS_24M_Q4_Summary]
	  @PracticeIDs VARCHAR(MAX)
AS

	/*
	AUTHOR:						Justin Sherborne
	CREATE DATE:				17 Sep 2024											
	 --JS added consumer_status = 'active' for RAPHS_Cohort only on 20250613 to align with SLM			
	*/

	DECLARE @AuthorisedPracticeIDList TABLE (
		  PracticeID INT
	)
	INSERT INTO @AuthorisedPracticeIDList (PracticeID)
	EXEC [dbo].[Report_GetAuthorisedPracticeIDs];


	--- Get the selected ID's
	DECLARE @SelectedPracticeIDList TABLE (
		  PracticeID INT
	)
	INSERT INTO @SelectedPracticeIDList (PracticeID)
	SELECT NUMBER
	FROM PrimeWiseReporting.[dbo].[fn_SplitInt](@PracticeIDs, ',');

	WITH RAPHS_Cohort AS
	(
		SELECT Cohort
			 , Ethnicity
			 , SUM(Denominator) AS 'Denominator'
			 , SUM(Numerator) AS Completed
			 , CAST(SUM(Numerator) AS DECIMAL(10, 2)) / CAST(SUM(Denominator) AS DECIMAL(10, 2)) AS performance
			 , 0.72 AS Target  --on 2025-3-3: JS altered to reflect new target (was 0.682 prior to this)
			 , (Select CEILING((0.72 * CAST(SUM(SLM_Age_24_Months_Qtr4) AS DECIMAL(10, 2))) - CAST(SUM(Numerator_24_Months_Qtr4) AS DECIMAL(10, 2)))
			 from (Select distinct NHI, SLM_Age_24_Months_Qtr4, Numerator_24_Months_Qtr4 from IMMS_Childhood_Detail 
			 where SLM_Age_24_Months_Qtr4 = 1 and consumer_status = 'active') as z) AS Gap --on 2025-3-3: JS altered to reflect new target (was 0.682 prior to this)
			 , 1 AS orderby
		FROM (
			SELECT
			DISTINCT PracticeID
				   , 'RAPHS Network' AS Cohort
				   , NHI
				   , IIF(Ethnicity = 'NZ Maori', 'Maori', 'Non-Maori') AS 'Ethnicity'
				   , 1 AS Denominator
				   , Numerator_24_Months_Qtr4 AS Numerator
			FROM IMMS_Childhood_Detail  --Select * from IMMS_Childhood_Detail
			WHERE SLM_Age_24_Months_Qtr4 = 1 and consumer_status = 'active' --JS added 20250613 to align with SLM
		) AS z
		GROUP BY Cohort
			   , Ethnicity
	),
	Practice_Cohort AS
	(
		SELECT Cohort
			 , Ethnicity
			 , SUM(Denominator) AS 'Denominator'
			 , SUM(Numerator) AS Completed
			 , CAST(SUM(Numerator) AS DECIMAL(10, 2)) / CAST(SUM(Denominator) AS DECIMAL(10, 2)) AS performance
			 , 0.72 AS Target --on 2025-3-3: JS altered to reflect new target (was 0.682 prior to this)
			 , CEILING((0.72 * CAST(SUM(Denominator) AS DECIMAL(10, 2))) - CAST(SUM(Numerator) AS DECIMAL(10, 2))) AS Gap --on 2025-3-3: JS altered to reflect new target (was 0.682 prior to this)
			 , 2 AS orderby
		FROM (
			SELECT
			DISTINCT Practice AS Cohort
				   , NHI
				   , IIF(Ethnicity = 'NZ Maori', 'Maori', 'Non-Maori') AS Ethnicity
				   , 1 AS Denominator
				   , Numerator_24_Months_Qtr4 AS Numerator
			FROM IMMS_Childhood_Detail AS i
				JOIN @SelectedPracticeIDList AS p ON p.PracticeID = i.PracticeID
			WHERE SLM_Age_24_Months_Qtr4 = 1 --Wont filter consumer_status = active for practices
		) AS z
		GROUP BY Cohort
			   , Ethnicity
	)
	SELECT *
	FROM RAPHS_Cohort
	UNION ALL
	SELECT *
	FROM Practice_Cohort;