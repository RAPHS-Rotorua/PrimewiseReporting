--drop proc Temp_ApptMeasure_Reporting
--Select * from Testing_DB.dbo.Temp_Appointment_Measurement_Report_Data
--Exec Temp_ApptMeasure_Reporting '4'

CREATE Procedure [dbo].[Temp_ApptMeasure_Reporting] @PracticeIDs VARCHAR(MAX)
as

/*
	Author:  Justin Sherborne
	Date: 8 Feb 2018

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
		d.PracticeID, d.Practice, d.NHI, d.Patient, d.Age_QtrEnd, d.Gender, 
		iif(d.Ethnicity='NZ European/Pakeha','NZ European',iif(d.Ethnicity = 'European (not further defined)','European',d.Ethnicity)) as 'Ethnicity',
		d.Provider,d.DateAppt, d.MondayApptDate, d.Day_of_Week,
		 Cast(d.DateAppt as Date) as Appointment_DateOnly,
		 d.[Current or Recent Smoker], d.Smok_LastScreen,
		 d.Smok_DueThisQtr,d.CVD_DueThisQtr, d.CX_DueThisQtr, d.DAR_DueThisQtr, d.LINC_DueThisQtr,
		 d.Smok_DueNextQtr, d.CVD_DueNextQtr, d.CX_DueNextQtr, d.DAR_DueNextQtr, d.LINC_DueNextQtr
	FROM @AuthorisedPracticeIDList AS PID
	INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
	INNER JOIN PrimewiseReporting.dbo.Temp_Appointment_Measurement_Report_Data as d on d.PracticeID = PID.PracticeID