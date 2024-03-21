USE ecommerce;

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
