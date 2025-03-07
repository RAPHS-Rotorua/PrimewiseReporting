USE [PrimewiseReporting]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[rpt_IMMS_24MQ4SummaryRAPHS]
AS

	/*
	AUTHOR:						Justin Sherborne
	CREATE DATE:				17 Sep 2024											
	 		
	*/

	WITH RAPHS_Cohort AS
	(
		SELECT Cohort
			 , Ethnicity
			 , SUM(Denominator) AS 'Denominator'
			 , SUM(Numerator) AS Completed
			 , CAST(SUM(Numerator) AS DECIMAL(10, 2)) / CAST(SUM(Denominator) AS DECIMAL(10, 2)) AS performance
			 , 0.72 AS Target  --on 2025-3-3: JS altered to reflect new target (was 0.682 prior to this)
			 , CEILING((0.72 * CAST(SUM(Denominator) AS DECIMAL(10, 2))) - CAST(SUM(Numerator) AS DECIMAL(10, 2))) AS Gap --on 2025-3-3: JS altered to reflect new target (was 0.682 prior to this)
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
			WHERE SLM_Age_24_Months_Qtr4 = 1
		) AS z
		GROUP BY Cohort
			   , Ethnicity
	)
	SELECT *
	FROM RAPHS_Cohort;
GO



