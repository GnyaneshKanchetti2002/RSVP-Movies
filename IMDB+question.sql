USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/
Select * from ratings;


-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT 
(Select count(*) from director_mapping) as number_of_rows_director_mapping,
(Select count(*) from genre) as number_of_rows_genre,
(Select count(*) from movie) as number_of_rows_movie,
(Select count(*) from names) as number_of_rows_names,
(Select count(*) from ratings) as number_of_rows_ratings,
(Select count(*) from role_mapping) as number_of_rows_role_mapping;


-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT 
(SELECT count(id) FROM movie WHERE id IS NULL) as ID_NULL,
(SELECT count(id) FROM movie WHERE title IS NULL) as Title_NULL,
(SELECT count(id) FROM movie WHERE year IS NULL) as Year_NULL,
(SELECT count(id) FROM movie WHERE date_published IS NULL) as DatePublished_NULL,
(SELECT count(id) FROM movie WHERE duration IS NULL) as Duration_NULL,
(SELECT count(id) FROM movie WHERE country IS NULL) as Country_NULL,
(SELECT count(id) FROM movie WHERE worlwide_gross_income IS NULL) as WorldWide_NULL,
(SELECT count(id) FROM movie WHERE languages IS NULL) as Language_NULL,
(SELECT count(id) FROM movie WHERE production_company IS NULL) as production_company_NULL;


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT year, count(id) as number_ofmovies FROM movie GROUP BY (year);
SELECT month(date_published) as month_num, count(id) as number_of_movies FROM movie GROUP BY (month(date_published)) ORDER BY (month_num);



/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
select * from movie;
SELECT count(distinct id) as Number_of_movies, year FROM movie WHERE (country REGEXP 'USA' or country REGEXP 'India') and year = 2019  GROUP BY (year);


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT distinct genre as list_genres FROM genre;



/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT genre, count(id) as Number_of_movies FROM movie m INNER JOIN genre g on m.id = g.movie_id GROUP BY (genre) ORDER BY (Number_of_movies) desc LIMIT 1; 



/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
CREATE VIEW count_genre as (SELECT movie_id, count(genre) as Number_of_genres FROM genre GROUP BY (movie_id) HAVING Number_of_genres = 1);
SELECT count(movie_id) FROM count_genre;

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)

/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT genre, avg(duration) as avg_duration FROM movie m INNER JOIN genre g on m.id = g.movie_id GROUP BY (genre);


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
CREATE VIEW genre_rank as(
SELECT genre, count(id) as movie_count, RANK() over(ORDER BY (count(id)) desc) as genre_rank FROM movie m INNER JOIN genre g on m.id = g.movie_id 
GROUP BY (genre) ORDER BY (movie_count) desc 
); 

SELECT * FROM genre_rank WHERE genre = 'Thriller';


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
SELECT min(avg_rating) as min_avg_rating, max(avg_rating) as max_avg_rating, min(total_votes) as min_total_votes, max(total_votes) as max_total_votes,
 min(median_rating) as min_median_rating , max(median_rating) as max_median_rating FROM ratings;


/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
CREATE VIEW movie_rank as(
SELECT title,avg_rating, RANK() OVER(ORDER BY (avg_rating) desc) as movie_rank FROM movie m INNER JOIN ratings r on m.id = r.movie_id ORDER BY (avg_rating) desc 
);

SELECT * FROM movie_rank WHERE movie_rank <= 10;


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
SELECT median_rating, count(movie_id) as movie_count FROM ratings GROUP BY (median_rating) ORDER BY (movie_count) desc;



/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
DROP VIEW  if EXISTS production_company_rank;

CREATE VIEW production_company_rank as (
SELECT production_company, count(id) as movie_count, rank() OVER(ORDER BY (count(id)) desc) as prod_company_rank FROM movie m INNER JOIN ratings r on m.id = r.movie_id WHERE avg_rating > 8 and m.production_company is not null 
GROUP BY (production_company) ORDER BY (movie_count) desc
);

SELECT * FROM production_company_rank WHERE prod_company_rank = 1;



-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT g.genre, count(m.id) as movie_count FROM movie m INNER JOIN genre g on m.id = g.movie_id INNER JOIN ratings r on g.movie_id = r.movie_id 
WHERE total_votes > 1000 and year = 2017 and month(date_published) = 3 and country REGEXP 'USA' GROUP BY (g.genre) ORDER BY (movie_count) desc;
 


-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
SELECT title, avg_rating, genre FROM movie m INNER JOIN genre g on m.id = g.movie_id INNER JOIN ratings r on r.movie_id = m.id 
WHERE title REGEXP '^The' and r.avg_rating > 8 ORDER BY (avg_rating) desc;



-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
SELECT count(*), r.median_rating as count_movies FROM movie m INNER JOIN ratings r on m.id = r.movie_id WHERE median_rating = 8 and date_published between '2018-04-01' AND '2019-04-01' ORDER BY date_published;


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
SELECT m.country, sum(r.total_votes) FROM movie m INNER JOIN ratings r on m.id = r.movie_id WHERE country = 'Germany' or country = 'Italy'
GROUP BY (m.country);







