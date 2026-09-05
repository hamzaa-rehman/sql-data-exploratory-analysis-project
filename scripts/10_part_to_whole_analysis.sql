/*===============================================================================
 Part-to-Whole Analysis
 ================================================================================
 Purpose:
   - To determine how individual categories or entities contribute to the overall total.
   - To analyze the share of each part relative to the complete dataset.
   - Useful for understanding the distribution and contribution of different segments.

 SQL Functions Used:
   - SUM(), AVG(): Aggregates values for analysis.
   - Window Functions: SUM() OVER() for calculating overall or grouped totals.
================================================================================*/

-- Which categories contribute most overall sales?

WITH category_sales AS(
SELECT 
	dp.category AS category,
	sum(sales_amount) AS ctg_sales,
	sum(sum(sales_amount))OVER() AS total_Sales
FROM gold.fact_sales fs
LEFT JOIN gold.dim_products dp 
ON dp.product_key=fs.product_key 
GROUP BY dp.category
)
SELECT 
	category,
	ctg_sales,
	total_sales,
	concat(Round((CAST(ctg_sales AS FLOAT)/total_Sales )*100,2),'%') AS percentage_of_total
FROM category_sales 
ORDER BY percentage_of_total DESC
