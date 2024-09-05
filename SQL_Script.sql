                                                          -- DATA WRANGLING  
                                         
-- QUERY FOR CREATING DATABASE
CREATE DATABASE amazondata;      

-- QUERY FOR SELECTING DATABASE OF INTEREST
USE amazondata;           
       
-- QUERY FOR CREATING TABLE
CREATE TABLE sales (
    invoice_id VARCHAR(11) NOT NULL,
    branch VARCHAR(1) NOT NULL,
    city VARCHAR(9) NOT NULL,
    customer_type VARCHAR(6) NOT NULL,
    gender VARCHAR(6) NOT NULL,
    product_line VARCHAR(22) NOT NULL,
    unit_price DECIMAL(4 , 2 ) NOT NULL,
    quantity TINYINT UNSIGNED NOT NULL,
    vat DECIMAL(6 , 4 ) NOT NULL,
    total DECIMAL(8 , 4 ) NOT NULL,
    purchase_date DATE NOT NULL,
    purchase_time TIME NOT NULL,
    payment_method VARCHAR(11) NOT NULL,
    cogs DECIMAL(5 , 2 ) NOT NULL,
    gross_margin_percentage DECIMAL(10 , 9 ) NOT NULL DEFAULT 4.761904762,
    gross_income DECIMAL(6 , 4 ) NOT NULL,
    rating DECIMAL(3 , 1 ) NOT NULL
);

                                                    -- FEATURE ENGINEERING 
                                                    
-- QUERY TO ADD COLUMN time_of_day BY USING ALTER STATEMENT AND TO INSERT DATA USING UPDATE STATEMENT, CASE STATEMENT AND HOUR FUNCTION 
ALTER TABLE sales
ADD COLUMN time_of_day VARCHAR(9) NOT NULL;

UPDATE sales
SET time_of_day = CASE
    WHEN HOUR(purchase_time) < 12 THEN 'Morning'
    WHEN HOUR(purchase_time) < 18 THEN 'Afternoon'
    ELSE 'Evening'
END;

-- QUERY TO ADD COLUMN name_of_day BY USING ALTER STATEMENT AND TO INSERT DATA USING UPDATE STATEMENT AND DAYNAME FUNCTION 
ALTER TABLE sales
ADD COLUMN name_of_day VARCHAR(9) NOT NULL;

UPDATE sales
SET name_of_day = DAYNAME(purchase_date);

-- QUERY TO ADD COLUMN name_of_month BY USING ALTER STATEMENT AND TO INSERT DATA USING UPDATE STATEMENT AND MONTHNAME FUNCTION 
ALTER TABLE sales
ADD COLUMN name_of_month VARCHAR(9) NOT NULL;

UPDATE sales
SET name_of_month = MONTHNAME(purchase_date);

                                              -- EXPLORATORY DATA ANALYSIS 
                                              
-- 1. What is the count of distinct cities in the dataset?
SELECT -- to retrieve specified the column
    COUNT(DISTINCT city) AS distinct_count -- count the number of distinct values in the city column 
FROM sales;  --  used to specify the table from which we want to retrieve data


-- 2. For each branch, what is the corresponding city?.
SELECT branch, city -- to retrieve the specified columns
FROM sales --  used to specify the table from which we want to retrieve data
GROUP BY branch, city  -- to get all unique branches and unique city associated with each unique branch
ORDER BY branch;  -- order the result in ascending order based on branch column


-- 3. What is the count of distinct product lines in the dataset?
SELECT  -- to retrieve the specified column
    COUNT(DISTINCT product_line) AS distinct_count  -- count the number of distinct values in the product_line column
FROM -- used to specify the table from which we want to retrieve data
    sales;  


-- 4. Which payment method occurs most frequently?
SELECT -- to retrieve the specified column
    payment_method,
    COUNT(payment_method) AS total_count -- count the occurrences of each unique payment_method 
FROM -- used to specify the table from which we want to retrieve data
    sales
