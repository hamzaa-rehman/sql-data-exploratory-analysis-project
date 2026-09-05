/*============================================================================
 Product Report
 =============================================================================
 Purpose:
   - This report consolidates key product metrics and behavioral insights.

 Highlights:
   1. Gathers essential product information such as product name, category, subcategory, and cost.
   2. Segments products by revenue to identify High Performers, Mid Performers, and Low Performers.
   3. Aggregates product-level metrics:
     - total_orders
     - total_sales
     - total_quantity_sold
     - total_customers (unique)
     - lifespan (in months)
   4. Calculates valuable KPIs:
     - recency (months since last_order)
     - average order value
     - average monthly spending
============================================================================*/


IF OBJECT_ID('gold.report_products','V') IS NOT NULL
	DROP gold.report_products

CREATE VIEW gold.report_products AS

WITH base_query AS(
/*----------------------------------------------------------------------------
 1) Base query: Retrieving Core columns from fact_sales and dim_products
 ----------------------------------------------------------------------------*/
SELECT 
	f.order_number,
	f.product_key,
	f.customer_key,
	f.order_date,
	f.sales_amount,
	f.quantity,
	f.price,
	p.product_name,
	p.category,
	p.subcategory,
	p.cost
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key =f.product_key 
WHERE order_date IS NOT NULL  -- only consider valid sales date
),
/*----------------------------------------------------------------------------
 2) Product Aggregations: Summarizes key metrics at product level
 ----------------------------------------------------------------------------*/ 
product_aggregation AS(
SELECT 
	product_name,
	category,
	subcategory,
	cost,
	SUM(sales_amount) AS total_sales,
	COUNT(quantity) AS total_quantity,
	COUNT(DISTINCT order_number) AS total_orders,
	COUNT(DISTINCT customer_key) AS total_customers,
	MAX(order_date) AS last_sale_date,
	DATEDIFF(MONTH,MIN(order_date),MAX(order_date)) AS lifespan,
	ROUND(CAST(sales_amount AS FLOAT)/NULLIF(quantity,0),2) AS avg_selling_price
FROM base_query
GROUP BY product_name,
category,
subcategory,
cost,
sales_amount,
quantity
)
/*----------------------------------------------------------------------------
 3) Final Result: Combine all results to one output
 ----------------------------------------------------------------------------*/ 
SELECT
	product_name,
	category,
	subcategory,
	cost,
	last_sale_date,
	DATEDIFF(MONTH,last_sale_date,GETDATE()) AS recency,
	CASE 
		WHEN total_sales>=500000 THEN 'High Performer'
		WHEN total_sales BETWEEN 100000 AND 499999 THEN 'Mid Performer'
		ELSE 'low performer'
	END product_segment,
	total_sales,
	total_quantity,
	total_orders,
	total_customers, 
	avg_selling_price,
	--Average Order Revenue (AOR)
	Case 
	when total_orders=0 THEN 0
	ELSE total_sales /total_orders 
	END avg_order_revenue,
	--Average monthly Sales
	CASE
		WHEN lifespan= 0 THEN 0
		ELSE total_sales/lifespan
	END avg_monthly_sale
FROM product_aggregation
