--Exec rpt_MoreHeartandDiabetes '30','Total Population'
CREATE Procedure [dbo].[rpt_MoreHeartandDiabetes] @PracticeIDs VARCHAR(MAX), @CVD_Cohort varchar(50)
as
SET NOCOUNT ON	

/*
	Author:  Justin Sherborne
	Date: 14 Nov 2016
*/	
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

Declare  @Start_5_year Date, @AgeDate Date, @Qtr int
Select @Qtr = Max(Quarter_No) from Reporting_Quarter; --Note this table copied to PR now
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
Select @Start_5_Year = DateAdd(day,1,DateAdd(Year,-5, @AgeDate));

with HBA1c
as
(Select * from
(Select NHI,p.PracticeID, HBa1c,
row_number() over(Partition by NHI order by HBa1c desc) as row_num
from Patient as p
	join ReportingPatientByPractice as r on r.PatientID = p.PatientID
	where 
	--Funding = 'Capitated' and   --Removed this on 15 Feb 2017 as was omitting Ruatahi -- Don't think we need to check if Capitated
	HBa1c is not null) as t
	where row_num = 1)

Select pr.SurgeryName as Practice, h.HBa1c,
Case 
	when Category = 'Presumptive Risk' then 'Presumptive Risk'
	when Category = 'Virtual Screen' then 'RAPHS Virtual Screen'
	when CVDRisk_Bands in('20-25','25-30','>=30') then '>=20 CVD Risk'
	when CVDRisk_Bands in('15-20') then '15-19 CVD Risk'
	when CVDRisk_Bands in('10-15') then '10-14 CVD Risk'
	when CVDRisk_Bands in('<2.5','2.5-5','5-10') then '<10 CVD Risk'
	else 'Invalid Risk Recorded'
End as CVD_Group,
Cast(Case 
	when Category = 'Presumptive Risk' then 1
	when Category = 'Virtual Screen' then 6
	when CVDRisk_Bands in('20-25','25-30','>=30') then 2
	when CVDRisk_Bands in('15-20') then 3
	when CVDRisk_Bands in('10-15') then 4
	when CVDRisk_Bands in('<2.5','2.5-5','5-10') then 5
	else 7
End as int) as CVD_Group_Sort,
Case 
	when Category = 'Presumptive Risk' then 'Established CVD'
	when Category = 'Virtual Screen' then 'RAPHS Virtual Screen'
	when CVDRisk_Bands_2018 in('> 15') then '> 15 Percent CVD Risk'
	when CVDRisk_Bands_2018 in('5-15') then '5-15 Percent CVD Risk'
	when CVDRisk_Bands_2018 in('< 5') then '< 5 Percent CVD Risk'
	else 'Invalid Risk Recorded'
End as CVD_Group_2018,
Cast(Case 
	when Category = 'Presumptive Risk' then 1
	when Category = 'Virtual Screen' then 6
	when CVDRisk_Bands_2018 in('> 15') then 2
	when CVDRisk_Bands_2018 in('5-15') then 3
	when CVDRisk_Bands_2018 in('< 5') then 4
	else 7
End as int) as CVD_Group_Sort_2018,
Case
	When Gender = 'M' and Age_As_At between 35 and 44 and Eth1 = 21 then 'Maori Men 35-44'
	else 'Total Population'
End as CVD_cohort,
Case
	when c.LastScreen is null then 'Never Screened'
	When c.CVDRA_Status = 'Due' then 'Overdue'
	else c.CVDRA_Status
End as 'Screen_Status',
 c.*
from
@AuthorisedPracticeIDList AS PID
		INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
 join Stage_CVDRA_Report as c on c.PracticeID = PID.PracticeID
	left join Practice as pr on pr.PracticeID = c.PracticeID
	left join HBA1c as h on h.NHI = c.NHI and h.PracticeID = c.PracticeID
	where 
	c.PatientUnenrolled = 0 
	and
	(Case
	When Gender = 'M' and Age_As_At between 35 and 44 and Eth1 = 21 then 'Maori Men 35-44'
	else 'Total Population'
End = @CVD_Cohort or @CVD_Cohort = 'Total Population')