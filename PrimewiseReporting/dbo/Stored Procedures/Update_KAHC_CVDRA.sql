Create Proc [dbo].[Update_KAHC_CVDRA]
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
from StaticData.dbo.Stage_CVDRA_Report_KAHC_20240122
where LastScreen >= @StartDate
)
Update i
set i.LastScreen = p.LastScreen, i.ExternalToPractice = 1, --1 for ExternalToPractice (so we know came from previous pms)
i.CVDRisk = p.CVDRisk, i.CVDRisk_Bands = p.CVDRisk_Bands, i.CVDRisk_Bands_Sort = p.CVDRisk_Bands_Sort, 
i.CVDRA_Status = p.CVDRA_Status, i.CVDRisk_Text = p.CVDRisk_Text, i.CVDRisk_Bands_2018 = p.CVDRisk_Bands_2018, i.CVDRisk_Bands_Sort_2018 = p.CVDRisk_Bands_Sort_2018
from Stage_CVDRA_Report as i
	join Old_Profile_CVDRA as p on p.nhi = i.NHI
	where i.CVDRA_Status <> 'Risk Recorded' 
		and i.PracticeID = 30;