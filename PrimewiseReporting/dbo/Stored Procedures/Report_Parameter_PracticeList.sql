/*
AUTHOR:						Noel Gourdie (Montage)
CREATE DATE:				21/6/2013
												
 		
*/

CREATE PROCEDURE [dbo].[Report_Parameter_PracticeList]

AS
BEGIN
	SET NOCOUNT ON	

	
	DECLARE @AuthorisedPracticeIDList TABLE
		(
		PracticeID INT
		)
				
	INSERT INTO	@AuthorisedPracticeIDList(PracticeID)
	EXEC [dbo].[Report_GetAuthorisedPracticeIDs]


	SELECT P.PracticeID AS Value
		,SurgeryName as Label 
	FROM Practice AS P
	INNER JOIN @AuthorisedPracticeIDList AS IDs ON IDs.PracticeId = P.PracticeId
	ORDER BY Label

END