GROUP BY payment_method  -- group rows of result set based on the unique values in the payment_method column   
ORDER BY total_count DESC -- sort the result in descending order based on the values in the total_count column
LIMIT 1; -- restricts the result to just one row       
                                                              
                                                              
-- 5. Which product line has the highest sales?
SELECT  -- to retrieve the specified columns
    product_line, 
    SUM(total) AS total_sales -- sum all values in the column named total for each unique product line 
FROM -- used to specify the table from which we want to retrieve data
    sales
GROUP BY product_line -- group rows of result set based on the values in the product_line column 
ORDER BY total_sales DESC -- sort the result in descending order based on the unique values in the total_sales column
LIMIT 1; -- restricts the result to just one row

SELECT  -- to retrieve the specified columns
    product_line, 
    SUM(quantity) AS total_quantity -- sum all values in the column named quantity for each unique product line
FROM -- used to specify the table from which we want to retrieve data
    sales
GROUP BY product_line -- group rows of result set based on the unique values in the product_line column 
ORDER BY total_quantity DESC -- sort the result in descending order based on the values in the total_quantity column
LIMIT 1; -- restricts the result to just one row


-- 6. How much revenue is generated each month?
SELECT  -- to retrieve the specified columns
    name_of_month, 
    SUM(total) AS monthly_revenue  -- sum all values in the column named total for each unique month
FROM -- used to specify the table from which we want to retrieve data
    SALES
GROUP BY name_of_month -- group rows of result set based on the unique values in the name_of_month column 
ORDER BY monthly_revenue DESC; -- sort the result in descending order based on the values in the name of monthly_revenue column


-- 7. In which month did the cost of goods sold reach its peak?
SELECT -- to retrieve the specified columns
    name_of_month, 
    SUM(cogs) AS monthy_cogs -- sum all values in the column named cogs for each unique month
FROM -- used to specify the table from which we want to retrieve data
    sales
GROUP BY name_of_month -- group rows of result set based on the unique values in the name_of_month column
ORDER BY monthy_cogs DESC -- sort the result in descending order based on the values in the monthly_cogs column
LIMIT 1; -- restricts the result to just one row


-- 8. Which product line generated the highest revenue?
SELECT  -- to retrieve the specified columns
    product_line, 
    SUM(total) AS product_line_revenue  -- sum all values in the column named total for each unique product line
FROM  -- used to specify the table from which we want to retrieve data
    sales
GROUP BY product_line -- group rows of result set based on the unique values in the product_line column 
ORDER BY product_line_revenue DESC -- sort the result in descending order based on the values in the product_line_revenue column
LIMIT 1; -- restricts the result to just one row


-- 9. In which city was the highest revenue recorded?
SELECT -- to retrieve the specified columns
    city, 
    SUM(total) AS city_revenue -- sum all values in the column named total for each unique city
FROM -- used to specify the table from which we want to retrieve data
    sales
GROUP BY city  -- group rows of result set based on the  unique values in the city column 
ORDER BY city_revenue DESC -- sort the result in descending order based on the values in the total_revenue column
LIMIT 1; -- restricts the result to just one row


-- 10. Which product line incurred the highest Value Added Tax?
SELECT -- to retrieve the specified columns
    product_line, 
    SUM(vat) AS product_line_vat -- sum all values in the column named vat for for each unique product_line
FROM -- used to specify the table from which we want to retrieve data
    sales
GROUP BY product_line  -- group rows of result set based on the unique values in the product_line column 
ORDER BY product_line_vat DESC -- sort the result in descending order based on the values in the product_line_vat column
LIMIT 1; -- restricts the result to just one row


-- 11. For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."
WITH cte_name AS ( -- allows us to define temporary result sets that can be used within the scope of a single SQL statement
SELECT -- to retrieve the specified columns
product_line, 
SUM(total) AS product_line_revenue -- sum all values in the column named total for each product line 
FROM -- used to specify the table from which we want to retrieve data
sales 
GROUP BY product_line) -- group rows of result set based on the unique values in the product_line column 

