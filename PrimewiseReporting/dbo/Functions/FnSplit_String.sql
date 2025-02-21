CREATE FUNCTION [dbo].[FnSplit_String]
 (
@List nvarchar(2000),
@SplitOn nvarchar(5)
 )  
 RETURNS @RtnValue table 
 (
Value nvarchar(50)
 ) 
 AS  
 BEGIN
 While (Charindex(@SplitOn,@List)>0)
Begin 
Insert @RtnValue (value)
Select
Value = ltrim(rtrim(Substring(@List,1,Charindex(@SplitOn,@List)-1))) 
Set @List = Substring(@List,Charindex(@SplitOn,@List)+len(@SplitOn),len(@List))
End 

Insert Into @RtnValue (Value)
Select Value = ltrim(rtrim(@List))
Return
 END