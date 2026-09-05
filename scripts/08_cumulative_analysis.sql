/*===============================================================================
 Cumulative Analysis
 ================================================================================
Purpose:
  - To determine running totals and moving averages for important metrics.
  - To monitor accumulated performance across different time periods.
  - Useful for evaluating growth and understanding long-term trends.

SQL Functions Used:
  - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================*/

--Caluclate the total sales per month and the running total of sales over time.

WITH total_sales_per_month AS(
SELECT 
	MONTH(order_date) AS months ,
	SUM(sales_amount) AS total_sales_month
FROM gold.fact_sales
WHERE MONTH(order_date) IS NOT NULL 
GROUP BY MONTH(order_date)
)
SELECT 
	*,
	SUM(total_sales_month) OVER(ORDER BY months) AS running_total,
	AVG(total_sales_month) OVER(ORDER BY  months) AS moving_avg
FROM total_sales_per_month
ORDER BY months

--Performance Analysis
-- Analyze the yearly performance of poducts
-- by comparing each products's sales to both
-- its avg sales performance and the previous year's sales.

WITH yearly_prod_sale AS (
SELECT 
	dp.product_name AS product,
	YEAR(order_date) AS order_year,
	SUM(fs.sales_amount) AS yearly_sales
From gold.fact_sales fs
LEFT JOIN gold.dim_products dp 
ON dp.product_key = fs.product_key
WHERE YEAR(order_date) IS NOT NULL
GROUP BY  
	dp.product_name,
	YEAR(order_date)
),
product_performance AS(
SELECT 
product,
order_year,
yearly_Sales,
LAG(yearly_sales) OVER(
					  PARTITION BY product
					  ORDER BY order_year 
					  )as previous_year_sale,
AVG(yearly_sales) OVER( 
					  PARTITION BY product
					  )as avg_sales				  
from yearly_prod_sale 
)
SELECT 
order_year,
product,
yearly_sales,
avg_Sales,
yearly_sales -avg_sales AS diff_avg,
CASE
	WHEN yearly_sales -avg_sales>0 THEN 'Above Avg'
	WHEN yearly_sales -avg_sales<0 THEN 'Below Avg'
	ELSE 'Avg'
END avg_change,
yearly_sales - previous_year_sale AS diff_py, --Year Over Year Analysis 
CASE
	WHEN yearly_sales -previous_year_sale>0 THEN 'Increase'
	WHEN yearly_sales -previous_year_sale<0 THEN 'Decrease'
	ELSE 'No Change'
END py_change 
FROM product_performance
