/*===============================================================================
 Date Range Exploration 
 ================================================================================
 Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

 SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
 ===============================================================================*/

--Find the date of the first and last order
--How many years of sales are available

SELECT
	MIN(order_date) AS first_order_date, 
	MAX (order_date) AS last_order_date,
	DATEDIFF(YEAR,MIN(order_date),MAX (order_date)) AS order_range_years,
	DATEDIFF(MONTH,MIN(order_date),MAX (order_date)) AS order_range_month
FROM gold.fact_sales

--Find the oldest and youngest customers

SELECT
	MIN(birthdate) AS youngest_customer,
	DATEDIFF(YEAR,MIN(birthdate),GETDATE()) AS youngest_customer_age,
	MAX(birthdate) AS oldest_customer,
	DATEDIFF(YEAR,MAX(birthdate),getdate()) Oldest_customer_age
FROM gold.dim_customers
