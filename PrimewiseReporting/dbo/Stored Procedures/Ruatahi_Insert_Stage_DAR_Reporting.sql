Create proc [dbo].[Ruatahi_Insert_Stage_DAR_Reporting]
as
insert Stage_Dar_Reporting
(PracticeID, SurgeryName, NHI, Surname, Firstname, Prov, DOB, Age_Qtr_End, Gender, Ethnicity, Quintile, CellPhone, HomePhone, CalculatedLincScore, 
CurrentRecordedLincScore, DAREnrolmentDate, [DAR Last Completed], [DAR Next Planned Review Date], LTCEnrolmentExpiryDate, In_Denominator, In_Numerator, 
Dar_Status, Dar_Status_Sort, DARLastExcludedDate, LTCEnrolmentIndicator, LTCEnrolmentIndicator_Text, LTCEnrolmentIndicator_Sort, Network_Group, 
RS_Referred, RSAnnaulReviewNextPlanDate, RSAnnualReviewLastCompletedDate, RSAnnualReviewLastExcludedDate, RSEnrolmentDate, HBa1c, [Alb Creat Ratio], 
[ACEi or A2], [Diabetes Type], HbA1c_Bands, HBa1c_Bands_sort, WholeGroup, DateOfDeath, HbA1c_Date, AlbCreat_Date, PatientUnenrolled)
Select 
27, SurgeryName, d2.NHI, Surname, Firstname, Prov, DOB, Age_Qtr_End, Gender, Ethnicity, Quintile, CellPhone, HomePhone, CalculatedLincScore, CurrentRecordedLincScore, 
DAREnrolmentDate, [DAR Last Completed], [DAR Next Planned Review Date], LTCEnrolmentExpiryDate, In_Denominator, In_Numerator, Dar_Status, Dar_Status_Sort, 
DARLastExcludedDate, LTCEnrolmentIndicator, LTCEnrolmentIndicator_Text, LTCEnrolmentIndicator_Sort, Network_Group, RS_Referred, RSAnnaulReviewNextPlanDate, 
RSAnnualReviewLastCompletedDate, RSAnnualReviewLastExcludedDate, RSEnrolmentDate, HBa1c, [Alb Creat Ratio], [ACEi or A2], [Diabetes Type], HbA1c_Bands, 
HBa1c_Bands_sort, WholeGroup, DateOfDeath, HbA1c_Date, AlbCreat_Date, PatientUnenrolled
 from PrimewiseReporting_RAPHS_DEV.dbo.Stage_Dar_Reporting as d2
	left join (Select NHI from Stage_DAR_Reporting where practiceID = 27) as d on d.NHI = d2.NHI
	where d.NHI is Null