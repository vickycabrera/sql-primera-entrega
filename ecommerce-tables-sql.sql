-- Creación de la base de datos

CREATE DATABASE IF NOT EXISTS ecommerce;

-- Uso la base de datos 

USE ecommerce;

-- Creación de la tabla customers --

CREATE TABLE IF NOT EXISTS customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    fist_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(50),
    address VARCHAR(100),
    customer_password VARCHAR(30)
);

-- Creación de la tabla categories --

CREATE TABLE IF NOT EXISTS categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(30)
);

-- Creación de la tabla products --

CREATE TABLE IF NOT EXISTS products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(50),
    sku VARCHAR(20),
    price INT,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Creación de la tabla carts --

CREATE TABLE IF NOT EXISTS carts (
    cart_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Creación de la tabla cart_items --

CREATE TABLE IF NOT EXISTS cart_items (
    cart_item_id INT PRIMARY KEY AUTO_INCREMENT,
    cart_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (cart_id) REFERENCES carts(cart_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Creación de la tabla orders --

CREATE TABLE IF NOT EXISTS orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    order_date DATE,
    total_value INT,
    order_status VARCHAR(30),
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Creación de la tabla shipments --

CREATE TABLE IF NOT EXISTS shipments (
    shipment_id INT PRIMARY KEY AUTO_INCREMENT,
    shipment_date DATE,
	address VARCHAR(100),
    zip_code VARCHAR(20),
    city VARCHAR(30),
    country VARCHAR(30),
	order_id INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Creación de la tabla payments --

CREATE TABLE IF NOT EXISTS payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    payment_date DATE,
	payment_method VARCHAR(30),
	amount INT,
	order_id INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Creación de la tabla order_items --

CREATE TABLE IF NOT EXISTS order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    quantity INT,
    price INT,
    product_id INT,
    order_id INT,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);


