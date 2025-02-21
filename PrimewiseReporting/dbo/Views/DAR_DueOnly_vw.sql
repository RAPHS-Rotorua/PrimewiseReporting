CREATE view [dbo].[DAR_DueOnly_vw]
as
Select PracticeID, SurgeryName, NHI, Surname, Firstname, Cast(DOB as Date) as 'DOB', Ethnicity, [DAR Last Completed], 
Cast([DAR Next Planned Review Date] as date) as 'DAR Next Planned Review Date', In_Numerator, In_Denominator,
Dar_Status, Prov, HBa1c, [Alb Creat Ratio], RS_Referred, isNull(Cellphone,'') + ', ' + isNull(Homephone,'') as Contact
from Stage_Dar_Reporting  --Select distinct In_Numerator, Dar_Status from Stage_Dar_Reporting order by In_Numerator, DAR_Status desc
where Dar_Status in('Overdue', 'Never Screened', 'Due This Quarter', 'Due Next Quarter') and PatientUnenrolled = 0;