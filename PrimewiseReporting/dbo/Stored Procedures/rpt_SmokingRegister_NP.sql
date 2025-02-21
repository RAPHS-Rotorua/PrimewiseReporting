CREATE Procedure [dbo].[rpt_SmokingRegister_NP] @PracticeIDs VARCHAR(MAX)
as
SET NOCOUNT ON	

/*
	Author:  Justin Sherborne
	Date: 2 Jun 2016

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

Select h.NHI, h.LastName + ', ' + h.Firstname as Fullname,
h.DOB, h.Eth as Ethnicity1, h.Ethnicity as Ethnicity1Description, h.Quintile, h.MobilePhone as CellPhone,
h.HomePhone, h.Provider,
h.LastSeenDate as LastEvent  ,
h.LastQuitDate as CessLastScreen  ,
h.Quit_Intervention  ,
Case when h.In_Numerator_15_Months = 'Yes' then 'Cessation Recorded' else 'Overdue' End as Smoking_Status, --NCHAR(0x207A) is * and NCHAR(178) is 2 if required
case when h.LastSeenDate >= dateadd(day,-10,Cast(GetDate() as Date)) then 'Yes' else 'No' End as MissedOp,
'Ngati Pikiao Health Services' as SurgeryName,
h.LastUpdated as Last_Updated
FROM 
@AuthorisedPracticeIDList AS PID
		INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
	join Stage_Smoking_NgatiPikiao as h on h.practiceID = PID.PracticeID
	left join Practice as p on h.PracticeID = p.PracticeID