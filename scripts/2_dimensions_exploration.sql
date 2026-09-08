/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables.
*/

-- Retrieve a list of all unique countries
SELECT DISTINCT
	country
FROM
	gold.dim_customers;

-- Retrieve a list of unique categories, subcategories, and products
SELECT DISTINCT
	category,
	subcategory
FROM
	gold.dim_products;

SELECT DISTINCT
	category,
	subcategory,
	product_number
FROM
	gold.dim_products
ORDER BY
	1, 2, 3;