/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics for quick insights.
    - To identify overall trends or spot anomalies.
===============================================================================
*/

-- Find the total sales
SELECT
	SUM(sls_price) AS total_sales
FROM
	gold.fact_sales;

-- Find how many items are sold
SELECT
	SUM(quantity) AS total_items_quantity
FROM
	gold.fact_sales;

-- Find the average selling price
SELECT
	AVG(sls_price) AS avg_price
FROM
	gold.fact_sales;

-- Find the total number of orders
SELECT
	COUNT(DISTINCT order_number) AS total_orders_amount
FROM
	gold.fact_sales;

-- Find the total number of products
SELECT
	COUNT(DISTINCT product_key) AS total_products
FROM
	gold.dim_products;

-- Find the total number of customers
SELECT
	COUNT(DISTINCT customer_id) AS total_customers
FROM
	gold.dim_customers;

-- Find the total number of customers that has placed an order
SELECT
	COUNT(DISTINCT customer_key) AS customers_with_orders
FROM gold.fact_sales;

-- Final report on key metrics
SELECT 'Total sales' AS measure_name, SUM(sales_amount) AS measure_value
FROM gold.fact_sales
UNION ALL
SELECT 'Total product quantity' AS measure_name, SUM(quantity) AS measure_value
FROM gold.fact_sales
UNION ALL
SELECT 'Avg price' AS measure_name, AVG(sls_price) AS measure_value
FROM gold.fact_sales
UNION ALL
SELECT 'Total number of orders' AS measure_name, COUNT(DISTINCT order_number) AS measure_value
FROM gold.fact_sales
UNION ALL
SELECT 'Total number of products' AS measure_name, COUNT(DISTINCT product_key) AS measure_value
FROM gold.dim_products
UNION ALL
SELECT 'Total number of customers' AS measure_name, COUNT(DISTINCT customer_key) AS measure_value
FROM gold.dim_customers;