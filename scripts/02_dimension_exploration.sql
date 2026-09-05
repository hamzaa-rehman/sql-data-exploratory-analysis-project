/*===============================================================================
 Dimensions Exploration
 ===============================================================================
 Purpose:
    - To explore the structure of dimension tables.
	
 SQL Functions Used:
    - DISTINCT
    - ORDER BY
 ===============================================================================*/

-- Explore All countries our customer's come from

SELECT DISTINCT 
	country 
FROM gold.dim_customers

-- Explore All Categories "The major Divisions"

SELECT DISTINCT 
	category 
FROM gold.dim_products 

-- Explore All Unique categories, subCategories and products

SELECT DISTINCT 
	category,
	subcategory,
	product_name  
FROM gold.dim_products 
ORDER BY 1,2,3
