-- Walmart Project

CREATE Database walmart_sales;
USE walmart_sales;

SELECT 
    *
FROM
    walmart;

-- Count total records
SELECT 
    COUNT(*)
FROM
    walmart;

-- Count payment methods and number of transactions by payment method
SELECT 
    payment_method, COUNT(*) AS no_of_payments
FROM
    walmart
GROUP BY payment_method;

-- Count distinct branches
SELECT 
    COUNT(DISTINCT branch)
FROM
    walmart;

-- Find the minimum quantity sold
SELECT 
    MIN(quantity)
FROM
    walmart;

-- Q1: Find different payment methods, number of transactions, and quantity sold by payment method
SELECT 
    payment_method,
    COUNT(*) AS no_of_payments,
    SUM(quantity) AS no_qty_sold
FROM
    walmart
GROUP BY payment_method;

-- Q2: Identify the highest-rated category in each branch
-- Display the branch, category, and avg rating
SELECT branch, category, avg_rating
FROM (
    SELECT 
        branch,
        category,
        ROUND(AVG(rating),2) AS avg_rating,
        RANK() OVER(PARTITION BY branch ORDER BY AVG(rating) DESC) AS rankk
    FROM walmart
    GROUP BY branch, category
) AS ranked
WHERE rankk = 1
LIMIT 10;

-- Q3: Identify the busiest day for each branch based on the number of transactions
SELECT branch, day_name, no_transactions
FROM (
    SELECT 
        branch,
        DAYNAME(date) AS day_name,
        COUNT(*) AS no_transactions,
        RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rankk
    FROM walmart
    GROUP BY branch, day_name
) AS ranked
WHERE rankk = 1
LIMIT 10;

-- Q4: Calculate the total quantity of items sold per payment method
SELECT 
    payment_method, SUM(quantity) AS no_qty_sold
FROM
    walmart
GROUP BY payment_method;

-- Q5: Determine the average, minimum, and maximum rating of categories for each city
SELECT 
    city,
    category,
    MIN(rating) AS min_rating,
    MAX(rating) AS max_rating,
    ROUND(AVG(rating), 2) AS avg_rating
FROM
    walmart
GROUP BY city , category
LIMIT 10;

-- Q6: Calculate the total profit for each category
SELECT 
    category,
    ROUND(SUM(unit_price * quantity * profit_margin),
            2) AS total_profit
FROM
    walmart
GROUP BY category
ORDER BY total_profit DESC;

-- Q7: Determine the most common payment method for each branch
WITH cte AS (
    SELECT 
        branch,
        payment_method,
        COUNT(*) AS total_trans,
        RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rankK
    FROM walmart
    GROUP BY branch, payment_method
)
SELECT branch, payment_method AS preferred_payment_method
FROM cte
WHERE rankK = 1
LIMIT 10;

-- Q8: Categorize sales into Morning, Afternoon, and Evening shifts
SELECT 
    branch,
    CASE
        WHEN HOUR(time) < 12 THEN 'Morning'
        WHEN HOUR(time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS num_invoices
FROM
    walmart
GROUP BY branch , shift
ORDER BY branch , num_invoices DESC;