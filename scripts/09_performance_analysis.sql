/*===============================================================================
 Performance Analysis (Year-over-Year, Month-over-Month)
 ================================================================================
 Purpose:

  - To evaluate the performance of products, customers, or regions across different time periods.
  - For comparing results against benchmarks and identifying top-performing entities.
  - To monitor yearly trends and measure changes in growth.

 SQL Functions Used:

  - LAG(): Retrieves values from previous rows.
  - AVG() OVER(): Calculates average values within defined partitions.
  - CASE: Applies conditional logic for analyzing trends.
 ===============================================================================*/

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
					  )AS previous_year_sale,
AVG(yearly_sales) OVER( 
					  PARTITION BY product
					  )AS avg_sales				  
FROM yearly_prod_sale 
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
