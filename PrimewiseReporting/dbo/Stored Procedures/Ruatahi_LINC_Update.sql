Create proc [dbo].[Ruatahi_LINC_Update]
as
Update l
set l.In_Numerator = iif(l2.In_Numerator = 1,1,l.In_Numerator),
l.LTC_Status = iif(isNull(l2.[Last_Completed],'1900-01-01') >  isnull(l.[Last_Completed],'1900-01-01'),l2.LTC_Status, l.LTC_Status),
l.[Last_Completed] = iif(isnull(l2.[Last_Completed],'1900-01-01') >  isnull(l.[Last_Completed],'1900-01-01'), l2.[Last_Completed], l.[Last_Completed]),
l.LTC_Status_Sort = iif(isnull(l2.[Last_Completed],'1900-01-01') >  isnull(l.[Last_Completed],'1900-01-01'), l2.LTC_Status_sort, l.LTC_Status_sort)
from  Stage_LINC_Reporting as l
join PrimewiseReporting_RAPHS_DEV.dbo.Stage_LINC_Reporting as l2 on l2.NHI = l.NHI 
where l.PracticeID = 27;