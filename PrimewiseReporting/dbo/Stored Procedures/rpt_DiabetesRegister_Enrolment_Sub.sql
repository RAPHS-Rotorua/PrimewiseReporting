CREATE Procedure [dbo].[rpt_DiabetesRegister_Enrolment_Sub] @Enrolment int, @PracticeIDs VARCHAR(MAX)
as
SET NOCOUNT ON	

/*
	Author:  Justin Sherborne
	Date: 28 Apr 2014

*/	
	
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



if @Enrolment = 1
	Begin
	
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
				WHEN 'Overdue' THEN 10
				WHEN 'Due This Month' THEN 30
				WHEN 'No Recall' THEN 50
				WHEN 'No Review Planned' THEN 70
				WHEN 'Not Complete' THEN 85
				WHEN 'OK' THEN 95
				ELSE 105 END AS LTCAnnualReviewStatusOrder
		,PBP.LTCAnnualReviewEnrolmentDate as LINCEnrolmentDate
			,PBP.LTCAnnualReviewLastCompletedDate as 'LINC Last Completed'
			,PBP.LTCAnnualReviewNextPlanDate as 'LINC Next Planned Review Date'
			,PBP.DARStatus
			,Case PBP.DARStatus 
		When 'Overdue' then 1
		When 'Due This Month' then 2
		When 'No Recall' then 3
		When 'No Review Planned' then 4
		When 'Not Complete' then 5
		When 'OK' then 6
		Else 99
	End as Dar_Status_Sort_Order
			,DAREnrolmentDate
			,DARLastCompletedDate as 'Diabetes Last Completed'
			,DARNextPlanDate as 'Diabetes Next Planned Review Date'	
			,LTCEnrolmentIndicator
			,Case LTCEnrolmentIndicator
				when 1 then 'Yes'
				else 'No'
			End as LTCEnrolmentIndicator_Text
			,CurrentDiabeticPatientCount
			,pc.DiabeticPercentSplit
		FROM @AuthorisedPracticeIDList AS PID
		INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
		INNER JOIN Patient PAT On PAT.PracticeID = PID.PracticeID
		LEFT OUTER JOIN dbo.ReportingPatientByPractice AS PBP ON PBP.PatientId = PAT.PatientId 
		INNER JOIN Practice AS P ON P.PracticeID = PID.PracticeID
		left outer join percent_by_practice pc ON pc.PracticeID = PAT.PracticeID
		CROSS JOIN dbo.ReportingRaphsSummary AS SD	
		WHERE PAT.DiabetesIndicator = 1 and 
		LTCEnrolmentIndicator =1 
		AND SD.FiscalYearKey = @FiscalYearKey
		AND SD.FiscalQuarterKey = @FiscalQuarterKey
	End
else
	Begin
	
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
				WHEN 'Overdue' THEN 10
				WHEN 'Due This Month' THEN 30
				WHEN 'No Recall' THEN 50
				WHEN 'No Review Planned' THEN 70
				WHEN 'Not Complete' THEN 85
				WHEN 'OK' THEN 95
				ELSE 105 END AS LTCAnnualReviewStatusOrder
		,PBP.LTCAnnualReviewEnrolmentDate as LINCEnrolmentDate
			,PBP.LTCAnnualReviewLastCompletedDate as 'LINC Last Completed'
			,PBP.LTCAnnualReviewNextPlanDate as 'LINC Next Planned Review Date'
			,PBP.DARStatus
			,Case PBP.DARStatus 
		When 'Overdue' then 1
		When 'Due This Month' then 2
		When 'No Recall' then 3
		When 'No Review Planned' then 4
		When 'Not Complete' then 5
		When 'OK' then 6
		Else 99
	End as Dar_Status_Sort_Order
			,DAREnrolmentDate
			,DARLastCompletedDate as 'Diabetes Last Completed'
			,DARNextPlanDate as 'Diabetes Next Planned Review Date'	
			,LTCEnrolmentIndicator
			,Case LTCEnrolmentIndicator
				when 1 then 'Yes'
				else 'No'
			End as LTCEnrolmentIndicator_Text
			,CurrentDiabeticPatientCount
			,pc.DiabeticPercentSplit
		FROM @AuthorisedPracticeIDList AS PID
		INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
		INNER JOIN Patient PAT On PAT.PracticeID = PID.PracticeID
		LEFT OUTER JOIN dbo.ReportingPatientByPractice AS PBP ON PBP.PatientId = PAT.PatientId 
		INNER JOIN Practice AS P ON P.PracticeID = PID.PracticeID
		left outer join percent_by_practice pc ON pc.PracticeID = PAT.PracticeID
		CROSS JOIN dbo.ReportingRaphsSummary AS SD
		
		
		WHERE PAT.DiabetesIndicator = 1 and 
		(LTCEnrolmentIndicator = 0 or LTCEnrolmentIndicator is null) 
		AND SD.FiscalYearKey = @FiscalYearKey
		AND SD.FiscalQuarterKey = @FiscalQuarterKey
	End