create database movie_db;
use  movie_db;
-- 1.	A production company wants to identify profitable movies.
--  Write a query to find movies where revenue > budget. 
select title,revenue,budget 
from mov 
where revenue > budget;

-- To know the count values
select count(*) as profit_mov_count
from mov 
where revenue > budget;
-- This defines the total count of profitable movies
-- CONCLUSION: The analysis identifies movies that are financially successful by comparing revenue against budget.
-- 2.	Find the top 10 most profitable movies based on profit (revenue - budget). 
select title,(revenue - budget)  as profit
from mov 
order by profit desc
limit 10 ;
--  CONCLUSION: The top 10 most profitable movies highlight projects with the highest financial returns.

-- 3.	Identify movies that were high budget but failed (budget high but revenue low). 
select title,revenue,budget 
from mov 
where  budget > 100000000
and 
revenue < budget;
--  CONCLUSION:High-budget loss-making movies reveal risks associated with large investments.

-- 4.	Categorize movies into: 
-- •	Hit (profit > 100M) 
-- •	Average 
-- •	Flop (loss)
SELECT 
  title,
    budget,
    revenue,
    (revenue - budget) AS profit,
    
    CASE 
        WHEN (revenue - budget) > 100000000 THEN 'Hit'
        WHEN (revenue - budget) >= 0 THEN 'Average'
        ELSE 'Flop'
    END AS category
FROM mov
where (revenue - budget) > 100000000;
-- Conclusion: Movies are effectively categorized into Hit, Average, and Flop based on profitability.

-- 5.	Find movies with high ratings but low vote_count (hidden gems). 
select title,vote_count,vote_average
from mov 
where  vote_average >=5
and 
vote_count < 1000;
-- Conclusion: Hidden gems are identified as high-quality movies with low audience reach.

-- 6.	Find movies with low ratings but high vote_count (overhyped movies). 
select title,vote_count,vote_average
from mov 
where  vote_average <5
and 
vote_count >1000;
-- Conclusion: Overhyped movies are detected where popularity does not match audience ratings.

-- 7.	Get the top 5 highest rated movies with at least 1000 votes. 
select title,vote_count
from mov 
where  vote_count >1000 
order by vote_count desc
limit 5;
-- Conclusion: Highly-rated and widely voted movies represent strong audience approval.

-- 8.	Calculate the average rating of all movies.
select avg(vote_average) as average_rating
from mov ;
-- Conclusion: The average rating provides an overall measure of dataset quality.

-- 9.	Find the average budget and revenue of movies. 
select 
round (avg(budget),2) as avg_budget,
round(avg(revenue),2) as avg_revenue 
from mov ;

-- creating view 
create view vw_avg_br as
select title,budget,revenue,
avg(budget) over() as avg_budget,
avg(revenue) over() as avg_revenue 
from mov;
-- Conclusion: Budget and revenue averages help understand general industry investment trends.

-- 10.	Which movies have budget above average but revenue below average? 
select *
from vw_avg_br
where budget > avg_budget
and revenue < avg_revenue ;
-- Conclusion: Some movies show poor financial performance despite high investment.

-- 11.	Calculate the profit percentage for each movie:
select title, budget,
    revenue,
    round(((revenue - budget)/ budget) * 100,3) AS profit_perc
    from mov;
-- Conclusion: Profit percentage offers deeper insight into financial efficiency.

-- 12.	Find movies with highest ROI (Return on Investment).
select title ,budget,revenue ,round(((revenue - budget)/ budget) * 100,0) AS ROI
from mov
limit 10;
-- Conclusion: ROI analysis identifies the most efficient and rewarding investments.

-- 13.	Find the most common genre. 
select genres, count(*) as genres_count
from mov
group by genres
order by genres_count desc 
limit 1;
-- Conclusion: The most common genre reflects audience preference trends.
-- total count
select  count(genres) 
from mov;

