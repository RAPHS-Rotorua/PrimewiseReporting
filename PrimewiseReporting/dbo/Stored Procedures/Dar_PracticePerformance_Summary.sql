CREATE Procedure [dbo].[Dar_PracticePerformance_Summary] @PracticeIDs VARCHAR(MAX)
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


Select h.PracticeID, Cast((Cast(sum(h.In_Numerator) as decimal(15,4))/Cast(Sum(h.In_Denominator) as decimal(15,4))) as decimal(5,4)) as Performance,
(Select Cast((Cast(sum(h1.In_Numerator) as decimal(15,4))/Cast(Sum(h1.In_Denominator) as decimal(15,4))) as decimal(5,4))
from Stage_Dar_Reporting as h1 where h1.Ethnicity = 'NZ Maori' and h1.PracticeID = h.PracticeID and h1.PatientUnenrolled = 0) as Performance_Maori,
Case when
Ceiling((0.85 * Sum(h.In_Denominator))) - 
Sum(h.In_Numerator) < 0 then 0
else
Ceiling((0.85 * Sum(h.In_Denominator))) - 
Sum(In_Numerator)
End
as No_Required_To_Target,
Case when
(Select ceiling((0.85 * Sum(h2.In_Denominator))) - Sum(h2.In_Numerator)
from Stage_Dar_Reporting as h2 where h2.Ethnicity = 'NZ Maori' and h2.PracticeID = h.PracticeID and h2.PatientUnenrolled = 0) < 0 
then 0
else
(Select ceiling((0.85 * Sum(h2.In_Denominator))) - Sum(h2.In_Numerator)
from Stage_Dar_Reporting as h2 where h2.Ethnicity = 'NZ Maori' and h2.PracticeID = h.PracticeID and h2.PatientUnenrolled = 0)
End as No_Required_To_Target_Maori
from @AuthorisedPracticeIDList AS PID
		INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
	join Stage_Dar_Reporting as h on PID.practiceID = h.PracticeID
	left join Practice as p on h.PracticeID = p.PracticeID
	where h.PatientUnenrolled = 0
	group by h.PracticeID