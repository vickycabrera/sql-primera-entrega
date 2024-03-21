USE ecommerce;

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
 
 -- Miramos como quedó la nueva tabla de Auditoría:
 select * from LOG_AUDITORIA 
 