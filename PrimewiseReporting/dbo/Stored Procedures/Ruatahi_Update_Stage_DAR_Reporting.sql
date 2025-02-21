CREATE proc [dbo].[Ruatahi_Update_Stage_DAR_Reporting]
as
update d
set d.Prov = d2.prov,
	d.In_Numerator = iif(d2.In_Numerator = 1,1,d.In_Numerator),
	d.Dar_Status = iif(d2.[DAR Last Completed] >  d.[DAR Last Completed],d2.Dar_Status, d.Dar_Status),
	d.Dar_Status_Sort = iif(d2.[DAR Last Completed] >  d.[DAR Last Completed],d2.Dar_Status_sort, d.Dar_Status_sort),
	d.[DAR Last Completed] = iif(d2.[DAR Last Completed] >  d.[DAR Last Completed], d2.[DAR Last Completed], d.[DAR Last Completed]),
	d.[DAR Next Planned Review Date] = iif(d2.[DAR Next Planned Review Date] is not null, d2.[DAR Next Planned Review Date], d.[DAR Next Planned Review Date]),
	d.HbA1c_Date = iif(d2.HbA1c_Date > d.Hba1c_Date, d2.HbA1c_Date, d.HbA1c_Date),
	d.HbA1c_Bands = iif(d2.HbA1c_Date > d.Hba1c_Date, d2.HbA1c_Bands, d.HbA1c_Bands),
	d.HBa1c_Bands_sort = iif(d2.HbA1c_Date > d.Hba1c_Date, d2.HbA1c_Bands_sort, d.HbA1c_Bands_sort),
	d.HBa1c = iif(d2.HbA1c_Date > d.Hba1c_Date, d2.HbA1c, d.HbA1c),
	d.AlbCreat_Date = iif(d2.AlbCreat_Date > d.AlbCreat_Date, d2.AlbCreat_Date, d.AlbCreat_Date),
	d.[Alb Creat Ratio] = iif(d2.AlbCreat_Date > d.AlbCreat_Date, d2.[Alb Creat Ratio], d.[Alb Creat Ratio]),
	d.CellPhone = iif(d2.Cellphone is not null and rtrim(ltrim(d2.Cellphone)) <> '', d2.CellPhone, d.Cellphone),
	d.HomePhone = iif(d2.Homephone is not null and rtrim(ltrim(d2.Homephone)) <> '', d2.HomePhone, d.Homephone)
from Stage_Dar_Reporting as d
	join PrimewiseReporting_RAPHS_DEV.dbo.Stage_Dar_Reporting as d2 on d2.NHI = d.NHI
where d.PracticeID = 27;