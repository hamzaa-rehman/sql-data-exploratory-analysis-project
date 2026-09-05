/*===================================================================================================
 Ranking Analysis
 ====================================================================================================
 Purpose:
    - To rank entities (e.g., products, customers) according to their performance or selected metrics.
    - To determine the highest and lowest performing entities.
 
 SQL Functions Used:
   - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
   - Clauses: GROUP BY, ORDER BY
 ===================================================================================================*/


-- Which 5 products generates the highest revenue

SELECT TOP 5
	dp.product_name ,
	SUM(sales_amount) AS highest_revenue
FROM gold.fact_sales fs
LEFT JOIN gold.dim_products dp 
ON dp.product_key =fs.product_key 
GROUP BY product_name
order by highest_revenue DESC

-- Which 5 worst-performing products in terms of sales

SELECT TOP 5
	dp.product_name ,
	SUM(sales_amount) AS highest_revenue
FROM gold.fact_sales fs
LEFT JOIN gold.dim_products dp 
ON dp.product_key =fs.product_key 
GROUP BY product_name
ORDER BY  highest_revenue 

-- Top-10 customers who have generated the highest revenue 


SELECT TOP 10
	dc.customer_key,
	CONCAT(dc.firstname,' ',dc.lastname) AS fullname,
	SUM(fs.sales_amount) AS highest_revenue
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customers dc
ON dc.customer_key =fs.customer_key 
GROUP BY dc.customer_key,concat(dc.firstname,' ',dc.lastname)
ORDER BY highest_revenue DESC
 
-- Lowest 3 customers with fewest orders placed

SELECT TOP 3
	dc.customer_key,
	CONCAT(dc.firstname,' ',dc.lastname) AS fullname,
	COUNT(DISTINCT fs.order_number) AS highest_revenue
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customers dc
ON dc.customer_key =fs.customer_key 
GROUP BY dc.customer_key,concat(dc.firstname,' ',dc.lastname)
ORDER BY highest_revenue 
