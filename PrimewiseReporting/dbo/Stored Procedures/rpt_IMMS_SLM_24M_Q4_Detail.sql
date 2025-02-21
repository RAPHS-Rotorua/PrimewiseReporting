--exec rpt_IMMS_SLM_24M_Q4_Detail '17'
CREATE Procedure [dbo].[rpt_IMMS_SLM_24M_Q4_Detail] @PracticeIDs VARCHAR(MAX)
as

/*
AUTHOR:						Justin Sherborne
CREATE DATE:				14 Oct 2024											
*/
--Declare @PracticeIDs Varchar(Max)
--select @PracticeIDs = '17';

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

Select c.PracticeID, NHI, Full_Name, ProviderCode, Date_of_Birth, Child_Age, Ethnicity, Quintile, Gender, Phone, CSC_Number, CSC_Expiry_Date, CSC_Current,
Schedule_Status, iif(Schedule_Status = 'Due',1,iif(Schedule_Status = 'Partially Declined',2, iif(Schedule_Status = 'Fully Declined',3,4))) as Schedule_Status_Sort,
Immunisation_Schedule, Immunisation_Schedule_sort, Due_Group, Due_Group_Sort,
iif(Schedule_Status = 'Completed','Completed', Due_Group) as Schedule_Status_Group,
 Scheduled_Vaccine_Age, Scheduled_Age ,
Scheduled_Vaccine, WhenImm, dose, ImmunisationStatus, VaccineOutcome, Patient_Unenrolled, OrderByNumber 
from IMMS_Childhood_Detail as c
	join @SelectedPracticeIDList as s on s.PracticeID = c.PracticeID
where SLM_Age_24_Months_Qtr4 = 1