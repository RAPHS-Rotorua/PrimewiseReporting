Create proc [dbo].[Ruatahi_CX_Update]
as
update s
set s.In_Numerator_All = iif(s2.In_Numerator_All=1,1,s.In_Numerator_All),
s.Last_Screen = iif(isnull(s2.Last_Screen,'1900-01-01')>isnull(s.Last_Screen,'1900-01-01'),s2.Last_Screen, s.Last_Screen),
s.PMS_LastScreen = iif(isnull(s2.PMS_LastScreen,'1900-01-01')>isnull(s.PMS_LastScreen,'1900-01-01'),s2.PMS_LastScreen, s.PMS_LastScreen),
s.CX_Status = iif(isnull(s2.Last_Screen,'1900-01-01')>isnull(s.Last_Screen,'1900-01-01'),s2.CX_Status, s.CX_Status)
from Stage_CX_Reporting as s
	join PrimewiseReporting_RAPHS_DEV.dbo.Stage_CX_Reporting as s2 on s2.NHI = s.NHI
Where s.PracticeID = 27;