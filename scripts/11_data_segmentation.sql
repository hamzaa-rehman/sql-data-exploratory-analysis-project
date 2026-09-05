/*===============================================================================
 Data Segmentation Analysis
 ================================================================================
 Purpose:

   - To divide data into meaningful groups based on specific characteristics or criteria.
   - For analyzing customer groups, product segments, or regional categories.

 SQL Functions Used:
   - CASE: Applies custom rules to classify data into segments. 
   - GROUP BY: Organizes data based on defined segments.
 ===============================================================================*/

-- Segment products into  cost ranges and
-- count how many products fall into each segment
SELECT 
	cost_range,
	COUNT(*) total_products
FROM (
SELECT
	product_key,
	product_name,
	cost,
	CASE 
		WHEN cost<100 THEN 'Below 100'
		WHEN cost Between 100 AND 500 THEN '100-500'
		WHEN cost Between 500 AND 1000 THEN '500-1000'
		ELSE 'Above 1000'
	END cost_range
FROM gold.dim_products 
)t
GROUP BY cost_range
ORDER BY total_products DESC

/* Group Customers into three segments based on their scenerio behavior:
	- VIP: Customers with atleast 12 months of history and spending more than 5000 pounds.
	- Regular: Customers with atleast 12 months of history but spending less than 5000 pounds.
	- New: Customer with a lifespan less than 12 months
And find total number of customers in each group
*/

WITH customer_spending AS 
(
	SELECT 
	customer_key,
	SUM(sales_amount) AS total_Spending,
	DATEDIFF(MONTH,MIN(order_date),MAX(order_date)) AS lifespan
FROM gold.fact_sales fs 
GROUP BY customer_key
)
SELECT 
	t.segments ,
	COUNT(*) AS counting
FROM(
SELECT
	customer_key,
	total_spending,
	lifespan,
	CASE
		WHEN lifespan>=12 AND total_spending>5000 THEN 'VIP'
		WHEN lifespan>=12 AND total_spending<=5000 THEN 'Regular'
		ELSE 'NEW'
	END segments
FROM customer_spending
)t
GROUP BY t.segments 
