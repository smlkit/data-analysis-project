/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/

-- Make report gold.report_customers as View
CREATE VIEW gold.report_customers AS
	WITH base_query AS (
		-- 1) Base Query: Retrieve core columns from tables
		SELECT
			f.order_number,
			f.product_key,
			f.order_date,
			f.sales_amount,
			f.quantity,
			c.customer_key,
			c.customer_number,
			CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
			DATEDIFF(year, c.birthdate, GETDATE()) AS customer_age
		FROM gold.fact_sales AS f
		LEFT JOIN gold.dim_customers AS c
			ON f.customer_key = c.customer_key
		WHERE f.order_date IS NOT NULL
	), customer_aggregation AS (
		-- 2) Customer Aggregations: Summarizes key metrics at the customer level
		SELECT
			customer_key,
			customer_number,
			customer_name,
			customer_age,
			COUNT(DISTINCT order_number) AS total_orders,
			SUM(sales_amount) AS total_sales,
			SUM(quantity) AS total_quantity,
			COUNT(DISTINCT product_key) AS total_products,
			MAX(order_date) AS last_order_date,
			DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
		FROM base_query
		GROUP BY
			customer_key,
			customer_number,
			customer_name,
			customer_age
	)
	-- 3) Final Query: Combines all customers results into one output
	SELECT
		customer_key,
		customer_number,
		customer_name,
		customer_age,
		CASE
			WHEN customer_age < 20 THEN 'Gen Z'
			WHEN customer_age BETWEEN 20 AND 29 THEN 'Millennial'
			WHEN customer_age BETWEEN 30 AND 39 THEN 'Gen X'
			WHEN customer_age BETWEEN 40 AND 49 THEN 'Boomer'
			WHEN customer_age >= 50 THEN 'Gen Silver'
		END AS age_group,
		total_orders,
		total_sales,
		total_quantity,
		total_products,
		last_order_date,
		lifespan,
		CASE
				WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
				WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
				ELSE 'New'
		END AS customer_segment,
		DATEDIFF(month, last_order_date, GETDATE()) AS recency_in_months,
		CASE
			WHEN total_sales = 0 THEN 0
			ELSE total_sales / total_orders
		END AS avg_order_value,
		CASE
			WHEN lifespan = 0 THEN total_sales
			ELSE total_sales / lifespan
		END AS avg_monthly_spend
	FROM customer_aggregation;