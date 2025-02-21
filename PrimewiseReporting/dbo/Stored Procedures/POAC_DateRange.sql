Create proc [dbo].[POAC_DateRange] @Year int, @Month int
as
Select
Cast((Cast(@Year as char(4)) + '-' +
Cast(@Month as char(2)) + '-1') as date) as StartDate,
EOMonth(Cast((Cast(@Year as char(4)) + '-' +
Cast(@Month as char(2)) + '-1') as date)) as EndDate;