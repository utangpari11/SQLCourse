use gdb041; -- Please update if youare using the database for SQL .
select distinct* from dim_customer;
select distinct region from dim_customer;
-- division -> segment -> category -> product 
/*Month, product Name, variant, sold quantity, gross price per item, gross price total 
Report for monthly based sales for Croma india customer FY=2021
the above fiels should have in the report*/
-- 1. What is customer code for Chroma India 
select customer_code from dim_customer where customer like "%croma%" and market="india";
select * from fact_sales_monthly where customer_code = 
	(select customer_code from dim_customer where customer like "%croma%" and market="india");
select * from fact_sales_monthly 
where customer_code = "90002002" and year(date)=2021 order by date desc;
-- 2. Add from calender year to fiscal year 
select *,date_add(date,INTERVAL 4 MONTH) from fact_sales_monthly;



