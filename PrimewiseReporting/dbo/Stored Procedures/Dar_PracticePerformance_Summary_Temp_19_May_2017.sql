/***
Exec Dar_PracticePerformance_Summary_Temp_19_May_2017 '27'
***/
CREATE Procedure [dbo].[Dar_PracticePerformance_Summary_Temp_19_May_2017] @PracticeIDs VARCHAR(MAX)
as
SET NOCOUNT ON	

/*
	Author:  Justin Sherborne
	Date: 19 May 2016
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


Select h.PracticeID, Cast((Cast(sum(h.In_Numerator) as decimal(5,2))/Cast(Sum(h.In_Denominator) as decimal(5,2))) as decimal(5,2)) as Performance,
(Select Cast((Cast(sum(h1.In_Numerator) as decimal(5,2))/Cast(Sum(h1.In_Denominator) as decimal(5,2))) as decimal(5,2))
from Dar_Reporting_TempTest_19May2017 as h1 where h1.Ethnicity1Description = 'NZ Maori' and h1.PracticeID = h.PracticeID) as Performance_Maori,
Sum(h.In_Denominator) - Sum(h.In_Numerator) as No_Required_To_Target,
(Select Sum(h2.In_Denominator) - Sum(h2.In_Numerator) 
from Dar_Reporting_TempTest_19May2017 as h2 where h2.Ethnicity1Description = 'NZ Maori' and h2.PracticeID = h.PracticeID) as No_Required_To_Target_Maori
from @AuthorisedPracticeIDList AS PID
		INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
	join Dar_Reporting_TempTest_19May2017 as h on PID.practiceID = h.PracticeID
	left join Practice as p on h.PracticeID = p.PracticeID
	group by h.PracticeID