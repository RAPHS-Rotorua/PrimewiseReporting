Create proc [dbo].[rpt_IMMS_ChildhoodDetailRAPHS_proc]  @ScheduleStatus varchar(100)
as
/*
AUTHOR:						Justin Sherborne
CREATE DATE:				7 Mar 2025											
 		
*/
Select s.*
from IMMS_Childhood_Detail as s  
	where Immunisation_Schedule is not null and Schedule_Status = @ScheduleStatus;
