--This proc only for SQL05 PR as references RGPGStage which is not on SQL06_Inst2
CREATE proc [dbo].[CarriedFWD]
as
with Row_Set
as
(Select 1 as OrderByQtr, 'Q1' as Qtr, Financial_Year, PracticeID
from Stage_Financial as f1
union
Select 2 as OrderByQtr, 'Q2' as Qtr, Financial_Year, PracticeID
from Stage_Financial as f2
union
Select 3 as OrderByQtr, 'Q3' as Qtr, Financial_Year, PracticeID
from Stage_Financial as f3
union
Select 4 as OrderByQtr, 'Q4' as Qtr, Financial_Year, PracticeID
from Stage_Financial as f4
union
Select 5, 'Approved Spending',  Financial_Year, PracticeID
from Stage_Financial as f5
)
--Test
--Select * from Row_Set order by PracticeID, Financial_Year, OrderByQtr
,
Quarterly_Totals
as
(
Select 1 as OrderByQtr, 'Q1' as Qtr,
(Select distinct Qtr_DateRange from Stage_Financial as dr1 where dr1.Financial_Year = f1.Financial_Year and dr1.Quarter_No = 1) as 'QTR_DateRange', 
Financial_Year, PracticeID, Practice,(Select Sum(Quarter_CarryFwd) from Stage_Financial as f2 where f2.PracticeID = f1.PracticeID and 
f2.Financial_Year = f1.Financial_Year and f2.Quarter_No = 1) as Qtr_CarriedFwd
from Stage_Financial as f1
union
Select 2 as OrderByQtr, 'Q2' as Qtr, 
(Select distinct Qtr_DateRange from Stage_Financial as dr2 where dr2.Financial_Year = f3.Financial_Year and dr2.Quarter_No = 2) as 'QTR_DateRange', 
Financial_Year, PracticeID,Practice,(Select Sum(Quarter_CarryFwd) from Stage_Financial as f4 where f4.PracticeID = f3.PracticeID and 
f4.Financial_Year = f3.Financial_Year and f4.Quarter_No = 2) as Qtr_CarriedFwd
from Stage_Financial as f3
union
Select 3 as OrderByQtr, 'Q3' as Qtr, 
(Select distinct Qtr_DateRange from Stage_Financial as dr3 where dr3.Financial_Year = f5.Financial_Year and dr3.Quarter_No = 3) as 'QTR_DateRange', 
Financial_Year, PracticeID, Practice,(Select Sum(Quarter_CarryFwd) from Stage_Financial as f6 where f6.PracticeID = f5.PracticeID and 
f6.Financial_Year = f5.Financial_Year and f6.Quarter_No = 3) as Qtr_CarriedFwd
from Stage_Financial as f5
union
Select 4 as OrderByQtr, 'Q4' as Qtr, 
(Select distinct Qtr_DateRange from Stage_Financial as dr4 where dr4.Financial_Year = f7.Financial_Year and dr4.Quarter_No = 4) as 'QTR_DateRange', 
Financial_Year, PracticeID, Practice,(Select Sum(Quarter_CarryFwd) from Stage_Financial as f8 where f8.PracticeID = f7.PracticeID and 
f8.Financial_Year = f7.Financial_Year and f8.Quarter_No = 4) as Qtr_CarriedFwd
from Stage_Financial as f7
union
Select 5 , 'Approved Spending', dr5.Qtr_DateRange,  fp.Financial_Year, fp.PracticeID,dr5.Practice, Sum(PaymentAmount_GSTExcl)
from RGPGStage.dbo.Stage_Financial_Payments as fp	
join (Select distinct PracticeID, Practice, Financial_Year, Quarter_No, Qtr_DateRange from Stage_Financial) as dr5 on dr5.Financial_Year = fp.Financial_Year 
		and dr5.Quarter_No = fp.Quarter_No and dr5.PracticeID = fp.PracticeID
where PaymentType = 'Quality Plan Approved Spending'
group by dr5.Qtr_DateRange, fp.Financial_Year, fp.PracticeID, dr5.Practice
)
--Test
--Select * from Quarterly_Totals order by PracticeID, Financial_Year, OrderByQtr
Select r.*, q.QTR_DateRange, q.Qtr_CarriedFwd
from Row_Set as r
	left join Quarterly_Totals as q on q.Financial_Year = r.Financial_Year and q.PracticeID = r.PracticeID and r.OrderByQtr = q.OrderByQtr