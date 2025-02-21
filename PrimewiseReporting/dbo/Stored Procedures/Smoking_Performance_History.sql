CREATE procedure [dbo].[Smoking_Performance_History]
as
Declare @DateStamp datetime
select @DateStamp = GetDate();

with Smoking_Cohort
as
(
Select PracticeID, count(*) as Smoking_Cohort
from RGPGStage.dbo.Stage_Smoking_Status  group by practiceID
union
select 99 as PracticeID, ((Select count(*) from RGPGStage.dbo.Stage_Smoking_Status)
+ (Select count(*) from RGPGStage.dbo.Stage_Smoking_MyPractice_Smokers))  as Smoking_Cohort)

Select s.*, @DateStamp as DateStamp, c.Smoking_Cohort
from Smoking_Performance_vw as s
	join Smoking_Cohort as c on c.PracticeID = s.PracticeID