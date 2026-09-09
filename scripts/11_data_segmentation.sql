/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.
===============================================================================
*/

-- Segment products into cost ranges
-- and count how many products fall into each segment
WITH product_segment AS (
	SELECT 
		product_key,
		product_name,
		product_cost,
		CASE
			WHEN product_cost < 100 THEN 'Low Price'
			WHEN product_cost BETWEEN 100 AND 500 THEN 'Mid Price'
			WHEN product_cost BETWEEN 500 AND 1000 THEN 'High Price'
			ELSE 'Premium'
		END AS price_category
	FROM gold.dim_products
)
SELECT
	price_category,
	COUNT(product_key) AS product_count
FROM product_segment
GROUP BY price_category
ORDER BY product_count DESC;

/*
Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than €5,000.
	- Regular: Customers with at least 12 months of history but spending €5,000 or less.
	- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/
WITH customers_segments AS (
	SELECT
		c.customer_key,
		SUM(f.sales_amount) AS total_spendings,
		MAX(order_date) AS last_order,
		MIN(order_date) AS fist_order,
		DATEDIFF(month, MIN(order_date),MAX(order_date)) AS lifespan
	FROM gold.fact_sales AS f
	LEFT JOIN gold.dim_customers AS c
	ON f.customer_key = c.customer_key
	GROUP BY c.customer_key
)
SELECT
	customer_segment,
	COUNT(customer_key) AS customer_count
FROM (
	SELECT
		customer_key,
		total_spendings,
		lifespan,
		CASE
			WHEN lifespan >= 12 AND total_spendings > 5000 THEN 'VIP'
			WHEN lifespan >= 12 AND total_spendings <= 5000 THEN 'Regular'
			ELSE 'New'
		END AS customer_segment
	FROM customers_segments
)t
GROUP BY customer_segment
ORDER BY customer_count DESC;