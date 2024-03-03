-- Creación de la base de datos

DROP DATABASE IF exists ecommerce;
CREATE DATABASE IF NOT EXISTS ecommerce;

-- Uso la base de datos 

USE ecommerce;

-- Creación de la tabla customers --

CREATE TABLE IF NOT EXISTS customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(50) NOT NULL,
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
    product_name VARCHAR(50) NOT NULL,
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
    quantity INT NOT NULL,
    price INT NOT NULL,
    product_id INT NOT NULL,
    order_id INT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Insertamos los clientes
INSERT INTO customers (first_name, last_name, email, address, customer_password)
VALUES
    ('John', 'Doe', 'john.doe@email.com', '123 Main St', 'password123'),
    ('Jane', 'Smith', 'jane.smith@email.com', '456 Oak Ave', 'securepwd456'),
    ('Carlos', 'Garcia', 'carlos.garcia@email.com', '789 Elm St', 'mypassword789'),
    ('Maria', 'Martinez', 'maria.martinez@email.com', '101 Pine St', 'pass1234'),
    ('David', 'Johnson', 'david.johnson@email.com', '202 Maple Ave', 'davidpwd567'),
    ('Laura', 'Lee', 'laura.lee@email.com', '303 Cedar St', 'laurapass987'),
    ('Samuel', 'Brown', 'samuel.brown@email.com', '404 Birch Ave', 'samuel123'),
    ('Emma', 'Taylor', 'emma.taylor@email.com', '505 Spruce St', 'emmapass456'),
    ('Daniel', 'Clark', 'daniel.clark@email.com', '606 Pine Ave', 'danielpwd789'),
    ('Sophia', 'White', 'sophia.white@email.com', '707 Oak St', 'sophiapass321'),
    ('Ethan', 'Miller', 'ethan.miller@email.com', '808 Maple Ave', 'ethan123'),
    ('Olivia', 'Anderson', 'olivia.anderson@email.com', '909 Cedar St', 'oliviapass654'),
    ('Liam', 'Wilson', 'liam.wilson@email.com', '1010 Elm Ave', 'liampass987'),
    ('Ava', 'Moore', 'ava.moore@email.com', '1111 Birch St', 'avapassword123'),
    ('Mason', 'Davis', 'mason.davis@email.com', '1212 Spruce Ave', 'masonpwd456');

-- Insertamos las categorias
INSERT INTO categories (category_name)
VALUES
    ('Electrónicos'),
    ('Ropa'),
    ('Hogar y Jardín'),
    ('Deportes y Aire libre'),
    ('Libros'),
    ('Juguetes'),
    ('Salud y Belleza'),
    ('Herramientas'),
    ('Joyas y Relojes'),
    ('Alimentación'),
    ('Automotriz'),
    ('Electrodomésticos'),
    ('Muebles'),
    ('Mascotas'),
    ('Tecnología');

-- Insertamos los productos, relacionando su category_id con los de la anterior inserción
INSERT INTO products (product_name, sku, price, category_id)
VALUES
    ('Laptop HP Pavilion', 'HP123', 1200, 1),
    ('Camiseta de Algodón', 'COT456', 25, 2),
    ('Juego de Sartenes Antiadherentes', 'KITCHEN789', 80, 3),
    ('Raqueta de Tenis Wilson', 'TENNIS001', 90, 4),
    ('Libro "El Principito"', 'BOOK123', 15, 5),
    ('Set de Bloques de Construcción', 'TOY456', 30, 6),
    ('Cepillo de Dientes Eléctrico', 'ELEC789', 50, 7),
    ('Taladro Inalámbrico', 'DRILL001', 120, 8),
    ('Collar de Plata con Diamantes', 'JEWELRY123', 200, 9),
    ('Pack de Snacks Saludables', 'SNACK456', 10, 10),
    ('Aceite de Motor Sintético', 'OIL789', 40, 11),
    ('Aspiradora Robot Inteligente', 'ROBOTIC001', 180, 12),
    ('Sofá de Cuero', 'SOFA123', 500, 13),
    ('Juguete para Gatos con Hierba Gatera', 'PET456', 15, 14),
    ('Paquete de Vacaciones a la Playa', 'VACATION789', 800, 15);
    
-- Insertamos carritos relacionados con los customers generados anteriormente
INSERT INTO carts (customer_id)
VALUES
    (1),
    (2),
    (3),
    (4),
    (5),
    (6),
    (7),
    (8),
    (9),
    (10),
    (11),
    (12),
    (13),
    (14),
    (15);

-- Insertamos items de carrito asociados a carritos y productos generados anteriormente
INSERT INTO cart_items (cart_id, product_id, quantity)
VALUES
    (1, 1, 2),
    (2, 3, 1),
    (3, 5, 3),
    (4, 7, 1),
    (5, 9, 2),
    (6, 11, 1),
    (7, 13, 4),
    (8, 15, 2),
    (9, 2, 3),
    (10, 4, 1),
    (11, 6, 2),
    (12, 8, 1),
    (13, 10, 3),
    (14, 12, 2),
    (15, 14, 1);

