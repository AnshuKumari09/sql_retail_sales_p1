CREATE DATABASE sql_project_p2;


DROP TABLE IF EXISTS retail_sales;

CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE, 
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);

SELECT * FROM retail_sales
LIMIT 10;

-- data cleaning
SELECT * FROM retail_sales
WHERE   
    sale_date IS NULL
	OR 
    quantity IS NULL
	OR
    cogs IS NULL
	OR
    total_sale IS NULL;

DELETE FROM retail_sales
WHERE   
    sale_date IS NULL
    OR quantity IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;

-- SELECT COUNT(*) FROM retail_sales  (kitne rows the pta krne ke liye)

-- data exploration 
-- How many sales we have ?
-- SELECT COUNT(*) as total_sale FROM retail_sales

-- how many unique customers we have?
-- SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales

-- SELECT DISTINCT category FROM retail_sales

-- main data analysis & Business key problems & Answers

-- Q1. write a sql query to retrieve all columns for sales made on '2022-11-05'.
SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05';

--Q2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the Quantity sold is 
-- more than 4 in the month of Nov-2022
-- SELECT 
--     category,           -- ← This is column 1
--     SUM(quantity)       -- ← This is column 2
-- FROM retail_sales           --it is giving full quantity sum of clothing
-- WHERE category = 'Clothing'
-- GROUP BY 1;

-- SELECT 
--     category,          
--     SUM(quantity)      
-- FROM retail_sales           
-- WHERE category = 'Clothing'
--   AND 
--   TO_CHAR(sale_date,'YYYY-MM') = '2022-11'
-- GROUP BY 1;

SELECT 
*    
FROM retail_sales           
WHERE category = 'Clothing'
  AND 
  TO_CHAR(sale_date,'YYYY-MM') = '2022-11'
  AND
  quantity >= 4
GROUP BY 1;

-- Q3. Write a SQL query to calculate the total_sales(total_sale) for each category
SELECT 
    category,           
    SUM(total_sale) as net_sale,
	COUNT(*) as total_orders
FROM retail_sales           --it is giving full quantity sum of clothing
GROUP BY 1;

--Q4. write a SQL query to find the average age of customer who purchaseditems from 'Beauty' category.
-- SELECT 
-- *
-- FROM retail_sales
-- WHERE category = 'Beauty'

-- SELECT 
-- AVG(age) as avg_age  -- number is too big , let round off
-- FROM retail_sales
-- WHERE category = 'Beauty'

SELECT 
ROUND(AVG(age),2) as avg_age  -- number is too big , let round off
FROM retail_sales
WHERE category = 'Beauty'

--Q5. write a SQL query to find all transactions where the total_sale is greater than 100
SELECT * FROM retail_sales
WHERE total_sale>1000

--Q6. Write a sql query to find the total number of transactions (transaction_id) made by each gender in each category
SELECT 
    category, 
    gender,
    COUNT(*) AS total_trans
FROM retail_sales
GROUP BY category, gender
ORDER BY 1;

--Q7. Write a SQL query to calculate the average sale for each month. find out best selling month in each year 
-- SELECT ROUND(AVG(total_sale)::NUMERIC, 2) AS avg_sale
-- FROM retail_sales;

-- SELECT 
--     EXTRACT(YEAR FROM sale_date) AS year,  
--     EXTRACT(MONTH FROM sale_date) AS month, 
--     ROUND(AVG(total_sale)::NUMERIC ,2) AS avg_sale,
--     RANK() OVER (
--         PARTITION BY EXTRACT(YEAR FROM sale_date)
--         ORDER BY ROUND(AVG(total_sale)::NUMERIC ,2) DESC
--     ) AS monthly_rank
-- FROM retail_sales
-- GROUP BY 1, 2
-- ORDER BY 1, 3 DESC;

SELECT year,
       month,
	   avg_sale FROM(
SELECT
    EXTRACT(YEAR FROM sale_date) AS year,  
    EXTRACT(MONTH FROM sale_date) AS month, 
    ROUND(AVG(total_sale)::NUMERIC ,2) AS avg_sale,
    RANK() OVER (
        PARTITION BY EXTRACT(YEAR FROM sale_date)
        ORDER BY ROUND(AVG(total_sale)::NUMERIC ,2) DESC
    ) AS monthly_rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE monthly_rank = 1

--Q8 . Write a sql query to find the top 5 customers based on the highest total_sales
total sales select karo, desc order me bnao, aur kaho ki upar ka 5 chahiye.
SELECT customer_id,
       SUM(total_sale) AS total_spent
FROM retail_sales
GROUP BY customer_id
ORDER BY 2 DESC
LIMIT 5;

--Q9. Write a SQL query to find the number of unique customers who purchased items from each category.
-- SELECT category,
--        COUNT(DISTINCT(customer_id)) as unique_cust
-- 	   FROM retail_sales
-- 	   GROUP BY category

SELECT 
   CASE 
      WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
      WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
      ELSE 'Evening'
   END AS shift,
   COUNT(*) AS number_of_orders
FROM retail_sales
GROUP BY shift;


-- SELECT EXTRACT(HOUR FROM CURRENT_TIME)