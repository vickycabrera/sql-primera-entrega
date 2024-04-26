USE ecommerce_DB;

-- ///////////////////////////////////////////////////////////////////////////
-- PROCEDIMIENTOS: 

-- Procedimiento para obtener todos los productos en un carrito de compras:
-- Este procedimiento toma el ID del carrito como entrada y devuelve todos los productos incluidos en ese carrito

DROP PROCEDURE IF EXISTS get_products_in_cart;

DELIMITER //
CREATE PROCEDURE get_products_in_cart
									(IN cart_id_param INT)
	BEGIN
		SELECT CI.product_id, P.product_name, CI.quantity
		FROM cart_items CI
		INNER JOIN products P ON CI.product_id = P.product_id
		WHERE CI.cart_id = cart_id_param;
	END //
DELIMITER ;

-- La ejecutamos así:
-- CALL get_products_in_cart(1);


-- Procedimiento para obtener el estado de una orden y la fecha de envío:
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

-- La ejecutamos así:
-- CALL get_order_status_and_shipment_date(1, @order_status, @shipment_date);
-- SELECT @order_status, @shipment_date;