-- Insertamos órdenes asociadas a clientes generados anteriormente
INSERT INTO orders (order_date, total_value, order_status, customer_id)
VALUES
    ('2024-03-01', 150, 'En proceso', 1),
    ('2024-03-02', 300, 'En proceso', 2),
    ('2024-03-03', 80, 'En espera', 3),
    ('2024-03-04', 200, 'Completado', 4),
    ('2024-03-05', 50, 'En espera', 5),
    ('2024-03-06', 180, 'En proceso', 6),
    ('2024-03-07', 400, 'En proceso', 7),
    ('2024-03-08', 250, 'En proceso', 8),
    ('2024-03-09', 120, 'En espera', 9),
    ('2024-03-10', 75, 'Completado', 10),
    ('2024-03-11', 220, 'En proceso', 11),
    ('2024-03-12', 130, 'En proceso', 12),
    ('2024-03-13', 350, 'En proceso', 13),
    ('2024-03-14', 200, 'Completado', 14),
    ('2024-03-15', 100, 'En espera', 15);
    
-- Insertamos items de orden asociados a productos y órdenes generados anteriormente
INSERT INTO order_items (quantity, price, product_id, order_id)
VALUES
    (2, 1200, 1, 1),
    (1, 25, 2, 2),
    (3, 80, 3, 3),
    (1, 90, 4, 4),
    (2, 15, 5, 5),
    (1, 30, 6, 6),
    (4, 50, 7, 7),
    (2, 120, 8, 8),
    (3, 200, 9, 9),
    (1, 10, 10, 10),
    (2, 40, 11, 11),
    (1, 180, 12, 12),
    (3, 500, 13, 13),
    (2, 15, 14, 14),
    (1, 800, 15, 15);
    
-- Insertanos envíos asociados a órdenes generadas anteriormente 
INSERT INTO shipments (shipment_date, address, zip_code, city, country, order_id)
VALUES
    ('2024-03-02', '123 Main St', '12345', 'New York', 'United States', 1),
    ('2024-03-03', '456 Oak Ave', '67890', 'Los Angeles', 'United States', 2),
    ('2024-03-04', '789 Elm St', '54321', 'London', 'United Kingdom', 3),
    ('2024-03-05', '101 Pine St', '98765', 'Paris', 'France', 4),
    ('2024-03-06', '202 Maple Ave', '11111', 'Tokyo', 'Japan', 5),
    ('2024-03-07', '303 Cedar St', '22222', 'Sydney', 'Australia', 6),
    ('2024-03-08', '404 Birch Ave', '33333', 'Berlin', 'Germany', 7),
    ('2024-03-09', '505 Spruce St', '44444', 'Toronto', 'Canada', 8),
    ('2024-03-10', '606 Pine Ave', '55555', 'Rome', 'Italy', 9),
    ('2024-03-11', '707 Oak St', '66666', 'Barcelona', 'Spain', 10),
    ('2024-03-12', '808 Maple Ave', '77777', 'Seoul', 'South Korea', 11),
    ('2024-03-13', '909 Cedar St', '88888', 'Beijing', 'China', 12),
    ('2024-03-14', '1010 Elm Ave', '99999', 'Sao Paulo', 'Brazil', 13),
    ('2024-03-15', '1111 Birch St', '00000', 'Cape Town', 'South Africa', 14),
    ('2024-03-16', '1212 Spruce Ave', '12312', 'Mexico City', 'Mexico', 15);
    
-- Insertamos pagos asociados a órdenes generadas anteriormente
INSERT INTO payments (payment_date, payment_method, amount, order_id)
VALUES
    ('2024-03-02', 'Tarjeta de Crédito', 150, 1),
    ('2024-03-03', 'MercadoPago', 300, 2),
    ('2024-03-04', 'Transferencia Bancaria', 80, 3),
    ('2024-03-05', 'Tarjeta de Débito', 200, 4),
    ('2024-03-06', 'MercadoPago', 50, 5),
    ('2024-03-07', 'Tarjeta de Débito', 180, 6),
    ('2024-03-08', 'Tarjeta de Crédito', 400, 7),
    ('2024-03-09', 'MercadoPago', 250, 8),
    ('2024-03-10', 'Transferencia Bancaria', 120, 9),
    ('2024-03-11', 'Tarjeta de Débito', 75, 10),
    ('2024-03-12', 'MercadoPago', 220, 11),
    ('2024-03-13', 'Apple Pay', 130, 12),
    ('2024-03-14', 'Tarjeta de Crédito', 350, 13),
    ('2024-03-15', 'MercadoPago', 200, 14),
    ('2024-03-16', 'Transferencia Bancaria', 100, 15);
    
-- Comprobamos que los datos hayan quedado bien
SELECT * FROM customers;
SELECT * FROM categories;
SELECT * FROM products;
SELECT * FROM carts;
SELECT * FROM cart_items;
SELECT * FROM orders;
SELECT * FROM order_items;
SELECT * FROM payments;
SELECT * FROM shipments;
