/* 
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.
*/

-- Calculate
-- 1) The total sales per month
-- 2) Running total of sales by year
-- 3) Moving average price by year
SELECT
    order_date,
    total_sales,
    SUM(total_sales) OVER(PARTITION BY YEAR(order_date) ORDER BY order_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total_by_year,
    AVG(avg_price) OVER(PARTITION BY YEAR(order_date) ORDER BY order_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_avg_by_year
FROM (
    SELECT
        DATETRUNC(month, order_date) AS order_date,
        SUM(sales_amount) AS total_sales,
        AVG(sls_price) AS avg_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(month, order_date)
)t;
