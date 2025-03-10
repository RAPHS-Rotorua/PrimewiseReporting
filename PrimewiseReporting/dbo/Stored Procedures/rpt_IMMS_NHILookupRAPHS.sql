CREATE Procedure [dbo].[rpt_IMMS_NHILookupRAPHS] @NHI varchar(50)
as
/*
AUTHOR:						Justin Sherborne
CREATE DATE:				10-3-2025											
 		
*/
Select i.Practice, i.NHI, Full_Name, i.Date_of_Birth, Child_Age, Ethnicity, Quintile, Gender, Phone, Scheduled_Vaccine, Scheduled_Vaccine_Age, Eligibility_Age, dose, WhenImm, ImmunisationStatus,
	iif(Due_Group like 'Upcoming%', Due_Group,Immunisation_Schedule) as 'Immunisation_Schedule', 	
	Immunisation_Schedule_sort,VaccineOutcome ,Due_Group, Due_Group_Sort, OrderByNumber
from IMMS_Childhood_Detail as i
	where i.NHI = @NHI
