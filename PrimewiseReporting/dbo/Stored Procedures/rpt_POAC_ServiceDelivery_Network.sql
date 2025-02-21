--Test
--exec [rpt_POAC_ServiceDelivery] '15'

Create Procedure [dbo].[rpt_POAC_ServiceDelivery_Network]  @Start date, @End date
as
SET NOCOUNT ON	

/*
	Author:  Justin Sherborne
	Date: 15 aug 2016

*/	


	Select  Case when p.SurgeryName is null
				then s.Provider
				else p.SurgeryName
			End as SurgeryName, s.* 
	FROM POAC_ServiceDelivery as s
	left JOIN Practice AS P ON P.PracticeID = s.PracticeID
	WHERE Cast(s.DateObserved as date) between @Start and @End