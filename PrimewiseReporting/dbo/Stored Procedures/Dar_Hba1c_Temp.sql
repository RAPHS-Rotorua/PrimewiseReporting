/***
Exec [Dar_Hba1c_Temp] '27'
***/
CREATE Procedure [dbo].[Dar_Hba1c_Temp] @PracticeIDs VARCHAR(MAX)
as
SET NOCOUNT ON	

/*
	Author:  Justin Sherborne
	Date: 26 Jul 2017
*/	



DECLARE @AuthorisedPracticeIDList TABLE
		(
		PracticeID INT
		)		
	INSERT INTO	@AuthorisedPracticeIDList(PracticeID)
	EXEC [dbo].[Report_GetAuthorisedPracticeIDs];




	--- Get the selected ID's
	DECLARE @SelectedPracticeIDList TABLE
		(
		PracticeID INT
		)		
	INSERT INTO	@SelectedPracticeIDList(PracticeID)
	SELECT NUMBER FROM PrimeWiseReporting.[dbo].[fn_SplitInt] (@PracticeIDs, ',');


Select h.HbA1c_Bands, h.HBa1c_Bands_sort, Sum(In_Numerator) as No_In_Numerator,
Sum(In_Denominator) as No_In_Denominator,
Sum(In_Denominator) - Sum(In_Numerator) as Remainder,
Cast(((Cast(Sum(In_Numerator) as decimal(5,2))/Cast(Sum(In_Denominator) as decimal(5,2))) * 100) as decimal(4,1)) as Complete,
(100 - Cast(((Cast(Sum(In_Numerator) as decimal(5,2))/Cast(Sum(In_Denominator) as decimal(5,2))) * 100) as decimal(4,1))) as Due
from @AuthorisedPracticeIDList AS PID
		INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
	join Dar_Reporting_TempTest as h on PID.practiceID = h.PracticeID
	left join Practice as p on h.PracticeID = p.PracticeID
	group by h.HbA1c_Bands, h.HBa1c_Bands_sort