-- Customer Sales Analysis — SQL Project
-- Complete Database Setup
-- Just run this file in MySQL Workbench
-- It will create everything automatically!


DROP DATABASE IF EXISTS customer_sales;
CREATE DATABASE customer_sales;
USE customer_sales;


-- TABLE 1: regions
CREATE TABLE regions (
region_id INT PRIMARY KEY AUTO_INCREMENT,
region_name VARCHAR(50) NOT NULL
);

INSERT INTO regions (region_name) VALUES
('Northeast', 'USA'), ('Southeast', 'USA'), ('Midwest', 'USA'),
('Southwest', 'USA'), ('West', 'USA'), ('Northwest', 'USA'),
('Central', 'USA'), ('Mid-Atlantic', 'USA');


-- TABLE 2: categories
CREATE TABLE categories (
category_id INT PRIMARY KEY AUTO_INCREMENT,
category_name VARCHAR(50) NOT NULL
);

INSERT INTO categories (category_name) VALUES
('Electronics', 'Smartphones, laptops, tablets and accessories'),
('Clothing', 'Apparel, footwear and fashion accessories'),
('Home & Kitchen', 'Furniture, cookware and home decor'),
('Sports & Outdoors', 'Fitness equipment, camping and outdoor gear'),
('Books & Media', 'Books, e-books, music and movies'),
('Health & Beauty', 'Personal care, wellness and beauty products'),
('Toys & Games', 'Board games, puzzles and childrens toys'),
('Office Supplies', 'Stationery, printers and office furniture');


-- TABLE 3: salespeople
CREATE TABLE salespeople (
salesperson_id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
email VARCHAR(100) NOT NULL,
region_id INT NOT NULL,
hire_date DATE NOT NULL,
commission_rate DECIMAL(4,2) NOT NULL,
FOREIGN KEY (region_id) REFERENCES regions(region_id)
);


-- TABLE 4: customers
CREATE TABLE customers (
customer_id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
email VARCHAR(100) NOT NULL,
city VARCHAR(50) NOT NULL,
state VARCHAR(50) NOT NULL,
region_id INT NOT NULL,
customer_segment VARCHAR(20) NOT NULL,
signup_date DATE NOT NULL,
FOREIGN KEY (region_id) REFERENCES regions(region_id)
);


-- TABLE 5: products
CREATE TABLE products (
product_id INT PRIMARY KEY AUTO_INCREMENT,
product_name VARCHAR(100) NOT NULL,
category_id INT NOT NULL,
unit_price DECIMAL(10,2) NOT NULL, 
cost_price DECIMAL(10,2) NOT NULL,
FOREIGN KEY (category_id) REFERENCES categories(category_id)
);


-- TABLE 6: orders
CREATE TABLE orders (
order_id INT PRIMARY KEY AUTO_INCREMENT,
customer_id INT NOT NULL,
salesperson_id INT NOT NULL,
order_date DATE NOT NULL,
order_status VARCHAR(20) NOT NULL DEFAULT 'Pending',
FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
FOREIGN KEY (salesperson_id) REFERENCES salespeople(salesperson_id)
);


-- TABLE 7: order_items
CREATE TABLE order_items (
order_item_id INT PRIMARY KEY AUTO_INCREMENT,
order_id INT NOT NULL,
product_id INT NOT NULL,
quantity INT NOT NULL,
discount DECIMAL(4,2) NOT NULL DEFAULT 0.00,
line_total DECIMAL(10,2) NOT NULL,
FOREIGN KEY (order_id) REFERENCES orders(order_id),
FOREIGN KEY (product_id) REFERENCES products(product_id)
);
