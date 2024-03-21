USE ecommerce;

-- ///////////////////////////////////////////////////////////////////////////
-- FUNCIONES:

-- Calcular el total gastado por un cliente en todas sus órdenes
drop function if exists total_spent_by_customer;

DELIMITER //
CREATE FUNCTION total_spent_by_customer(customer_id_param INT) 
	RETURNS INT
	DETERMINISTIC
	BEGIN
		DECLARE total_amount INT;
		SELECT SUM(total_value) INTO total_amount
		FROM orders 
		WHERE customer_id = customer_id_param;
		RETURN total_amount;
	END //
DELIMITER ;
    
-- La ejecutamos:
SELECT total_spent_by_customer(1);

-- Contar la cantidad de órdenes completadas en un rango de fechas
drop function if exists count_orders_completed_between_dates;

DELIMITER //
CREATE FUNCTION count_orders_completed_between_dates(start_date DATE, end_date DATE) 
	RETURNS INT
	DETERMINISTIC
	BEGIN
		DECLARE total_orders INT;
		SELECT COUNT(*) INTO total_orders
		FROM orders
		WHERE order_status = 'Completado'
		AND order_date BETWEEN start_date AND end_date;
		RETURN total_orders;
	END //
DELIMITER ;

-- La ejecutamos:
SELECT count_orders_completed_between_dates("2024-03-01", "2024-03-30");

-- ///////////////////////////////////////////////////////////////////////////
-- PROCEDIMIENTOS: 

-- Procedimiento para obtener todos los productos en un carrito de compras:
-- Este procedimiento toma el ID del carrito como entrada y devuelve todos los productos incluidos en ese carrito junto con su cantidad, 
-- así como el total de productos en el carrito.

DROP PROCEDURE IF EXISTS get_products_in_cart;

DELIMITER //
CREATE PROCEDURE get_products_in_cart
									(IN cart_id_param INT)
	BEGIN
		-- Seleccionar los productos en el carrito dado el cart_id
		SELECT CI.product_id, P.product_name, CI.quantity
		FROM cart_items CI
		INNER JOIN products P ON CI.product_id = P.product_id
		WHERE CI.cart_id = cart_id_param;
	END //
DELIMITER ;

-- La ejecutamos:
CALL get_products_in_cart(1);

-- Procedimiento para Obtener el estado de una orden y la fecha de envío:
-- Toma el ID de la orden como entrada y devuelve el estado actual de la orden y la fecha de envío si está disponible.
DROP PROCEDURE IF EXISTS get_order_status_and_shipment_date;
DELIMITER //
CREATE PROCEDURE get_order_status_and_shipment_date
													(IN order_id_param INT, 
													OUT order_status VARCHAR(30), 
													OUT shipment_date DATE)
	BEGIN
		SELECT O.order_status, S.shipment_date
		INTO order_status, shipment_date
		FROM orders O 
		LEFT JOIN shipments S ON O.order_id = S.order_id
		WHERE O.order_id = order_id_param;
	END //
DELIMITER ;

-- La ejecutamos:
CALL get_order_status_and_shipment_date(1, @order_status, @shipment_date);
SELECT @order_status, @shipment_date;

-- ///////////////////////////////////////////////////////////////////////////
-- TRIGGERS

-- Creamos la tabla donde vamos a guardar la información de Auditoría
-- Para registrar movimientos realizados en tablas con información sensible
drop table if exists LOG_AUDITORIA;

CREATE TABLE IF NOT EXISTS LOG_AUDITORIA 
(
ID_LOG INT AUTO_INCREMENT,
PK_ID INT NOT NULL, 
CAMPONUEVO_CAMPOANTERIOR VARCHAR(255),
NOMBRE_DE_ACCION VARCHAR(10),
NOMBRE_TABLA VARCHAR(50),
USUARIO VARCHAR(100),
FECHA_UPD_INS_DEL TIMESTAMP,
PRIMARY KEY (ID_LOG)
)
;

-- Creamos en trigger que se dispara al insertar un nuevo customer
-- Y guarda la info del movimiento en la tabla de Auditoría 
DROP TRIGGER if exists TRG_LOG_AUDITORIA_1;

