/*
AUTHOR:						Noel Gourdie (Montage)
CREATE DATE:				16/6/2013
												
 		
*/

CREATE PROCEDURE [dbo].[Report_DiseaseBurden_Incentive]

	@PracticeIDs VARCHAR(MAX)
	
AS
BEGIN
	SET NOCOUNT ON	
	
	-- find the authorised Practicec IDs
	DECLARE @AuthorisedPracticeIDList TABLE
		(
		PracticeID INT
		)		
	INSERT INTO	@AuthorisedPracticeIDList(PracticeID)
	EXEC [dbo].[Report_GetAuthorisedPracticeIDs]




	--- Get the selected ID's
	DECLARE @SelectedPracticeIDList TABLE
		(
		PracticeID INT
		)		
	INSERT INTO	@SelectedPracticeIDList(PracticeID)
	SELECT NUMBER FROM PrimeWiseReporting.[dbo].[fn_SplitInt] (@PracticeIDs, ',')


	--- Get the FiscalYear and Quarter Key
	DECLARE @FiscalYearKey INT  
			,@FiscalQuarterKey INT  

	
	SET @FiscalYearKey = (SELECT MAX(FiscalYearKey) FROM dbo.ReportingRaphsSummary)
	SET @FiscalQuarterKey = (SELECT MAX(FiscalQuarterKey) FROM dbo.ReportingRaphsSummary WHERE FiscalYearKey  = @FiscalYearKey)


	
	--- Incentive report data
	SELECT 
		'P' +  RIGHT('00' + CAST(BB.PracticeID AS VARCHAR(2)), 2) AS Practice
		,P.SurgeryName
		,CASE WHEN BB.ParticipatingPracticeIndicator = 1 THEN 'True' Else 'False' END AS RAPHS
		,BB.AgeBand
		,BB.NeedsIndicator
		,BB.CapitatedPatientCount Patients
		,BB.DALYRate
		,BB.GrossDALYValue  AS DALYRAPHS
		,CASE WHEN ISNULL(SD.GrossDALYValue, 0) <> 0 THEN ISNULL(BB.GrossDALYValue, 0) / SD.GrossDALYValue ELSE 0 END AS PercentOfRAPHS
		,CASE WHEN ISNULL(SD.GrossDALYValue, 0) <> 0 THEN ISNULL(BB.GrossDALYValue, 0) / SD.GrossDALYValue ELSE 0 END  * SD.QuarterlyLINCIncentivePool AS QuarterlyPayment
		,(CASE WHEN ISNULL(SD.GrossDALYValue, 0) <> 0 THEN ISNULL(BB.GrossDALYValue, 0) / SD.GrossDALYValue ELSE 0 END  * SD.QuarterlyLINCIncentivePool) / 3.0 AS MonthlyPayment
		,SD.CapitatedPatientCount 
		,SD.QuarterlyDiabeticPatientCount AS DiabeticPatientCount
		,SD.LTCPatientCount
		,SD.GrossDALYValue
		,SD.QuaterlyLINCFundingPool
		,SD.QuaterlyDiabetesFundingPool
		,'Incentive' as PaymentType
	FROM @AuthorisedPracticeIDList AS PID
	INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
	INNER JOIN Practice AS P ON P.PracticeID = PID.PracticeID
	INNER JOIN dbo.ReportingDiseaseBurdenBand AS BB ON BB.PracticeID = PID.PracticeId
	CROSS JOIN dbo.ReportingRaphsSummary AS SD
	WHERE BB.FiscalYearKey = @FiscalYearKey
	AND BB.FiscalQuarterKey = @FiscalQuarterKey
	AND SD.FiscalYearKey = @FiscalYearKey
	AND SD.FiscalQuarterKey = @FiscalQuarterKey


END