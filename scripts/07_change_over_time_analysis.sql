/*===============================================================================
 Change Over Time Analysis
 ================================================================================
 Purpose:
   - To examine trends, growth, and variations in important metrics across time.
   - For analyzing time-based patterns and detecting seasonality.
   - To evaluate increases or decreases across specific time periods.

SQL Functions Used:
   - Date Functions: DATEPART(), DATETRUNC(), FORMAT()
   - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================*/

-- Analyse sales performance over time

SELECT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date);
