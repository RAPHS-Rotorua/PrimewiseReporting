--test:  Select * from Stage_LINC_Reporting
Create proc [dbo].[rpt_LINC_ExpiredBefore_QtrStart] @PracticeIDs VARCHAR(MAX)
as
/*
	Author:  Justin Sherborne
	Date: 11 Jan 2024
*/	
SET NOCOUNT ON;
Declare @Qtr int,@Year int, @QtrStart date;
Select @Year = Year_no from Stage_Reporting_Year;
Select @Qtr = Quarter_No from Reporting_Quarter; 
set @QtrStart =
	Case @Qtr
		When 1 then Cast((Cast((@Year - 1) as char(4)) + '-07-01') as date)
		when 2 then Cast((Cast((@Year - 1) as char(4)) + '-10-01') as date)
		When 3 then Cast((Cast((@Year) as char(4)) + '-01-01') as date)
		When 4 then Cast((Cast((@Year) as char(4)) + '-04-01') as date)
	End;  --Start of Quarter

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

Select l.*
	FROM @AuthorisedPracticeIDList AS PID
	INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
	INNER JOIN Stage_LINC_Reporting as l on l.PracticeID = PID.PracticeID
	where l.PatientUnenrolled = 0 and LTCEnrolmentExpiryDate < @QtrStart
order by practiceID;