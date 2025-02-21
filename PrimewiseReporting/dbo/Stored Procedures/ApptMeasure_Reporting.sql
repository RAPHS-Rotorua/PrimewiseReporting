CREATE Procedure [dbo].[ApptMeasure_Reporting] @PracticeIDs VARCHAR(MAX),@StartDate date, @NoDays int
as

/*
	Author:  Justin Sherborne
	Date: 9 Apr 2019

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
		Case when d.Ethnicity='NZ European/Pakeha' then 'NZ European'
			when d.Ethnicity = 'European (not further defined)' then 'European'
			else d.Ethnicity
		 End as 'Ethnicity',
		d.Provider,d.DateAppt, d.MondayApptDate, d.Day_of_Week,
		 d.DateAppt_AsDate as Appointment_DateOnly,
		 d.DateApptFormat,
		 d.[Current or Recent Smoker], d.Smok_LastScreen,
		 d.Smok_DueThisQtr,d.CVD_DueThisQtr, d.CX_DueThisQtr, d.DAR_DueThisQtr, d.LINC_DueThisQtr,
		 d.Smok_DueNextQtr, d.CVD_DueNextQtr, d.CX_DueNextQtr, d.DAR_DueNextQtr, d.LINC_DueNextQtr
	FROM @AuthorisedPracticeIDList AS PID
	INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
	INNER JOIN PrimewiseReporting.dbo.Appointment_Measurement_Report_Data as d on d.PracticeID = PID.PracticeID
	where d.DateAppt_AsDate between @StartDate and DateAdd(day,@NoDays,@StartDate) ;  --@NoDays will be 1 by default which will mean only @StartDate will show on report