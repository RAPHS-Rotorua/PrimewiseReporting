CREATE Procedure [dbo].[rpt_POAC_ProcessStatus_LPC]  @Year int, @Month int
as
SET NOCOUNT ON	

/*
	Author:  Justin Sherborne
	Date: 15 aug 2016

*/	
Declare  @Count_InProcess int, @Count_Processed int;


SELECT @Count_InProcess = Count(*) 
FROM 
	POAC_ServiceDelivery
where Month(ProcessedDate) = Month(DateAdd(month,1,Cast((Cast(@year as char(4)) + '-' + cast(@Month as char(2)) + '-1') as date)))
	and Year(ProcessedDate) = Year(DateAdd(month,1,Cast((Cast(@year as char(4)) + '-' + cast(@Month as char(2)) + '-1') as date)))
and ProcessStatus = 'In Process'
and ServiceProvider = 'LPC';

SELECT @Count_Processed = Count(*) 
FROM 
	POAC_ServiceDelivery
where Month(ProcessedDate) = Month(DateAdd(month,1,Cast((Cast(@year as char(4)) + '-' + cast(@Month as char(2)) + '-1') as date)))
	and Year(ProcessedDate) = Year(DateAdd(month,1,Cast((Cast(@year as char(4)) + '-' + cast(@Month as char(2)) + '-1') as date)))
and ProcessStatus = 'Processed'
and ServiceProvider = 'LPC';

if @Count_InProcess > @Count_Processed 
		Select 'In Process' as ProcessState
	else
		Select 'Processed' as ProcessState