USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:



-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:


-- director_mapping
SELECT COUNT(*) 
FROM director_mapping;
-- There are 3867 rows in the director_mapping.

-- genre
SELECT COUNT(*)
FROM genre;
-- There are 14662 rows in the genre table.

-- movie
SELECT COUNT(*)
FROM movie;
-- There are 7997 rows in the movie table. 

-- names
SELECT COUNT(*)
FROM names;
-- There are 25735 rows in the names table.

-- ratings
SELECT COUNT(*)
FROM ratings;
-- There are 7997 rows in the ratings table.

-- role_mapping
SELECT COUNT(*)
FROM role_mapping;
-- There are 15615 rows in the role_mapping table.



-- Q2. Which columns in the movie table have null values?
-- Type your code below:

-- As found above, there are only 7997 rows in all in the movie table. 
-- So, if the individual columns have lesser value as the output of count, then that particular column in the table contains null.
SELECT COUNT(*) as total_count, 
	   COUNT(id) as id_count, 
       COUNT(title) as title_count, 
       COUNT(date_published) as date_published_count,
       COUNT(duration) as duration_count,
       COUNT(country) as country_count,
       COUNT(worlwide_gross_income) as worldwide_gross_income_count,
       COUNT(languages) as languages_count,
       COUNT(production_company) as production_company_count
FROM movie;

-- The columns worlwide_gross_income, languages and production_company have null values.



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


-- Part - 1
SELECT YEAR(date_published) as Year, 
	   COUNT(id) as number_of_movies
FROM movie
GROUP BY YEAR(date_published)
ORDER BY YEAR(date_published); 
/* Output : 
+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	3052			|
|	2018		|	2944			|
|	2019		|	2001			|
+---------------+-------------------+

*/

-- Part - 2

SELECT MONTH(date_published) as month_num, 
	   COUNT(id) as number_of_movies
FROM movie
GROUP BY month_num
ORDER BY month_num;

/*
Output:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 804			|
|	2			|	 640			|
|	3			|	 824			|
|	4			|	 680			|
|	5			|	 625			|
|	6			|	 580		    |
|	7			|	 493	    	|
|	8			|	 678			|
|	9			|	 809			|
|	10			|	 801			|
|	11			|	 625      		|
|	12			|	 438			|
+---------------+-------------------+ */




/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT COUNT(id) AS number_of_movies_produced
FROM movie
WHERE country = 'USA' OR 
      country = 'India' AND 
      YEAR(date_published) = 2019;

