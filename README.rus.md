# Проект анализа данных

## Содержание

### 📊 SQL-скрипты для анализа

| #   | Скрипт                                                                 | Описание                      |
| --- | ---------------------------------------------------------------------- | ----------------------------- |
| 01  | [1_database_exploration.sql](scripts/01_database_exploration.sql)      | Исследование структуры БД     |
| 02  | [2_dimensions_exploration.sql](scripts/02_dimensions_exploration.sql)  | Исследование таблиц измерений |
| 03  | [3_date_exploration.sql](scripts/03_date_exploration.sql)              | Исследование диапазонов дат   |
| 04  | [4_measures_exploration.sql](scripts/04_measures_exploration.sql)      | Исследование ключевых метрик  |
| 05  | [5_magnitude_analysis.sql](scripts/05_magnitude_analysis.sql)          | Анализ величин                |
| 06  | [6_ranking_analysis.sql](scripts/06_ranking_analysis.sql)              | Ранжирование сущностей        |
| 07  | [7_changes_over_time.sql](scripts/07_changes_over_time.sql)            | Анализ изменений во времени   |
| 08  | [8_comulative_analysis.sql](scripts/08_comulative_analysis.sql)        | Кумулятивный анализ           |
| 09  | [9_performance_analysis.sql](scripts/09_performance_analysis.sql)      | Анализ производительности     |
| 10  | [10_part_to_whole_analysis.sql](scripts/10_part_to_whole_analysis.sql) | Анализ «часть к целому»       |
| 11  | [11_data_segmentation.sql](scripts/11_data_segmentation.sql)           | Сегментация данных            |
| 12  | [12_report_customers.sql](scripts/12_report_customers.sql)             | Отчёт по клиентам             |
| 13  | [13_report_products.sql](scripts/13_report_products.sql)               | Отчёт по продуктам            |

### 📁 Наборы данных

| Файл                                                      | Тип       | Описание           |
| --------------------------------------------------------- | --------- | ------------------ |
| [gold.dim_customers.csv](datasets/gold.dim_customers.csv) | Измерение | Данные о клиентах  |
| [gold.dim_products.csv](datasets/gold.dim_products.csv)   | Измерение | Данные о продуктах |
| [gold.fact_sales.csv](datasets/gold.fact_sales.csv)       | Факт      | Транзакции продаж  |

## Раздел 1: Исследование базы данных

### Цель

В этом разделе выполняется первоначальное исследование структуры базы данных, включая:

- Список всех объектов (таблиц, представлений и т.д.) в базе данных
- Проверка схем таблиц и метаданных
- Просмотр столбцов и типов данных ключевых таблиц

Цель — понять модель данных перед началом анализа.

### Исследование всех объектов в базе данных

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

### Исследование столбцов в базе данных

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

## Раздел 2: Исследование измерений

### Цель

- Изучить структуру таблиц измерений.
- Получить уникальные значения из таблиц измерений для понимания данных.

### Исследование уникальных стран

```sql
SELECT DISTINCT
country
FROM
gold.dim_customers;
```

### Исследование уникальных категорий и подкатегорий

```sql
SELECT DISTINCT
category,
subcategory
FROM
gold.dim_products;
```

### Исследование уникальных категорий, подкатегорий и продуктов

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

## Раздел 3: Исследование диапазонов дат

### Цель

- Определить временные границы ключевых данных.
- Понять диапазон исторических данных.

### Исследование дат заказов

Определить первую и последнюю дату заказа, а также общую продолжительность в годах.

```sql
SELECT
MAX(order_date) AS last_order_date,
MIN(order_date) AS first_order_date,
DATEDIFF(year, MIN(order_date), MAX(order_date)) AS order_range_years
FROM
gold.fact_sales;
```

### Исследование клиентов

Найти самого молодого и самого старшего клиента, а также разницу в возрасте.

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

## Раздел 4: Исследование метрик (ключевые показатели)

### Цель

- Рассчитать агрегированные метрики для быстрого понимания данных.
- Выявить общие тенденции или аномалии.

### Общая сумма продаж

```sql
SELECT
SUM(sls_price) AS total_sales
FROM
gold.fact_sales;
```

### Общее количество проданных товаров

```sql
SELECT
SUM(quantity) AS total_items_quantity
FROM
gold.fact_sales;
```

### Средняя цена продажи

```sql
SELECT
AVG(sls_price) AS avg_price
FROM
gold.fact_sales;
```

### Общее количество заказов

```sql
SELECT
COUNT(DISTINCT order_number) AS total_orders_amount
FROM
gold.fact_sales;
```

### Общее количество продуктов

```sql
SELECT
COUNT(DISTINCT product_key) AS total_products
FROM
gold.dim_products;
```

### Общее количество клиентов

```sql
SELECT
COUNT(DISTINCT customer_id) AS total_customers
FROM
gold.dim_customers;
```

### Общее количество клиентов, сделавших заказ

```sql
SELECT
COUNT(DISTINCT customer_key) AS customers_with_orders
FROM
gold.fact_sales;
```

### Итоговый отчёт по ключевым метрикам

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

## Раздел 5: Анализ величин

### Цель

