/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.
===============================================================================
*/

-- Find which categories contribute the most to overall sales
WITH category_sales AS (
    SELECT
        category,
        SUM(sales_amount) AS total_category_sales
    FROM gold.fact_sales AS f
    LEFT JOIN gold.dim_products AS p
    ON f.product_key = p.product_key
    GROUP BY category
)
SELECT
    category,
    total_category_sales,
    SUM(total_category_sales) OVER() AS overall_sales,
    CONCAT(ROUND((CAST(total_category_sales AS FLOAT) / SUM(total_category_sales) OVER()) * 100, 2), '%') AS contribution_percent
FROM category_sales;