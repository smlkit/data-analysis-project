/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.
*/

-- Change by year
SELECT
	YEAR(order_date) AS year,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) AS total_product_quantity,
	COUNT(DISTINCT customer_key) AS total_customers
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date);

-- Change by quarters
SELECT
	DATENAME(quarter, order_date) AS quarter,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) AS total_product_quantity,
	COUNT(DISTINCT customer_key) AS total_customers
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATENAME(quarter, order_date)
ORDER BY DATENAME(quarter, order_date);

-- Change by months
SELECT
	DATENAME(month, order_date) AS month,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) AS total_product_quantity,
	COUNT(DISTINCT customer_key) AS total_customers
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATENAME(month, order_date)
ORDER BY DATENAME(month, order_date);
