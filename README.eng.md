# Data Analysis Project

## Table of Contents

### 📊 SQL Analysis Scripts

| #   | Script                                                                 | Description                |
| --- | ---------------------------------------------------------------------- | -------------------------- |
| 01  | [1_database_exploration.sql](scripts/01_database_exploration.sql)      | Explore database structure |
| 02  | [2_dimensions_exploration.sql](scripts/02_dimensions_exploration.sql)  | Explore dimension tables   |
| 03  | [3_date_exploration.sql](scripts/03_date_exploration.sql)              | Explore date ranges        |
| 04  | [4_measures_exploration.sql](scripts/04_measures_exploration.sql)      | Explore key measures       |
| 05  | [5_magnitude_analysis.sql](scripts/05_magnitude_analysis.sql)          | Analyze magnitude          |
| 06  | [6_ranking_analysis.sql](scripts/06_ranking_analysis.sql)              | Rank entities              |
| 07  | [7_changes_over_time.sql](scripts/07_changes_over_time.sql)            | Analyze trends over time   |
| 08  | [8_comulative_analysis.sql](scripts/08_comulative_analysis.sql)        | Cumulative analysis        |
| 09  | [9_performance_analysis.sql](scripts/09_performance_analysis.sql)      | Performance analysis       |
| 10  | [10_part_to_whole_analysis.sql](scripts/10_part_to_whole_analysis.sql) | Part-to-whole analysis     |
| 11  | [11_data_segmentation.sql](scripts/11_data_segmentation.sql)           | Data segmentation          |
| 12  | [12_report_customers.sql](scripts/12_report_customers.sql)             | Customer report            |
| 13  | [13_report_products.sql](scripts/13_report_products.sql)               | Product report             |

### 📁 Datasets

| File                                                      | Type      | Description        |
| --------------------------------------------------------- | --------- | ------------------ |
| [gold.dim_customers.csv](datasets/gold.dim_customers.csv) | Dimension | Customer data      |
| [gold.dim_products.csv](datasets/gold.dim_products.csv)   | Dimension | Product data       |
| [gold.fact_sales.csv](datasets/gold.fact_sales.csv)       | Fact      | Sales transactions |

## Section 1: Database Exploration

### Purpose

This section covers the initial exploration of the database structure, including:

- Listing all objects (tables, views, etc.) in the database
- Inspecting table schemas and metadata
- Reviewing columns and data types for key tables

The goal is to understand the data model before performing any analysis.

### Explore All Objects in Database

```sql
SELECT
    *
FROM
    INFORMATION_SCHEMA.TABLES;
```

```sql
SELECT
    TABLE_SCHEMA,
    TABLE_NAME,
    TABLE_TYPE
FROM
    INFORMATION_SCHEMA.TABLES
ORDER BY
    TABLE_SCHEMA,
    TABLE_NAME;
```

### Explore Columns in Database

```sql
SELECT
    *
FROM
    INFORMATION_SCHEMA.COLUMNS
WHERE
    TABLE_NAME = 'dim_customers';
```

```sql
SELECT
    *
FROM
    INFORMATION_SCHEMA.COLUMNS
WHERE
    TABLE_NAME = 'dim_products';
```

```sql
SELECT
    *
FROM
    INFORMATION_SCHEMA.COLUMNS
WHERE
    TABLE_NAME = 'fact_sales';
```

## Section 2: Dimension Exploration

### Purpose

- Explore the structure of dimension tables.
- Retrieve unique values from dimension tables to understand the data.

### Explore Unique Countries

```sql
SELECT DISTINCT
    country
FROM
    gold.dim_customers;
```

### Explore Unique Categories and Subcategories

```sql
SELECT DISTINCT
    category,
    subcategory
FROM
    gold.dim_products;
```

### Explore Unique Categories, Subcategories, and Products

```sql
SELECT DISTINCT
    category,
    subcategory,
    product_number
FROM
    gold.dim_products
ORDER BY
    1, 2, 3;
```

