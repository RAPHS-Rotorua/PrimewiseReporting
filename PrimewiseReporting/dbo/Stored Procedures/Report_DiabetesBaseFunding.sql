CREATE PROCEDURE [dbo].[Report_DiabetesBaseFunding]

	@PracticeIDs VARCHAR(MAX)
	
AS
BEGIN
	SET NOCOUNT ON	
	
	---DECLARE @PracticeIDs VARCHAR(MAX) = '3,4'
	
	
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
			,@CalendarDateKey INT
	
	SET @FiscalYearKey = (SELECT MAX(FiscalYearKey) FROM dbo.ReportingRaphsSummary)
	SET @FiscalQuarterKey = (SELECT MAX(FiscalQuarterKey) FROM dbo.ReportingRaphsSummary WHERE FiscalYearKey  = @FiscalYearKey)

	SET @CalendarDateKey = (SELECT MAX(DateKey) 
							FROM dbo.Calendar AS C
							INNER JOIN dbo.ReportingPracticeByContract AS PBC ON PBC.CalendarDateKey = c.DateKey
							WHERE FiscalQuarter = @FiscalQuarterKey AND FiscalYear = CAST(@FiscalYearKey AS VARCHAR(4)))


SELECT --PBC.PracticeId
		'P' +  RIGHT('00' + CAST(PBC.PracticeID AS VARCHAR(2)), 2) AS PracticeId
		,P.SurgeryName
		,PBC.QuaterlyDiabeticPatientCount 
		,CASE WHEN ISNULL(SD.QuarterlyDiabeticPatientCount, 0) = 0 THEN 0 ELSE CAST(ISNULL(PBC.QuaterlyDiabeticPatientCount, 0) AS NUMERIC(18,2))/SD.QuarterlyDiabeticPatientCount END AS DiabeticPercentSplit
		,CASE WHEN ISNULL(SD.QuarterlyDiabeticPatientCount, 0) = 0 THEN 0 ELSE CAST(ISNULL(PBC.QuaterlyDiabeticPatientCount, 0) AS NUMERIC(18,2))/SD.QuarterlyDiabeticPatientCount END 
			* SD.QuaterlyDiabetesFundingPool  AS QuarterlyAllocation
		
		,CASE WHEN ISNULL(SD.QuarterlyDiabeticPatientCount, 0) = 0 THEN 0 ELSE CAST(ISNULL(PBC.QuaterlyDiabeticPatientCount, 0) AS NUMERIC(18,2))/SD.QuarterlyDiabeticPatientCount END 
			* SD.QuaterlyDiabetesFundingPool /3 AS MonthlyAllocation
		,SD.CapitatedPatientCount 
		,SD.QuarterlyDiabeticPatientCount AS TotalDiabeticPatientCount
		,SD.LTCPatientCount
		,SD.GrossDALYValue
		,SD.QuaterlyLINCFundingPool
		,SD.QuaterlyDiabetesFundingPool
		,'Base' as PaymentType
		,@FiscalQuarterKey as FiscalQuarterKey
		,@FiscalYearKey as FiscalYearKey
		--,SD.QuarterlyLINCIncentivePool		
		--,SD.QuarterlyDIABIncentivePool
		--,SD.QuarterlyAdminSalaryPool
	FROM @AuthorisedPracticeIDList AS PID
	INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
	INNER JOIN Practice AS P ON P.PracticeID = PID.PracticeID
	INNER JOIN dbo.ReportingPracticeByContract AS PBC ON PBC.PracticeID = PID.PracticeId
	CROSS JOIN dbo.ReportingRaphsSummary AS SD
	WHERE PBC.CalendarDateKey = @CalendarDateKey
	AND SD.FiscalYearKey = @FiscalYearKey
	AND SD.FiscalQuarterKey = @FiscalQuarterKey
	AND ContractCode = 'DIAB'

UNION


	SELECT --PBC.PracticeId
		'P' +  RIGHT('00' + CAST(PBC.PracticeID AS VARCHAR(2)), 2) AS PracticeId
		,P.SurgeryName
		,PBC.QuaterlyDiabeticPatientCount 
		,CASE WHEN ISNULL(SD.QuarterlyDiabeticPatientCount, 0) = 0 THEN 0 ELSE CAST(ISNULL(PBC.QuaterlyDiabeticPatientCount, 0) AS NUMERIC(18,2))/SD.QuarterlyDiabeticPatientCount END AS DiabeticPercentSplit
		,CASE WHEN ISNULL(SD.QuarterlyDiabeticPatientCount, 0) = 0 THEN 0 ELSE CAST(ISNULL(PBC.QuaterlyDiabeticPatientCount, 0) AS NUMERIC(18,2))/SD.QuarterlyDiabeticPatientCount END 
			* SD.QuarterlyDIABIncentivePool  AS QuarterlyAllocation
		
		,CASE WHEN ISNULL(SD.QuarterlyDiabeticPatientCount, 0) = 0 THEN 0 ELSE CAST(ISNULL(PBC.QuaterlyDiabeticPatientCount, 0) AS NUMERIC(18,2))/SD.QuarterlyDiabeticPatientCount END 
			* SD.QuarterlyDIABIncentivePool /3 AS MonthlyAllocation
		,SD.CapitatedPatientCount 
		,SD.QuarterlyDiabeticPatientCount AS TotalDiabeticPatientCount
		,SD.LTCPatientCount
		,SD.GrossDALYValue
		,SD.QuaterlyLINCFundingPool
		,SD.QuaterlyDiabetesFundingPool
		,'Incentive' as PaymentType
		,@FiscalQuarterKey as FiscalQuarterKey
		,@FiscalYearKey as FiscalYearKey
		--,SD.QuarterlyLINCIncentivePool		
		--,SD.QuarterlyDIABIncentivePool
		--,SD.QuarterlyAdminSalaryPool
	FROM @AuthorisedPracticeIDList AS PID
	INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
	INNER JOIN Practice AS P ON P.PracticeID = PID.PracticeID
	INNER JOIN dbo.ReportingPracticeByContract AS PBC ON PBC.PracticeID = PID.PracticeId
	CROSS JOIN dbo.ReportingRaphsSummary AS SD
	WHERE PBC.CalendarDateKey = @CalendarDateKey
	AND SD.FiscalYearKey = @FiscalYearKey
	AND SD.FiscalQuarterKey = @FiscalQuarterKey
	AND ContractCode = 'DIAB'
	
END