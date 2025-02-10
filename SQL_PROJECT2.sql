--SQL retail sales analysis 

--creat table 
DROP TABLE IF EXISTS Retail_sales;
CREATE TABLE Retail_sales
(
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

SELECT * FROM Retail_sales
LIMIT 10;

SELECT COUNT(*) FROM  Retail_sales;

-- check the all column if any null values present or ont
 		SELECT * FROM Retail_sales
		 WHERE transactions_id IS NULL;
		 
SELECT * FROM Retail_sales
WHERE 
    transactions_id IS NULL
    OR sale_date IS NULL
    OR customer_id IS NULL
    OR gender IS NULL
    OR age IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR price_per_unit IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;

DELETE  FROM Retail_sales
WHERE 
    transactions_id IS NULL
    OR sale_date IS NULL
    OR customer_id IS NULL
    OR gender IS NULL
    OR age IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR price_per_unit IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;

	-- how many sales we have 
	SELECT COUNT(*) AS Total_sale FROM Retail_sales;

--how many Uniqe costomer we have  in the records 
 SELECT COUNT(DISTINCT customer_id) AS Total_customer FROM Retail_sales;

 --how many uniqe category we have
 SELECT COUNT(DISTINCT category) AS Total_category FROM Retail_sales;
 
  SELECT DISTINCT category FROM Retail_sales;--category names

 -- Data Analysis & Business Key Problems & Answer

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
--Q 11: Identify the Top 3 Highest Revenue-Generating Customers 
--Q12: Find the Most Popular Product Category
---Q13: Find the Top 3 Customers with the Highest Average Order Value (AOV)	

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
  SELECT * FROM Retail_sales;
  
  SELECT * FROM Retail_sales
  WHERE sale_date='2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold
--is more than 3 in the month of Nov-2022
  SELECT *
  FROM Retail_sales
  WHERE category='Clothing' AND
 TO_CHAR(sale_date,'YYYY-mm')='2022-11'
 AND
 quantity>=3
  GROUP BY 1;
  
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
 
 SELECT DISTINCT category,SUM(total_sale) AS Net_sale
 FROM Retail_sales
 GROUP BY 1;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT category,ROUND(AVG(age)) AS AVG_Customer
FROM Retail_sales
WHERE category='Beauty'
GROUP BY 1 ;
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT transactions_id,total_sale --their you can use *
FROM Retail_sales
WHERE total_sale>1000;

SELECT * --their you can use *
FROM Retail_sales
WHERE total_sale>1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

	SELECT gender,category,COUNT(transactions_id) AS total_transaction
	FROM Retail_sales
	GROUP BY gender,category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year	

SELECT * FROM Retail_sales

 	SELECT sale_date,AVG(total_sale) 
	 FROM Retail_sales
	 WHERE TO_CHAR(sale_date,'YYYY-MM')>='01-2022'
	GROUP BY 1;
	 
SELECT * FROM -- use can use also year,month and ave_sale
(
 	SELECT EXTRACT( YEAR FROM sale_date) AS year,
	   EXTRACT(MONTH FROM sale_date ) AS month,AVG(total_sale) AS avg_sale,
	   RANK() OVER(PARTITION BY EXTRACT( YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC ) AS rank
	 FROM Retail_sales
	 GROUP BY year,month 
) AS t1
WHERE rank=1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
	
  SELECT * FROM Retail_sales
	
  SELECT customer_id,
  SUM(total_sale) AS Total_sales
  FROM Retail_sales
  GROUP BY 1
  ORDER BY 2 DESC LIMIT 5;

  -- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

  SELECT COUNT(DISTINCT customer_id),category AS uniqe_customer
  FROM Retail_sales
  GROUP BY 2;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 7, Evening >7)

--1st METHOD
   SELECT * ,
        CASE
		   WHEN sale_time<'12:00:00' THEN 'MORNING'
		   WHEN sale_time BETWEEN '12:00:00' AND '17:00:00' THEN 'AFTERNOON'
		   ELSE  'EVENING'
		   END AS SHIFT
		   FROM Retail_sales;
--2nd METHOD 
		    SELECT * ,
        CASE
		   WHEN EXTRACT(HOUR FROM sale_time)< 12 THEN 'MORNING'
		   WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'AFTERNOON'
		   ELSE  'EVENING'
		   END AS SHIFT
		   FROM Retail_sales;
		   
-- main ANS OF QUE 
    WITH hourly_sale 
	AS(
		   SELECT * ,
        CASE
		   WHEN EXTRACT(HOUR FROM sale_time)< 12 THEN 'MORNING'
		   WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'AFTERNOON'
		   ELSE  'EVENING'
		   END AS SHIFT
		   FROM Retail_sales
      )
   SELECT shift,COUNT(transactions_id) FROM hourly_sale --this is a transaction happen by shifts
   GROUP BY shift;
   
--Question 11: Identify the Top 3 Highest Revenue-Generating Customers
	 SELECT * FROM Retail_sales
	 
	 SELECT DISTINCT customer_id,SUM(total_sale) AS Revenue
	 FROM Retail_sales
	 GROUP BY 1
	 ORDER BY 2 DESC LIMIT 3;

--Q12: Find the Most Popular Product Category

		SELECT category,SUM(quantity) AS Popular_category
		FROM Retail_sales 
		GROUP BY category
		ORDER BY SUM(quantity) DESC LIMIT 1;

-- Q13: Find the Top 3 Customers with the Highest Average Order Value (AOV)
			
	SELECT DISTINCT customer_id,AVG(total_sale) AS Revenue
	 FROM Retail_sales
	 GROUP BY 1
	 ORDER BY 2 DESC LIMIT 3;