SELECT *, 
    CASE  -- to assign a performance status based on whether the sum of revenue for each product line is greater than the overall average revenue
        WHEN product_line_revenue > (SELECT AVG(product_line_revenue) from cte_name) THEN "Good"
        ELSE "Bad"
    END AS performance_status  -- used to alias the result of the CASE statement 
FROM cte_name 
ORDER BY performance_status; -- sort the result in ascending order based on the values in the performance_status column


-- 12. Identify the branch that exceeded the average number of products sold.
SELECT -- to retrieve the specified columns
    branch, 
    SUM(quantity) AS branch_quantity -- sum all values in the column named quantity for each unique branch
FROM sales
GROUP BY branch -- group rows of result set based on the unique values in the branch column 
HAVING branch_quantity > ( -- specifies that only groups with a sum of quantity greater than a certain value will be included in the result set
SELECT AVG(branch_quantity) FROM (SELECT branch, SUM(quantity) AS branch_quantity FROM sales GROUP BY branch) -- subquery that calculates the average quantity sold across all branches
AS sub);


-- 13. Which product line is most frequently associated with each gender?
SELECT *   -- to retrieve the specified columns
FROM -- used to specify the table from which we want to retrieve data
(
WITH cte_name AS (  -- allows us to define temporary result sets that can be used within the scope of a single SQL statement
SELECT gender, product_line, 
COUNT(product_line) AS product_line_count -- count the occurrences of each unique product line
FROM sales 
GROUP BY gender, product_line -- to get all unique genders and unique product line associated with each unique gender
)
SELECT *,  
ROW_NUMBER() OVER (PARTITION BY gender ORDER BY product_line_count DESC) AS num FROM cte_name) AS sub -- generates a sequential row number for each row within each partition defined by the gender column, ordering the rows within each partition by the product_line_count column in descending order
WHERE num = 1; -- clause filters the rows of result, include only those where the value of the num column is equal to 1


-- 14. Calculate the average rating for each product line.
SELECT -- to retrieve the specified columns
    product_line,
    AVG(rating) AS product_line_avg_rating -- calculates the average value of a numeric column called rating for each unique product line
FROM -- used to specify the table from which we want to retrieve data
    sales
GROUP BY product_line -- group rows of result set based on the values in the product_line column 
ORDER BY product_line_avg_rating DESC; -- sort the result in descending order based on the values in the product_line_avg_rating column


-- 15. Count the sales occurrences for each time of day on every weekday.
SELECT -- to retrieve the specified columns
	name_of_day, time_of_day,
    COUNT(*) AS sales_count -- count the occurrences of each unique name of day associated with each unique time of day
FROM -- used to specify the table from which we want to retrieve data
	sales 
WHERE name_of_day NOT IN ('saturday', 'sunday') -- filters the rows of the result based on given condition
GROUP BY name_of_day, time_of_day -- to get all name of day and time of day associated with each name of day
ORDER BY sales_count DESC; -- sort the result in descending order based on the values in the sales_count column


-- 16. Identify the customer type contributing the highest revenue.
SELECT  -- to retrieve the specified columns
    customer_type, 
    SUM(total) AS costumer_type_revenue -- sum all values in the column named total for each unique customer_type
FROM  -- used to specify the table from which we want to retrieve data
    sales
GROUP BY customer_type -- group rows of a result set based on the values in the customer_type column 
ORDER BY costumer_type_revenue DESC -- sort the result in descending order based on the values in the costumer_type_revenue column
LIMIT 1; -- restricts the result to just one row


-- 17. Determine the city with the highest VAT percentage.
SELECT  -- to retrieve the specified columns
    city, 
    (SUM(vat) / SUM(total)) * 100 AS vat_percentage  -- vat % = (total vat/total sales) * 100
FROM -- used to specify the table from which we want to retrieve data
    sales
GROUP BY city;  -- group rows of a result set based on the values in the city column 


-- 18. Identify the customer type with the highest VAT payments.
SELECT -- to retrieve the specified columns
    customer_type, 
    SUM(vat) AS total_vat_payment -- sum all values in the column named vat for each unique customer_type
