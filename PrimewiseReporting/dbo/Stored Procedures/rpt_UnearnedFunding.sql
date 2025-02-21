--Test
--exec rpt_DiabetesRegister '15'

CREATE Procedure [dbo].[rpt_UnearnedFunding] @PracticeIDs VARCHAR(MAX), @Month tinyint, @Year smallint
as
SET NOCOUNT ON	

/*
	Author:  Justin Sherborne
	Date: 17 Jul 2014

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


	SELECT
p.SurgeryName, p.SurgeryPrefix, r.*
		,1 as WholeGroup
	FROM @AuthorisedPracticeIDList AS PID
	INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
	join RunningUnearned_NoTarget_MonthTotals as r on r.PracticeID = SL.PracticeID
	INNER JOIN Practice AS P ON P.PracticeID = PID.PracticeID
	where r.YearNo = @Year and r.MonthNo = @Month