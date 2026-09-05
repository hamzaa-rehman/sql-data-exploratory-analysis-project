/*===============================================================================
Magnitude Analysis
===============================================================================
Purpose:
  - To measure the scale of data and organize results based on selected dimensions.
  - For analyzing how data is distributed among different categories.

SQL Functions Used:
    - Aggregate Functions: SUM(), COUNT(), AVG()
    - GROUP BY, ORDER BY
===============================================================================
*/

-- Find total customers by country

SELECT 
	country,
	COUNT(customer_key ) AS total_customer
FROM gold.dim_customers
GROUP BY country
ORDER BY count(customer_key) DESC

--Find total customers by gender

SELECT 
	gender,
	COUNT(customer_key) AS total_customer
FROM gold.dim_customers
GROUP BY gender
ORDER BY count(customer_key) DESC

--Find total products by category

SELECT 
	category,
	COUNT(product_key) AS total_customer
FROM gold.dim_products 
GROUP BY category
ORDER BY count(product_key) DESC

--What is average cost in each category

SELECT 
	category,
	AVG(cost ) AS total_customer
FROM gold.dim_products 
GROUP BY category
ORDER BY total_customer DESC

-- What is total revenue generated for each category?

SELECT 
	dp.category ,
 	SUM(fs.sales_amount) AS total_revenue
FROM gold.fact_sales fs
LEFT JOIN gold.dim_products dp 
ON dp.product_key =fs.product_key
GROUP BY  dp.category 

-- What is total revenue generated for each csutomer?

SELECT 
	 dc.customer_id,
	 dc.firstname,
	 dc.lastname,
	 SUM(fs.sales_amount) AS total_revenue
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customers dc 
ON dc.customer_key =fs.customer_key 
GROUP BY 
	dc.customer_id,
	dc.firstname,
	dc.lastname
ORDER BY total_revenue DESC

-- What is the distribution of sold items across countries

SELECT 
	 dc.country,
	 sum(quantity) AS total_sold_items
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customers dc 
ON dc.customer_key =fs.customer_key 
GROUP BY dc.country 
ORDER BY total_sold_items DESC