-- 14.	Which genre has the highest average revenue? 
SELECT genres, AVG(revenue) AS avg_revenue
FROM mov
GROUP BY genres
ORDER BY avg_revenue DESC
LIMIT 1;
-- Conclusion: Certain genres consistently generate higher average revenue.

-- 15 Find genres with lowest average ratings
SELECT genres, AVG(revenue) AS avg_revenue
FROM mov
GROUP BY genres
ORDER BY avg_revenue asc
LIMIT 1;
-- Conclusion: Some genres underperform, indicating lower audience interest or returns.

-- 16.Number of movies produced in each language
select original_language ,count(*) as num_mov
from mov
group by original_language
order by num_mov desc;
-- Conclusion: Language-based analysis shows production distribution across regions.

-- 17. Which language has the highest average revenue?
SELECT original_language, AVG(revenue) AS rev_lang
FROM mov
GROUP BY original_language
ORDER BY  rev_lang desc
LIMIT 1;
-- Conclusion: Certain languages contribute more significantly to revenue generation.

-- 18. How many movies were released each year
SELECT YEAR(release_date) AS year, COUNT(*) AS total_movies
FROM mov
GROUP BY YEAR(release_date)
ORDER BY year;

-- Using DATE_FORMAT() instead of YEAR()
SELECT DATE_FORMAT(release_date, '%Y') AS year, 
       COUNT(*) AS total_movies
FROM mov
GROUP BY DATE_FORMAT(release_date, '%Y')
ORDER BY year;
-- Conclusion: Movie production trends vary across years.

-- 19. Year with highest total revenue
SELECT YEAR(release_date) AS year, SUM(revenue) AS total_revenue
FROM mov
GROUP BY YEAR(release_date)
ORDER BY total_revenue DESC 
LIMIT 1;
-- Conclusion: Specific years stand out with the highest total revenue generation.

-- 20. Most profitable movie in each year
SELECT Title, Release_date, Budget, Revenue, Profit
FROM (
    SELECT 
        Title,
        Release_date,
        Budget,
        Revenue,
        (Revenue - Budget) AS Profit,
        ROW_NUMBER() OVER (
            PARTITION BY  year(Release_date)
            ORDER BY (Revenue - Budget) DESC
        ) AS rn
    FROM Mov
) tab
WHERE rn = 1;
-- Conclusion: Each year has standout movies contributing maximum profit.

-- 21. Movies with revenue greater than average revenue
SELECT title, revenue
FROM mov
WHERE revenue > (
    SELECT AVG(revenue) FROM mov
);
-- Conclusion: Movies performing above average revenue indicate strong market success.

-- 22. Movies with rating above average rating
SELECT title,vote_average
FROM mov
WHERE vote_average > (
    SELECT AVG(vote_average) FROM mov
);
-- Conclusion: Above-average rated movies reflect better audience satisfaction.

-- 23. Movies with maximum revenue (using subquery)
SELECT title, revenue
FROM mov
WHERE revenue = (
    SELECT MAX(revenue) FROM mov
);
-- Using DENSE_RANK()
SELECT title, revenue
FROM (
    SELECT title, revenue,
           DENSE_RANK() OVER (ORDER BY revenue DESC) AS rnk
    FROM mov
) den_ran
WHERE rnk = 1;
-- Conclusion: Highest revenue movies represent peak commercial success.

-- 24. Rank movies based on revenue
SELECT title, revenue,
       RANK() OVER (ORDER BY revenue DESC) AS rank_position
FROM mov;
-- Conclusion: Ranking movies by revenue helps compare overall performance.
-- 
SELECT *
FROM (
    SELECT 
        title,
        YEAR(release_date) AS year,
        revenue,
        RANK() OVER (
            PARTITION BY YEAR(release_date)
            ORDER BY revenue DESC
        ) AS rnk FROM mov
) tab
WHERE rnk <= 3;
-- Conclusion: Top performers per year highlight consistent industry leaders.

