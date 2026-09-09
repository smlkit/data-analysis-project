/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items based on performance or other metrics.
    - To identify top performers or laggards.
===============================================================================
*/

-- Find top 5 product that generate the highest revenue
SELECT
	*
FROM (
	SELECT
		p.product_name,
		SUM(f.sales_amount) AS total_sales,
		ROW_NUMBER() OVER(ORDER BY SUM(f.sales_amount) DESC) AS sales_rank
	FROM
		gold.fact_sales AS f
	LEFT JOIN gold.dim_products AS p
		ON f.product_key = p.product_key
	GROUP BY
		p.product_name
)t
WHERE sales_rank <= 5;

-- Find the the top 5 worst-preforming products in terms of sales
SELECT
	*
FROM (
	SELECT TOP 5
		p.product_name,
		SUM(f.sales_amount) AS total_sales,
		ROW_NUMBER() OVER(ORDER BY SUM(f.sales_amount)) AS sales_rank
	FROM
		gold.fact_sales AS f
	LEFT JOIN gold.dim_products AS p
		ON f.product_key = p.product_key
	GROUP BY
		p.product_name
)t
WHERE sales_rank <= 5;

-- Fint the top 3 customers with the most amount of orders
SELECT TOP 3
		c.customer_key,
		c.first_name,
		c.last_name,
		COUNT(DISTINCT order_number) AS total_orders,
		ROW_NUMBER() OVER(ORDER BY COUNT(DISTINCT order_number) DESC) AS orders_rank
	FROM
		gold.fact_sales AS f
	LEFT JOIN gold.dim_customers AS c
		ON f.customer_key = c.customer_key
	GROUP BY
		c.customer_key,
		c.first_name,
		c.last_name;