## Section 3: Date Range Exploration

### Purpose

- Determine the temporal boundaries of key data points.
- Understand the range of historical data.

### Explore Order Dates

Determine the first and last order date and the total duration in years.

```sql
SELECT
    MAX(order_date) AS last_order_date,
    MIN(order_date) AS first_order_date,
    DATEDIFF(year, MIN(order_date), MAX(order_date)) AS order_range_years
FROM
    gold.fact_sales;
```

### Explore Customers

Find the youngest customer, the oldest customer, and their age difference.

```sql
SELECT
    MAX(birthdate) AS youngest_customer_birthdate,
    DATEDIFF(year, MAX(birthdate), GETDATE()) AS youngest_customer_age,
    MIN(birthdate) AS oldest_customer_birthdate,
    DATEDIFF(year, MIN(birthdate), GETDATE()) AS oldest_customer_age,
    DATEDIFF(year, MIN(birthdate), MAX(birthdate)) AS age_diff_years
FROM
    gold.dim_customers;
```

## Section 4: Measures Exploration (Key Metrics)

### Purpose

- Calculate aggregated metrics for quick insights.
- Identify overall trends or spot anomalies.

### Total Sales

```sql
SELECT
    SUM(sls_price) AS total_sales
FROM
    gold.fact_sales;
```

### Total Items Sold

```sql
SELECT
    SUM(quantity) AS total_items_quantity
FROM
    gold.fact_sales;
```

### Average Selling Price

```sql
SELECT
    AVG(sls_price) AS avg_price
FROM
    gold.fact_sales;
```

### Total Number of Orders

```sql
SELECT
    COUNT(DISTINCT order_number) AS total_orders_amount
FROM
    gold.fact_sales;
```

### Total Number of Products

```sql
SELECT
    COUNT(DISTINCT product_key) AS total_products
FROM
    gold.dim_products;
```

### Total Number of Customers

```sql
SELECT
    COUNT(DISTINCT customer_id) AS total_customers
FROM
    gold.dim_customers;
```

### Total Number of Customers That Placed an Order

```sql
SELECT
    COUNT(DISTINCT customer_key) AS customers_with_orders
FROM
    gold.fact_sales;
```

### Final Report on Key Metrics

```sql
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
```

## Section 5: Magnitude Analysis

### Purpose

- Quantify data and group results by specific dimensions.
- Understand data distribution across categories.

### Total Customers by Countries

```sql
SELECT
    country,
    COUNT(customer_id) AS customers_amount
FROM
    gold.dim_customers
GROUP BY
    country
ORDER BY
    customers_amount DESC;
```

### Total Customers by Gender

```sql
SELECT
    gender,
    COUNT(customer_id) AS customers_amount
FROM
    gold.dim_customers
GROUP BY
    gender
ORDER BY
    customers_amount DESC;
```

### Total Products by Category

```sql
SELECT
    category,
    COUNT(product_id) AS products_amount
FROM
    gold.dim_products
GROUP BY
    category
ORDER BY
    products_amount DESC;
```

### Average Cost in Each Category

```sql
SELECT
    category,
    AVG(product_cost) AS avg_cost
FROM gold.dim_products
GROUP BY
    category
ORDER BY
    avg_cost DESC;
```

### Total Revenue Generated by Each Category

```sql
SELECT
    p.category,
    SUM(f.sales_amount) AS total_revenue
FROM
    gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
    ON p.product_key = f.product_key
GROUP BY
    category
ORDER BY
    total_revenue DESC;
```

### Total Revenue Generated by Each Customer

```sql
SELECT
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(f.sales_amount) AS total_revenue
FROM
    gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
    ON c.customer_key = f.customer_key
GROUP BY
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY
    total_revenue DESC;
```

### Distribution of Sold Items Across Countries

