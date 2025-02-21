Create procedure [dbo].[RMC_HBa1c_Result_Update]
	as
	with HBa1c_Result
	as
	(Select * from
	(Select NHI, [HbA1c Result], ROW_NUMBER() over(Partition by NHI order by [Screening Date] desc) as row_num
	from rgpgstage.dbo.RMC_Indici_HBa1c) as z
	where row_num = 1
	)
	Update d
	set d.HBa1c = h.[HbA1c Result], 
	d.HbA1c_Bands = Case 
			when [HbA1c Result] <= 64 then '<=64mmol/mol'
			when [HbA1c Result] <= 80 then '<=80mmol/mol'
			when [HbA1c Result] <= 100 then '<=100mmol/mol'
			when [HbA1c Result] > 100 then '>100mmol/mol'
			else 'No Result'
		End,
	d.HBa1c_Bands_sort = Case
			when [HbA1c Result]<= 64 then 1
			when [HbA1c Result] <= 80 then 2
			when [HbA1c Result] <= 100 then 3
			when [HbA1c Result] > 100 then 4
			else 5
		End 
	from Stage_Dar_Reporting as d
		join HBa1c_Result as h on h.NHI = d.NHI
		where d.PracticeID = 17