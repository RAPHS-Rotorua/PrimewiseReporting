/*
AUTHOR:						Noel Gourdie (Montage)
CREATE DATE:				21/6/2013
												
 		
*/

CREATE PROCEDURE [dbo].[Report_GetAuthorisedPracticeIDs]

AS
BEGIN
	SET NOCOUNT ON	

	-- GET Practice IDs
	SELECT PracticeID
	FROM ReportingPracticeConnectionInformation
	WHERE IS_MEMBER(ADUserGroup) = 1 
	
END