```sql
SELECT
    c.country,
    SUM(f.quantity) AS total_sold_items
FROM
    gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
    ON c.customer_key = f.customer_key
GROUP BY
    c.country
ORDER BY
    total_sold_items DESC;
```

## Section 6: Ranking Analysis

### Purpose

- Rank items based on performance or other metrics.
- Identify top performers or laggards.

### Top 5 Products by Highest Revenue

```sql
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
) t
WHERE sales_rank <= 5;
```

### Top 5 Worst-Performing Products by Sales

```sql
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
) t
WHERE sales_rank <= 5;
```

### Top 3 Customers with the Most Orders

```sql
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
```

## Section 7: Change Over Time Analysis

### Purpose

- Track trends, growth, and changes in key metrics over time.
- Perform time-series analysis and identify seasonality.
- Measure growth or decline over specific periods.

### Change by Year

```sql
SELECT
    YEAR(order_date) AS year,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_product_quantity,
    COUNT(DISTINCT customer_key) AS total_customers
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date);
```

### Change by Quarters

```sql
SELECT
    DATENAME(quarter, order_date) AS quarter,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_product_quantity,
    COUNT(DISTINCT customer_key) AS total_customers
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATENAME(quarter, order_date)
ORDER BY DATENAME(quarter, order_date);
```

### Change by Months

```sql
SELECT
    DATENAME(month, order_date) AS month,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_product_quantity,
    COUNT(DISTINCT customer_key) AS total_customers
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATENAME(month, order_date)
ORDER BY DATENAME(month, order_date);
```

## Section 8: Cumulative Analysis

### Purpose

- Calculate running totals or moving averages for key metrics.
- Track performance over time cumulatively.
- Useful for growth analysis or identifying long-term trends.

### Total Sales per Month, Running Total and Moving Average by Year

```sql
SELECT
    order_date,
    total_sales,
    SUM(total_sales) OVER(
        PARTITION BY YEAR(order_date)
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total_by_year,
    AVG(avg_price) OVER(
        PARTITION BY YEAR(order_date)
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_avg_by_year
FROM (
    SELECT
        DATETRUNC(month, order_date) AS order_date,
        SUM(sales_amount) AS total_sales,
        AVG(sls_price) AS avg_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(month, order_date)
) t;
```

## Section 9: Performance Analysis (Year-over-Year, Month-over-Month)

### Purpose

- Measure the performance of products, customers, or regions over time.
- Benchmark and identify high-performing entities.
- Track yearly trends and growth.

### Yearly Product Performance vs. Average and Previous Year

Analyze the yearly performance of products by comparing their sales to both the average sales performance of the product and the previous year's sales.

```sql
WITH yearly_product_sales AS (
    SELECT
        YEAR(f.order_date) AS order_year,
        p.product_name,
        SUM(f.sales_amount) AS current_sales
    FROM gold.fact_sales AS f
    LEFT JOIN gold.dim_products AS p
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
    GROUP BY
        YEAR(f.order_date),
        p.product_name
)
SELECT
    order_year,
    product_name,
    current_sales,
    AVG(current_sales) OVER(PARTITION BY product_name) AS avg_sales,
    current_sales - AVG(current_sales) OVER(PARTITION BY product_name) AS diff_avg,
    CASE
        WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) > 0 THEN 'Above avg'
        WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) < 0 THEN 'Below avg'
        ELSE 'Avg'
    END AS avg_change,
    LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) AS prev_year_sales,
    current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) AS diff_prev_year,
    CASE
        WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
        WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
        WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) IS NULL THEN 'No prev sales'
        ELSE 'No change'
    END AS prev_year_change
FROM yearly_product_sales
ORDER BY
    product_name,
    order_year;
```

## Section 10: Part-to-Whole Analysis

### Purpose

- Compare performance or metrics across dimensions or time periods.
- Evaluate differences between categories.
- Useful for A/B testing or regional comparisons.

### Category Contribution to Overall Sales

Find which categories contribute the most to overall sales.

