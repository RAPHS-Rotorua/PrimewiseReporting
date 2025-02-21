/** 2025-2-21: js added ProviderPaymnet field and edited Status = 'Eligibility criteria not met  **/
CREATE PROCEDURE [dbo].[POAC_DailyServiceDelivery]
	  @PracticeIDs VARCHAR(MAX)
AS
	SET NOCOUNT ON;

	DECLARE @AuthorisedPracticeIDList TABLE (
		  PracticeID INT
	)
	INSERT INTO @AuthorisedPracticeIDList (PracticeID)
	EXEC [dbo].[Report_GetAuthorisedPracticeIDs]
	--- Get the selected ID's
	DECLARE @SelectedPracticeIDList TABLE (
		  PracticeID INT
	)
	INSERT INTO @SelectedPracticeIDList (PracticeID)
	SELECT NUMBER
	FROM PrimeWiseReporting.[dbo].[fn_SplitInt](@PracticeIDs, ',')

	SELECT s.PracticeID
		 , p.SurgeryName AS Practice
		 , s.NHI
		 , s.Firstname + ' ' + s.LastName AS PatientName
		 , s.Code
		 , s.ServiceDescription
		 , s.DateObserved
		 , CAST(s.DateModified AS DATE) AS 'DateModified'
		 , ProviderPayment AS 'Package Fund'
		 , IIF(comment IS NULL, s.ProviderPayment, s.Total) AS 'Total'
		 , CASE
			   WHEN comment IS NOT NULL THEN 'Criteria not met'
			   WHEN comment IS NULL THEN 'Criteria met'
			   ELSE [Status]
		   END AS 'Status'
		 , Comment
		 , HasComment
		 , DateObserved_Date
	FROM @AuthorisedPracticeIDList AS PID
		INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
		INNER JOIN POAC_ServiceDelivery_Daily AS s ON s.PracticeID = PID.PracticeID
		JOIN practice AS p ON p.PracticeID = s.PracticeID

	SET NOCOUNT OFF;