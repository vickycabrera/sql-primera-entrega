USE ecommerce_DB;

-- ///////////////////////////////////////////////////////////////////////////
-- FUNCIONES:

-- Calcular el total gastado por un cliente en todas sus órdenes
drop function if exists total_spent_by_customer;

DELIMITER //
CREATE FUNCTION total_spent_by_customer(customer_id_param INT) 
	RETURNS INT
	DETERMINISTIC
	BEGIN
		DECLARE total_amount DECIMAL;
		SELECT SUM(total_value) INTO total_amount
		FROM orders 
		WHERE customer_id = customer_id_param;
		RETURN total_amount;
	END //
DELIMITER ;
    
-- Para ejecutar la función:
-- SELECT total_spent_by_customer(1);


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

-- Para ejecutar la función:
-- SELECT count_orders_completed_between_dates("2024-03-01", "2024-03-30");