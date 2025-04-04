﻿/***
Exec LINC_PracticePerformance_Summary_Temp '15'
***/
CREATE Procedure [dbo].[LINC_PracticePerformance_Summary_Temp] @PracticeIDs VARCHAR(MAX)
as
SET NOCOUNT ON	

/*
	Author:  Justin Sherborne
	Date: 7 Aug 2017
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


Select h.PracticeID, Cast((Cast(sum(h.In_Numerator) as decimal(7,3))/Cast(Sum(h.In_Denominator) as decimal(7,3))) as decimal(7,3)) as Performance,
(Select Cast((Cast(sum(h1.In_Numerator) as decimal(7,3))/Cast(Sum(h1.In_Denominator) as decimal(7,3))) as decimal(7,3))
from LINC_Reporting_TempTest as h1 where h1.Ethnicity1Description = 'NZ Maori' and h1.PracticeID = h.PracticeID) as Performance_Maori,
(Sum(h.In_Denominator) * 0.9) - Sum(h.In_Numerator) as No_Required_To_Target,
(Select (Sum(h2.In_Denominator) * 0.9) - Sum(h2.In_Numerator) 
from Dar_Reporting_TempTest as h2 where h2.Ethnicity1Description = 'NZ Maori' and h2.PracticeID = h.PracticeID) as No_Required_To_Target_Maori
from @AuthorisedPracticeIDList AS PID
		INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
	join LINC_Reporting_TempTest as h on PID.practiceID = h.PracticeID
	left join Practice as p on h.PracticeID = p.PracticeID
	where h.LTCEnrolmentIndicator = 1
	group by h.PracticeID