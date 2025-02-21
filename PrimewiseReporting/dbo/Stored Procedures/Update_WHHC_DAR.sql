CREATE proc [dbo].[Update_WHHC_DAR]
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
with OLD_PMS_DAR
as
(
Select NHI, iif([DAR Last Completed] >= @Start,1,0) as 'Numerator', [DAR Last Completed],
	Case
		when Dar_Status = 'Deceased' then 'Deceased'
		when [DAR Last Completed] is null then 'Never Screened'
		when [DAR Last Completed] < @Due_This_Qtr then 'Overdue'
		When [DAR Last Completed] >= @Due_This_Qtr and 
			[DAR Last Completed] < @Start then 'Due This Quarter'
		when [DAR Last Completed] >= @Start and 
			[DAR Last Completed] < @Due_Next_Qtr then 'Due Next Quarter'
		When [DAR Last Completed] >= @Due_Next_Qtr then 'OK'
		else
			'Error - to fix'
	End as Dar_Status_New,
 	Case 
		when Dar_Status = 'Deceased' then 6 
		when [DAR Last Completed] is null then 1
		when [DAR Last Completed] < @Due_This_Qtr then 2
		When [DAR Last Completed] >= @Due_This_Qtr and 
			[DAR Last Completed] < @Start then 3
		when [DAR Last Completed] >= @Start and 
			[DAR Last Completed] < @Due_Next_Qtr then 4
		When [DAR Last Completed] >= @Due_Next_Qtr then 5
		else
			7
	End as Dar_Status_Sort_New
 from StaticData.dbo.Stage_DAR_Reporting_WHHC_20240620 --Select  from StaticData.dbo.Stage_DAR_Reporting_WHHC_20240620
)
update i
	set i.In_Numerator = iif(i.In_Numerator = 0 and p.Numerator = 1,p.Numerator, i.In_Numerator),
		i.Dar_Status = iif(i.Dar_Status <> 'Deceased' and i.[DAR Last Completed] is null, p.Dar_Status_New, i.Dar_Status),
			 i.Dar_Status_sort = iif(i.Dar_Status <> 'Deceased' and i.[DAR Last Completed] is null, p.Dar_Status_Sort_New, i.Dar_Status_Sort),
				i.[DAR Last Completed] = iif(i.[DAR Last Completed] is null,p.[DAR Last Completed],i.[DAR Last Completed])
	from Stage_DAR_Reporting as i 
		join OLD_PMS_DAR as p on p.NHI = i.NHI
		where i.PracticeID = 8;