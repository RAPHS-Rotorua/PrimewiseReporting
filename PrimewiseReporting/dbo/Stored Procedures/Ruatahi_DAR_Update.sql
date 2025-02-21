Create proc [dbo].[Ruatahi_DAR_Update]
aS
update d
set 
	d.In_Numerator = iif(d2.In_Numerator = 1,1,d.In_Numerator),
	d.Dar_Status = iif(isnull(d2.[DAR Last Completed],'1900-01-01') >  isnull(d.[DAR Last Completed],'1900-01-01'),d2.Dar_Status, d.Dar_Status),
	d.Dar_Status_Sort = iif(isnull(d2.[DAR Last Completed],'1900-01-01') >  isnull(d.[DAR Last Completed],'1900-01-01'),d2.Dar_Status_sort, d.Dar_Status_sort),
	d.[DAR Last Completed] = iif(isnull(d2.[DAR Last Completed],'1900-01-01') >  isnull(d.[DAR Last Completed],'1900-01-01'), d2.[DAR Last Completed], d.[DAR Last Completed]),
	d.[DAR Next Planned Review Date] = iif(d2.[DAR Next Planned Review Date] is not null, d2.[DAR Next Planned Review Date], d.[DAR Next Planned Review Date]),
	d.HbA1c_Date = iif(isnull(d2.HbA1c_Date,'1900-01-01') > isnull(d.Hba1c_Date,'1900-01-01'), d2.HbA1c_Date, d.HbA1c_Date),
	d.HbA1c_Bands = iif(isnull(d2.HbA1c_Date,'1900-01-01') > isnull(d.Hba1c_Date,'1900-01-01'), d2.HbA1c_Bands, d.HbA1c_Bands),
	d.HBa1c_Bands_sort = iif(isnull(d2.HbA1c_Date,'1900-01-01') > isnull(d.Hba1c_Date,'1900-01-01'), d2.HbA1c_Bands_sort, d.HbA1c_Bands_sort),
	d.HBa1c = iif(isnull(d2.HbA1c_Date,'1900-01-01') > isnull(d.Hba1c_Date,'1900-01-01'), d2.HbA1c, d.HbA1c),
	d.AlbCreat_Date = iif(isnull(d2.AlbCreat_Date,'1900-01-01') > isnull(d.AlbCreat_Date,'1900-01-01'), d2.AlbCreat_Date, d.AlbCreat_Date),
	d.[Alb Creat Ratio] = iif(isnull(d2.AlbCreat_Date,'1900-01-01') > isnull(d.AlbCreat_Date,'1900-01-01'), d2.[Alb Creat Ratio], d.[Alb Creat Ratio]),
	d.CellPhone = iif(d2.Cellphone is not null and rtrim(ltrim(d2.Cellphone)) <> '', d2.CellPhone, d.Cellphone),
	d.HomePhone = iif(d2.Homephone is not null and rtrim(ltrim(d2.Homephone)) <> '', d2.HomePhone, d.Homephone)
from Stage_Dar_Reporting as d
	join PrimewiseReporting_RAPHS_DEV.dbo.Stage_Dar_Reporting as d2 on d2.NHI = d.NHI
where d.PracticeID = 27;