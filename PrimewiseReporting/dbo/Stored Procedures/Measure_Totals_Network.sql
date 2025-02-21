CREATE Procedure [dbo].[Measure_Totals_Network]  @Month tinyint, @Year smallint
as
SET NOCOUNT ON	
/*
	Author:  Justin Sherborne
	Date: 31_May_2019
*/	


 Select 

 p.PracticeID,YearNo, MonthNo, FundingAllocationGroup as MeasureGroup,p.FundingAllocationID, Allocation as Measure, Max(Performance) as Performance, 
 Max(Performance_PreviousMonth) as PerformancePreviousMonth,
 Max(MeasureTarget) as [Target], Max(BaseTarget) as BaseTarget,
 Sum(p.PracticeBaseInitialMax) as FlexibleFundingAvailable,
 Sum(PracticeMaxGrandTotal) as AvailableFunding, Sum(PracticeEarnedBase) as FlexibleFundingEarned, 
  Sum(p.PracticeBaseInitialMax) - Sum(PracticeEarnedBase) as FlexibleFundingUnearned,
  Sum(p.PracticeIncentiveInitialMax) as IncentiveInitialAvailable,
 Sum(p.PracticeIncentiveFinalMax)  as IncentiveFinalAvailable,
 Sum(PracticeEarnedIncentive) as IncentiveFundingEarned,
 Sum(PracticeEarnedBase + PracticeEarnedIncentive) as TotalFundingEarned,Sum(PracticeUnearnedTotal) as MonthlyUnearnedTotal,
Sum(p.QuarterlyUnearnedAvailable) as QuarterlyUnearnedAvailable,
Sum(p.QuarterlyUnearnedAchieved) as QuarterlyUnearnedAchieved
 from 
FundingPayment as p
 where YearNo = @Year and MonthNo = @Month
 group by p.PracticeID, YearNo, MonthNo, FundingAllocationGroup,p.FundingAllocationID, Allocation
 order by MeasureGroup, FundingAllocationID