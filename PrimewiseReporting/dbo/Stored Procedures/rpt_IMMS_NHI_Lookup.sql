--exec rpt_IMMS_NHI_Lookup '17','XZG3805'

CREATE Procedure [dbo].[rpt_IMMS_NHI_Lookup] @PracticeIDs VARCHAR(MAX), @NHI varchar(50)
as
/*
AUTHOR:						Justin Sherborne
CREATE DATE:				8 Oct 2024											
 		
*/

--Declare @PracticeIDs Varchar(Max); --testing
--set @PracticeIDs = '17';

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

Select i.Practice, i.NHI, Full_Name, i.Date_of_Birth, Child_Age, Ethnicity, Quintile, Gender, Phone, Scheduled_Vaccine, Scheduled_Vaccine_Age, Eligibility_Age, dose, WhenImm, ImmunisationStatus,
	iif(Due_Group like 'Upcoming%', Due_Group,Immunisation_Schedule) as 'Immunisation_Schedule', 	
	Immunisation_Schedule_sort,VaccineOutcome ,Due_Group, Due_Group_Sort, OrderByNumber
from IMMS_Childhood_Detail as i
	join @SelectedPracticeIDList as p on p.PracticeID = i.PracticeID
	and i.NHI = @NHI