CREATE proc [dbo].[RMC_CX_Update]
as
Declare @Start_3_Year Date, @Start_5_year Date,@DueNextQtr_Date Date;
Declare @Start Date,@End Date, @AgeDate Date, @Qtr int, @Year smallint;
Select @Year = Year_no from RGPGStage.dbo.Stage_Reporting_Year
Select @Qtr = Quarter_No from RGPGStage.dbo.Reporting_Quarter; 
set @AgeDate =
	Case @Qtr
		When 1 then Cast((Cast((@Year - 1) as char(4)) + '-09-30') as date)
		when 2 then Cast((Cast((@Year - 1) as char(4)) + '-12-31') as date)
		When 3 then Cast((Cast((@Year) as char(4)) + '-03-31') as date)
		When 4 then Cast((Cast((@Year) as char(4)) + '-06-30') as date)
	End;  --End of Quarter
Select @Start_3_Year = DateAdd(day,1,DateAdd(Year,-3, @AgeDate))
Select @DueNextQtr_Date = DateAdd(Month,3,@Start_3_Year); 
Select @Start_5_Year = DateAdd(day,1,DateAdd(Year,-5, @AgeDate));
Select @Start = DateAdd(day,1,DateAdd(Year,-3,@AgeDate)), @End =  DateAdd(day,1,@AgeDate);
--Select @Qtr Qtr, @Year YearNum, @Start Start,@Start_3_Year Start_3_Year, @End as EndDate, @DueNextQtr_Date DueNextQtr_Date, @AgeDate  Age_As_At_Date, Month(GetDate()) MonthNum;
With RMC_CX
as
(Select * from
(
Select distinct ltrim(rtrim(NHI)) as 'NHI', try_Convert(date, Right(ltrim(rtrim([Screening Date])),4) +'-'+ substring(ltrim(rtrim([Screening Date])),4,2) + '-' + 
left(ltrim(rtrim([Screening Date])),2)) as ScreeningDate, [Screening date],
row_Number() over(partition by ltrim(rtrim(NHI)) order by
try_Convert(date, Right(ltrim(rtrim([Screening Date])),4) +'-'+ substring(ltrim(rtrim([Screening Date])),4,2) + '-' + 
left(ltrim(rtrim([Screening Date])),2))  desc) as row_num
 from rgpgstage.[dbo].[RMC_Indici_CX]
) as z
where row_num = 1
)
update r
set r.CX_Status =
Case 
		when 
			(Select Max(v) from (Values(x.ScreeningDate), (r.Last_Screen)) as value(v)) >= @Start_3_Year
			and (Select Max(v) from (Values(x.ScreeningDate), (r.Last_Screen)) as value(v)) < @DueNextQtr_Date then	
		'Due Next Qtr'
		when r.Last_Screen 
				>= @Start_3_Year or x.ScreeningDate >= @Start_3_Year
			then 'Complete'
		else
			'Overdue' 
	End,
	In_Numerator_All = iif(r.Last_Screen >= @Start_3_Year or x.ScreeningDate >= @Start_3_Year, 1, 0),
	r.PMS_LastScreen = x.ScreeningDate,
	r.Last_Screen = (Select Max(v) from (Values(x.ScreeningDate), (r.Last_Screen)) as value(v)),
	Data_Origin = iif(x.ScreeningDate > r.Collections_Last_Screen,'PMS',r.Data_Origin)
from Stage_CX_Reporting as r
	join RMC_CX as x on x.NHI = r.NHI --inner join ok as just updating those in RMC_CX
	where r.PracticeID = 17