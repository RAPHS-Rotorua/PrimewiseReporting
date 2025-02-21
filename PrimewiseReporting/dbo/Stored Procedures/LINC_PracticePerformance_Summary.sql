CREATE Procedure [dbo].[LINC_PracticePerformance_Summary] @PracticeIDs VARCHAR(MAX)
as
SET NOCOUNT ON	

/*
	Author:  Justin Sherborne
	Date: 10 Sep 2017
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
from Stage_LINC_Reporting as h1 where h1.Ethnicity = 'NZ Maori' and h1.In_Denominator = 1 and h1.PatientUnenrolled = 0 and h1.PracticeID = h.PracticeID) as Performance_Maori,
case
	when
		ceiling(Sum(h.In_Denominator) * 0.9) - Sum(h.In_Numerator) < 0
	then 0
else
	ceiling(Sum(h.In_Denominator) * 0.9) - Sum(h.In_Numerator)	
End as No_Required_To_Target,
Case
	when
(Select ceiling((Sum(h2.In_Denominator) * 0.9)) - Sum(h2.In_Numerator) 
from Stage_LINC_Reporting as h2 where h2.Ethnicity = 'NZ Maori' and h2.In_Denominator = 1 and h2.PatientUnenrolled = 0 and h2.PracticeID = h.PracticeID) < 0
	then 0
Else
(Select ceiling((Sum(h3.In_Denominator) * 0.9)) - Sum(h3.In_Numerator) 
from Stage_LINC_Reporting as h3 where h3.Ethnicity = 'NZ Maori' and h3.In_Denominator = 1 and h3.PatientUnenrolled = 0 and h3.PracticeID = h.PracticeID)
End
 as No_Required_To_Target_Maori
from @AuthorisedPracticeIDList AS PID
		INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
	join Stage_LINC_Reporting as h on PID.practiceID = h.PracticeID
	left join Practice as p on h.PracticeID = p.PracticeID
	where h.PatientUnenrolled = 0 and h.In_Denominator = 1
	group by h.PracticeID