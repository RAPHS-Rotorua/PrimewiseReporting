CREATE Procedure [dbo].[DAR_Reporting] @PracticeIDs VARCHAR(MAX)
as

/*
	Author:  Justin Sherborne
	Date: 21 Aug 2017

*/	
SET NOCOUNT ON;
	
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


	SELECT
		d.PracticeID
		,d.SurgeryName
		,NHI
		,Surname
		,Firstname
		,d.DOB
		,d.Prov  --JS on Jun 17 2015 Added this so that can filter by Prov in the Registers
		,Age_Qtr_End
		,Gender
		,Ethnicity
		,Quintile
		,CellPhone, HomePhone
		,CalculatedLincScore
		,CurrentRecordedLincScore 
	,d.DAREnrolmentDate
		,d.[DAR Last Completed] 
		,d.[DAR Next Planned Review Date]
		,d.LTCEnrolmentExpiryDate
		,
	In_Numerator,
	Dar_Status,
	Dar_Status_Sort
		,LTCEnrolmentIndicator
		,LTCEnrolmentIndicator_Text,
	LTCEnrolmentIndicator_Sort
		,'Network' as Network_Group
		,d.RS_Referred
		,d.RSAnnaulReviewNextPlanDate
		,d.RSAnnualReviewLastCompletedDate
		,d.RSAnnualReviewLastExcludedDate
		,d.RSEnrolmentDate
		,HBa1c
		,[Alb Creat Ratio]
		,[ACEi or A2]
		,[Diabetes Type]
		,
		d.HBa1c_Bands
		,
		d.HBa1c_Bands_sort
		,1 as WholeGroup,
		d.HbA1c_Date,
		d.AlbCreat_Date
	FROM @AuthorisedPracticeIDList AS PID
	INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
	INNER JOIN Stage_Dar_Reporting as d on d.PracticeID = PID.PracticeID
	where d.PatientUnenrolled = 0