use moviesdb;
-- A movie with highest rating
select * from movies order by imdb_rating desc limit 1;
select * from movies where imdb_rating = 9.3;
-- youll get same ans but you dont know which is highest rating value	
select max(imdb_rating) from movies;
select * from movies where imdb_rating = 
	(select max(imdb_rating) from movies);
-- called Subquery 
-- get lowest rating movie
select * from movies where imdb_rating = (select min(imdb_rating) from movies);

-- Ex of Returning list of value
-- Get min rating and max rating both movies 
select * from movies where imdb_rating IN (1.9,9.3); -- in real scene you dont know which are low and high
select * from movies where imdb_rating IN (
	(select min(imdb_rating) from movies), 
    (select max(imdb_rating) from movies)
);

-- Ex. of returning a table
-- select all the actors have age > 70 and < 80
select name, (year(curdate()) - birth_year) as age from actors having age >70 and age <80;
-- in above query the where clause not work, so have to use 'HAVING' clause
-- using subquery now , imagine age calculated table as sub table and run a query on it
select * from 
(select name, (year(curdate()) - birth_year) as age from actors) as all_actors_age  -- this is you sub-table
where age >70 and age<80;

-- get all actors worked in any of these movies = 101, 110, 121
select actor_id,a.name, a.birth_year from movie_actor ma join movies m using(movie_id) join actors a using (actor_id) where m.movie_id IN (101,110,121);
-- same result using the subquery 
select actor_id from movie_actor where movie_id in (101,110,121);  -- youll get all actors ID and now joining with other table to get actor_name
select * from actors where actor_id IN (select actor_id from movie_actor where movie_id in (101,110,121));
-- Here IN keyword used as pass mutiple items into the where clause from another table
select * from actors where actor_id = ANY (select actor_id from movie_actor where movie_id in (101,110,121));  -- Using the ANY keyword similar as IN 

-- select all movies whose rating is greater than any of marvel movies rating
-- ques is that all movies which rating is more than the marvel's min rate movie 
select * from movies where imdb_rating > (select min(imdb_rating) from movies where studio='Marvel Studios');  
select * from movies where imdb_rating > ANY (select imdb_rating from movies where  studio='Marvel Studios');
select * from movies where imdb_rating > some (select imdb_rating from movies where  studio='Marvel Studios');  -- using some keyword
-- ANY and some keyword are both same functionality 

-- select all movies whose rating is greater than ALL of marvel movies rating
select * from movies where imdb_rating > ALL (select imdb_rating from movies where studio='Marvel Studios');  -- Using ANY keyword
select * from movies where imdb_rating > (select MAX(imdb_rating) from movies where studio='Marvel Studios');  -- same ans 

-- select actor_id, actor_name and total number of movies they acted in
select * from actors;
select * from movie_actor;
explain analyze select a.name,actor_id,count(movie_id) as movie_count from movie_actor ma join actors a using(actor_id) group by actor_id order by movie_count desc;
select count(*) from movie_actor where actor_id=54;  -- get count of movies for actor 54 

explain analyze -- keyword write before query to check performance of the query. 
select actor_id, name,
(select count(*) from movie_actor where actor_id=actors.actor_id) as movie_count 
from actors order by movie_count desc;  -- instead of 54 (specific actor) make as dynamic
-- You can add the explain analyze keyword and see the differences in the performance of the both above query giving same result

/* Exercise - select all the movies with minimum and maximum release_year. Note that there 
can be more than one movies in min and max year hence output rows can be more than 2 */
select * from movies where release_year in ((select min(release_year) from movies),(select max(release_year) from movies));
-- Always remeber that when you use sub-query you can add ';' to finish query, you need brackets in the query to start and finish it

/* Exercise  select all the rows from movies table whose imdb_rating is higher than the average rating */
select * from movies where imdb_rating > (select avg(imdb_rating) from movies);

-- CTE (common table expressions) - Replacing the sub-query table - 'with tempTable'
select actor_name, age 
	from (select name as actor_name, year(curdate()) - birth_year as age from actors) as actor_age_table
    where age > 70 and age < 85;  -- will modify this query into CTE
    
with actor_age_table as (
	select name as actor_name, year(curdate()) - birth_year as age from actors
) -- first select statement ('with') values will be stored into actor_age_table and then second query run(below query)
select actor_name,age from actor_age_table where age > 70 and age < 85;
with actor_age_table(at_name,at_age) as (
	select name as actor_name, year(curdate()) - birth_year as age from actors
) -- Passing parameters like function and use them into second query 
select at_name,at_age from actor_age_table where at_age > 70 and at_age < 85;
/* You can even make join statement using CTE
WITH 
	CTE1 AS (select a,b from table1),
    CTE2 AS (select c,d from table2)
select b,d from CTE1 join CTE2 where CTE1.a = CTE2.c   */

-- get movies that produced 500% profit and their rating was less than avg rating for all movies, lets work in 2 parts
-- 1. movies that produced 500% profit
select *, (revenue-budget)*100/budget as pct_profit from financials having pct_profit > 500;
-- 2. their rating was less than avg rating for all movies
select * from movies where imdb_rating < (select avg(imdb_rating) as avg_rating from movies);  
-- now combining these 2 queries using join, sub-query 
select x.movie_id, x.pct_profit,y.title, y.imdb_rating
from (
	select *, (revenue-budget)*100/budget as pct_profit from financials
) x 
join (
	select * from movies where imdb_rating < (select avg(imdb_rating) as avg_rating from movies)
) y using(movie_id) where pct_profit >=500;

-- using CTE
with x as (select *, (revenue-budget)*100/budget as pct_profit from financials) ,
	 y as (select * from movies where imdb_rating < (select avg(imdb_rating) as avg_rating from movies))
	select x.movie_id, x.pct_profit,y.title, y.imdb_rating from x join y using(movie_id) where pct_profit >= 500;
/*
CTE makes query readability more easy compared to adding more where clause 
you can use x-subquery into y-subquery so no need to repeat the statement again (Reusability)
visibility for creating data views  */

/* Que - select all hollowood movies released after year 2000 that made more than 500 millions $ 
profit or more profit. Note that all hollywood movies have millions as a unit hence you don't
need to do unit converstion. Also you can write this query without CTE as well but you should
try to write this using CTE only */

select * from movies join financials using(movie_id) where industry="Hollywood" and (revenue-budget) >=500 and release_year>2000;
with x as (select movie_id,title,release_year from movies where industry="Hollywood"),
	y as (select movie_id,(revenue-budget) as profit from financials )
select title,profit from x join y using(movie_id) where profit>500 and release_year>2000;
-- below is solution and above is your work
with cte as (select title, release_year, (revenue-budget) as profit
			from movies m
			join financials f
			on m.movie_id=f.movie_id	
			where release_year>2000 and industry="hollywood"
	)select * from cte where profit>500