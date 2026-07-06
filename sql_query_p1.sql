-- SQL retail salas analysis - P1
CREATE DATABASE sql_project_p2;

		CREATE TABLE retail_sales
		(
		
			transactions_id INT PRIMARY KEY,
			sale_date DATE,
			sale_time TIME,
			customer_id INT,	
			gender VARCHAR(15),
			age INT,
			category VARCHAR(15),
			quantiy INT,
			price_per_unit FLOAT,
			cogs  FLOAT,
			total_sale FLOAT
		
		);


SELECT * FROM retail_sales
WHERE transactions_id IS NULL


SELECT * FROM retail_sales
WHERE
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL 
	OR
	total_sale IS NULL;


DELETE FROM retail_sales
WHERE 
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL 
	OR
	total_sale IS NULL;

SELECT COUNT(*)
  FROM retail_sales

--data exploration
--how many sales we have?

SELECT COUNT(*) as total_sale FROM retail_sales

--how many customers we have?
SELECT COUNT( DISTINCT customer_id) AS TOTAL_CUSTOMER FROM retail_sales 


SELECT  DISTINCT category 
 FROM retail_sales


 --data analysis questions

 --Q.1 write a SQL query to retrive all coloumns for sales made on ' 2022-11-05'
 SELECT * 
  FROM retail_sales
  WHERE sale_date = '2022-11-05'

/*  Q.2 write a SQL query to retrive all transaction where  the category is 'clothing' and the 
quantity sold is more  than 4 in the month on november-2022  */

SELECT *
 FROM retail_sales
 WHERE category = 'Clothing'
 AND 
 TO_CHAR(sale_date,'YYYY-MM')='2022-11'
 AND
 quantiy >= 4

 --Q.3  write a SQL query to calculate the total sales (total_sale) for each category

 SELECT category,
 SUM(total_sale) as net_sale
 FROM retail_sales
 
 GROUP BY category 
 
--Q.4  write a SQL query to find the average age of customer who purchased item from ' beauty' category

SELECT 
ROUND (AVG(age),3) AS age_of_customer
FROM retail_sales
where category = 'Beauty'

--Q.5 write a SQL query to FIND ALL  transaction where  the total_sale is greater than 1000.

 SELECT * 
  FROM retail_sales
  WHERE total_sale > 1000

--Q.6  write a SQL query to FIND the total number of transactions (transactions_id) made by each gender in each category.

 SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales
GROUP 
    BY 
    category,
    gender
ORDER BY 1


--Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1

--Q.8 Write a SQL query to find the top 5 customers based on the highest total sales

SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--Q.9 Write a SQL query to find the number of unique customers who purchased items from each category

SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category

--Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift
  