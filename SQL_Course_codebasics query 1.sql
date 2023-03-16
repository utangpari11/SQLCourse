use moviesdb;
select title from movies;
select distinct industry from movies;
select * from movies where title like "%Thor%";
select * from movies where imdb_rating>=6 and imdb_rating <=8;
select * from movies where imdb_rating between 6 AND 8; -- including 6 and 8

select * from movies where release_year= 2022 or release_year= 2019 or release_year= 2018;
select * from movies where release_year IN (2022,2018,2019); -- the , represents OR Condition
select * from movies where studio IN ("Marvel Studios","Zee Studios");  -- IN keyword works for strings also 

select * from movies where imdb_rating is NULL; -- How to fetch null values
select * from movies where imdb_rating is NOT NULL; -- How to fetch null values

select * from movies where industry="bollywood" order by imdb_rating DESC;   -- order by descending value
select * from movies where industry="hollywood" order by imdb_rating DESC limit 5;   -- order by descending value and only top 2
select * from movies where industry="hollywood" order by imdb_rating DESC limit 5 offset 2;  
-- order by descending value and only top 5 and showing from the third value so skip first 2 value and then show all
-- It will showing 5 values but the highest rating top 2 values will cut and then it will be measured.


select * from movies order by release_year desc;
select title, release_year from movies where title like '%thor%' order by release_year asc;
-- select all thor movies by their release year

select * from movies where studio != 'Marvel studios';
-- select all movies that are not from marvel studios

select AVG(imdb_rating) as Average_Rating from movies where studio = "Marvel Studios"; -- returns 7.50000  ,average of all marvel movies
select ROUND(AVG(imdb_rating)) from movies where studio = "Marvel Studios";  -- returns 8
select ROUND(AVG(imdb_rating),2) as Average_Rating from movies where studio = "Marvel Studios"; -- returns 7.50 ,as keyword for rename column name

select count(*) from movies where industry = "Hollywood";
select industry,count(*) as cnt from movies group by industry;  -- make a list of all different industry type movies
select industry,count(*) as cnt, avg(imdb_rating) as avg_rating from movies group by industry;  

-- https://www.w3schools.com/mysql/func_mysql_max.asp  So much to remember so go through diff funcs from this page

select count(*) from movies where release_year between 2015 and 2022;  -- count movies release between 2015 to 2022
select release_year,count(title) as movie_count from movies group by release_year order by release_year desc;
-- print a year and how many movies were released in that year starting with latest year

select release_year,count(*) as cnt from movies where cnt>2 group by release_year ; 
-- above will not work when you want further use aggregate function to calculation
select release_year,count(*) as cnt from movies group by release_year having cnt>2;

-- sequence in which SQL engine will perform the actions
-- FROM -> WHERE -> GROUP BY -> HAVING -> ORDER BY

select year(curdate());
-- calculate age from birth_year of actors
select *,year(curdate())-birth_year as actor_age from actors;   -- Similar how you make mew calculated column of Age in Excel or Power BI

select *,revenue-budget as profit from financials;
select revenue from financials where movie_id = (select movie_id from movies where title like "3 Idiots");

select *, 
	IF(currency='USD',revenue*77,revenue) as revenue_inr
from financials;
-- convert USD revenue into INR (1 usd = 77 inr)

select distinct unit from financials;  -- it will gives billions, million, thousands <- these 3 records.
-- Show Revenue in Million in new column 
select *,	
	case 
		when unit="thousands" then revenue/1000
        when unit="billions" then revenue*1000
        else revenue
    end as revenue_million
from financials;
	
select * from financials;
-- Print profit % for all the movies  from financials table.
select *,revenue - budget as profit, round((revenue-budget)/budget,2) as profit_PCT from financials;

/*
You have a table with cricket scores of players and you want to 
retrieve second, third and fourth highest scores. Select the correct query for this
*/
SELECT * from player_stats ORDER BY score DESC LIMIT 3 OFFSET 1;
/*
Write a query to retrieve movies whose title start with THE and their rating is between 5 and 6 (including 6 but excluding 5)
*/
SELECT * from movies WHERE imdb_rating>5 and imdb_rating <=6 and title LIKE "The%";

/* You have a customers table with customer_id as a primary key. Write a query to select all ODD customer_id records */
SELECT * from customers WHERE customer_id % 2 = 1;

/* For movies table, write a query to print (1) count of distinct imdb_rating (2) 
standard deviation of imdb_rating (HINT: Use your google skills) */
SELECT count(distinct imdb_rating), STDDEV(imdb_rating) from movies;





 