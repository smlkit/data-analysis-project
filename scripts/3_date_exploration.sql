/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.
===============================================================================
*/

-- Explore order dates
-- Determine the first and last order date and the total duration in months
SELECT
	MAX(order_date) AS last_order_date,
	MIN(order_date) AS first_order_date,
	DATEDIFF(year, MIN(order_date), MAX(order_date)) AS order_range_years
FROM
	gold.fact_sales;

-- Explore customers
-- Find youngest cusomer, oldest & their age diff
SELECT
	MAX(birthdate) AS youngest_customer_birthdate,
	DATEDIFF(year, MAX(birthdate), GETDATE()) AS youngest_customer_age,
	MIN(birthdate) AS oldest_customer_birthdate,
	DATEDIFF(year, MIN(birthdate), GETDATE()) AS oldest_customer_age,
	DATEDIFF(year, MIN(birthdate), MAX(birthdate)) AS age_diff_years
FROM
	gold.dim_customers;