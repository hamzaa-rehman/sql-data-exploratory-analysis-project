/*============================================================================
 Customer Report
 =============================================================================
 
 Purpose:
    - This report consolidates key customer metrics and behavioral insights.

 Highlights:

   1. Gathers essential customer information such as names, ages, and transaction details.
   2. Segments customers into categories (VIP, Regular, New) and age groups.
   3. Aggregates customer-level metrics:
      - total_orders
      - total_sales
      - total_quantity_purchased
      - total_products
      - lifespan (in months)
   4. Calculates valuable KPIs:
      - recency (months since last_order)
      - average order value
      - average monthly spending
============================================================================*/

-- =============================================================================
-- Create Report: gold.report_customers
-- =============================================================================
IF OBJECT_ID('gold.report_customers', 'V') IS NOT NULL
    DROP VIEW gold.report_customers;

CREATE VIEW gold.report_customers  AS
	
WITH base_query AS(
/*----------------------------------------------------------------------------
 1) Base query: Retrieving Core columns from tables
 ----------------------------------------------------------------------------*/ 
SELECT 
	f.order_number,
	f.product_key,
	f.order_date,
	f.sales_amount,
	f.quantity,
	c.customer_key,
	c.customer_number, 
	CONCAT(c.firstname,' ',c.lastname) AS customer_name ,
	Datediff(Year,c.birthdate,getdate()) AS age
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c 
ON  c.customer_key =f.customer_key 
WHERE f.order_date IS NOT NULL
),
customer_aggregation AS(
/*----------------------------------------------------------------------------
 2) Customer Aggregations: Summarizes key metrics at customer level
 ----------------------------------------------------------------------------*/ 
SELECT 
 	customer_key,
	customer_number, 
	customer_name,
	age,
	COUNT(DISTINCT order_number) AS total_orders,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) AS total_quantity, 
	COUNT(DISTINCT product_key) AS total_product,
	MAX(order_date) AS last_order_date,
	DATEDIFF(MONTH,MIN(order_date),MAX(order_date)) AS lifespan 
FROM base_query 
GROUP BY
	customer_key,
	customer_number, 
	customer_name,
	age
)
/*----------------------------------------------------------------------------
 3) Final Result: Combine all results to one output
 ----------------------------------------------------------------------------*/
SELECT
	customer_key,
	customer_number, 
	customer_name,
	age,
	CASE 
		WHEN age<20 THEN 'Under 20'
		WHEN age BETWEEN 20 AND 29 THEN '20-29'
		WHEN age BETWEEN 30 AND 39 THEN '30-39'
		WHEN age BETWEEN 40 AND 49 THEN '40-49'
		ELSE '50 and above'
	END age_groups,
	CASE
		WHEN lifespan>=12 AND total_sales >5000 THEN 'VIP'
		WHEN lifespan>=12 AND total_sales<=5000 THEN 'Regular'
	ELSE 'NEW'
	END customer_segment,
	DATEDIFF(MONTH,last_order_date,getdate()) as recency,
	total_orders,
	total_sales,
	total_quantity, 
	total_product,
	lifespan,
-- Compute average order value(AVO)
	CASE
		WHEN total_orders=0 THEN 0
		ELSE total_sales /total_orders
	END AS average_order_value,
-- Compute average monthly spend (AVO)
	CASE
		WHEN lifespan=0 THEN 0
		ELSE total_sales /lifespan 
	END AS average_monthly_spend
FROM customer_aggregation 
