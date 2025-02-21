CREATE Procedure [dbo].[Appt_Measures_DateParameters]
as
Declare @Qtr int, @Year int, @Financial_Year char(11), @AgeDate date,
@ReportFilterDate date, @Today date,
@Qtr_Range varchar(30), @NextQtr_Range varchar(30), 
@DataLastUpdated date;
Select @Today = Cast(GetDate() as date); 
Select @ReportFilterDate = Cast(Case Datepart(dw,@Today)
	when 1 then DateAdd(day,-6,@Today)
	when 2 then @Today
	when 3 then DateAdd(day,-1,@Today)
	when 4 then DateAdd(day,-2,@Today)
	when 5 then DateAdd(day,-3,@Today)
	when 6 then DateAdd(day,-4,@Today)
	when 7 then DateAdd(day,-5,@Today)
	End as Date)
Select @Year = Max(Year_no) from Stage_reporting_Year;
Select @Qtr = Max(Quarter_No) from Reporting_Quarter; 
set @Financial_Year = Cast((@Year - 1) as char(4)) + ' - ' + Cast(@Year as char(4))
set @AgeDate =  --Age at end of quarter
	Case @Qtr
		When 1 then Cast((Cast(Year(GetDate()) as char(4)) + '-09-30') as date)
		when 2 then
			case when Month(GetDate()) = 1 then
				Cast((Cast((Year(GetDate()) - 1) as char(4)) + '-12-31') as date)
			else
				Cast((Cast(Year(GetDate()) as char(4)) + '-12-31') as date)
			End
		When 3 then Cast((Cast(Year(GetDate()) as char(4)) + '-03-31') as date)
		When 4 then Cast((Cast(Year(GetDate()) as char(4)) + '-06-30') as date)
	End;  --Start of Quarter
Set @Qtr_Range = Convert(char(11),DateAdd(Month,-3,DateAdd(day,1,@AgeDate)),106) + ' - ' + Convert(char(11),@AgeDate,106);
Set @NextQtr_Range = Convert(char(11),DateAdd(day,1,@AgeDate),106) + ' - ' + Convert(char(11),EOMonth(DateAdd(Month,2,DateAdd(day,1,@AgeDate))),106)
Select @DataLastUpdated = Max(DateStamp) from Appointment_Measurement_Report_Data ;  --Need to update this to pick up last refresh of appointment book
Select Cast(@Qtr as char(1)) as Qtr_No,@Today as Todays_Date,  @ReportFilterDate as ReportFilterDate,
 @AgeDate  AsAtAge, @Financial_Year as FinancialYear, 
@Qtr_Range as Qtr_Range, @NextQtr_Range as Next_Qtr_Range, @DataLastUpdated DataLastUpdated;