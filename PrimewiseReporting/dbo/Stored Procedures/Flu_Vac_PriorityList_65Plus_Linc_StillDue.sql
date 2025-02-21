CREATE Proc [dbo].[Flu_Vac_PriorityList_65Plus_Linc_StillDue]  @PracticeIDs VARCHAR(MAX)
as
SET NOCOUNT ON;
	
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
Select * from
(
Select p.PracticeID, pr.SurgeryName, p.NHI, p.Firstname + ' ' + p.Surname as Name, p.DOB, p.Gender, e.EthnicGroupDescription as Ethnicity, p.Quintile,
p.ProviderCode,
DATEDIFF(Year,p.DOB, GetDate())
-
	Case
		When Cast(DATEADD(Year,DATEDIFF(Year,p.DOB, GetDate()),p.DOB) as date) > Cast(GetDate() as Date) then 1
		else 0
	End as Age, iif(p.LTCEnrolmentIndicator = 1,'Yes','No') as EnrolledInLINC,
 p.CellPhone, p.HomePhone, p.WorkPhone,isnull(iif(Post_Street='',Null, Post_Street) +', ','') + isnull(iif(Post_Suburb='',Null,Post_Suburb) + ', ','') + 
	isNull(iif(Post_City='',Null,Post_City) +', ','') + 'NZ' as 'Address',
 iif(
 DATEDIFF(Year,p.DOB, GetDate())
-
	Case
		When Cast(DATEADD(Year,DATEDIFF(Year,p.DOB, GetDate()),p.DOB) as date) > Cast(GetDate() as Date) then 1
		else 0
	End >=65,'65 Plus','Less than 65') as '65 Plus'
from 
@AuthorisedPracticeIDList AS PID
	INNER JOIN @SelectedPracticeIDList AS SL ON SL.PracticeID = PID.PracticeID
join Patient as p on p.PracticeID = PID.PracticeID
	join Practice as pr on pr.PracticeID = p.PracticeID
	left join Ethnicity as e on e.EthnicGroupCode = p.Ethnicity1
	Left join FluVaccinations as f on f.NHI = p.NHI
where (EnrolledInPMS = 'enrolled' or Funding = 'Capitated')
and p.PracticeID <> 0 and f.NHI is null
) as z
where (Age >=65 or EnrolledInLINC = 'Yes')
order by DOB;