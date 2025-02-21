Create proc [dbo].[Ruatahi_CVDRA_Update]
as
update s
set s.LastScreen = iif(isnull(s2.LastScreen,'1900-01-01')>isnull(s.LastScreen,'1900-01-01'),s2.LastScreen, s.LastScreen),
s.CVDRA_Status = iif(isnull(s2.LastScreen,'1900-01-01')>isnull(s.LastScreen,'1900-01-01'),s2.CVDRA_Status, s.CVDRA_Status),
s.CVDRisk = iif(isnull(s2.LastScreen,'1900-01-01')>isnull(s.LastScreen,'1900-01-01') and s2.CVDRisk is not null,s2.CVDRisk, s.CVDRisk),
s.CVDRisk_Bands_Sort = iif(isnull(s2.LastScreen,'1900-01-01')>isnull(s.LastScreen,'1900-01-01') and s2.CVDRisk is not null,s2.CVDRisk_Bands_Sort, s.CVDRisk_Bands_Sort),
s.CVDRisk_Bands = iif(isnull(s2.LastScreen,'1900-01-01')>isnull(s.LastScreen,'1900-01-01') and s2.CVDRisk is not null,s2.CVDRisk_Bands, s.CVDRisk_Bands),
s.CVDRisk_Text = iif(isnull(s2.LastScreen,'1900-01-01')>isnull(s.LastScreen,'1900-01-01') and s2.CVDRisk_Text is not null and rtrim(ltrim(s2.CVDRisk_Text)) <> '',s2.CVDRisk_Text, s.CVDRisk_Text)
from Stage_CVDRA_Report as s
	join PrimewiseReporting_RAPHS_DEV.dbo.Stage_CVDRA_Report as s2 on s2.NHI = s.NHI
Where s.PracticeID = 27;