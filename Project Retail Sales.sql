-- SQL Retail Sales Analysis - P1
CREATE DATABASE sql_project1;


-- Create TABLE
USE sql_project1;
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
			(
			transactions_id	INT PRIMARY KEY,
            sale_date DATE,
            sale_time TIME,
            customer_id	INT,
            gender VARCHAR(15),
            age	INT,
            category VARCHAR(15),
            quantiy	INT,
            price_per_unit FLOAT,	
            cogs FLOAT,
            total_sale FLOAT
			);
            
SELECT * FROM retail_sales
LIMIT 10;

SELECT COUNT(*) FROM retail_sales;

--- Data Exploration 

-- How many sales we have?
SELECT COUNT(*) as total_sale 
FROM retail_sales;

-- How many unique customers we have?
SELECT COUNT(DISTINCT customer_id) as total_customers
FROM retail_sales;

-- How many unique categories we have?
SELECT COUNT(DISTINCT category) as total_categories
FROM retail_sales;

SELECT DISTINCT category FROM retail_sales;

-- Data Analysis & Business Key Problems & Answers

-- Q1. Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q2. Write a SQL Query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in 
-- the month of Nov-2022
SELECT * FROM retail_sales
WHERE category = 'Clothing'
	AND 
    DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
	AND
    quantiy >= 4;

-- Q3. Write a SQL query to calculate the total sales for each category
SELECT
	category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1;

-- Q4. Write a SQL query to find the average age of customers who purchased items from 'Beauty' category
SELECT
	AVG(age) as avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- Q5. Write a SQL query to find all transactions where the total_sale is greater than 1000
SELECT * FROM retail_sales
WHERE total_sale > 1000;

-- Q6. Write a SQL query to find the total number of transactions made by each gender in each category
SELECT 
	category,
    gender,
    COUNT(*) AS total_trans
FROM retail_sales
GROUP BY category, gender
ORDER BY 1;

-- Q7. Write a SQL query to calculate the average sale for each month. Find out the best selling month in each year
SELECT * FROM
(
	SELECT 
		YEAR(sale_date) AS year,
		month(sale_date) AS month,
		AVG(total_sale) AS avg_sale,
		RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) as r
	FROM retail_sales
	GROUP BY 1, 2
) as t1
WHERE r = 1;	

-- Q8. Write a SQL query to find the top 5 customers based on the highest total sales
SELECT 
	customer_id,
    SUM(total_sale) as total_sale
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Q9. Write a SQL query to find the number of unique chustomer who purchased items from each category
SELECT
	category,
    COUNT(DISTINCT customer_id) as unique_cus
FROM retail_sales
GROUP BY category;

-- Q10. Write a SQL query to create each shift and number of orders (e.g. Morning <= 12, Afternoon between 12 & 17, evening > 17)
WITH hourly_sales
AS
(
SELECT *,
	CASE 
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS shift
FROM retail_sales
)
SELECT 
	shift,
    COUNT(*) AS total_orders
FROM hourly_sales
GROUP BY shift;

-- End of Project