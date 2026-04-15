-- Customer Sales Analysis — SQL Project
-- BEGINNER QUERIES 
-- Topics: SELECT, WHERE, ORDER BY, GROUP BY


USE customer_sales;


-- List all customers from California
SELECT first_name, last_name, city, state
FROM customers
WHERE state = 'California';



-- Find all products with unit price > $100
SELECT product_name, unit_price
FROM products
WHERE unit_price > 100
ORDER BY unit_price DESC;



-- How many orders are in each status?
SELECT order_status, COUNT(*) AS order_count
FROM orders
GROUP BY order_status
ORDER BY order_count DESC;



-- List the top 10 most expensive products
SELECT product_name, unit_price
FROM products
ORDER BY unit_price DESC
LIMIT 10;



-- ind all customers who signed up in 2024
SELECT first_name, last_name, signup_date
FROM customers
WHERE signup_date BETWEEN '2024-01-01' AND '2024-12-31';



-- Count customers in each segment
SELECT customer_segment, COUNT(*) AS customer_count
FROM customers
GROUP BY customer_segment
ORDER BY customer_count DESC;



-- Salespeople hired before 2022
SELECT first_name, last_name, hire_date
FROM salespeople
WHERE hire_date < '2022-01-01';



-- Total products in each category
SELECT c.category_name, COUNT(p.product_id) AS product_count
FROM categories c
LEFT JOIN products p ON c.category_id = p.category_id
GROUP BY c.category_name
ORDER BY product_count DESC;