-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT (SELECT count(id) FROM names WHERE name is null) as name_nulls, (SELECT count(id) FROM names WHERE height is null) as height_nulls,
(SELECT count(id) FROM names WHERE date_of_birth is null) as date_of_birth_nulls,
(SELECT count(id) FROM names WHERE known_for_movies is null) as known_for_movies_nulls ;


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
CREATE VIEW top_genre as(
SELECT g.genre, count(m.id) as movie_count FROM movie m INNER JOIN genre g on m.id = g.movie_id INNER JOIN ratings r on r.movie_id = m.id WHERE avg_rating > 8 
GROUP BY (g.genre) ORDER BY (movie_count) desc LIMIT 3
);

SELECT genre FROM top_genre;
SELECT * FROM director_mapping d INNER JOIN movie m on d.movie_id = m.id INNER JOIN names n on n.id = d.name_id INNER JOIN genre g on g.movie_id = m.id;

DROP VIEW IF EXISTS top_director;

CREATE VIEW director AS(
SELECT m.id, d.name_id, m.title, n.name, g.genre, r.avg_rating FROM director_mapping d INNER JOIN movie m on d.movie_id = m.id INNER JOIN names n on n.id = d.name_id 
INNER JOIN genre g on g.movie_id = m.id INNER JOIN ratings r on r.movie_id = d.movie_id, top_genre WHERE g.genre IN (top_genre.genre) and r.avg_rating > 8
ORDER BY (avg_rating) desc
);

CREATE VIEW top_director as(
SELECT name as director_name, count(name) as movie_count, rank() OVER(ORDER BY (count(name)) desc) as director_rank FROM director GROUP BY (name) 
);

SELECT director_name, movie_count FROM top_director WHERE director_rank <= 3 LIMIT 3;


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT name, count(m.id) as movie_count FROM movie m INNER JOIN role_mapping rm on m.id = rm.movie_id INNER JOIN names n on rm.name_id = n.id 
INNER JOIN ratings r on r.movie_id = m.id WHERE r.median_rating >= 8 GROUP BY (name) ORDER BY (count(m.id)) desc LIMIT 2;


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT production_company, sum(total_votes) as vote_count, rank() OVER(ORDER BY sum(total_votes) desc) as prod_comp_rank FROM movie m INNER JOIN ratings r on m.id = r.movie_id 
GROUP BY (production_company) ORDER BY (vote_count) desc LIMIT 3;




/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT m.id, m.title, n.id, n.name, r.avg_rating, r.total_votes, m.languages FROM movie m INNER JOIN role_mapping rm on m.id = rm.movie_id INNER JOIN names n on n.id = rm.name_id INNER JOIN ratings r on r.movie_id = m.id
 WHERE country = 'India';

DROP VIEW IF EXISTS actors;
CREATE VIEW actors AS(
SELECT n.name, sum(total_votes) as total_votes, count(m.id) as movie_count, (sum(avg_rating*total_votes)/sum(total_votes)) as actor_avg_rating,
rank() OVER(ORDER BY (sum(avg_rating*total_votes)/sum(total_votes)) desc) as actor_rank
FROM movie m INNER JOIN role_mapping rm on m.id = rm.movie_id INNER JOIN names n on n.id = rm.name_id INNER JOIN ratings r on r.movie_id = m.id
WHERE country = 'India' and rm.category = 'actor' GROUP BY (n.name) HAVING count(m.id) >= 5 ORDER BY (actor_avg_rating) desc
);

SELECT * FROM actors ;





-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

DROP VIEW IF EXISTS actress;
CREATE VIEW actress AS(
SELECT n.name, sum(total_votes) as total_votes, count(m.id) as movie_count, round(sum(avg_rating*total_votes)/sum(total_votes),2) as actor_avg_rating,
rank() OVER(ORDER BY (round(sum(avg_rating*total_votes)/sum(total_votes),2)) desc) as actor_rank
FROM movie m INNER JOIN role_mapping rm on m.id = rm.movie_id INNER JOIN names n on n.id = rm.name_id INNER JOIN ratings r on r.movie_id = m.id
WHERE country = 'India' and rm.category = 'actress' and languages = 'Hindi' GROUP BY (n.name) HAVING count(m.id) >= 3 ORDER BY (actor_avg_rating) desc
);

SELECT * FROM actress;







/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
SELECT m.title, r.avg_rating, CASE WHEN r.avg_rating > 8 THEN 'Superhit' WHEN r.avg_rating BETWEEN 7 and 8 THEN 'Hit' WHEN r.avg_rating BETWEEN 5 and 7 THEN 'One-time-watch'
WHEN r.avg_rating < 5 THEN 'Flop' END as movie_category
FROM movie m INNER JOIN genre g on m.id = g.movie_id INNER JOIN ratings r on r.movie_id = m.id 
WHERE genre = 'Thriller';



