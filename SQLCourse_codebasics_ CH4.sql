select * from movies;
select * from financials;
-- Inner join 
select 
	movies.movie_id, title, budget, revenue, currency, unit
from movies
join financials
on movies.movie_id=financials.movie_id;
-- to make the query shorter
select 
	mv.movie_id, title, budget, revenue, currency, unit
from movies mv
INNER join financials fn
on mv.movie_id=fn.movie_id;
/*
 Default join in INNER JOIN (When you dont specify anything and just write JOIN then it will take as INNER JOIN)
 When you see above query result it it not giving the record for movie_id 106(Sholay), 112(Inception) and more 
because for those movies_id the data is there in movies table but not in financial table
similarly there are some movies_id 406, 412 which are in financials table not in movies table so it will not in the join
 <- known as Inner Join 
*/

select 
	mv.movie_id, title, budget, revenue, currency, unit
from movies mv
LEFT join financials fn
on mv.movie_id=fn.movie_id;
/* In the left join the movies 106(sholay), 112(inception) will be there with null value for the financials data */

select 
	mv.movie_id, title, budget, revenue, currency, unit
from movies mv
RIGHT join financials fn
on mv.movie_id=fn.movie_id;
/* In the RIGHT join the movies 406, 412 ID is not visible because 
- We choose to select only value from mv.movies_id and the financials records are there so it shows
but not movie_id and name , If you change fn.movies_id then it will show movie_id bcs its from financial table 
but still not showing the title*/


select mv.movie_id, title, budget, revenue, currency, unit
from movies mv left join financials fn on mv.movie_id=fn.movie_id
union
select fn.movie_id, title, budget, revenue, currency, unit
from movies mv RIGHT join financials fn on mv.movie_id=fn.movie_id;

-- inner Join 
-- outer Join - Left Join, Right Join, Full Join
-- in a query instead of left join can write LEFT OUTER JOIN

/*
-- In a query when you have same column name in both the table, use of 'USING' and no need to specify table like fn.movie_id
-- it will automatically gives right join table using right table's movie_id column , similarly for left join also.
-- Like USING(movie_id) , USING(movie_id,title) you can connect using 1 or more columns */
select movie_id, title, budget, revenue, currency, unit
from movies mv RIGHT join financials fn USING (movie_id);

-- Show all the movies with their language names
select * from movies join languages on movies.language_id = languages.language_id;
select title, name from movies m join languages l using (language_id);

--  Show all Telugu movie names (assuming you don't know language id for Telugu)
select title from movies m join languages l using (language_id) where l.name = "Telugu";

--  Show language and number of movies released in that language
select l.name, count(m.movie_id) as no_movies from languages l left join movies m using (language_id) 
	group by language_id order by no_movies DESC;
    
-- Cross Join Demo
use food_db;
select * from items;  -- has vadapav, dosa, sandwich and their prices
select * from variants;  -- has butter, cheese, plain and their prices
select * from items cross join variants;
select *, concat(name,"-",variant_name) as full_name from items cross join variants;

use moviesdb;
select * from financials;

-- Create movies list with their profit 
select movie_id, title, budget, revenue, currency, unit, (revenue-budget) as profit 
from movies m join financials f using (movie_id) ;

select movie_id, title, budget, revenue, currency, unit, (revenue-budget) as profit 
from movies m join financials f using (movie_id) where industry="bollywood" order by profit desc ; -- but profit is in various money units

-- create bollywood movies list with their profit in Millions sorted the list by profit in descending
select movie_id, title, budget, revenue, currency, unit, 
	case 
		when unit="Thousands" then round((revenue-budget)/1000,2)
        when unit="Billions" then round((revenue-budget)*1000,2)
        else round((revenue-budget),2)
    end as profit_million
from movies m join financials f using (movie_id) where industry="bollywood" order by profit_million	 desc ; 

-- Same query but only top 5 movies with highest profit.
select movie_id, title, budget, revenue, currency, unit, 
	case 
		when unit="Thousands" then round((revenue-budget)/1000,2)
        when unit="Billions" then round((revenue-budget)*1000,2)
        else round((revenue-budget),2)
    end as profit_million
from movies m join financials f using (movie_id) where industry="bollywood" order by profit_million desc LIMIT 5 ; 


-- print movie names and all actors worked in film in one line many values.
select m.title, group_concat( a.name separator ' | '  ) from movies m join movie_actor ma on m.movie_id =  ma.movie_id
 join actors a on a.actor_id = ma.actor_id group by m.movie_id;
 
 -- Print all Actors Group into unique actor name and all different movies they worked in.
select a.name, group_concat( m.title separator ' | '  ) from actors a join movie_actor ma on a.actor_id =  ma.actor_id
 join movies m on m.movie_id = ma.movie_id group by a.actor_id;
 
-- Print actor name and count of movies they worked in ,.
select a.name,group_concat( m.title separator ' | '  ) as movies, count(m.title) movie_count 
from actors a join movie_actor ma on a.actor_id =  ma.actor_id
 join movies m on m.movie_id = ma.movie_id group by a.actor_id order by movie_count desc;
 
-- Exercise 
-- movie.title| revenue in financials | financials.currency fin.unit
select * from movies;
select * from financials; 
select * from languages;
select m.title, f.currency,f.unit,revenue,
	case
		when unit="Thousands" then round(revenue/1000,2)
        when unit="Billions" then round(revenue*1000,2)
        else revenue
    end as revenue_mln
from financials f join movies m using (movie_id)
join languages l using(language_id) where l.name = "Hindi" order by revenue_mln desc;


