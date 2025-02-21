CREATE Procedure [dbo].[LINC_Score] @PracticeIDs VARCHAR(MAX)
as
SET NOCOUNT ON	

/*
	Author:  Justin Sherborne
	Date: 5 Sep 2017
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

Select
		Case
			when CalculatedLINCScore is Null or try_convert(decimal(5,2),CalculatedLINCScore)  = 0 then 'Self Managing'
			when try_convert(decimal(5,2),CalculatedLINCScore) < 5 then 'Low'
			when try_convert(decimal(5,2),CalculatedLINCScore) < 13 then 'Medium'
			when try_convert(decimal(5,2),CalculatedLINCScore) < 30 then 'High'
			when try_convert(decimal(5,2),CalculatedLINCScore) >= 30 then 'Peak'
			else 'Error ##'
		End as LincScore_Band,
		Case
			when CalculatedLINCScore is Null or try_convert(decimal(5,2),CalculatedLINCScore)  = 0 then 1
			when try_convert(decimal(5,2),CalculatedLINCScore) < 5 then 2
			when try_convert(decimal(5,2),CalculatedLINCScore) < 13 then 3
			when try_convert(decimal(5,2),CalculatedLINCScore) < 30 then 4
			when try_convert(decimal(5,2),CalculatedLINCScore) >= 30 then 5
			else 6
		End as LincScore_Sort,
		count(*) as Total_No_Rows,
		Cast(Count(*) as decimal(10,2))/
		Cast((Select count(*) from
		@AuthorisedPracticeIDList AS PID2
		INNER JOIN @SelectedPracticeIDList AS SL2 ON SL2.PracticeID = PID2.PracticeID
		 join Patient as p2 on p2.PracticeID = PID2.PracticeID
		 join reportingpatientbypractice as rp2 on rp2.patientID = p2.PatientID 
		where p2.EnrolledInPMS = 'Enrolled' and isNull(CalculatedLINCScore,0) > 0) as decimal(10,2)) as Percent_Calc
		,(Select count(*) from
		@AuthorisedPracticeIDList AS PID2
		INNER JOIN @SelectedPracticeIDList AS SL2 ON SL2.PracticeID = PID2.PracticeID
		 join Patient as p2 on p2.PracticeID = PID2.PracticeID
		 join reportingpatientbypractice as rp2 on rp2.patientID = p2.PatientID 
		where p2.EnrolledInPMS = 'Enrolled' and isNull(CalculatedLINCScore,0) > 0) as Total_EnrolledPatients
		from @AuthorisedPracticeIDList AS PID
		INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID	
		join Patient PAT on PAT.PracticeID = PID.PracticeID
	LEFT OUTER JOIN dbo.ReportingPatientByPractice AS PBP ON PBP.PatientId = PAT.PatientId 
	INNER JOIN Practice AS P ON P.PracticeID = PAT.PracticeID
	where PAT.EnrolledInPMS = 'Enrolled' --Only interested in enrolled for this as it is not a measure
	and 		isNull(Calculatedlincscore,0) > 0
		group by
		Case
			when CalculatedLINCScore is Null or try_convert(decimal(5,2),CalculatedLINCScore) = 0 then 'Self Managing'
			when try_convert(decimal(5,2),CalculatedLINCScore) < 5 then 'Low'
			when try_convert(decimal(5,2),CalculatedLINCScore) < 13 then 'Medium'
			when try_convert(decimal(5,2),CalculatedLINCScore) < 30 then 'High'
			when try_convert(decimal(5,2),CalculatedLINCScore) >= 30 then 'Peak'
			else 'Error ##'
		End ,
				Case
			when CalculatedLINCScore is Null or try_convert(decimal(5,2),CalculatedLINCScore)  = 0 then 1
			when try_convert(decimal(5,2),CalculatedLINCScore) < 5 then 2
			when try_convert(decimal(5,2),CalculatedLINCScore) < 13 then 3
			when try_convert(decimal(5,2),CalculatedLINCScore) < 30 then 4
			when try_convert(decimal(5,2),CalculatedLINCScore) >= 30 then 5
			else 6
		End