/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT g.genre, avg(m.duration) as avg_duration, sum(AVG(duration)) OVER(ORDER BY (g.genre)) as running_total_duration,
avg(avg(m.duration)) OVER(ORDER BY (g.genre)) as moving_avg_duration
FROM movie m INNER JOIN genre g on m.id = g.movie_id GROUP BY (g.genre);



-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies
CREATE VIEW top_genres as(
SELECT genre, count(m.id) as movie_count FROM movie m INNER JOIN genre g on m.id = g.movie_id GROUP BY (g.genre) ORDER BY (count(m.id)) desc LIMIT 3
);

DROP VIEW IF EXISTS top_movie;
CREATE VIEW top_movie AS (
SELECT g.genre, m.year, m.title, m.worlwide_gross_income, DENSE_RANK() OVER(PARTITION BY year ORDER BY (m.worlwide_gross_income) desc) as movie_rank
FROM movie m INNER JOIN genre g on m.id = g.movie_id, top_genres 
WHERE g.genre IN (top_genres.genre) 
);

SELECT * FROM top_movie WHERE movie_rank <= 5;


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
CREATE VIEW multilingual AS(
SELECT * FROM movie WHERE languages REGEXP ','
);

SELECT ml.production_company, count(ml.id) as movie_count, RANK() OVER(ORDER BY (count(ml.id)) desc) as prod_comp_rank FROM multilingual ml INNER JOIN ratings r on ml.id = r.movie_id 
WHERE median_rating >= 8 and ml.production_company IS NOT NULL
GROUP BY (ml.production_company) ORDER BY (count(ml.id)) desc LIMIT 2;



-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT n.name, sum(r.total_votes) as total_votes, count(m.id) as movie_count, SUM(r.avg_rating*r.total_votes)/SUM(r.total_votes) as actress_avg_rating,
RANK() OVER(ORDER BY (count(m.id)) desc) as actress_rank
FROM movie m INNER JOIN role_mapping rm on m.id = rm.movie_id INNER JOIN names n on n.id = rm.name_id 
INNER JOIN genre g on g.movie_id = m.id INNER JOIN ratings r on r.movie_id = m.id WHERE rm.category = 'actress' and r.avg_rating > 8 and g.genre = 'Drama'
GROUP BY (n.name) ORDER BY (count(m.id)) desc LIMIT 3;



/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
DROP VIEW IF EXISTS top_directors;
CREATE VIEW top_directors AS(
SELECT n.name, count(m.id) as movies_count FROM movie m INNER JOIN director_mapping dm on m.id = dm.movie_id INNER JOIN names n on dm.name_id = n.id
GROUP BY (n.name) ORDER BY (count(m.id)) desc LIMIT 9
);

DROP VIEW IF EXISTS directors;
CREATE VIEW directors AS(
SELECT DISTINCT(p.name_id), (td.name), td.movies_count as number_of_movies 
FROM top_directors td LEFT JOIN (SELECT * FROM director_mapping dm INNER JOIN names n on dm.name_id = n.id) p on td.name = p.name
INNER JOIN movie m on m.id = p.movie_id
);

DROP VIEW IF EXISTS directors_rating;
CREATE VIEW directors_rating AS(
SELECT n.name, AVG(r.avg_rating) as avg_rating, SUM(r.total_votes) as total_votes, min(r.avg_rating) as min_rating, max(r.avg_rating) as max_rating, SUM(duration) as total_duration
FROM ratings r INNER JOIN director_mapping dm on r.movie_id = dm.movie_id INNER JOIN names n on n.id = dm.name_id INNER JOIN movie m on m.id = r.movie_id,
top_directors WHERE n.name IN (top_directors.name)
GROUP BY (n.name)
);

DROP VIEW IF EXISTS date_summary;
CREATE VIEW date_summary as(
SELECT DISTINCT(dm.name_id), m.date_published, Lead(date_published,1) OVER(PARTITION BY dm.name_id ORDER BY date_published,dm.movie_id ) AS next_date_published
FROM movie m INNER JOIN director_mapping dm on m.id = dm.movie_id, directors WHERE dm.name_id IN (directors.name_id)
);

DROP VIEW IF EXISTS date_difference_avg;
CREATE VIEW date_difference_avg AS(
SELECT name_id, ROUND(AVG(Datediff(next_date_published, date_published))) AS date_difference_avg
 FROM date_summary WHERE next_date_published IS NOT NULL GROUP BY (name_id)
 );
 

SELECT d.name_id as director_id, d.name as director_name, d.number_of_movies, dda.date_difference_avg as avg_inter_movie_days,
dr.avg_rating, dr.total_votes, dr.min_rating, dr.max_rating, dr.total_duration
FROM directors d INNER JOIN directors_rating dr on d.name = dr.name INNER JOIN date_difference_avg dda on dda.name_id = d.name_id
ORDER BY (number_of_movies) desc;


