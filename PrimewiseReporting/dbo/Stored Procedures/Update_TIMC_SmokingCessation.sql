Create proc [dbo].[Update_TIMC_SmokingCessation]
as
Declare @Qtr int,@Year int, @Start Date, @QtrEnd date;
Select @Year = Year_no from Stage_Reporting_Year;
Select @Qtr = Quarter_No from Reporting_Quarter; 
set @QtrEnd =
	Case @Qtr
		When 1 then Cast((Cast((@Year - 1) as char(4)) + '-09-30') as date)
		when 2 then Cast((Cast((@Year - 1) as char(4)) + '-12-31') as date)
		When 3 then Cast((Cast((@Year) as char(4)) + '-03-31') as date)
		When 4 then Cast((Cast((@Year) as char(4)) + '-06-30') as date)
	End;  --End of Quarter
Set @Start = Dateadd(day,1,dateadd(month,-15, @QtrEnd));
--Select @Qtr Qtr, @Year 'Year', @Start Start, @QtrEnd QtrEnd;

With OLD_Profile_Smoking
as
(
Select NHI, 1 as Numerator, CessLastScreen
from StaticData.dbo.Stage_Smoking_Register_TIMC_20250106  --change this:  Select * from StaticData.dbo.Stage_Smoking_Register_TIMC_20250106 
where CessLastScreen >= @Start  --all of these will be in numerator
)
--Select * from OLD_Profile_Smoking
--order by CessLastScreen

update i
set i.Numerator_15M_EOQ = p.Numerator, i.CessLastScreen = p.CessLastScreen,
i.Numerator_1 = p.Numerator
from Stage_Smoking_Register as i
	join OLD_Profile_Smoking as p on p.nhi = i.nhi
	where i.PracticeID = 28 and i.Numerator_15M_EOQ = 0; --change this:  practiceID