FROM -- used to specify the table from which we want to retrieve data
    sales
GROUP BY customer_type -- group rows of result set based on the unique values in the customer_type column 
ORDER BY total_vat_payment DESC -- sort the result in descending order based on the values in the total_vat_payment column
LIMIT 1;  -- restricts the result to just one row


-- 19. What is the count of distinct customer types in the dataset?
SELECT -- to retrieve the specified columns
    COUNT(DISTINCT customer_type) AS distinct_count -- count the number of distinct values in the customer_type column 
FROM  -- used to specify the table from which we want to retrieve data
    SALES;
    

-- 20. What is the count of distinct payment methods in the dataset?
SELECT -- to retrieve the specified columns
    COUNT(DISTINCT payment_method) AS distinct_payment_method_count -- count the number of distinct values in the payment_method column 
FROM -- used to specify the table from which we want to retrieve data
    sales;


-- 21. Which customer type occurs most frequently?
SELECT -- to retrieve the specified columns
    customer_type, 
    COUNT(customer_type) AS customer_type_count -- count the occurrences of each unique customer_type
FROM  -- used to specify the table from which we want to retrieve data
    sales
GROUP BY customer_type -- group rows of a result set based on the unique values in the customer_type column 
ORDER BY customer_type_count DESC -- sort the result in descending order based on the values in the customer_type_count column
LIMIT 1; -- restricts the result to just one row


-- 22. Identify the customer type with the highest purchase frequency.
SELECT  -- to retrieve the specified columns
    customer_type, 
    COUNT(customer_type) AS purchase_frequency -- count the occurrences of each unique customer_type
FROM  -- used to specify the table from which we want to retrieve data
    sales
GROUP BY customer_type -- group rows of result set based on the values in the customer_type column 
ORDER BY purchase_frequency DESC  -- sort the result in descending order based on the values in the purchase_frequency column
LIMIT 1; -- restricts the result to just one row


-- 23. Determine the predominant gender among customers.
SELECT  -- to retrieve the specified columns
    gender, 
    COUNT(gender) AS gender_count -- count the occurrences of each unique gender
FROM  -- used to specify the table from which we want to retrieve data
    sales
GROUP BY gender -- group rows of result set based on the values in the gender column 
ORDER BY gender_count DESC  -- sort the result in descending order based on the values in the gender_count column
LIMIT 1; -- restricts the result to just one row


-- 24. Examine the distribution of genders within each branch.
SELECT -- to retrieve the specified columns
    branch, gender, 
    COUNT(gender) AS gender_count -- count the occurrences of each unique gender
FROM -- used to specify the table from which we want to retrieve data
    sales
GROUP BY branch, gender  -- to get all unique branches and unique gender associated with each unique branch
ORDER BY branch, gender DESC; -- sort the result based on the values of the branch column in ascending order and the gender column in descending order


-- 25. Identify the time of day when customers provide the most ratings.
SELECT -- to retrieve the specified columns
    time_of_day, 
    COUNT(rating) AS number_of_ratings -- count the occurrences of each unique rating
FROM -- used to specify the table from which we want to retrieve data
    sales
GROUP BY time_of_day -- group rows of result set based on the values in the time_of_day column
ORDER BY number_of_ratings DESC  -- sort the result in descending order based on the values in the number_of_ratings column
LIMIT 1; -- restricts the result to just one row


-- 26. Determine the time of day with the highest customer ratings for each branch.
SELECT * -- to retrieve the specified columns
FROM -- used to specify the table from which we want to retrieve data
(
WITH cte_name AS -- allows us to define temporary result sets that can be used within the scope of a single SQL statement
(
SELECT branch, time_of_day,  
COUNT(rating) AS rating_count  -- count the occurrences of each unique rating
FROM sales  
GROUP BY branch, time_of_day -- to get all unique branch and unique time of day associated with each unique branch
)
SELECT *, 
ROW_NUMBER() OVER (PARTITION BY branch ORDER BY rating_count DESC) as num FROM cte_name) AS sub  -- generates a sequential row number for each row within each partition defined by the branch column, ordering the rows within each partition by the rating_count column in descending order
WHERE num = 1;  -- clause filters the rows of result, include only those where the value of the num column is equal to 1


