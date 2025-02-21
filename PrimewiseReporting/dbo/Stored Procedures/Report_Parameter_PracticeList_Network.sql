/*
AUTHOR:						Noel Gourdie (Montage)
CREATE DATE:				21/6/2013
												
 		
*/

CREATE PROCEDURE [dbo].[Report_Parameter_PracticeList_Network]

AS
BEGIN
	SET NOCOUNT ON	



	SELECT P.PracticeID AS Value
		,SurgeryName as Label 
	FROM Practice AS P
	where PracticeID not in(0)
	ORDER BY Label

END