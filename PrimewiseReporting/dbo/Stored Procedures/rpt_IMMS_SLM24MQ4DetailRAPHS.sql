USE [PrimewiseReporting]
GO

/****** Object:  StoredProcedure [dbo].[rpt_IMMS_SLM24MQ4DetailRAPHS]    Script Date: 11/03/2025 8:57:23 am ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[rpt_IMMS_SLM24MQ4DetailRAPHS]  --drop proc rpt_IMMS_SLM24MQ4Detail
as

/*
AUTHOR:						Justin Sherborne
CREATE DATE:				10 Mar 2025										
*/

Select c.PracticeID, c.PracticePrefix, NHI, Full_Name, ProviderCode, Date_of_Birth, Child_Age, Ethnicity, Quintile, Gender, Phone, CSC_Number, CSC_Expiry_Date, CSC_Current,
Schedule_Status, iif(Schedule_Status = 'Due',1,iif(Schedule_Status = 'Partially Declined',2, iif(Schedule_Status = 'Fully Declined',3,4))) as Schedule_Status_Sort,
Immunisation_Schedule, Immunisation_Schedule_sort, Due_Group, Due_Group_Sort,
iif(Schedule_Status = 'Completed','Completed', Due_Group) as Schedule_Status_Group,
 Scheduled_Vaccine_Age, Scheduled_Age ,
Scheduled_Vaccine, WhenImm, dose, ImmunisationStatus, VaccineOutcome, Patient_Unenrolled, OrderByNumber 
from IMMS_Childhood_Detail as c
where SLM_Age_24_Months_Qtr4 = 1
GO
