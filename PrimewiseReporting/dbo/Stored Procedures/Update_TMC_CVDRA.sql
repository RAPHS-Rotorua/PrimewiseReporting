CREATE Proc [dbo].[Update_TMC_CVDRA]
as
Declare @StartDate date;
Declare @QtrStart date;
Declare @QtrEnd_PlusOne date;
Declare @Year_Start date;
select @Year_Start = MAX(Reporting_Start) from Stage_Reporting_Year;

Select @QtrEnd_PlusOne = MAX(QtrEndPlusOne) from rgpgstage.dbo.CVDRA_Qtr();

select @StartDate = MAX(StartDate) from rgpgstage.dbo.CVDRA_Qtr();

Select @QtrStart = Max(QtrStart) from rgpgstage.dbo.CVDRA_Qtr();
--Select @QtrEnd_PlusOne as QtrEnd_PlusOne, @StartDate as StartDate, @QtrStart as QtrStart;

with Old_Profile_CVDRA
as
(
select NHI, LastScreen, CVDRA_Status, CVDRisk, CVDRisk_Bands, CVDRisk_Bands_2018, CVDRisk_Text, CVDRisk_Bands_Sort, CVDRisk_Bands_Sort_2018  
from StaticData.dbo.Stage_CVDRA_Report_TMC_20241015  --change this
)
Update i
set i.LastScreen = iif(i.CVDRA_Status <> 'Risk Recorded' and p.LastScreen > isnull(i.LastScreen,'1905-1-1'), p.LastScreen, i.LastScreen), 
i.ExternalToPractice = iif(i.CVDRA_Status <> 'Risk Recorded' and p.LastScreen > isnull(i.LastScreen,'1905-1-1'), 1,0), --1 for ExternalToPractice (so we know came from previous pms)
i.CVDRisk = iif(i.CVDRA_Status <> 'Risk Recorded' and p.LastScreen > isnull(i.LastScreen,'1905-1-1'),p.CVDRisk, i.CVDRisk), 
i.CVDRisk_Bands = iif(i.CVDRA_Status <> 'Risk Recorded' and p.LastScreen > isnull(i.LastScreen,'1905-1-1'),p.CVDRisk_Bands,i.CVDRisk_Bands), 
i.CVDRisk_Bands_Sort = iif(i.CVDRA_Status <> 'Risk Recorded' and p.LastScreen > isnull(i.LastScreen,'1905-1-1'),p.CVDRisk_Bands_Sort, i.CVDRisk_Bands_Sort),
i.CVDRA_Status = iif(i.CVDRA_Status <> 'Risk Recorded' and p.LastScreen > = @StartDate, p.CVDRA_Status, i.CVDRA_STatus), 
i.CVDRisk_Text = iif(i.CVDRA_Status <> 'Risk Recorded' and p.LastScreen > isnull(i.LastScreen,'1905-1-1'), p.CVDRisk_Text, i.CVDRisk_Text), 
i.CVDRisk_Bands_2018 = iif(i.CVDRA_Status <> 'Risk Recorded' and p.LastScreen > isnull(i.LastScreen,'1905-1-1'),p.CVDRisk_Bands_2018, i.CVDRisk_Bands_2018), 
i.CVDRisk_Bands_Sort_2018 = iif(i.CVDRA_Status <> 'Risk Recorded' and p.LastScreen > isnull(i.LastScreen,'1905-1-1'),p.CVDRisk_Bands_Sort_2018, i.CVDRisk_Bands_Sort_2018)
from Stage_CVDRA_Report as i
	join Old_Profile_CVDRA as p on p.nhi = i.NHI
		and i.PracticeID = 4; --change this