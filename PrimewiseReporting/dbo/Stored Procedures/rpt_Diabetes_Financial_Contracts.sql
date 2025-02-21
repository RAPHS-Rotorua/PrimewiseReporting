CREATE Procedure [dbo].[rpt_Diabetes_Financial_Contracts] @PracticeIDs VARCHAR(MAX)
	as
	
	/*
	Note we need to update the temp table Temp_HBa1Results_ByPractice_Current for the HBA1C results
	for each quarter.  we are currently keeping a history of these tables at the moment
	*/
	
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
	
	DECLARE @FiscalYearKey INT  
			,@FiscalQuarterKey INT  
			,@CalendarDateKey INT
	
	SET @FiscalYearKey = (SELECT MAX(FiscalYearKey) FROM dbo.ReportingRaphsSummary)
	SET @FiscalQuarterKey = (SELECT MAX(FiscalQuarterKey) FROM dbo.ReportingRaphsSummary WHERE FiscalYearKey  = @FiscalYearKey)

	SET @CalendarDateKey = (SELECT MAX(DateKey) 
							FROM dbo.Calendar AS C
							INNER JOIN dbo.ReportingPracticeByContract AS PBC ON PBC.CalendarDateKey = c.DateKey
							WHERE FiscalQuarter = @FiscalQuarterKey AND FiscalYear = CAST(@FiscalYearKey AS VARCHAR(4)))

--Get the Total_DIAB_06QuarterlyPatientcount
Declare @DIAB_06_PatientCount int
Set @DIAB_06_PatientCount = (Select MAX(Total) as Total_DIAB_06_Count
from Temp_HBa1Results_ByPractice_Current) 
--select * from Temp_HBa1Results_ByPractice_Current
Declare @DIAB_MMC_PatientCount int
Set @DIAB_MMC_PatientCount = (Select SUM(QuaterlyDiabeticpatientCount) as Total_DIAB_MMC_Count
from ReportingPracticeByContract
where ContractCode = '348553/02')

Declare @DIAB_PatientCount int
Set @DIAB_PatientCount = (Select SUM(QuaterlyDiabeticpatientCount) as Total_DIAB_Count
from ReportingPracticeByContract
where ContractCode = '328875/07a')

--Test  Select Sum(DiabeticPatientCount) + 120 from rgpgstage.Lookup.LookupCapitatedPatients where PracticeID = 30 and FiscalYear = 2014 and FiscalQuarter = 4

--Select * from ReportingPracticeByContract where ContractCode = 'DIAB_MMC'

SELECT --PBC.PracticeId
		ContractCode
		, Case 
			when ContractCode = '328875/07a' then 'Diabetes Management Services (DAR Funding) - Contract 328875'
			When ContractCode = '328875/07b' then 'Diabetes Management Services (DCIP Funding) - Contract 328875'
			When ContractCode = '348553/02' then 'Long Term Conditions Management Programme - Contract 348553'
		  End as ContractDescription
		,'P' +  RIGHT('00' + CAST(PBC.PracticeID AS VARCHAR(2)), 2) AS PracticeId
		,P.SurgeryName
		,'Incentive' as PaymentType
		,
		Case when ContractCode = '328875/07b' 
			then isnull((Select NoHBa1c_Above_75 from Temp_HBa1Results_ByPractice_Current where PracticeID = PBC.PracticeID),0)
			else
				PBC.QuaterlyDiabeticPatientCount 
			end as 'QuaterlyDiabeticPatientCount'
		,CASE WHEN ISNULL(SD.QuarterlyDiabeticPatientCount, 0) = 0 THEN 0 ELSE (CAST(
		ISNULL(
		Case when ContractCode = '328875/07b' 
			then (Select NoHBa1c_Above_75 from Temp_HBa1Results_ByPractice_Current where PracticeID = PBC.PracticeID)
			else
				PBC.QuaterlyDiabeticPatientCount 
			end
			, 0) AS NUMERIC(18,2))/
		Case ContractCode 
			when '328875/07a' then @DIAB_PatientCount
			when '328875/07b' then @DIAB_06_PatientCount
			when '348553/02' then @DIAB_MMC_PatientCount
		END)
		End AS DiabeticPercentSplit
		,CASE WHEN ISNULL(SD.QuarterlyDiabeticPatientCount, 0) = 0 THEN 0 ELSE 
		(CAST(
		ISNULL(
		Case when ContractCode = '328875/07b' 
			then (Select NoHBa1c_Above_75 from Temp_HBa1Results_ByPractice_Current where PracticeID = PBC.PracticeID)
			else
				PBC.QuaterlyDiabeticPatientCount 
			end
		, 0) AS NUMERIC(18,2))/
		Case ContractCode 
			when '328875/07a' then @DIAB_PatientCount
			when '328875/07b' then @DIAB_06_PatientCount
			when '348553/02' then @DIAB_MMC_PatientCount
		END)  END 
			* 
		Case ContractCode 
			when '328875/07a' then SD.QuarterlyDIABIncentivePool
			when '328875/07b' then SD.QuarterlyDIAB_06IncentivePool
			when '348553/02' then SD.QuarterlyDIAB_MMCIncentivePool
		END
		  AS QuarterlyAllocation		
		,CASE WHEN ISNULL(SD.QuarterlyDiabeticPatientCount, 0) = 0 THEN 0 ELSE 
		(CAST(
		ISNULL(
		Case when ContractCode = '328875/07b' 
			then (Select NoHBa1c_Above_75 from Temp_HBa1Results_ByPractice_Current where PracticeID = PBC.PracticeID)
			else
				PBC.QuaterlyDiabeticPatientCount 
			end
		, 0) AS NUMERIC(18,2))/
		Case ContractCode 
			when '328875/07a' then @DIAB_PatientCount
			when '328875/07b' then @DIAB_06_PatientCount
			when '348553/02' then @DIAB_MMC_PatientCount
		END)  END  
			* 
		Case ContractCode 
			when '328875/07a' then SD.QuarterlyDIABIncentivePool
			when '328875/07b' then SD.QuarterlyDIAB_06IncentivePool
			when '348553/02' then SD.QuarterlyDIAB_MMCIncentivePool
		END /3 AS MonthlyAllocation
	FROM @AuthorisedPracticeIDList AS PID
	INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
	INNER JOIN Practice AS P ON P.PracticeID = PID.PracticeID
	INNER JOIN dbo.ReportingPracticeByContract AS PBC ON PBC.PracticeID = PID.PracticeId
	CROSS JOIN dbo.ReportingRaphsSummary AS SD
	WHERE PBC.CalendarDateKey = @CalendarDateKey
	AND SD.FiscalYearKey = @FiscalYearKey
	AND SD.FiscalQuarterKey = @FiscalQuarterKey
	And ContractCode in('328875/07a','328875/07b','348553/02')
