CREATE view [dbo].[LINC_Measure_Summary_vw]
as
with Measure_Summary as
(
Select PracticeID, Practice as PracticeCode, 'CVDRA Performance - Total eligible population' as Measure,Total_Eligible as Cohort, Total_Eligible as Denominator, Risk_Recorded as Numerator, Performance, 
No_Required_To_Target, National_Target,'CVDRA' as Code, 'Cardiovascular Disease Risk Assessment' as 'Group' from CVD_Performance_vw
union all
Select PracticeID, Practice, 'CVDRA Performance - Maori Male aged 35-44' as Measure,Total_Eligible_M_3544 as Cohort, Total_Eligible_M_3544, Risk_Recorded_M_3544, Performance_M_3544, No_Required_To_Target_M_3544, 
National_Target,'CVDRA' as Code, 'Cardiovascular Disease Risk Assessment' as 'Group' from CVD_Performance_vw
union all
Select PracticeID, Practice, 'LINCAR Performance - Total eligible population' as Measure,Total_Eligible as Cohort, Total_Eligible, LINC_Complete,Performance_Total, No_Required_To_Target, 
National_Target, 'LINCAR', 'LINC Annual Review' from LINC_Performance_vw
union all
Select PracticeID, Practice, 'Smoking Cessation - Total eligible population', Total_Eligible as Cohort, Total_Eligible as Denominator, Cessation_Recorded as Numerator, Performance, No_Required_To_Target, 
Programme_Goal, 'SMOKCESS','Smoking Cessation Intervention' from Smoking_Performance_vw
union all
Select PracticeID, Practice, 'Smoking Cessation - Maori only',Total_Eligible_Maori as Cohort, Total_Eligible_Maori, Cessation_Recorded_Maori, Performance_Maori, 
No_Required_To_Target_Maori, Programme_Goal, 'SMOKCESS','Smoking Cessation Intervention' from Smoking_Performance_vw
union all
Select PracticeID, Practice, 'Cervical Screening - Total eligible population', Cohort_All as Cohort, Denominator_All as Denominator, CX_Complete as Numerator,
Performance_Total, No_Required_To_Target, National_Target, 'CX','Cervical Screening' from CX_Performance_vw
union all
Select PracticeID, Practice, 'Cervical Screening - Maori Only', Cohort_Maori as Cohort, Denominator_Maori, CX_Complete_Maori, 
Performance_Maori, No_Required_To_Target_Maori, National_Target, 'CX','Cervical Screening' from CX_Performance_vw
union all
Select PracticeID, Practice, 'DAR Performance - Total eligible population', Total_Eligible as cohort, Total_Eligible as Denominator, DAR_Complete as Numerator, 
Performance_Total, No_Required_To_Target, National_Target, 'DAR','Diabetes Annual Review' from DAR_Performance_vw
union all
Select PracticeID, Practice, 'DAR Performance - HbA1c <= 64 mmol per mol', Total_Hba1c64mmol, Total_Hba1c64mmol as Denominator, DAR_Complete_HbA1c64mmol as Numerator, 
Performance_HbA1c64, No_Required_To_Target_HbA1c64, National_Target, 'DAR','Diabetes Annual Review' from DAR_Performance_vw
)
Select pr.SurgeryName, m.*
from Measure_Summary as m
	join Practice as pr on pr.PracticeID = m.PracticeID