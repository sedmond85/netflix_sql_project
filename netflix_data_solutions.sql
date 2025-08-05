SELECT *
FROM netflix;

SELECT 
	COUNT (*) AS total_content
FROM netflix;


DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
	show_id	VARCHAR(6),
	type	VARCHAR(10),
	title	VARCHAR(150),
	director	VARCHAR(208),
	casts	VARCHAR(1000),
	country	VARCHAR(150),
	date_added	VARCHAR(150),
	release_year INT,
	rating	VARCHAR(10),
	duration	VARCHAR(15),
	listed_in	VARCHAR(100),
	description VARCHAR(250)
);

SELECT 
	DISTINCT type
FROM netflix;


SELECT *
FROM netflix


-- 15 Business Problems

-- 1. Count the number of Movies & TV Shows

SELECT * 
FROM netflix

SELECT 
	type,
	COUNT(*) as total_content
FROM netflix
GROUP BY type


-- 2. Find the most common rating for movies and TV Shows

SELECT 
	type,
	rating
FROM
(
	SELECT 
		type,
		rating,
		COUNT(*),
		RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as ranking
	FROM netflix
	GROUP BY 1,2
) as t1
WHERE 
	ranking = 1

-- 3. List all the movies released in a specific year (e.g., 2020)
-- filter movies from 2020

SELECT * 
FROM netflix
WHERE
	type = 'Movie'
	AND
	release_year = 2020



-- 4. Find the top 5 countries with the most content on Netflix

SELECT DISTINCT 
	TRIM(UNNEST (string_to_array(country, ','))) as new_country,
	COUNT(show_id) AS total_content
FROM netflix
WHERE country IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5



-- 5. Identify the longest movie duration

SELECT *
FROM netflix
WHERE type ='Movie'
	AND duration =(SELECT MAX(duration) FROM netflix)



-- 6. Find content added in the last 5 years

SELECT *
FROM netflix
WHERE to_date(date_added, 'Month DD, YYYY') >= CURRENT_DATE - interval '5 years'

-- 7. Find all the movies/tv shows by the director 'Steven Spielberg'

SELECT *
FROM netflix
WHERE director ILIKE '%Steven Spielberg%'


-- 8. List all tv shows with more than 5 seasons

SELECT *
-- split_part (duration, ' ', 1) AS seasons
FROM netflix
WHERE type = 'TV Show'
	AND split_part(duration, ' ', 1)::numeric > 5



-- 9. Count the number of content items in each genre

SELECT
	TRIM(UNNEST (string_to_array (listed_in, ','))) as genre,
	COUNT (show_id) as total_content
FROM netflix
GROUP BY 1



-- 10. Find each year & and the average numbers of content release by Canada & return the top 5 years with the highest content release

SELECT 
  EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year,
  COUNT(*) AS total_content,
  COUNT(*)::numeric / (SELECT COUNT(*) FROM netflix WHERE country = 'Canada')::numeric * 100 AS avg_content
FROM netflix
WHERE country = 'Canada'
GROUP BY 1
ORDER BY avg_content DESC
LIMIT 5;


-- 11. List all movies that are documentaries

SELECT *
FROM netflix 
WHERE listed_in ILIKE '%documentaries%'




-- 12. Finad all content without a director

SELECT *
FROM netflix 
WHERE director is NULL


13. Find how many movies actor 'Kevin Hart' appeared in the last 10 years


SELECT *
FROM netflix
WHERE casts ILIKE '%Kevin Hart%'
	AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10

14. Find the top 10 actors who have appeared in the highest number of movies produced in USA

SELECT 
-- show_id, casts, 
	TRIM(UNNEST (STRING_TO_ARRAY(casts, ','))) as actors,
	COUNT(*) as total_content
FROM netflix 
WHERE country ILIKE '%united states%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10


-- 15. Categorize the content based on the keywords 'kill' and 'violence' in the description field. Label content containing these keywords as 'Bad'
 and all other content as 'Good'. Count hoe many items fall into each category

WITH new_table AS 
(
  SELECT *,
    CASE 
      WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad_Content' 
      ELSE 'Good_Content'
    END AS category
  FROM netflix
)

SELECT category,
  COUNT(*) AS total_content
FROM new_table
GROUP BY 1;
	
-- WHERE description ILIKE '%kill%' OR description ILIKE '%violence%'

