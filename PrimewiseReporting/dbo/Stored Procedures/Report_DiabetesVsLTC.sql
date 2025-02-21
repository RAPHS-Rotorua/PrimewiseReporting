/*
AUTHOR:						Noel Gourdie (Montage)
CREATE DATE:				27/6/2013
												
 		
--*/

CREATE PROCEDURE [dbo].[Report_DiabetesVsLTC]

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
		,PBC.CurrentDiabeticPatientCount
		,PBC.DiabeticLTCPatientCount
		,SD.CurrentDiabeticPatientCount AS SummaryCurrentDiabeticPatientCount
		,SD.DiabetesLTCPatientCount AS SummaryDiabetesLTCPatientCount
	FROM @AuthorisedPracticeIDList AS PID
	INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
	INNER JOIN Practice AS P ON P.PracticeID = PID.PracticeID
	INNER JOIN dbo.ReportingPracticeByContract AS PBC ON PBC.PracticeID = PID.PracticeId
	CROSS JOIN dbo.ReportingRaphsSummary AS SD
	WHERE PBC.CalendarDateKey = @CalendarDateKey
	AND SD.FiscalYearKey = @FiscalYearKey
	AND SD.FiscalQuarterKey = @FiscalQuarterKey


END