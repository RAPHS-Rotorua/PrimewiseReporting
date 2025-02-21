--Exec rpt_MoreHeartandDiabetes_PracticePerformance_Summary '17'
CREATE Procedure [dbo].[rpt_MoreHeartandDiabetes_PracticePerformance_Summary_Network]
as
SET NOCOUNT ON	

/*
	Author:  Justin Sherborne
	Date: 3 Feb 2017
*/	


Select h.Performance, h.Performance_M_3544, h.No_Required_To_Target, h.No_Required_To_Target_M_3544
FROM 
CVD_Performance_vw as h
where Practice = 'RAPHS'