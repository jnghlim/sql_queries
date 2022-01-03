use ab_test

-- Creating Test Table

select * INTO sampletb
FROM
(
select * from marketing
) a 

drop table sampletb

-- Check each column's datatype

exec sp_columns marketing
---- Looks like it would be better to change the datatype of the 
----	ID column into nvarchar
----	Dt_Customer into Date

-- Change ID Column (Float) into nvarchar

alter table marketing
alter column ID nvarchar(50)

-- Change Dt_Customer (nvarchar) into Date

alter table marketing
alter column Dt_Customer Date


-- Counting Null Values for Each Column

select 
    sum(case when ID is null then 0 else 1 end) as Column_1, 
    sum(case when Year_Birth is null then 0 else 1 end) as Column_2, 
    sum(case when Education is null then 0 else 1 end) as Column_3,
	sum(case when Marital_Status is null then 0 else 1 end) as Column_4,
	sum(case when Income is null then 0 else 1 end) as Column_5,
	sum(case when Kidhome is null then 0 else 1 end) as Column_6,
	sum(case when Teenhome is null then 0 else 1 end) as Column_7,
	sum(case when Dt_Customer is null then 0 else 1 end) as Column_8,
	sum(case when Recency is null then 0 else 1 end) as Column_9,
	sum(case when MntWines is null then 0 else 1 end) as Column_10,
	sum(case when MntFruits is null then 0 else 1 end) as Column_11,
	sum(case when MntMeatProducts is null then 0 else 1 end) as Column_12,
	sum(case when MntFishProducts is null then 0 else 1 end) as Column_13,
	sum(case when MntSweetProducts is null then 0 else 1 end) as Column_14,
	sum(case when MntGoldProds is null then 0 else 1 end) as Column_15,
	sum(case when NumDealsPurchases is null then 0 else 1 end) as Column_16,
	sum(case when NumWebPurchases is null then 0 else 1 end) as Column_17,
	sum(case when NumCatalogPurchases is null then 0 else 1 end) as Column_18,
	sum(case when NumStorePurchases is null then 0 else 1 end) as Column_19,
	sum(case when NumWebVisitsMonth is null then 0 else 1 end) as Column_20,
	sum(case when AcceptedCmp3 is null then 0 else 1 end) as Column_21,
	sum(case when AcceptedCmp4 is null then 0 else 1 end) as Column_22,
	sum(case when AcceptedCmp5 is null then 0 else 1 end) as Column_23,
	sum(case when AcceptedCmp1 is null then 0 else 1 end) as Column_24,
	sum(case when AcceptedCmp2 is null then 0 else 1 end) as Column_25,
	sum(case when Complain is null then 0 else 1 end) as Column_26,
	sum(case when Z_CostContact is null then 0 else 1 end) as Column_27,
	sum(case when Z_Revenue is null then 0 else 1 end) as Column_28,
	sum(case when Response is null then 0 else 1 end) as Column_29
from marketing
---- Looks Like only Income Value has 24 null values

-- Among all the columns, Income column affects the most to the amount of income. 
-- So decided to put average values of income grouping by the Education Column

select Education, avg(Income)
from marketing
group by Education

Update a
SET Income = ISNULL(a.Income,b.Income)
From marketing a
JOIN (select Education, cast(avg(Income) as int) as Income
	 from marketing
	 group by Education) b
	 on a.Education = b.Education
Where a.Income is null

-- Adding a Additional Columns

---- Total number of minors (Teens + Kids)

alter table marketing
add MntMinors INT NULL

update marketing
set MntMinors = Kidhome + Teenhome

---- Age of Customer When he/she enrolled at the company

alter table marketing
add Age INT NULL

update marketing
set Age = YEAR(Dt_Customer) - Year_Birth

---- Total amount of money each customer spent

alter table marketing
add TotalMoneySpent INT NULL

update marketing
set TotalMoneySpent = MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds

---- Total amount of purchases of each customer

alter table marketing
add TotalPurchases INT NULL

update marketing
set TotalPurchases = NumWebPurchases + NumCatalogPurchases + NumStorePurchases

-- Add all the accepted previous campaigns to one column

alter table marketing
add acceptedPreviousCmp INT NULL

update marketing
set acceptedPreviousCmp = AcceptedCmp1 + AcceptedCmp2 + AcceptedCmp3 + AcceptedCmp4 + AcceptedCmp5

-- Drop Columns that we do not need

alter table marketing
drop column Z_CostContact, Z_Revenue, Year_Birth, Kidhome, Teenhome, AcceptedCmp1, AcceptedCmp2, AcceptedCmp3, AcceptedCmp4, AcceptedCmp5

-- Change acceptedPreviousCampaign to be an indicator whether the customer has accepted previous campaigns or not.

update marketing
set acceptedPreviousCmp = 1
where acceptedPreviousCmp != 0

-- People who accepted Marketing Campaign

select count(*)
from marketing
where acceptedPreviousCmp = 1 OR Response = 1

-- Setting rows with both column value with 1 to have just Response column have 1
update marketing
set acceptedPreviousCmp = 0
where acceptedPreviousCmp = 1 and Response = 1

-- People who did not accept any of the campaigns.

select count(*)
from marketing
where acceptedPreviousCmp = 0 AND Response = 0

-- Campaign Acceptance Column. If acceptedPreviousCampaign
select * from marketing