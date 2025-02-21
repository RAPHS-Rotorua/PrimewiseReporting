CREATE Procedure [dbo].[rpt_LINC_Reporting] @PracticeIDs VARCHAR(MAX)
as
/*
	Author:  Justin Sherborne
	Date: 11 Sep 2017

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
		l.PracticeID
		,l.Practice
		,NHI
		,Surname
		,Firstname
		,l.DOB
		,l.Prov  --JS on Jun 17 2015 Added this so that can filter by Prov in the Registers
		,AgeQtrEnd
		,Gender
		,Ethnicity
		,Quintile
		,CellPhone, HomePhone
		,CalculatedLincScore
		,CurrentRecordedLincScore 
		,l.Last_Completed
		,l.LINC_Next_Planned
		,l.LTCEnrolmentExpiryDate
		,
	In_Numerator,
	In_Denominator,
	l.LTC_Status,
	l.LTC_Status_Sort
		,LTCEnrolmentIndicator
		,LTCEnrolmentIndicator_Text,
	LTCEnrolmentIndicator_Sort
		,'Network' as Network_Group
		,HBa1c
		,[Alb Creat Ratio]
		,[ACEi or A2]
		,DiabetesIndicator
		,[Diabetes Type]
		,l.HBa1c_Bands
		,l.HBa1c_Bands_sort
		,1 as WholeGroup
	FROM @AuthorisedPracticeIDList AS PID
	INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
	INNER JOIN Stage_LINC_Reporting as l on l.PracticeID = PID.PracticeID
	where l.PatientUnenrolled = 0 and l.In_Denominator = 1