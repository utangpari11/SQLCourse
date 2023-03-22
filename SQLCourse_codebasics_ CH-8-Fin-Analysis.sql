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
select * from fact_sales_monthly where customer_code = 90002002 and get_fiscal_year(date)=2021 and get_fiscal_quarter(date)="Q2" order by date desc;
select *,get_fiscal_quarter(date) as tmn from fact_sales_monthly where customer_code = 90002002 and get_fiscal_year(date)=2021 having tmn="Q2" order by date desc;
 
-- Now for the main question on top of page, we need product and variant column from the dim_product table;
select s.date,s.product_code, p.product, p.variant, s.sold_quantity from fact_sales_monthly s join dim_product p using(product_code) 
where customer_code = 90002002 and get_fiscal_year(date)=2021 order by date asc limit 1000000;

-- Now for the main question on top of page, we need Gross price per item , gross_price from fact_gross_price;
-- we have only gross_price from that table, have to calculate per item
select * from fact_gross_price where product_code="A0118150101"; 
-- try this and see every diff fiscal year the price for one product is differen so use 2 parameter for join - producr_code and fiscal_year
select s.date,s.product_code, p.product, p.variant, s.sold_quantity , g.gross_price
	from 
		fact_sales_monthly s join dim_product p using(product_code) 
		join fact_gross_price g 
			on g.product_code = s.product_code and g.fiscal_year=get_fiscal_year(s.date)
where customer_code = 90002002 and get_fiscal_year(date)=2021 order by date asc limit 1000000;  
-- We got gross_price now try gross_price_total
select s.date,s.product_code, p.product, p.variant, s.sold_quantity , g.gross_price,
	ROUND(g.gross_price*s.sold_quantity,2) as gross_price_total
	from 
		fact_sales_monthly s join dim_product p using(product_code) 
		join fact_gross_price g 
			on g.product_code = s.product_code and g.fiscal_year=get_fiscal_year(s.date)
where customer_code = 90002002 and get_fiscal_year(date)=2021 order by date asc limit 1000000;  

-- So this is final result which manager wants, export the result into the CSV
-- Now modify it into the Excel or create dashboard in power BI 

-- Croma's transactions sorted by date
select * from fact_sales_monthly s join fact_gross_price g on 
	g.product_code = s.product_code and 
    g.fiscal_year = get_fiscal_year(s.date)
where customer_code = 90002002
order by s.date asc;
-- in above result, there are multiple row with same date, we need single row with a month
select s.date , SUM(g.gross_price * s.sold_quantity) as gross_price_total 
from fact_sales_monthly s join fact_gross_price g on 
	g.product_code = s.product_code and 
    g.fiscal_year = get_fiscal_year(s.date)
	where customer_code = 90002002
    group by s.date order by s.date asc ; 
    
/*Exc - Generate a yearly report for Croma India where there are two columns, Fiscal Year, Total Gross Sales amount In that year from Croma */
select * from dim_customer; -- For Croma - "90002002" customer_code
select get_fiscal_year(s.date) as fy, ROUND(SUM(g.gross_price*s.sold_quantity),2)
from fact_sales_monthly s join fact_gross_price g on s.product_code = g.product_code and get_fiscal_year(s.date) = g.fiscal_year 
where customer_code = 90002002 group by fy;
-- Convert this into a stored procedure 
-- It will be easy just to input a customer_code
call gdb041.get_monthly_gross_sales_for_customer(90002002); -- To call the procedure