--Exec [dbo].[rpt_POAC_MonthlyServiceDelivery_LPC] 2016, 12

Create Procedure [dbo].[rpt_POAC_MonthlyServiceDelivery_LPC] @Year int, @Month int
as
SET NOCOUNT ON	

/*
	Author:  Justin Sherborne
	Date: 9 Feb 2017

*/	
	Select 'Lakes Primecare' as SurgeryName, s.* 
	FROM 
	POAC_ServiceDelivery as s
	WHERE Month(ProcessedDate) = Month(DateAdd(month,1,Cast((Cast(@year as char(4)) + '-' + cast(@Month as char(2)) + '-1') as date)))
	and Year(ProcessedDate) = Year(DateAdd(month,1,Cast((Cast(@year as char(4)) + '-' + cast(@Month as char(2)) + '-1') as date)))
	and ServiceProvider = 'LPC'