CREATE Procedure [dbo].[DIAB_Reporting_Temp_May19_2017] @PracticeIDs VARCHAR(MAX)
as

/*
	Author:  Justin Sherborne
	Date: 19 May 2017

*/	
SET NOCOUNT ON;
	
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

	
	-- find the authorised Practicec IDs
	DECLARE @AuthorisedPracticeIDList TABLE
		(
		PracticeID INT
		)		
	INSERT INTO	@AuthorisedPracticeIDList(PracticeID)
	EXEC [dbo].[Report_GetAuthorisedPracticeIDs]




	--- Get the selected ID's
	DECLARE @SelectedPracticeIDList TABLE
		(
		PracticeID INT
		)		
	INSERT INTO	@SelectedPracticeIDList(PracticeID)
	SELECT NUMBER FROM PrimeWiseReporting.[dbo].[fn_SplitInt] (@PracticeIDs, ',')


	SELECT
		PAT.PracticeID
		,P.SurgeryName
		,NHI
		,Surname
		,Firstname
		,Pat.ProviderCode as Prov  --JS on Jun 17 2015 Added this so that can filter by Prov in the Registers
		,DOB
		,Age
		,Gender
		,isNull(Ethnicity1Description,'Not Stated') as 'Ethnicity1Description'
		,Quintile
		,CellPhone, HomePhone
		,CalculatedLincScore
		,CurrentRecordedLincScore 
	,PBP.DAREnrolmentDate
		,PBP.DARLastCompletedDate
		,PBP.DARNextPlanDate
		,PAT.LTCEnrolmentExpiryDate
		,
	Case
		when isNull(PBP.DARLastCompletedDate,'1900-01-01') >= @Start then 1 else 0 End as In_Numerator,
	Case 
		when PBP.DARLastCompletedDate is null then 'Never Screened'
		when PBP.DARLastCompletedDate < @Due_This_Qtr then 'Overdue'
		When PBP.DARLastCompletedDate >= @Due_This_Qtr and 
			pbp.DARLastCompletedDate < @Start then 'Due This Quarter'
		when PBP.DARLastCompletedDate >= @Start and 
			PBP.DARLastCompletedDate < @Due_Next_Qtr then 'Due Next Quarter'
		When PBP.DARLastCompletedDate >= @Due_Next_Qtr then 'OK'
		else
			'Error - to fix'
	End as Dar_Status,
 	Case 
		when PBP.DARLastCompletedDate is null then 1
		when PBP.DARLastCompletedDate < @Due_This_Qtr then 2
		When PBP.DARLastCompletedDate >= @Due_This_Qtr and 
			pbp.DARLastCompletedDate < @Start then 3
		when PBP.DARLastCompletedDate >= @Start and 
			PBP.DARLastCompletedDate < @Due_Next_Qtr then 4
		When PBP.DARLastCompletedDate >= @Due_Next_Qtr then 5
		else
			6
	End as Dar_Status_Sort
		,LTCEnrolmentIndicator
		,Case 
			when LTCEnrolmentIndicator = 1 and DATEDIFF(day,GetDate(),PAT.LTCEnrolmentExpiryDate) < 0 then 'Expired'
			when LTCEnrolmentIndicator = 1 and DATEDIFF(day,GetDate(),PAT.LTCEnrolmentExpiryDate) < 90 then 'Due To Expire'
			when LTCEnrolmentIndicator = 1 and DATEDIFF(day,GetDate(),PAT.LTCEnrolmentExpiryDate) >= 90 then 'Enrolled'
			else 'Expired'  --changed Sep 8 2014 as 'Not Enrolled' didn't make sense when they had an enrolment date
		End as LTCEnrolmentIndicator_Text,
		Case 
			when LTCEnrolmentIndicator = 1 and DATEDIFF(day,GetDate(),PAT.LTCEnrolmentExpiryDate) < 0 then 3
			when LTCEnrolmentIndicator = 1 and DATEDIFF(day,GetDate(),PAT.LTCEnrolmentExpiryDate) < 90 then 2
			when LTCEnrolmentIndicator = 1 and DATEDIFF(day,GetDate(),PAT.LTCEnrolmentExpiryDate) >= 90 then 1
			else 3  --changed Sep 8 2014 as 'Not Enrolled' didn't make sense when they had an enrolment date
		End as LTCEnrolmentIndicator_Sort
		,'Network' as Network_Group
		,Case PBP.RSReferred
			when 1 then 'Yes'
			else 'No'
		End as RS_Referred
		,PBP.RSAnnaulReviewNextPlanDate
		,PBP.RSAnnualReviewLastCompletedDate
		,PBP.RSAnnualReviewLastExcludedDate
		,PBP.RSEnrolmentDate
		,HBa1c
		,[Alb Creat Ratio]
		,[ACEi or A2]
		,[Diabetes Type]
		,
		Case When HBa1c IS null then 'No Result'
			when HBa1c > 75.00 then '>75'   
			when HBa1c >= 65 then '65-74'
			when HBa1c >= 50 then '50-64'
			else '<50'
		End as HBa1c_Bands
		,
		Case when HBa1c > 75.00 then 1   
			when HBa1c >= 65 then 2
			when HBa1c >= 50 then 3
			when HBa1c < 50 then 4
			else 5
		End as HBa1c_Bands_sort
		,1 as WholeGroup
	FROM @AuthorisedPracticeIDList AS PID
	INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
	INNER JOIN Patient PAT On PAT.PracticeID = PID.PracticeID
	LEFT OUTER JOIN dbo.ReportingPatientByPractice AS PBP ON PBP.PatientId = PAT.PatientId 
	INNER JOIN Practice AS P ON P.PracticeID = PID.PracticeID
	WHERE PAT.DiabetesIndicator = 1 and Pat.Funding = 'Capitated'