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
select *,date_add(date,INTERVAL 4 MONTH) from fact_sales_monthly;  -- date_add function
select * from fact_sales_monthly where customer_code="90002002" 
	and year(date_add(date,INTERVAL 4 MONTH))=2021; -- with directly compare to fiscal_year
/*Add a function from left menu and complete - to get the fiscal year from a common date
*/
select * from fact_sales_monthly where customer_code=90002002
	and get_fiscal_year(date)=2021 order by date desc;
    
/*The above question with criteria of FY=2021 and Quarter=4 ,, We will do it by create a new functionget_fiscal_yearget_fiscal_year*/
select * from fact_sales_montget_fiscal_yearget_fiscal_yearhly where customer_code = 90002002 and get_fiscal_year(date)=2021 and get_fiscal_quarter(date)="Q2" order by date desc;
select *,get_fiscal_quarter(date) as tmn from fact_sales_monthly where customer_code = 90002002 and get_fiscal_year(date)=2021 having tmn="Q2" order by date desc;

/*
CREATE DEFINER=`root`@`localhost` FUNCTION `get_fiscal_year`( calendar_date date 
) RETURNS int
    DETERMINISTIC
BEGIN
	DECLARE fiscal_year INT;
    SET fiscal_year = YEAR(date_add(calendar_date,interval 4 month));
RETURN fiscal_year;
END
----------------------------
 CREATE DEFINER=`root`@`localhost` FUNCTION `get_fiscal_quarter`(calender_date date) RETURNS char(2) CHARSET latin1
    DETERMINISTIC
BEGIN
	DECLARE mn tinyint;
    DECLARE qtr char(2);
    SET mn = MONTH(calender_date);
    case 
		when mn IN (1,2,3) then SET qtr="Q1";
		when mn IN (4,5,6) then SET qtr="Q2";
		when mn IN (7,8,9) then SET qtr="Q3";
	else 
		 SET qtr="Q4";
	end case;
RETURN qtr;
END */ 


