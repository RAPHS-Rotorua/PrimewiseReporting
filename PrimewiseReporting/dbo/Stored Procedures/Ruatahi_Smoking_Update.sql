Create proc [dbo].[Ruatahi_Smoking_Update]
as
update s
set s.Numerator_15M_EOQ = iif(s2.Numerator_15M_EOQ=1,1,s.Numerator_15M_EOQ),
s.CessLastScreen = iif(isnull(s2.CessLastScreen,'1900-01-01')>isnull(s.CessLastScreen,'1900-01-01'),s2.CessLastScreen, s.CessLastScreen),
s.Cessation_when_Due = iif(isnull(s2.CessLastScreen,'1900-01-01')>isnull(s.CessLastScreen,'1900-01-01'),s2.Cessation_when_Due, s.Cessation_when_Due),
s.Cessation_When_Due_Sort = iif(isnull(s2.CessLastScreen,'1900-01-01')>isnull(s.CessLastScreen,'1900-01-01'),s2.Cessation_when_Due_Sort, s.Cessation_when_Due_Sort)
from Stage_Smoking_Register as s
	join PrimewiseReporting_RAPHS_DEV.dbo.Stage_Smoking_Register as s2 on s2.NHI = s.NHI
Where s.PracticeID = 27;