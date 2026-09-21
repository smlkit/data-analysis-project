# Data Analysis Project

## Table of Contents

### 📊 SQL Analysis Scripts

| #   | Script                                                         | Description                |
| --- | -------------------------------------------------------------- | -------------------------- |
| 01  | [1_database_exploration.sql](scripts/1_database_exploration.sql)       | Explore database structure |
| 02  | [2_dimensions_exploration.sql](scripts/2_dimensions_exploration.sql)   | Explore dimension tables   |
| 03  | [3_date_exploration.sql](scripts/3_date_exploration.sql)               | Explore date ranges        |
| 04  | [4_measures_exploration.sql](scripts/4_measures_exploration.sql)       | Explore key measures       |
| 05  | [5_magnitude_analysis.sql](scripts/5_magnitude_analysis.sql)           | Analyze magnitude          |
| 06  | [6_ranking_analysis.sql](scripts/6_ranking_analysis.sql)               | Rank entities              |
| 07  | [7_changes_over_time.sql](scripts/7_changes_over_time.sql)             | Analyze trends over time   |
| 08  | [8_comulative_analysis.sql](scripts/8_comulative_analysis.sql)         | Cumulative analysis        |
| 09  | [9_performance_analysis.sql](scripts/9_performance_analysis.sql)       | Performance analysis       |
| 10  | [10_part_to_whole_analysis.sql](scripts/10_part_to_whole_analysis.sql) | Part-to-whole analysis     |
| 11  | [11_data_segmentation.sql](scripts/11_data_segmentation.sql)           | Data segmentation          |
| 12  | [12_report_customers.sql](scripts/12_report_customers.sql)             | Customer report            |
| 13  | [13_report_products.sql](scripts/13_report_products.sql)               | Product report             |

### 📁 Datasets

| File                                             | Type      | Description        |
| ------------------------------------------------ | --------- | ------------------ |
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
