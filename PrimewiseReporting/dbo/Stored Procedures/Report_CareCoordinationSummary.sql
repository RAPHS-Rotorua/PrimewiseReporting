/*
AUTHOR:						Noel Gourdie (Montage)
CREATE DATE:				16/6/2013
												
 		
--*/

CREATE PROCEDURE [dbo].[Report_CareCoordinationSummary]

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

	
	SET @FiscalYearKey = (SELECT MAX(FiscalYearKey) FROM dbo.ReportingRaphsSummary)
	SET @FiscalQuarterKey = (SELECT MAX(FiscalQuarterKey) FROM dbo.ReportingRaphsSummary WHERE FiscalYearKey  = @FiscalYearKey)





	SELECT
		PAT.PracticeID
		,P.SurgeryName
		,NHI
		,Surname
		,Firstname
		,DOB
		,Age
		,Gender
		,Ethnicity1Description
		,Quintile
		,PBP.CurrentRecordedLincScore
		,PBP.CurrentIntensityLevel
		,PBP.CurrentIntensityMeasurementDate
		,PBP.LTCAnnualReviewStatus 
		,CASE PBP.LTCAnnualReviewStatus 
			WHEN 'No Care Plan' THEN 1
			WHEN 'Overdue' THEN 2
			WHEN 'No Review Planned' THEN 3
			WHEN 'OK' THEN 4
			ELSE 99 END AS LTCAnnualReviewStatusOrder
		,PBP.LTCAnnualReviewNextPlanDate
	FROM @AuthorisedPracticeIDList AS PID
	INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
	INNER JOIN Patient PAT On PAT.PracticeID = PID.PracticeID
	LEFT OUTER JOIN dbo.ReportingPatientByPractice AS PBP ON PBP.PatientId = PAT.PatientId 
	INNER JOIN Practice AS P ON P.PracticeID = PID.PracticeID

	
	WHERE PAT.LTCEnrolmentIndicator = 1

	
END