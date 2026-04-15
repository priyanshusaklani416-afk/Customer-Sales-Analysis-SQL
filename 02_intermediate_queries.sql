--  Customer Sales Analysis — SQL Project
--  INTERMEDIATE QUERIES 
-- Topics: JOINs, GROUP BY, HAVING, Subqueries


USE customer_sales;


-- Total revenue per order
SELECT o.order_id, o.order_date, 
SUM(oi.line_total) AS order_total
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, o.order_date
ORDER BY order_total DESC;



-- Top 10 customers by total spending
SELECT c.first_name, c.last_name, c.customer_segment,
       SUM(oi.line_total) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC
LIMIT 10;



-- Which category generates most revenue?
SELECT cat.category_name, 
SUM(oi.line_total) AS total_revenue
FROM categories cat
JOIN products p ON cat.category_id = p.category_id
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY cat.category_name
ORDER BY total_revenue DESC;



-- verage order value by region
SELECT r.region_name,
ROUND(AVG(order_totals.order_total), 2) AS avg_order_value
FROM regions r
JOIN customers c ON r.region_id = c.region_id
JOIN orders o ON c.customer_id = o.customer_id
JOIN (
SELECT order_id, SUM(line_total) AS order_total
FROM order_items
GROUP BY order_id
) order_totals ON o.order_id = order_totals.order_id
GROUP BY r.region_name
ORDER BY avg_order_value DESC;



-- alesperson with highest total sales
SELECT s.first_name, s.last_name,
SUM(oi.line_total) AS total_sales
FROM salespeople s
JOIN orders o ON s.salesperson_id = o.salesperson_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY s.salesperson_id, s.first_name, s.last_name
ORDER BY total_sales DESC
LIMIT 1;



-- Customers who never placed an order
SELECT c.first_name, c.last_name, c.email, c.signup_date
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- Monthly revenue trend (2023 vs 2024)
SELECT 
SUBSTR(o.order_date, 1, 7) AS month,
SUBSTR(o.order_date, 1, 4) AS year,
ROUND(SUM(oi.line_total), 2) AS monthly_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY SUBSTR(o.order_date, 1, 7)
ORDER BY month;


-- Products ordered more than 50 times
SELECT p.product_name, 
SUM(oi.quantity) AS total_quantity_sold
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
HAVING SUM(oi.quantity) > 50
ORDER BY total_quantity_sold DESC;



-- Average discount per category
SELECT cat.category_name,
ROUND(AVG(oi.discount), 2) AS avg_discount
FROM categories cat
JOIN products p ON cat.category_id = p.category_id
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY cat.category_name
ORDER BY avg_discount DESC;



-- Regions with $50K+ in total sales
SELECT r.region_name,
ROUND(SUM(oi.line_total), 2) AS total_sales
FROM regions r
JOIN customers c ON r.region_id = c.region_id
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY r.region_name
HAVING SUM(oi.line_total) > 50000
ORDER BY total_sales DESC;
