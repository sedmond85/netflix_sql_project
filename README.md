# Netflix Data Analysis with SQL
![netflix_logo](https://images.ctfassets.net/y2ske730sjqp/5QQ9SVIdc1tmkqrtFnG9U1/de758bba0f65dcc1c6bc1f31f161003d/BrandAssets_Logos_02-NSymbol.jpg?w=940)

##This project explores Netflix's content using raw SQL. It includes table creation and 15 real-world business queries to extract insights from the platform’s dataset. The analysis is done entirely in SQL using PostgreSQL, with a focus on learning, exploration, and content strategy insights.

---

## 🧰 Technologies Used

- PostgreSQL
- SQL (GROUP BY, Window Functions, CTEs, Text Search)
- Netflix Sample Dataset

---

## 📁 Project Files

- `netflix_analysis.sql` – Main SQL script
- `README.md` – Project description and documentation

---

## 🏗️ Table Setup

```sql
DROP TABLE IF EXISTS netflix;

CREATE TABLE netflix (
  show_id VARCHAR(6),
  type VARCHAR(10),
  title VARCHAR(150),
  director VARCHAR(208),
  casts VARCHAR(1000),
  country VARCHAR(150),
  date_added VARCHAR(150),
  release_year INT,
  rating VARCHAR(10),
  duration VARCHAR(15),
  listed_in VARCHAR(100),
  description VARCHAR(250)
);
````

---

## 🔍 Business Questions + SQL Queries

### 1. 📺 Count the number of Movies & TV Shows

```sql
SELECT type, COUNT(*) AS total_content
FROM netflix
GROUP BY type;
```

---

### 2. 🔢 Find the most common rating for Movies and TV Shows

```sql
SELECT 
  type,
  rating
FROM (
  SELECT 
    type,
    rating,
    COUNT(*),
    RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
  FROM netflix
  GROUP BY 1, 2
) AS t1
WHERE ranking = 1;
```

---

### 3. 🎬 List all Movies released in 2020

```sql
SELECT * 
FROM netflix
WHERE type = 'Movie'
  AND release_year = 2020;
```

---

### 4. 🌎 Top 5 countries with the most content

```sql
SELECT 
  TRIM(UNNEST(string_to_array(country, ','))) AS new_country,
  COUNT(show_id) AS total_content
FROM netflix
WHERE country IS NOT NULL
GROUP BY 1
ORDER BY total_content DESC
LIMIT 5;
```

---

### 5. 🕒 Identify the longest movie duration

```sql
SELECT *
FROM netflix
WHERE type = 'Movie'
  AND duration = (SELECT MAX(duration) FROM netflix);
```

---

### 6. 📅 Find content added in the last 5 years

```sql
SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
```

---

### 7. 🎥 Find all content directed by Steven Spielberg

```sql
SELECT *
FROM netflix
WHERE director ILIKE '%Steven Spielberg%';
```

---

### 8. 📺 List all TV Shows with more than 5 seasons

```sql
SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND SPLIT_PART(duration, ' ', 1)::NUMERIC > 5;
```

---

### 9. 🎭 Count the number of content items in each genre

```sql
SELECT
  TRIM(UNNEST(string_to_array(listed_in, ','))) AS genre,
  COUNT(show_id) AS total_content
FROM netflix
GROUP BY 1;
```

---

### 10. 🍁 Top 5 years with most Canadian content added (by %)

```sql
SELECT 
  EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year,
  COUNT(*) AS total_content,
  COUNT(*)::NUMERIC / (SELECT COUNT(*) FROM netflix WHERE country = 'Canada')::NUMERIC * 100 AS avg_content
FROM netflix
WHERE country = 'Canada'
GROUP BY 1
ORDER BY avg_content DESC
LIMIT 5;
```

---

### 11. 📚 List all movies that are Documentaries

```sql
SELECT *
FROM netflix 
WHERE listed_in ILIKE '%documentaries%';
```

---

### 12. 🎬 Find all content without a director

```sql
SELECT *
FROM netflix 
WHERE director IS NULL;
```

---

### 13. 🎤 Count how many movies Kevin Hart appeared in the last 10 years

```sql
SELECT *
FROM netflix
WHERE casts ILIKE '%Kevin Hart%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```

---

### 14. 👤 Top 10 most-featured actors in U.S. content

```sql
SELECT 
  TRIM(UNNEST(STRING_TO_ARRAY(casts, ','))) AS actors,
  COUNT(*) AS total_content
FROM netflix 
WHERE country ILIKE '%united states%'
GROUP BY 1
ORDER BY total_content DESC
LIMIT 10;
```

---

### 15. ⚠️ Categorize content as “Good” or “Bad” based on keywords

```sql
WITH new_table AS (
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
```

---

## 📈 Insights You Can Draw

* Content trends over time
* Most popular genres and ratings
* Actor/director frequency analysis
* Geographic content distribution
* Simple content safety classification based on description

---

## 🚀 How to Use

1. Clone the repo:

   ```bash
   git clone https://github.com/your-username/netflix-sql-analysis.git
   cd netflix-sql-analysis
   ```

2. Load the Netflix dataset into your PostgreSQL database.

3. Run the queries in `netflix_analysis.sql` using a SQL IDE or CLI.

4. Modify queries as needed to explore deeper.

---

## 📬 Feedback

Open an issue or submit a PR if you have improvements or ideas!

---

## 📜 License

This project is licensed under the [MIT License](LICENSE).

```

---

Let me know if you want help adding sample data or a link to the dataset in the repo.
```