```sql
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
    CONCAT(
        ROUND(
            (CAST(total_category_sales AS FLOAT) / SUM(total_category_sales) OVER()) * 100,
            2
        ),
        '%'
    ) AS contribution_percent
FROM category_sales;
```

## Section 11: Data Segmentation Analysis

### Purpose

- Group data into meaningful categories for targeted insights.
- Perform customer segmentation, product categorization, or regional analysis.

### Product Segmentation by Cost Range

Segment products into cost ranges and count how many products fall into each segment.

```sql
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
```

### Customer Segmentation by Spending Behavior

Group customers into three segments based on their spending behavior:

- **VIP**: Customers with at least 12 months of history and spending more than €5,000.
- **Regular**: Customers with at least 12 months of history but spending €5,000 or less.
- **New**: Customers with a lifespan less than 12 months.

Find the total number of customers by each group.

```sql
WITH customers_segments AS (
    SELECT
        c.customer_key,
        SUM(f.sales_amount) AS total_spendings,
        MAX(order_date) AS last_order,
        MIN(order_date) AS first_order,
        DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
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
) t
GROUP BY customer_segment
ORDER BY customer_count DESC;
```

## Section 12: Customer Report

### Purpose

This report consolidates key customer metrics and behaviors.

### Highlights

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

### Create Report View `gold.report_customers`

```sql
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
```

## Section 13: Product Report

### Purpose

This report consolidates key product metrics and behaviors.

## Highlights

1. Gathers essential fields such as product name, category, subcategory, and cost.
2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
3. Aggregates product-level metrics:
   - total orders
   - total sales
   - total quantity sold
   - total customers (unique)
   - lifespan (in months)
4. Calculates valuable KPIs:
   - recency (months since last sale)
   - average order revenue (AOR)
   - average monthly revenue

### Create Report View `gold.report_products`

```sql
CREATE VIEW gold.report_products AS
    WITH base_query AS (
        -- 1) Base Query: Retrieve core columns from tables
        SELECT
            f.order_number,
            f.order_date,
            f.customer_key,
            f.quantity,
            f.sales_amount,
            p.product_key,
            p.product_name,
            p.product_cost,
            p.category,
            p.subcategory
        FROM gold.fact_sales AS f
        LEFT JOIN gold.dim_products AS p
            ON f.product_key = p.product_key
        WHERE f.order_date IS NOT NULL
    ), product_aggregations AS (
        -- 2) Product Aggregations: Summarizes key metrics at the product level
        SELECT
            product_key,
            product_name,
            product_cost,
            category,
            subcategory,
            COUNT(DISTINCT order_number) AS total_orders,
            SUM(sales_amount) AS total_sales,
            SUM(quantity) AS total_quantity,
            COUNT(DISTINCT customer_key) AS total_customers,
            MAX(order_date) AS last_order_date,
            DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan,
            ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)), 2) AS avg_selling_price
        FROM base_query
        GROUP BY
            product_key,
            product_name,
            product_cost,
            category,
            subcategory
    )
    -- 3) Final Query: Combines all product results into one output
    SELECT
        product_key,
        product_name,
        product_cost,
        avg_selling_price,
        category,
        subcategory,
        last_order_date,
        total_orders,
        total_sales,
        total_quantity,
        total_customers,
        lifespan,
        DATEDIFF(month, last_order_date, GETDATE()) AS recency_in_months,
        CASE
            WHEN total_sales > 5000 THEN 'High-Performer'
            WHEN total_sales > 1000 THEN 'Mid-Ranger'
            ELSE 'Low-Performer'
        END AS product_segment,
        CASE
            WHEN total_orders = 0 THEN 0
            ELSE total_sales / total_orders
        END AS avg_order_revenue,
        CASE
            WHEN lifespan = 0 THEN total_sales
            ELSE total_sales / lifespan
        END AS avg_monthly_revenue
    FROM product_aggregations;
```
