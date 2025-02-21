Create proc [dbo].[Update_KAHC_LINCAR]
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
--Select @Qtr Qtr, @Year 'Year', @Start Start, @QtrEnd QtrEnd, @Due_This_Qtr DueThisQtr, @Due_Next_Qtr DueNextQtr;
with LINCAR_OLD_Profile
as
(
Select NHI, iif(Last_Completed >= @Start,1,0) as 'Numerator', Last_Completed,
	Case
		when LTC_Status = 'Deceased' then 'Deceased'
		when Last_Completed is null then 'Never Screened'
		when Last_Completed < @Due_This_Qtr then 'Overdue'
		When Last_Completed >= @Due_This_Qtr and 
			Last_Completed < @Start then 'Due This Quarter'
		when Last_Completed>= @Start and 
			Last_Completed < @Due_Next_Qtr then 'Due Next Quarter'
		When Last_Completed >= @Due_Next_Qtr then 'OK'
		else
			'Error - to fix'
	End as LINCAR_Status_New,
 	Case 
		when LTC_Status = 'Deceased' then 6 
		when Last_Completed is null then 1
		when Last_Completed < @Due_This_Qtr then 2
		When Last_Completed >= @Due_This_Qtr and 
			Last_Completed < @Start then 3
		when Last_Completed >= @Start and 
			Last_Completed < @Due_Next_Qtr then 4
		When Last_Completed >= @Due_Next_Qtr then 5
		else
			7
	End as LINCAR_Status_Sort_New
from
(Select
row_number() over(partition by NHI order by Last_Completed desc) as row_num, *
from
(
Select NHI, [DAR Last Completed] as Last_Completed, Dar_Status as LTC_STatus
from StaticData.dbo.Stage_DAR_Reporting_KAHC_20240122
where [DAR Last Completed] is not null
union all
Select NHI, Last_Completed, LTC_Status
from StaticData.dbo.Stage_LINC_Reporting_KAHC_20240122
where Last_Completed is not null
) as z) as x
where row_num = 1)

	update i
	set i.In_Numerator = p.Numerator, 
		i.LTC_Status = iif(i.LTC_Status <> 'Deceased', p.LINCAR_Status_New, i.LTC_Status), 
			 i.LTC_Status_sort = iif(i.LTC_Status <> 'Deceased', p.LINCAR_Status_Sort_New, i.LTC_Status_sort),
				i.Last_Completed = p.Last_Completed
	from Stage_LINC_Reporting as i  
		join LINCAR_OLD_Profile as p on p.NHI = i.NHI 
		where i.PracticeID = 30 and i.In_Numerator = 0 and p.Numerator = 1;