-- 26. Running total of revenue
SELECT title, revenue,
       SUM(revenue) OVER (ORDER BY release_date) AS running_total
FROM mov;
-- Conclusion: Running revenue analysis shows growth trends over time.

-- 27. Difference from previous movie
SELECT 
    title,
    release_date,
    revenue,
    LAG(revenue) OVER (ORDER BY release_date) AS previous_revenue
FROM mov;
-- 
SELECT title, revenue,
       revenue - LAG(revenue) OVER (ORDER BY release_date) AS diff_from_prev
FROM mov;
-- Conclusion: Revenue comparison with previous movies reveals performance fluctuations.

-- 28. Procedure: Get movies above a given rating
DELIMITER //
CREATE PROCEDURE GetMoviesAboveRating(IN min_rating FLOAT)
BEGIN
    SELECT title, vote_average
    FROM mov
    WHERE vote_average > min_rating;
END //
DELIMITER ;
CALL GetMoviesAboveRating(7.5);
DROP PROCEDURE GetMoviesAboveRating;
-- Conclusion: Stored procedures improve reusability for filtering high-rated movies.

-- 29. Procedure: Movies within a budget range
DELIMITER //
CREATE PROCEDURE GetMoviesByBudget(
    IN min_budget BIGINT,
    IN max_budget BIGINT
)
BEGIN
    SELECT title, budget
    FROM mov
    WHERE budget BETWEEN min_budget AND max_budget;
END //
DELIMITER ;
CALL GetMoviesByBudget(50000000, 200000000);
-- Conclusion: Budget-based procedures help analyze investment-specific movies.

-- 30. Procedure: Top N profitable movies
DELIMITER //
CREATE PROCEDURE TopNProfitableMovies(IN n INT)
BEGIN
    SELECT title, (revenue - budget) AS profit
    FROM mov
    ORDER BY profit DESC
    LIMIT n;
END //
DELIMITER ;
CALL TopNProfitableMovies(5);
-- Conclusion: Top-N queries efficiently identify the most profitable movies.

-- 31. Movies with rating > 7 and vote_count > 5000
SELECT title, vote_average, vote_count
FROM mov
WHERE vote_average > 7 
  AND vote_count > 5000;
--   Conclusion: Combining ratings and vote count highlights genuinely successful movies.

  -- 32. Genres with average profit > 50M
  SELECT genres, AVG(revenue - budget) AS avg_profit
FROM mov
GROUP BY genres
HAVING AVG(revenue - budget) > 50000000;
-- Conclusion: Genre-based investment insights support strategic decision-making.

-- 33. Movies performing better than average revenue
SELECT title, revenue
FROM mov
WHERE revenue > (
    SELECT AVG(revenue) FROM mov
);
-- Conclusion: Above-average performers indicate competitive advantage in the market.

-- 34. Detect outliers (high budget, low rating)
SELECT title, budget, vote_average
FROM mov
WHERE budget > (
    SELECT AVG(budget) FROM mov
)
AND vote_average < (
    SELECT AVG(vote_average) FROM mov
);
-- Conclusion: Outliers reveal mismatches between investment and audience reception.

-- 35. Find movies where budget = 0 OR revenue = 0
SELECT title, budget, revenue
FROM mov
WHERE budget = 0 
   OR revenue = 0
   OR budget IS NULL OR revenue IS NULL;
-- Conclusion: Zero or missing financial data indicates data quality issues.

-- 36. Replace NULL values
-- Using IFNULL() 
SELECT 
    title,
    IFNULL(budget, 0) AS budget,
    IFNULL(revenue, 0) AS revenue
FROM mov;
-- Using COALESCE() 
SELECT 
    title,
    COALESCE(budget, 0) AS budget,
    COALESCE(revenue, 0) AS revenue
FROM mov;
-- Conclusion: Handling NULL values ensures more accurate and reliable analysis.

 select max(budget) from mov;
 select max(revenue) from mov;