DELIMITER //
CREATE TRIGGER TRG_LOG_AUDITORIA_1 AFTER INSERT ON customers
FOR EACH ROW 
	BEGIN
		INSERT INTO LOG_AUDITORIA (PK_ID, CAMPONUEVO_CAMPOANTERIOR, NOMBRE_DE_ACCION, NOMBRE_TABLA, USUARIO, FECHA_UPD_INS_DEL)
		VALUES ( NEW.customer_id, NEW.email, 'INSERT' , 'customers', CURRENT_USER(), NOW());		   
	END//
DELIMITER ;

-- Para probar generamos una nueva inserción en customers:
 INSERT INTO customers (first_name, last_name, email, address, customer_password)
 VALUES ('Usuario', 'Nuevo', 'user@new.com', 'Calle falsa 123', 'contraseña-prueba');
  
 
-- Creamos un segundo trigger que se dispara al modificar ordenes
-- Y guarda la info del movimiento (cambio de precio) en la tabla de Auditoría 
DROP TRIGGER if  exists TRG_LOG_AUDITORIA_2 ;

DELIMITER //
CREATE TRIGGER TRG_LOG_AUDITORIA_2 AFTER UPDATE ON orders
FOR EACH ROW 
	BEGIN
		INSERT INTO LOG_AUDITORIA (PK_ID, CAMPONUEVO_CAMPOANTERIOR, NOMBRE_DE_ACCION, NOMBRE_TABLA, USUARIO, FECHA_UPD_INS_DEL)
		VALUES (OLD.order_id, CONCAT('total_value Nuevo: ', NEW.total_value , ', total_value anterior: ', OLD.total_value), 'UPDATE', 'orders', CURRENT_USER(), NOW());
	END//
DELIMITER ;

-- Para probar generamos una actualización en tabla orders:
 UPDATE ORDERS SET total_value = 1000 where order_id = 2;
 

-- ///////////////////////////////////////////////////////////////////////////
-- VISTAS

-- Creamos una vista para acceder a la información almacenada en la tabla Auditoría
-- (ordenada por fecha: ultimos movimientos se ven primero)

CREATE OR REPLACE VIEW VW_LOG_AUDITORIA AS (
select * from LOG_AUDITORIA 
ORDER BY FECHA_UPD_INS_DEL DESC);

SELECT * FROM VW_LOG_AUDITORIA ; 


-- Vista de detalles del cliente y su carrito de compras:

CREATE OR REPLACE VIEW vw_customer_cart_details AS (
SELECT C.customer_id, C.first_name, C.last_name, C.email, C.address,
       CRT.cart_id
FROM customers C
LEFT JOIN carts CRT ON C.customer_id = CRT.customer_id);

SELECT * FROM vw_customer_cart_details ; 


-- Vista de detalles de la orden y su estado:

CREATE OR REPLACE VIEW vw_order_status_details AS (
SELECT O.order_id, O.order_date, O.total_value, O.order_status, O.customer_id,
       S.shipment_date, S.address, S.zip_code, S.city, S.country
FROM orders O
LEFT JOIN shipments S ON O.order_id = S.order_id);


SELECT * FROM vw_order_status_details ; 


-- Vista de resumen de ventas por categoría:

CREATE OR REPLACE VIEW vw_sales_by_category AS (
SELECT C.category_name, SUM(OI.quantity) AS total_quantity,
       SUM(OI.price * OI.quantity) AS total_revenue
FROM order_items OI
INNER JOIN products P ON OI.product_id = P.product_id
INNER JOIN categories C ON P.category_id = C.category_id
GROUP BY C.category_name);

SELECT * FROM vw_sales_by_category ; 


-- Vista de detalles de pago de una orden:

drop view if exists order_payment_details;
CREATE OR REPLACE VIEW order_payment_details AS (
SELECT O.order_id, O.order_date, O.total_value, O.order_status,
       P.payment_date, P.payment_method, P.amount as paid_amount
FROM orders O
INNER JOIN payments P ON O.order_id = P.order_id);

SELECT * FROM order_payment_details ;