-- There were 2555 movies produced in the year 2019 in USA or India.`



/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT DISTINCT genre
FROM genre;

/*
The unique list of genre are as follows:
1. Drama
2. Fantasy 
3. Thriller 
4. Comedy 
5. Horror
6. Family 
7. Romance 
8. Adventure 
9. Action 
10. Sci-Fi 
11. Crime 
12. Mystery 
13. Others
*/


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

WITH genre_information 
AS(
	SELECT genre, 
		   COUNT(id) AS movie_count
	FROM movie m INNER JOIN genre g 
		 ON m.id = g.movie_id
	GROUP BY genre
	ORDER BY movie_count DESC
) 
SELECT genre, 
	   max(movie_count) AS  Overall_movie_count 
FROM genre_information;


-- Drama has the highest number of movies produced overall.


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH movie_genre_information 
AS(
SELECT movie_id, count(genre) AS genre_count
FROM genre
GROUP BY movie_id
HAVING count(genre) = 1
)
SELECT count(movie_id) AS number_of_movies
FROM movie_genre_information;
 
-- There are 3289 movies which belong to only one genre.



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

SELECT 
    genre, ROUND(AVG(duration), 2) AS avg_duration
FROM
    movie m
        INNER JOIN
    genre g ON g.movie_id = m.id
GROUP BY genre
ORDER BY avg_duration DESC;

/*
OUTPUT:
+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	Action	    |		112.88		|
|	Romance		|		109.53		|
|	Crime		|		107.05		|
|	Drama		|		106.77		|
|	Fantasy		|		105.14		|
|	Comedy		|		102.62		|
|	Adventure	|		101.87		|
|	Mystery	    |		101.80		|
|	Thriller	|		101.58		|
|	Family		|		100.97		|
|	Others		|		100.16		|
|	Sci-Fi		|		97.94		|
|	Horror		|		92.72		|
+---------------+-------------------+ 

*/



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

WITH genre_rank_information 
AS(
	SELECT genre, 
		   COUNT(movie_id) AS movie_count, 
           RANK() OVER(ORDER BY COUNT(movie_id) DESC) AS genre_rank
	FROM genre
	GROUP BY genre
)
SELECT *
FROM genre_rank_information
WHERE genre = 'Thriller';


/*
OUTPUT:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|Thriller		|		1484		|			3		  |
+---------------+-------------------+---------------------+

*/


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/


-- Segment 2:


-- Q10.  Find the minimum and maximum values in each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
SELECT MIN(avg_rating) AS min_avg_rating, 
	   MAX(avg_rating) AS max_avg_rating, 
       MIN(total_votes) AS min_total_votes, 
       MAX(total_votes) AS max_total_votes, 
       MIN(median_rating) AS min_median_rating, 
       MAX(median_rating) AS max_median_rating
FROM ratings;

/* 
OUTPUT:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		1.0		|			10.0	|	       100		  |	   725138	    	 |		1	       |	10			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+

*/

    

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

WITH movie_rating_rank 
AS(
	SELECT title, 
		   avg_rating, 
		   DENSE_RANK() OVER(ORDER BY avg_rating DESC) AS movie_rank
	FROM ratings r INNER JOIN movie m ON m.id = r.movie_id
)
SELECT *
FROM movie_rating_rank
WHERE movie_rank <=10;




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

SELECT median_rating, COUNT(movie_id) as movie_count
FROM ratings
GROUP BY median_rating
ORDER BY median_rating;

/* OUTPUT:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		94			|
|	2			|		119			|
|	3			|		283			|
|	4			|		479			|
|	5			|		985			|
|	6			|		1975		|
|	7			|		2257		|
|	8			|		1030		|
|	9			|		429			|
|	10			|		346			|
+---------------+-------------------+ 

*/




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

With production_company_hits 
AS(
	SELECT production_company, COUNT(movie_id) as movie_count
	FROM movie m INNER JOIN ratings r ON r.movie_id = m.id
	WHERE avg_rating > 8 AND production_company IS NOT NULL
	GROUP BY production_company
), 
production_company_ranks 
AS(
	SELECT *, DENSE_RANK() OVER(ORDER BY movie_count DESC) as prod_company_rank
	FROM production_company_hits
)
SELECT *
FROM production_company_ranks
WHERE prod_company_rank = 1; 

/* OUTPUT:
+--------------------------+-------------------+---------------------+
|production_company        |movie_count	       |	prod_company_rank|
+--------------------------+-------------------+---------------------+
|Dream Warrior Pictures    |		3		   |			1	  	 |
|National Theatre Live     |		3		   |			1	  	 |
+--------------------------+-------------------+---------------------+

*/

-- There are two production houses that have produced the most number of hit movies: Dream Warrior Pictures and National Theatre Live.


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

SELECT genre, COUNT(g.movie_id) as movie_count
FROM genre g INNER JOIN movie m ON m.id = g.movie_id INNER JOIN ratings r ON r.movie_id = m.id 
WHERE country = 'USA' AND MONTH(date_published) = 3 AND YEAR(date_published) = 2017 AND total_votes > 1000
GROUP BY genre
ORDER BY movie_count DESC; 



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

SELECT title, avg_rating, genre
FROM movie m INNER JOIN genre g ON m.id = g.movie_id INNER JOIN ratings r ON r.movie_id = g.movie_id
WHERE avg_rating > 8 and title like 'The%'
ORDER BY avg_rating DESC;







-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT median_rating, COUNT(movie_id) AS movie_count
FROM  ratings r INNER JOIN movie m ON m.id = r.movie_id
WHERE median_rating =  8 AND (date(date_published) BETWEEN '2018-04-01' AND '2019-04-01');

-- There are 361 such movies which were released between 1 April 2018 and 1 April 2019 with a median rating of 8.


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

-- Method -1: Using languages column 

SELECT languages, sum(total_votes) as Total_Votes
FROM movie m INNER JOIN ratings r ON m.id = r.movie_id
WHERE languages LIKE '%German%' OR languages LIKE '%Italian%'
GROUP BY languages
ORDER BY Total_Votes DESC;
 

-- Method -2: Using country column
SELECT country, sum(total_votes) as Total_Votes
FROM movie m INNER JOIN ratings r ON m.id = r.movie_id
WHERE country = 'Germany' or country = 'Italy'
GROUP BY country
ORDER BY Total_Votes DESC;

-- Clearly, German movies get more votes than Italian movies as per the observation

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



SELECT 
	SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls,
    SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
    SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
    SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM names;

/*
OUTPUT:
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|		17335		|	      13431		  |	   15226	    	 |
+---------------+-------------------+---------------------+----------------------+

*/

-- Clearly, there are no null values in the name column. 
-- However, height, date_of_birth as well as known_for_movies contain null values.


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

SELECT name as director_name, COUNT(m.id) as movie_count
FROM names n 
	 INNER JOIN director_mapping dm ON dm.name_id = n.id 
     INNER JOIN movie m ON dm.movie_id = m.id 
     INNER JOIN genre g ON g.movie_id = m.id
     INNER JOIN ratings r ON r.movie_id = m.id
WHERE genre 
IN (
WITH genre_rank_info 
AS(
	SELECT genre, 
		   COUNT(r.movie_id) AS movie_count,
		   RANK() OVER(ORDER BY COUNT(r.movie_id) DESC)  AS genre_rank
	FROM genre g INNER JOIN ratings r ON r.movie_id = g.movie_id
	WHERE avg_rating > 8 
	GROUP BY genre
    LIMIT 3
)
SELECT genre
FROM genre_rank_info 
) AND avg_rating > 8
GROUP BY director_name
ORDER BY movie_count DESC
LIMIT 3;

-- The top 3 directors in the top three genres are: James Mangold, Anthony Russo and Soubin Shahir

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

SELECT name as actor_name, count(m.id) as movie_count
FROM role_mapping rm 
	 INNER JOIN names n ON n.id = rm.name_id
     INNER JOIN movie m ON m.id = rm.movie_id
     INNER JOIN ratings r ON r.movie_id = m.id
WHERE median_rating >= 8
GROUP BY actor_name
ORDER BY movie_count DESC
LIMIT 2;

/* OUTPUT:

+---------------+-------------------+
| actor_name	|	movie_count		|
+---------------+-------------------+
|Mammootty  	|		8			|
|Mohanlal		|		5			|
+---------------+-------------------+ 

*/


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

SELECT production_company, 
       SUM(total_votes) AS vote_count,
       RANK() OVER(ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM movie m 
	 INNER JOIN ratings r ON r.movie_id = m.id
GROUP BY production_company
LIMIT 3;

-- The top 3 production companies are: Marvel Studios, Twentieth Century Fox and Warner Bros. 	


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
WITH actor_info 
AS(
	SELECT name as actor_name, total_votes, 
		   COUNT(m.id)  as movie_count,
		   ROUND(SUM(avg_rating*total_votes)/SUM(total_votes), 2) AS actor_avg_rating
	FROM movie m 
		 INNER JOIN ratings r ON r.movie_id = m.id
		 INNER JOIN role_mapping rm ON rm.movie_id = m.id
		 INNER JOIN names n ON n.id = rm.name_id
	WHERE category='Actor'
		  AND country = 'India'
	GROUP BY actor_name
    HAVING movie_count >= 5
)
SELECT *, RANK() OVER(ORDER BY actor_avg_rating DESC) AS actor_rank
FROM actor_info; 

-- Vijay Sethupathi is at the top of the list.


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

WITH actress_info 
AS(
	SELECT name as actress_name, sum(total_votes), 
		   COUNT(m.id)  as movie_count,
		   ROUND(SUM(avg_rating*total_votes)/SUM(total_votes), 2) AS actress_avg_rating
	FROM movie m 
		 INNER JOIN ratings r ON r.movie_id = m.id
		 INNER JOIN role_mapping rm ON rm.movie_id = m.id
		 INNER JOIN names n ON n.id = rm.name_id
	WHERE category='Actress'
		  AND country = 'India'
          AND languages like '%Hindi%'
	GROUP BY actress_name
    HAVING movie_count >= 3
)
SELECT *, RANK() OVER(ORDER BY actress_avg_rating DESC) AS actress_rank
FROM actress_info; 

-- Tapsee Pannu tops the list of actress.
-- The top 5 actresses in the list are: Tapsee Pannu, Kriti Sanon, Divya Dutta, Shraddha Kapoor, and Kriti Kharbanda.


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
WITH thriller_info 
AS(
	SELECT title, avg_rating AS Rating
	FROM movie m 
		 INNER JOIN ratings r ON r.movie_id = m.id
		 INNER JOIN genre g ON g.movie_id = m.id
	WHERE genre= 'Thriller'
)
SELECT *, 
	   CASE
		   WHEN Rating > 8 THEN 'Superhit movies'
           WHEN Rating BETWEEN 7 AND 8 THEN 'Hit movies'
           WHEN Rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
           ELSE 'Flop movies'
       END AS Movie_Category
FROM thriller_info;    



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

SELECT genre, 
       AVG(duration) AS avg_duration,
       SUM(ROUND(AVG(duration), 2)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
       AVG(ROUND(AVG(duration), 2)) OVER(ORDER BY genre ROWS 10 PRECEDING) AS moving_average_duration
FROM genre g 
     INNER JOIN movie m ON g.movie_id = m.id
GROUP BY genre;



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
WITH genre_top_3_ranking 
AS(
SELECT genre, COUNT(m.id) as movie_count, RANK() OVER(ORDER BY genre DESC) AS genre_rank 
FROM genre g INNER JOIN movie m ON m.id = g.movie_id
GROUP BY genre
) 
SELECT genre
FROM genre_top_3_ranking
WHERE genre_rank <= 3;

-- Top 3 genres are: Thriller, Sci-Fi, and Romance


-- Movie Analysis
WITH movie_ranking AS(
	SELECT genre, 
		   YEAR(date_published) AS year, 
		   title AS movie_name, 
           CAST(REPLACE(REPLACE(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS DECIMAL(10)) AS worldwide_gross_income,
           RANK() OVER(PARTITION BY YEAR(date_published) ORDER BY CAST(replace(replace(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS decimal(10)) DESC) AS movie_rank
	FROM genre g INNER JOIN movie m ON m.id = g.movie_id
	WHERE genre IN ( WITH genre_top_3_ranking 
					 AS(
					 SELECT genre, COUNT(m.id) as movie_count, RANK() OVER(ORDER BY genre DESC) AS genre_rank 
					 FROM genre g INNER JOIN movie m ON m.id = g.movie_id
					 GROUP BY genre
					) 
						SELECT genre
						FROM genre_top_3_ranking
						WHERE genre_rank <= 3)
						)
						SELECT *
						FROM movie_ranking
						WHERE movie_rank <= 5;






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
WITH production_company_summary 
AS(
SELECT production_company, COUNT(m.id) as movie_count, RANK() OVER(ORDER BY COUNT(m.id) DESC) as prod_camp_rank
FROM movie m INNER JOIN ratings r ON r.movie_id = m.id
WHERE position(',' IN languages) > 0 AND median_rating >= 8 AND production_company IS NOT NULL
GROUP BY production_company
)
SELECT *
FROM production_company_summary
WHERE prod_camp_rank <= 2;

-- The top two production houses are: Star Cinema and Twentieth Century Fox


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

WITH actress_summary 
AS(
	SELECT name as actress_name, 
		   SUM(total_votes) AS total_votes, 
           COUNT(m.id) as movie_count, 
		   ROUND(SUM(avg_rating*total_votes)/SUM(total_votes), 2) AS actress_avg_rating,
		   RANK() OVER(ORDER BY COUNT(m.id) DESC) AS actress_rank
	FROM movie m 
		 INNER JOIN role_mapping rm ON rm.movie_id = m.id
		 INNER JOIN names n ON n.id = rm.name_id
		 INNER JOIN ratings r ON r.movie_id = rm.movie_id
		 INNER JOIN genre g ON g.movie_id = rm.movie_id
	WHERE avg_rating > 8 AND genre = 'drama' AND category='Actress'
    GROUP BY actress_name
)
SELECT *
FROM actress_summary
WHERE actress_rank <= 3;

-- Top 3 actresses are: Parvthy Thiruvothu, Susan Brown, and Amanda Lawrence


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

-- Type your code below:

WITH date_summary 
AS(
SELECT d.name_id,
	   n.name,
       m.date_published,
       duration,
       total_votes,
       d.movie_id,
       r.avg_rating,
       LEAD(m.date_published,1) OVER(partition BY d.name_id ORDER BY date_published, d.movie_id ) AS next_movie_date
FROM director_mapping d 
	 INNER JOIN names n ON n.id = d.name_id
     INNER JOIN movie m ON m.id = d.movie_id
     INNER JOIN ratings r ON r.movie_id = m.id
), inter_movie_days_calc
AS(
SELECT *, Datediff(next_movie_date, date_published) AS date_difference
FROM date_summary
)
SELECT name_id AS director_id,
	   name AS director_name,
       COUNT(movie_id) AS number_of_movies,
       ROUND(AVG(avg_rating), 2) AS avg_rating,
       ROUND(AVG(date_difference), 2) AS avg_inter_movie_days,
       SUM(total_votes) AS total_votes,
       MIN(avg_rating) AS min_rating,
       MAX(avg_rating) AS max_rating,
       SUM(duration) AS total_duration
FROM inter_movie_days_calc
GROUP BY director_id
ORDER BY number_of_movies DESC
LIMIT 9;

-- The End.



