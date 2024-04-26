
-- //////////// CREACION DE USUARIOS Y ADMINISTRACIÓN DE PERMISOS ///////////////////

-- Crea un usuario con sólo los permisos de lectura sobre todas las tablas
CREATE USER IF NOT EXISTS 'coderhouse@localhost' IDENTIFIED BY 'coderhouse';
GRANT SELECT ON ecommerce_DB.* TO 'coderhouse@localhost';

-- Crea un usuario que puede ver, insertar y modificar datos de las tablas.
-- No puede eliminar registros
CREATE USER IF NOT EXISTS'coderhouse2@localhost' IDENTIFIED BY 'coderhouse2';
GRANT SELECT, INSERT, UPDATE ON ecommerce_DB.* TO 'coderhouse2@localhost';


-- Setencia SELECT para seleccionar desde la tabla user en la base de datos
-- Para ver los usuarios creados y sus permisos

SELECT * FROM mysql.user;

-- con estos script puedo vizualizar los permisos otorgados a los usuarios creados
SHOW GRANTS FOR 'coderhouse@localhost';
SHOW GRANTS FOR 'coderhouse2@localhost';