CREATE PROCEDURE [dbo].[Report_DiabetesRegisterSummary]

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

;
with total as (

-- compute the total patient count for all practices
				select SUM(pbc.QuaterlyDiabeticPatientCount) as quarter_total
				from dbo.ReportingPracticeBycontract AS pbc
				where pbc.ContractCode = 'DIAB'
),				
-- compute the % of network per practice for diab contract
percent_by_practice as (
				select pbc.practiceid
				,pbc.QuaterlyDiabeticPatientCount
				,t.quarter_total
				,CASE WHEN ISNULL(pbc.QuaterlyDiabeticPatientCount, 0) = 0 THEN 0 ELSE 
				CAST(ISNULL(PBC.QuaterlyDiabeticPatientCount, 0) AS NUMERIC(18,2))/t.quarter_total END AS DiabeticPercentSplit 
				from dbo.ReportingPracticeBycontract AS pbc
				cross join total t			-- will need to change this join to left join on year and quarter for multi quarter change
				where pbc.ContractCode = 'DIAB'
)


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
		,CurrentRecordedLincScore 
		,PBP.LTCAnnualReviewStatus
		,CASE PBP.LTCAnnualReviewStatus 
			WHEN 'No Care Plan' THEN 1
			WHEN 'Overdue' THEN 2
			WHEN 'No Review Planned' THEN 3
			WHEN 'OK' THEN 4
			ELSE 99 END AS LTCAnnualReviewStatusOrder
		,PBP.LTCAnnualReviewNextPlanDate
		,PBP.DARStatus
		,CASE PBP.DARStatus
			WHEN 'No Care Plan' THEN 1
			WHEN 'Overdue' THEN 2
			WHEN 'No Review Planned' THEN 3
			WHEN 'OK' THEN 4
			ELSE 99 END AS DARStatusOrder
		,DARNextPlanDate	
		,LTCEnrolmentIndicator
		,CurrentDiabeticPatientCount
		,pc.DiabeticPercentSplit

	FROM @AuthorisedPracticeIDList AS PID
	INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
	INNER JOIN Patient PAT On PAT.PracticeID = PID.PracticeID
	LEFT OUTER JOIN dbo.ReportingPatientByPractice AS PBP ON PBP.PatientId = PAT.PatientId 
	INNER JOIN Practice AS P ON P.PracticeID = PID.PracticeID
	left outer join percent_by_practice pc ON pc.PracticeID = PAT.PracticeID
	CROSS JOIN dbo.ReportingRaphsSummary AS SD
	
	
	WHERE PAT.DiabetesIndicator = 1
	AND SD.FiscalYearKey = @FiscalYearKey
	AND SD.FiscalQuarterKey = @FiscalQuarterKey


END