Union
	SELECT --PBC.PracticeId
		ContractCode
		, Case 
			when ContractCode = '328875/07a' then 'Diabetes Management Services (DAR Funding) - Contract 328875'
			When ContractCode = '348553/02' then 'Long Term Conditions Management Programme - Contract 348553'
		  End as ContractDescription
		,'P' +  RIGHT('00' + CAST(PBC.PracticeID AS VARCHAR(2)), 2) AS PracticeId
		,P.SurgeryName
		,'Base' as PaymentType
		,PBC.QuaterlyDiabeticPatientCount 
		,CASE WHEN ISNULL(SD.QuarterlyDiabeticPatientCount, 0) = 0 THEN 0 ELSE (CAST(ISNULL(PBC.QuaterlyDiabeticPatientCount, 0) AS NUMERIC(18,2))/
		Case ContractCode 
			when '328875/07a' then @DIAB_PatientCount
			when '348553/02' then @DIAB_MMC_PatientCount
		END)
		End AS DiabeticPercentSplit
		,CASE WHEN ISNULL(SD.QuarterlyDiabeticPatientCount, 0) = 0 THEN 0 ELSE (CAST(ISNULL(PBC.QuaterlyDiabeticPatientCount, 0) AS NUMERIC(18,2))/
		Case ContractCode 
			when '328875/07a' then @DIAB_PatientCount
			when '348553/02' then @DIAB_MMC_PatientCount
		END)  END 
			* 
		Case ContractCode 
			when '328875/07a' then SD.QuaterlyDiabetesFundingPool
			when '348553/02' then SD.QuarterlyDIAB_MMCFundingPool
		END
		  AS QuarterlyAllocation		
		,CASE WHEN ISNULL(SD.QuarterlyDiabeticPatientCount, 0) = 0 THEN 0 ELSE (CAST(ISNULL(PBC.QuaterlyDiabeticPatientCount, 0) AS NUMERIC(18,2))/
		Case ContractCode 
			when '328875/07a' then @DIAB_PatientCount
			when '348553/02' then @DIAB_MMC_PatientCount
		END)  END 
			* 
		Case ContractCode 
			when '328875/07a' then SD.QuaterlyDiabetesFundingPool
			when '348553/02' then SD.QuarterlyDIAB_MMCFundingPool
		END /3 AS MonthlyAllocation
	FROM @AuthorisedPracticeIDList AS PID
	INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
	INNER JOIN Practice AS P ON P.PracticeID = PID.PracticeID
	INNER JOIN dbo.ReportingPracticeByContract AS PBC ON PBC.PracticeID = PID.PracticeId
	CROSS JOIN dbo.ReportingRaphsSummary AS SD
	WHERE PBC.CalendarDateKey = @CalendarDateKey
	AND SD.FiscalYearKey = @FiscalYearKey
	AND SD.FiscalQuarterKey = @FiscalQuarterKey
	And ContractCode in('328875/07a','348553/02')