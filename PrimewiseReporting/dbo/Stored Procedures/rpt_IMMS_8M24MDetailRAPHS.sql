USE [PrimewiseReporting]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[rpt_IMMS_8M24MDetailRAPHS]
as

/*
AUTHOR:						Justin Sherborne
CREATE DATE:				10-3-2025										
*/

Select c.PracticeID, c.PracticePrefix, NHI, Full_Name, ProviderCode, Date_of_Birth, Child_Age, Ethnicity, Quintile, Gender, Phone, CSC_Number, CSC_Expiry_Date, CSC_Current,
Age_8_Months, Milestone_Age_8_Months, Numerator_8_Months, Age_24_Months, Milestone_Age_24_Months, Numerator_24_Months,
iif(Milestone_Age_8_Months = 1, '8-Month', iif(Milestone_Age_24_Months = 1,'24-Month','Not in group')) as 'Milestone_Age',
Schedule_Status, iif(Schedule_Status = 'Due',1,iif(Schedule_Status = 'Partially Declined',2, iif(Schedule_Status = 'Fully Declined',3,4))) as Schedule_Status_Sort,
Immunisation_Schedule, Immunisation_Schedule_sort, Due_Group, Due_Group_Sort, Scheduled_Vaccine_Age, Scheduled_Age ,
Scheduled_Vaccine, WhenImm, dose, ImmunisationStatus, VaccineOutcome, Patient_Unenrolled, OrderByNumber 
from IMMS_Childhood_Detail as c
where Milestone_Age_8_Months = 1 or Milestone_Age_24_Months = 1
GO



