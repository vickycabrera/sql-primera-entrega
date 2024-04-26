
-- ////////////////////////////////////// TRANSACCIONES ///////////////////////////////////////////////////////////

-- Seleccionamos el schema ecommerce_DB
-- La modificación va a ser sobre la tabla CATEGORIES
USE ecommerce_DB;
select * from categories;

-- consulto el estado del autocommit
select @@autocommit;
-- seteo la variable a 0 para poder trabajar con transacciones
set autocommit = 0;

-- Inicio de la transacción
START TRANSACTION;

-- Punto de guardado 1
SAVEPOINT punto_1;

-- 1. Hacemos un UPDATE
UPDATE categories
SET category_name = 'ejemplo_punto_1'
WHERE category_id < 5;

-- Punto de guardado 2
SAVEPOINT punto_2;

-- 2. INSERTO 2 registros nuevos
INSERT INTO categories (category_id, category_name)
VALUES (100, 'ejemplo_punto_2'),
	   (101, 'ejemplo_punto_2');

-- Punto de guardado 3
SAVEPOINT punto_3;

-- 3. Hago otro UPDATE
UPDATE categories
SET category_name = 'ejemplo_punto_3'
WHERE category_id = 9;

-- Ver las 3 modificaciones en la tabla:
select * from categories;

-- Si quiero volver a alguno de los puntos anteriores a las modificaciones puedo usar:
ROLLBACK TO SAVEPOINT punto_1; 
ROLLBACK TO SAVEPOINT punto_2;      
ROLLBACK TO SAVEPOINT punto_3; 

-- Una vez que estoy seguro confirmo las transacciones
-- (Ya no se podrá volver a los puntos de guardado)
COMMIT;

-- Ver resultado final
select * from categories;