-- Customer Sales Analysis — SQL Project
-- ADVANCED QUERIES
-- Topics: Subqueries, CASE
-- (Fresher-Friendly — No Window Functions)


USE customer_sales;


-- Top spending customer per region
SELECT r.region_name, c.first_name, c.last_name,
ROUND(SUM(oi.line_total), 2) AS total_spent
FROM regions r
JOIN customers c ON r.region_id = c.region_id
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY r.region_name, c.customer_id, c.first_name, c.last_name
ORDER BY r.region_name, total_spent DESC;



-- Best selling product per category
SELECT cat.category_name, p.product_name,
SUM(oi.quantity) AS total_sold
FROM categories cat
JOIN products p ON cat.category_id = p.category_id
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY cat.category_name, p.product_name
ORDER BY cat.category_name, total_sold DESC;


-- Month-wise total revenue
SELECT SUBSTR(o.order_date, 1, 7) AS month,
ROUND(SUM(oi.line_total), 2) AS monthly_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY SUBSTR(o.order_date, 1, 7)
ORDER BY month;

-- Find customers whose total spending is above the overall average.
with customer_totals AS (
SELECT c.customer_id, c.first_name, c.last_name,
SUM(oi.line_total) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT first_name, last_name, ROUND(total_spent, 2) AS total_spent
FROM customer_totals
WHERE total_spent > (SELECT AVG(total_spent) FROM customer_totals)
ORDER BY total_spent DESC;




-- Salesperson total sales & commission
SELECT s.first_name, s.last_name,
s.commission_rate,
ROUND(SUM(oi.line_total), 2) AS total_sales,
ROUND(SUM(oi.line_total) * s.commission_rate, 2) AS commission_earned
FROM salespeople s
JOIN orders o ON s.salesperson_id = o.salesperson_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY s.salesperson_id, s.first_name, s.last_name, s.commission_rate
ORDER BY total_sales DESC;



-- How much higher or lower is the revenue in 2024 compared to 2023
SELECT SUBSTR(o.order_date, 1, 4) AS year,
ROUND(SUM(oi.line_total), 2) AS total_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY SUBSTR(o.order_date, 1, 4)
ORDER BY year;



-- When did each customer place their first order
SELECT c.first_name, c.last_name,
MIN(o.order_date) AS first_order_date
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY first_order_date;

-- Product profit margin — rank by profitability.
SELECT product_name, unit_price, cost_price,
ROUND((unit_price - cost_price) / unit_price * 100, 2) AS profit_margin_pct,
RANK() OVER (ORDER BY (unit_price - cost_price) / unit_price DESC) AS margin_rank
FROM products
ORDER BY margin_rank;



-- Rank customers by total spending within each region.
SELECT r.region_name, c.first_name, c.last_name,
SUM(oi.line_total) AS total_spent,
RANK() OVER (PARTITION BY r.region_id ORDER BY SUM(oi.line_total) DESC) AS spending_rank
FROM regions r
JOIN customers c ON r.region_id = c.region_id
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY r.region_id, r.region_name, c.customer_id, c.first_name, c.last_name
ORDER BY r.region_name, spending_rank;