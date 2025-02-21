--exec rpt_LINCAR_DateParameters '17';

CREATE proc [dbo].[rpt_LINCAR_DateParameters] @PracticeIDs varchar(max)  --drop proc exec Last_DataRefresh
as
Declare  @Start_1_year Date,@Start_3_year Date, @Previous_QtrStart date,  @CX_Period varchar(30), @AgeDate Date, @Qtr int, @Year int, @Financial_Year char(11), 
@Dar_Period varchar(30),
@Qtr_Range varchar(30),  @DataLastUpdated date;
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
Set @Previous_QtrStart = DateAdd(Month,-6,DateAdd(day,1,@AgeDate));
Select @Start_1_Year = DateAdd(day,1,DateAdd(Year,-1, @AgeDate));
Select @Start_3_Year = DateAdd(day,1,DateAdd(Year,-3, @AgeDate));
Set @Qtr_Range = Convert(char(11),DateAdd(Month,-3,DateAdd(day,1,@AgeDate)),106) + ' - ' + Convert(char(11),@AgeDate,106)
Set @Dar_Period = Convert(char(11),@Start_1_Year,106) + ' - ' + Convert(char(11),@AgeDate,106);
Set @CX_Period = Convert(char(11),@Start_3_Year,106) + ' - ' + Convert(char(11),@AgeDate,106);

DECLARE @AuthorisedPracticeIDList TABLE
		(
		PracticeID INT
		)		
	INSERT INTO	@AuthorisedPracticeIDList(PracticeID)
	EXEC [dbo].[Report_GetAuthorisedPracticeIDs];

	--- Get the selected ID's
	DECLARE @SelectedPracticeIDList TABLE
		(
		PracticeID INT
		)		
	INSERT INTO	@SelectedPracticeIDList(PracticeID)
	SELECT NUMBER FROM PrimeWiseReporting.[dbo].[fn_SplitInt] (@PracticeIDs, ',');

Select @DataLastUpdated = max(h.Last_Completed)
from @AuthorisedPracticeIDList AS PID
		INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
	join Stage_LINC_Reporting as h on PID.practiceID = h.PracticeID
	where h.PatientUnenrolled = 0 and h.In_Denominator = 1;

Select Cast(@Qtr as char(1)) as Qtr_No, @Start_1_Year Start_1_Year, @Start_3_year as Start_3_Year,
 @AgeDate  AsAtAge, @Previous_QtrStart as Previous_QtrStart, @Financial_Year as FinancialYear, 
@Qtr_Range as Qtr_Range, @Dar_Period as DAR_Period, @CX_Period as CX_Period, @DataLastUpdated LINCLastUpdated;