Create procedure [dbo].[RMC_CVDRisk_Update]
	as
	with CVD_Result
	as
	(Select * from
	(Select [Patient NHI Number] as NHI, [MeasurementDetail Result] as CVDRisk_Text,
	--RemoveChars only works as don't have for e.g. 5-10.  Only have >20 etc which is ok to strip out >.  If stripped out - might get 510 - Need to check this
	try_cast(rgpgstage.dbo.RemoveChars_CVD([MeasurementDetail Result]) as decimal(8,2)) as CVDRisk,  
	 ROW_NUMBER() over(Partition by [Patient NHI Number] order by [Measurements Screening Date] desc) as row_num
	from rgpgstage.dbo.RMC_Indici_CVDRisk) as z
	where row_num = 1
	)
	Update d
	set d.CVDRisk_Text = c.CVDRisk_Text, d.CVDRisk = c.CVDRisk,
	d.CVDRisk_Bands = 
	Case 
	when c.cvdRisk IS null then 'Not Recorded'
	When c.cvdRisk < 2.5 then '<2.5'
	When c.cvdRisk < 5 then '2.5-5'
	When c.cvdRisk < 10 then '5-10'
	When c.cvdRisk < 15 then '10-15'
	When c.cvdRisk < 20 then '15-20'
	When c.cvdRisk < 25 then '20-25'
	When c.cvdRisk < 30 then '25-30'
	When c.cvdRisk >=30 then '>=30'
End,
d.CVDRisk_Bands_Sort =
Case 
	when c.cvdRisk IS null then '9'
	When c.cvdRisk < 2.5 then 1
	When c.cvdRisk < 5 then 2
	When c.cvdRisk < 10 then 3
	When c.cvdRisk < 15 then 4
	When c.cvdRisk < 20 then 5
	When c.cvdRisk < 25 then 6
	When c.cvdRisk < 30 then 7
	When c.cvdRisk >=30 then 8
End
	from Stage_CVDRA_Report as d
		join CVD_Result as c on c.NHI = d.NHI
		where d.PracticeID = 17