-- output the entire table
select * 
from walmart;

-- checking the count of rows in the dataset
select count(*)
from walmart;

-- how many ways people have made payments
select DISTINCT (payment_method)
from walmart;

-- how many transactions in each payment method
select payment_method, count (*) as "# of transactions"
from walmart
group by payment_method
order by "# of transactions" desc;

-- how many different stores are there
select count(distinct(Branch)) as "branches"
from walmart;

-- -----------------------------------------------------------------------------
-- SOLVING SOME BUSINESS PROBLEMS


-- Q1. Find different payment method, number of transactions, and quantity sold by payment method
select payment_method, count (*) as "# of transactions", sum(quantity) as "# of quantity sold"
from walmart
group by payment_method
order by "# of transactions" desc;

-- Q2. Identify the highest-rated category in each branch. Display the branch, category, and avg rating

select *
from (

		select Branch, category, avg(rating) as avg_rating, rank() over (partition by branch order by avg(rating) desc) as rank
		from walmart
		group by Branch, category
		order by branch, avg_rating desc
)
where rank = 1;

-- Q3. Identify the busiest day for each branch based on the number of transactions
SELECT *
FROM (
    SELECT 
        branch,
        CASE strftime('%w', '20' || substr(date, 7, 2) || '-' || substr(date, 4, 2) || '-' || substr(date, 1, 2))
            WHEN '0' THEN 'Sunday'
            WHEN '1' THEN 'Monday'
            WHEN '2' THEN 'Tuesday'
            WHEN '3' THEN 'Wednesday'
            WHEN '4' THEN 'Thursday'
            WHEN '5' THEN 'Friday'
            WHEN '6' THEN 'Saturday'
        END AS day_name, 
        COUNT(*) AS num_transactions,
        -- FIXED LINE BELOW:
        RANK() OVER (PARTITION BY branch ORDER BY COUNT(*) DESC) AS rank
    FROM walmart
    GROUP BY branch, day_name
)
WHERE rank = 1;

-- Q4: Calculate the total quantity of items sold per payment method
select payment_method, sum(quantity) as num_quant_sold
from walmart
group by payment_method
order by "# of transactions" desc;

-- Q5. Determine the average, minimum, and maximum rating of categories for each city. 
-- list the city, average_rating, min_rating, and max_rating.
		-- we need to do group by city and by category
select city, 
	   category, 
	   min(rating) as min_rating,
	   max(rating) as max_rating,
	   avg(rating) as avg_rating
from walmart
group by city, category

--Q6: Calculate the total profit for each category. List category and total profit, 
--	  ordered from highest to lowest profit
select category, sum(total * profit_margin) as profit
from walmart
group by category
order by profit desc


-- Q7: Determine the most common payment method for each branch
with cte
as
(
	select 
		branch, 
		payment_method, 
		count(*) as total_trans,
		rank() over (partition by branch order by count(*) desc) as rank
	from walmart
	group by branch, payment_method
)
select *
from cte 
where rank= 1

-- q8. Categorize sales into 3 groups: Morning, Afternoon, and Evening
		-- we need to convert "text" format to "time" format for the time column
SELECT 
    branch,
    CASE 
        WHEN CAST(strftime('%H', time) AS INT) < 12 THEN 'Morning'
        WHEN CAST(strftime('%H', time) AS INT) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS day_time,
    COUNT(*) AS count
FROM walmart
GROUP BY branch, day_time
ORDER BY branch ASC, count DESC;

-- Q9. Identify the 5 branches with the highest revenue decrease ratio in revenue
--     from last year to current year (e.g., 2022 to 2023)

-- find each branch's revenue for prev yr and current yr.
        --- Revenue decrease ration = rdr
--          basic formula rdr= last_rev-cr_rev/ls-rev *100

--		SELECT *,
--			   '20' || SUBSTR(date, -2) AS formated_date
--		FROM walmart

WITH revenue_2022 AS (
    SELECT 
        branch,
        SUM(total) AS revenue
    FROM walmart
    -- Replicating the EXTRACT logic safely for SQLite:
    WHERE '20' || SUBSTR(date, -2) = '2022'
    GROUP BY 1
), 
revenue_2023 AS (
    SELECT 
        branch,
        SUM(total) AS revenue
    FROM walmart
    -- Replicating the EXTRACT logic safely for SQLite:
    WHERE '20' || SUBSTR(date, -2) = '2023'
    GROUP BY 1
)
select ls.branch, ls.revenue as last_year_revenue, 
		cs.revenue as cr_year_revenue, 
		round((ls.revenue - cs.revenue)/ls.revenue * 100, 2) as decr_ratio
from revenue_2022 as ls -- last yr sale
Join 
revenue_2023 as cs -- current sale
on ls.branch = cs.branch -- branch where its same in both cols
where ls.revenue > cs.revenue -- because we are finding the decrease ratio
order by 4 desc
limit 5 -- to get top 5 branches