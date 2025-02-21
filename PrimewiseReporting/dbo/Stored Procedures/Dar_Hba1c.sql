CREATE Procedure [dbo].[Dar_Hba1c] @PracticeIDs VARCHAR(MAX)
as
SET NOCOUNT ON	

/*
	Author:  Justin Sherborne
	Date: 21 Aug 2017
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
Cast(((Cast(Sum(In_Numerator) as decimal(15,2))/Cast(Sum(In_Denominator) as decimal(15,2))) * 100) as decimal(5,2)) as Complete,
(100 - Cast(((Cast(Sum(In_Numerator) as decimal(15,2))/Cast(Sum(In_Denominator) as decimal(15,2))) * 100) as decimal(5,2))) as Due
,Case when
Ceiling((0.85 * Sum(h.In_Denominator))) - 
Sum(h.In_Numerator) < 0 then 0
else
Ceiling((0.85 * Sum(h.In_Denominator))) - 
Sum(In_Numerator)
End
as No_Required_To_Target
from @AuthorisedPracticeIDList AS PID
		INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
	join Stage_Dar_Reporting as h on PID.practiceID = h.PracticeID
	left join Practice as p on h.PracticeID = p.PracticeID
	where h.PatientUnenrolled = 0
	group by h.HbA1c_Bands, h.HBa1c_Bands_sort