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

