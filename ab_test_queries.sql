/* 

Data Cleaning


*/

USE ab_test

select *
from control_modified

select * 
from test_modified

-- Merging two tables
select * INTO whole_table
FROM
(
select * from control_modified
UNION
select * from test_modified
) a

-- Removing Redundant/Useless Column
alter table whole_table
drop column F1

-- Checking each column's data type
SELECT DATA_TYPE from INFORMATION_SCHEMA.COLUMNS where
table_schema = 'dbo' and table_name = 'whole_table'


-- Filling Null Values with the average value of each column
update whole_table
set [Reach] = cast((select avg(Reach) as avgreach from whole_table) as int),
	[# of Impressions] = cast((select avg([# of Impressions]) from whole_table) as int),
    [# of Website Clicks] = cast((select avg([# of Website Clicks]) from whole_table) as int),
    [# of Searches] = cast((select avg([# of Searches]) from whole_table) as int),
    [# of View Content] = cast((select avg([# of View Content]) from whole_table) as int),
    [# of Add to Cart] = cast((select avg([# of Add to Cart]) from whole_table) as int),
    [# of Purchase] = cast((select avg([# of Purchase]) from whole_table) as int)
where [# of Impressions] is null

-- Converting Datetime column into Date column since time is all 0
ALTER TABLE whole_table ALTER COLUMN Date Date

