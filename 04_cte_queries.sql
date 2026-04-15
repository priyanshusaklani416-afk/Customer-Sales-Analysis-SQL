-- ============================================
-- 📊 Customer Sales Analysis — SQL Project
-- 📘 CTE QUERIES (Q31–Q35)
-- Topics: Common Table Expressions
-- ============================================

USE customer_sales;


-- List top 10 customers by spending (CTE)
WITH customer_spending AS (
SELECT c.customer_id, c.first_name, c.last_name,
ROUND(SUM(oi.line_total), 2) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT first_name, last_name, total_spent
FROM customer_spending
ORDER BY total_spent DESC
LIMIT 10;



-- Region-wise avg order value (CTE)
WITH order_totals AS (
SELECT o.order_id, o.customer_id,
ROUND(SUM(oi.line_total), 2) AS order_total
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, o.customer_id
)
SELECT r.region_name,
COUNT(*) AS total_orders,
ROUND(AVG(ot.order_total), 2) AS avg_order_value
FROM order_totals ot
JOIN customers c ON ot.customer_id = c.customer_id
JOIN regions r ON c.region_id = r.region_id
GROUP BY r.region_name
ORDER BY avg_order_value DESC;



-- High revenue months > $20K (CTE)
WITH monthly_revenue AS (
SELECT SUBSTR(o.order_date, 1, 7) AS month,
ROUND(SUM(oi.line_total), 2) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY SUBSTR(o.order_date, 1, 7)
)
SELECT month, revenue
FROM monthly_revenue
WHERE revenue > 20000
ORDER BY revenue DESC;





