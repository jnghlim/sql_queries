/* 

Cleaning Data in SQL Queries

*/

select *
from sales_insight.dbo.supermarket_sales

------------------------------------------------------------------------------------

-- Null Values Check (Iterated through all columns to check if there is any null values)
select *
from sales_insight.dbo.supermarket_sales
where [Invoice ID] is null
---- No null values found


-- Standardize Date Format

------ Sale Date

alter table supermarket_sales
add sale_date Date;

update sales_insight.dbo.supermarket_sales
set sale_date = convert(Date, Date);

alter table supermarket_sales
drop column Date;

------ Sale Time (hour) 

alter table supermarket_sales
add sale_time time;

update sales_insight.dbo.supermarket_sales
set sale_time = convert(Time, Time);

alter table supermarket_sales
drop column Time;

alter table supermarket_sales
add sale_time_hr INT;

update sales_insight.dbo.supermarket_sales
set sale_time_hr = DATEPART(HOUR, sale_time);

alter table supermarket_sales
drop column sale_time;

-- Delete Unused Columns
ALTER TABLE sales_insight.dbo.supermarket_sales
DROP COLUMN [Tax 5%]

alter table sales_insight.dbo.supermarket_sales
drop column [Total]

-- Duplicate Check
SELECT [Invoice ID], COUNT(*) as counts
FROM sales_insight.dbo.supermarket_sales
GROUP BY [Invoice ID]
HAVING COUNT(*) > 1
