--Test
--exec rpt_DiabetesRegister '15'

CREATE Procedure [dbo].[rpt_UnearnedFunding_Network]  @Month tinyint, @Year smallint
as
SET NOCOUNT ON	

/*
	Author:  Justin Sherborne
	Date: 17 Jul 2014

*/	
Select r.PracticeID,p.SurgeryName, p.SurgeryPrefix, FinancialYearID, YearNo, MonthNo, MonthOrder,
FundingAllocation, Denominator, Numerator, Performance, MeasureTarget, No_Required_To_Target,
Sum(RollingUnearnedTotal) as RollingUnearned, 
Sum(RollingPaidtotal) as RollingPaid FROM 
	RunningUnearned_NoTarget_MonthTotals as r
		left JOIN Practice AS P ON P.PracticeID = r.PracticeID
	where r.YearNo = @Year and r.MonthNo = @Month
	group by r.PracticeID,p.SurgeryName, p.SurgeryPrefix, FinancialYearID, YearNo, MonthNo, MonthOrder,
FundingAllocation, Denominator, Numerator, Performance, MeasureTarget, No_Required_To_Target