- Количественно оценить данные и сгруппировать результаты по определённым измерениям.
- Понять распределение данных по категориям.

### Общее количество клиентов по странам

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

### Общее количество клиентов по полу

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

### Общее количество продуктов по категориям

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

### Средняя себестоимость в каждой категории

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

### Общая выручка по каждой категории

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

### Общая выручка по каждому клиенту

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

### Распределение проданных товаров по странам

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

## Раздел 6: Анализ ранжирования

### Цель

- Ранжировать элементы на основе производительности или других метрик.
- Выявить лидеров и аутсайдеров.

### Топ-5 продуктов с наибольшей выручкой

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

### Топ-5 худших продуктов по продажам

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

### Топ-3 клиентов с наибольшим количеством заказов

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

## Раздел 7: Анализ изменений во времени

### Цель

- Отслеживать тенденции, рост и изменения ключевых метрик во времени.
- Выполнять анализ временных рядов и выявлять сезонность.
- Измерять рост или снижение за определённые периоды.

### Изменения по годам

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

### Изменения по кварталам

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

### Изменения по месяцам

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

## Раздел 8: Кумулятивный анализ

### Цель

- Рассчитывать накопительные итоги или скользящие средние по ключевым метрикам.
- Отслеживать производительность во времени накопительным итогом.
- Полезно для анализа роста или выявления долгосрочных трендов.

### Общие продажи по месяцам, накопительный итог и скользящее среднее по годам

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

## Раздел 9: Анализ производительности (год к году, месяц к месяцу)

### Цель

- Измерять производительность продуктов, клиентов или регионов во времени.
- Сравнивать и выявлять высокоэффективные сущности.
- Отслеживать годовые тенденции и рост.

### Годовая производительность продуктов по сравнению со средним и предыдущим годом

Анализ годовой производительности продуктов путём сравнения их продаж со средними продажами продукта и продажами предыдущего года.

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

## Раздел 10: Анализ «часть к целому»

### Цель

- Сравнивать производительность или метрики по измерениям или временным периодам.
- Оценивать различия между категориями.
- Полезно для A/B-тестирования или региональных сравнений.

### Вклад категорий в общие продажи

Определить, какие категории вносят наибольший вклад в общие продажи.

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

## Раздел 11: Анализ сегментации данных

### Цель

- Группировать данные в значимые категории для целевых инсайтов.
- Выполнять сегментацию клиентов, категоризацию продуктов или региональный анализ.

### Сегментация продуктов по диапазону себестоимости

Сегментировать продукты по диапазонам себестоимости и посчитать, сколько продуктов попадает в каждый сегмент.

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

### Сегментация клиентов по поведению в расходах

Разделить клиентов на три сегмента на основе их поведения в расходах:

- **VIP**: Клиенты с историей не менее 12 месяцев и расходами более €5 000.
- **Regular**: Клиенты с историей не менее 12 месяцев, но с расходами €5 000 или меньше.
- **New**: Клиенты с продолжительностью жизни менее 12 месяцев.

Найти общее количество клиентов в каждой группе.

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

## Раздел 12: Отчёт по клиентам

### Цель

Этот отчёт объединяет ключевые метрики и поведение клиентов.

### Основные моменты

1. Собирает основные поля: имена, возраст и детали транзакций.
2. Сегментирует клиентов по категориям (VIP, Regular, New) и возрастным группам.
3. Агрегирует метрики на уровне клиента:
   - общее количество заказов
   - общая сумма продаж
   - общее количество купленных товаров
   - общее количество продуктов
   - продолжительность жизни (в месяцах)
4. Рассчитывает ценные KPI:
   - давность (месяцы с последнего заказа)
   - средняя стоимость заказа
   - средние месячные расходы

### Создание представления отчёта `gold.report_customers`

```sql
CREATE VIEW gold.report_customers AS
WITH base_query AS (
-- 1) Базовый запрос: получение основных столбцов из таблиц
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
-- 2) Агрегация по клиентам: суммирование ключевых метрик на уровне клиента
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
-- 3) Итоговый запрос: объединение всех результатов по клиентам
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

## Раздел 13: Отчёт по продуктам

### Цель

Этот отчёт объединяет ключевые метрики и поведение продуктов.

### Основные моменты

1. Собирает основные поля: название продукта, категория, подкатегория и себестоимость.
2. Сегментирует продукты по выручке для выявления высокоэффективных, средних и низкоэффективных.
3. Агрегирует метрики на уровне продукта:
   - общее количество заказов
   - общая сумма продаж
   - общее количество проданных товаров
   - общее количество уникальных клиентов
   - продолжительность жизни (в месяцах)
4. Рассчитывает ценные KPI:
   - давность (месяцы с последней продажи)
   - средняя выручка с заказа (AOR)
   - средняя месячная выручка

### Создание представления отчёта `gold.report_products`

```sql
CREATE VIEW gold.report_products AS
WITH base_query AS (
-- 1) Базовый запрос: получение основных столбцов из таблиц
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
-- 2) Агрегация по продуктам: суммирование ключевых метрик на уровне продукта
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
-- 3) Итоговый запрос: объединение всех результатов по продуктам
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
