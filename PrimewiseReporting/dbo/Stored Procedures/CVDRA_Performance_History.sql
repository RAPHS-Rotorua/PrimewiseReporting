CREATE procedure [dbo].[CVDRA_Performance_History]
as
Declare @DateStamp datetime
select @DateStamp = GetDate();

with CVDRA_Cohort_ByPractice
as
(
Select PracticeID, count(*) as CVDRA_Cohort_Count from  RGPGStage.dbo.Stage_CVDRA_MOH_HealthTarget group by PracticeID
union
Select 99 as PracticeID, (Select count(*) from  RGPGStage.dbo.Stage_CVDRA_MOH_HealthTarget) as CVDRA_Cohort_Count)

Select c.*, @DateStamp as DateStamp, p.CVDRA_Cohort_Count
from IPIF_Performance_CVD as c
join CVDRA_Cohort_ByPractice as p on p.PracticeID = c.PracticeID