-- 27. Identify the day of the week with the highest average ratings.
SELECT  -- to retrieve the specified columns
    name_of_day, 
    AVG(rating) AS daily_average_rating -- calculates the average rating for each unique day
FROM -- used to specify the table from which we want to retrieve data
    sales
GROUP BY name_of_day -- group rows of result set based on the values in the name_of_day column
ORDER BY daily_average_rating DESC -- sort the result in descending order based on the values in the daily_average_rating  column
LIMIT 1; -- restricts the result to just one row


-- 28. the day of the week with the highest average ratings for each branch.
SELECT *   -- to retrieve the specified columns
FROM ( -- used to specify the table from which we want to retrieve data
WITH cte_name AS ( -- allows us to define temporary result sets that can be used within the scope of a single SQL statement
SELECT branch, name_of_day, 
AVG(rating) AS avg_rating -- calculates the average rating for each unique day
FROM sales
GROUP BY branch, name_of_day -- to get all unique branch and unique name of day associated with each unique branch
)
(SELECT *,   
ROW_NUMBER() OVER (PARTITION BY branch ORDER BY avg_rating DESC) AS num FROM cte_name)) AS sub -- generates a sequential row number for each row within each partition defined by the branch column, ordering the rows within each partition by the avg_rating column in descending order
WHERE num = 1  -- clause filters the rows of result, include only those where the value of the num column is equal to 1
ORDER BY branch;
                                                       
                                                       -- ANALYSIS LIST 
                                                    
													-- I. PRODUCT ANALYSIS 

-- A. Product Line Types

-- Codes used:
SELECT DISTINCT
    product_line
FROM
    sales; 
    
SELECT 
    COUNT(DISTINCT product_line) AS distinct_product_line_count
FROM
    sales; 

-- B. Best performing product line and the product line needing improvement

-- Codes used:
SELECT product_line, COUNT(quantity) AS quantity_count 
FROM sales
GROUP BY product_line
ORDER BY quantity_count DESC;
 
SELECT 
product_line, 
SUM(total) as product_line_revenue
FROM sales 
GROUP BY product_line
ORDER BY product_line_revenue DESC;
   
SELECT 
product_line, 
AVG(rating) as product_line_avg_rating
FROM sales
GROUP BY product_line
ORDER BY product_line_avg_rating DESC;   


                                                        -- II. SALES ANALYSIS 


SELECT product_line, name_of_month, SUM(total) as total_revenue
FROM sales
GROUP BY Product_line, name_of_month
ORDER BY product_line, total_revenue DESC;

SELECT product_line, name_of_day, SUM(total) AS total_revenue
FROM sales
GROUP BY product_line, name_of_day
ORDER BY product_line, total_revenue DESC;


SELECT product_line, time_of_day, SUM(total) AS total_revenue
FROM sales
GROUP BY product_line, time_of_day
ORDER BY product_line, total_revenue DESC;

SELECT product_line, SUM(quantity) AS total_quantity
FROM sales
GROUP BY product_line
ORDER BY total_quantity DESC;



                                                         -- CUSTOMER ANALYSIS 
                                                         
                                                         
SELECT gender, COUNT(gender) AS gender_count
FROM sales
GROUP BY gender
ORDER BY gender_count DESC;

SELECT payment_method, COUNT(payment_method) AS payment_method_count
FROM sales
GROUP BY payment_method
ORDER BY payment_method_count DESC;

SELECT city, SUM(total) as total_revenue
FROM sales
GROUP BY city
ORDER BY total_revenue DESC;

SELECT branch, SUM(total) AS total_revenue
FROM sales
GROUP BY branch
ORDER BY total_revenue DESC;

SELECT customer_type, count(customer_type) AS customer_type_count
FROM sales
GROUP BY customer_type
ORDER BY customer_type_count DESC;




