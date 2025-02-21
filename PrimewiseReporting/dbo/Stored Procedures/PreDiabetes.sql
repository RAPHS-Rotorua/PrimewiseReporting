CREATE Proc [dbo].[PreDiabetes]
as

Declare @Qtr int,@Year int, @QtrEnd Date, @Start Date, @Due_This_Qtr Date, @Due_Next_Qtr Date;
Select @Year = Year_no from Stage_Reporting_Year;
Select @Qtr = Quarter_No from Reporting_Quarter; 
set @QtrEnd =
	Case @Qtr
		When 1 then Cast((Cast((@Year - 1) as char(4)) + '-09-30') as date)
		when 2 then Cast((Cast((@Year - 1) as char(4)) + '-12-31') as date)
		When 3 then Cast((Cast((@Year) as char(4)) + '-03-31') as date)
		When 4 then Cast((Cast((@Year) as char(4)) + '-06-30') as date)
	End;  --End of Quarter
Set @Start = Dateadd(day,1,dateadd(year,-1, @QtrEnd));
Set @Due_This_Qtr = DateAdd(month, -3, @Start);
Set @Due_Next_Qtr = DateAdd(Month, 3, @Start);
--Test
--Select @Qtr Qtr, @Year 'Year', @Start Start, @QtrEnd QtrEnd, @Due_This_Qtr DueThisQtr, @Due_Next_Qtr DueNextQtr;

With Pre_Diabetes_Cohort
as
(Select pc.PracticeID, pc.SurgeryName as Practice, p.NHI, isNull(p.Firstname,'') + ' ' + p.Surname as Patient,p.DOB, p.Ethnicity1Description as Ethnicity, p.Quintile,
p.CellPhone, p.HomePhone, p.EnrolledInPMS, p.ProviderCode as ProvCode, p.DiabetesIndicator, p.Funding,p.LTCEnrolmentIndicator,
	DATEDIFF(Year, p.DOB, @QtrEnd)
	-
	iif(Cast(DateAdd(Year,DATEDIFF(Year, p.DOB, @QtrEnd), p.DOB) as Date) > @QtrEnd,1,0) as Age_QtrEnd,
	pr.HBa1c, pr.[Alb Creat Ratio] as AlbCreatRatio,
		pr.HbA1c_Date, pr.AlbCreat_Date
from patient as p
	join ReportingPatientByPractice as pr on pr.PatientID = p.PatientID
	join Practice as pc on pc.PracticeID = p.PracticeID)
	Select *
	from Pre_Diabetes_Cohort
	where EnrolledInPMS = 'Enrolled' and Age_QtrEnd between 15 and 79
	and HBa1c > 41 and 
	NHI not in(Select distinct NHI from Stage_Dar_Reporting)
	and DiabetesIndicator = 0