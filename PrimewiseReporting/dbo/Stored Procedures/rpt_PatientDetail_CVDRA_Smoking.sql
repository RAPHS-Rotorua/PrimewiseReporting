CREATE Procedure [dbo].[rpt_PatientDetail_CVDRA_Smoking] @PracticeIDs VARCHAR(MAX)
as
SET NOCOUNT ON	
/*
	Author:  Justin Sherborne
	Date: 2 March 2015
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

Select p.PatientID, p.NHI,p.DOB,p.Funding, p.EnrolledInPMS, p.PracticeID, p.SourceSurgeryID,
Case when s.NHI IS not null then 'Yes' else 'No' End as InCVDRACohort,
sm.Denominator_1 as InSmokingCohort,
s.Age_As_At as 'Age At Qtr End', s.CVDRA_Status, s.CVDRisk, s.InFundedProgramme, s.FundedScreenComplete, s.LastScreen as LastCVDScreen,
Case when sm.SmokingStatus in('Ex Smoker with SMO Code As At 15 Months','Other Smok Coded within 15 Months')
	then 'Ex-Smoker Recently Quit'
	When sm.SmokingStatus = 'Ex Smoker Code Only' then 'Ex-Smoker'
	When sm.SmokingStatus = 'Current Smoker' then 'Current Smoker'
else Null End as 'SmokingStatus' ,
Case when sm.Numerator_1 = 'Yes' then 'Cessation Recorded'
	when sm.Numerator_1 = 'No' and sm.Denominator_1 = 'Yes' then 'Due'
	else 'Not Required'
End as SmokingMOHStatus, 
Cast((SELECT Max(v) 
   FROM (VALUES (sm.Cess_Problem_Date),(sm.Cess_Profile_Date), (sm.Cess_Drug_Date),(sm.Cess_Measure_Date)) AS value(v)) as Date)  as LastCessation,
s.DIAB, s.Heart, s.Stroke, s.Vascular
from
@AuthorisedPracticeIDList AS PID
		INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
 join 
 Patient as p on PID.PracticeID = p.PracticeID
left join Stage_CVDRA_Report as s on p.NHI = s.NHI and p.PracticeID = s.PracticeID
left join Stage_Smoking_Register as sm on p.NHI = sm.nhi and p.PracticeID = sm.Practiceid


/*  Remember the age to be in CVD age cohort need to be from 35 - 74 for Male maori etc yet 55 - 74 for European female
use RGPGStage
go
Select * from capitation
where nhi in('SVD6771','LHE5219')


use PrimewiseReporting
go
Select * from Stage_CVDRA_Report
where nhi in('SVD6771','LHE5219')
*/

--Select * from Stage_Smoking_Register