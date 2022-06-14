1. Classic American names;
SELECT
    first_name,
    SUM(num)
FROM baby_names
GROUP BY first_name
HAVING COUNT(first_name) = 101
ORDER BY SUM(num) DESC ;
2. Timeless or trendy
SELECT
    first_name,
    SUM(num),
    CASE WHEN COUNT(first_name) > 80 THEN 'Classic'
         WHEN COUNT(first_name) > 50 THEN 'Semi-classic'
         WHEN COUNT(first_name) > 20 THEN 'Semi-trendy'
         ELSE 'Trendy' END AS popularity_type
    FROM baby_names
    GROUP BY first_name
    ORDER BY first_name ASC;
3. Top-ranked female names since 1920
SELECT
    RANK() OVER(ORDER BY SUM(num) DESC) AS name_rank,
    first_name,
    SUM(num)
FROM baby_names
WHERE sex = 'F'
GROUP BY first_name
LIMIT 10;
4. Picking a baby name
SELECT
    first_name
FROM baby_names
WHERE sex = 'F' AND year > 2015 AND first_name LIKE '%a'
GROUP BY first_name
ORDER BY SUM(num) DESC
5. The Olivia expansion
SELECT
    year,
    first_name,
    num,
    SUM(num) OVER(ORDER BY year) AS cumulative_olivias
FROM baby_names
WHERE first_name = 'Olivia'
ORDER BY year
6. Many males with the same name
SELECT
    year,
    MAX(num) AS max_num
FROM baby_names
WHERE sex = 'M'
GROUP BY year;
7. Top male names over the years
SELECT 
    b.year,
    first_name,
    num
FROM baby_names AS b
INNER JOIN (SELECT
                year,
                MAX(num) AS max_num
                FROM baby_names
                WHERE sex = 'M'
                GROUP BY year) AS sub 
ON b.year = sub.year AND b.num = sub.max_num
ORDER BY b.year DESC;
8. The most years at number one
WITH top_male_names AS (
    SELECT 
    b.year,
    first_name,
    num
FROM baby_names AS b
INNER JOIN (SELECT
                year,
                MAX(num) AS max_num
                FROM baby_names
                WHERE sex = 'M'
                GROUP BY year) AS sub 
ON b.year = sub.year AND b.num = sub.max_num
ORDER BY b.year DESC
)
SELECT
    first_name,
    COUNT(year) AS count_top_name
FROM top_male_names
GROUP BY first_name
ORDER BY count_top_name DESC;