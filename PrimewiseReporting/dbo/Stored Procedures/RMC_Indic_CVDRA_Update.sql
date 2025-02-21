CREATE proc [dbo].[RMC_Indic_CVDRA_Update] @StartCVDRA date
as
with Indici_CVDRA_Adhoc
as
(Select * from
(
Select cast((Right([Screening Date],4) +'-' + substring([Screening Date],4,2) + '-' + left([Screening Date],2))as date) as CVDRAScreen,
NHI,
substring(Provider,4,2) + substring(replace(Provider,'''',''),charindex(' ',Provider,4) + 1,2)  as ProviderCode,
[Contact No], row_number() 
over(Partition by NHI order by cast((Right([Screening Date],4) +'-' + substring([Screening Date],4,2) + '-' + left([Screening Date],2))as date) desc) as row_num 
from rgpgstage.dbo.RMC_Indici_CVDRA
) as z
where row_num = 1
)

update c
set LastScreen = iif(i.cvdraScreen > LastScreen,i.CVDRAScreen, LastScreen), 
CVDRA_Status = iif(i.cvdraScreen > isnull(LastScreen,'1901-01-01') and i.CVDRAScreen >= @StartCVDRA, 'Risk Recorded', CVDRA_Status),
CVDRisk = iif(i.cvdraScreen > c.LastScreen, NULL, CVDRisk),
CVDRisk_Bands = iif(i.cvdraScreen > c.LastScreen, NULL, CVDRisk_Bands), ProviderCode = i.ProviderCode
from Stage_CVDRA_Report as c join Indici_CVDRA_Adhoc as i on i.NHI = c.NHI
where c.PracticeID = 17