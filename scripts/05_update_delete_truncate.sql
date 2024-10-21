-- -----------------------------------
-- Tema     : Data Manipulation Language (DML) 
-- Profesor : Jesús Canales
-- Curso    : Base de Datos A1 
-- -----------------------------------

-----<> UPDATE > Permite la modificación o actualización de datos de la tabla.
-----<> sintaxis:
/*	UPDATE name_table
	SET name_column1 = expression1,
		name_column2 = expression2,...
	WHERE
		{condición}
		
Para las demos de la clase utilizaremos la base de datos dbCompuTech:
	-- Verificar la existencia de esquemas.		-> SELECT * FROM sys.schemas;
	-- Verificar la existencia de tablas.		-> SELECT * FROM sys.tables;
	-- Verificar la existencia de relaciones.	-> SELECT * FROM sys.foreign_keys 
	-- Verificar la existencia de registros.	-> SELECT * FROM persona.client

*/
--------------------------------------------------------------------------------
/* Reconociendo nuestra base de datos */

-- 1. Poner en uso la base de datos dbCompuTech
USE dbCompuTech
GO

-- 2. Ver estructura de tabla client
exec sp_help 'persona.client'
GO

-- 3. Listar registros de la tabla client
SELECT * FROM PERSONA.client
GO

-- 4. Actualizar la fecha de nacimiento de Fernando Ruíz Pérez a 01/07/2004
SET DATEFORMAT dmy;
UPDATE persona.client
	SET birthday = '01/07/2004'
	WHERE names = 'Fernando' AND last_names = 'Ruíz Pérez'
GO

--------------------------------------------------------------------------------
/* Eliminación lógica */

-- 1. Listar los registros de tabla client
SELECT * FROM persona.client
GO

-- 2. Eliminar lógicamente los clientes procedentes de Colombia
UPDATE persona.client
	SET status = 'I' -- I es inactivo
	WHERE country_id -- 101
	IN (
		SELECT id -- 101
		FROM persona.country 
		WHERE name_country = 'Chile'
		)
GO

-- 3. Verificamos el borrado lógico (status = I)
SELECT * FROM persona.client
GO
SELECT * FROM persona.country
GO
--------------------------------------------------------------------------------
--<> MERGE: realiza operaciones de inserción, actualización o eliminación 
-- en una tabla destino, según los resultados de una combinación con tabla origen. 

-----<> sintaxis:
/*	
	MERGE tabla_destino AS TARGET
	USING tabla_origen AS SOURCE
		ON columna_en_comun_target_and_source
	WHEN MATCHED THEN
		acción_si_coinciden_tabla_target_y_tabla_source
	WHEN NOT MATCHED BY TARGET THEN
		acción_sino_coinciden_con_tabla_target
	WHEN NOT MATCHED BY SOURCE THEN
		acción_sino_coinciden_con_tabla_origen	
*/

--- Listar registros de tabla client -> SELECT * FROM persona.client

--- Listar registros de tabla client_active -> SELECT * FROM persona.client_active

--------------------------------------------------------------------------------
---<> Pasar registros de client a client_active, sólo los status = A
--1.Pasamos los registros a la tabla client
MERGE persona.client_active AS trgt
USING persona.client AS src
	ON (trgt.id = src.id)
WHEN MATCHED AND src.status = 'I' 
	THEN DELETE
WHEN NOT MATCHED AND src.status = 'A' 
	THEN INSERT 
	(id, names, last_names, email, birthday, status)
	VALUES 
	(src.id, src.names, src.last_names, src.email, src.birthday, src.status)
WHEN MATCHED AND trgt.status = 'A' 
	THEN UPDATE SET
	trgt.names = src.names,
	trgt.last_names = src.last_names,
	trgt.email = src.email,
	trgt.birthday = src.birthday
OUTPUT $action, deleted.*, inserted.*; -- historial de lo que hizo merge
SELECT @@ROWCOUNT AS 'TOTAL PROCESADAS'; -- # filas afectadas o procesadas

--------------------------------------------------------------------------------
---<> Poniendo a prueba a MERGE

-- 1. Listamos registros de ambas tablas para comparar
SELECT * FROM persona.client_active;
SELECT * FROM persona.client;

-- 2. Restaurar lógicamente los clientes procedentes de Colombia
UPDATE persona.client
	SET status = 'A' -- I es inactivo
	WHERE country_id 
	IN (SELECT id FROM persona.country WHERE name_country = 'Colombia');

-- 3. Eliminar lógicamente los clientes procedentes de Perú
UPDATE persona.client
	SET status = 'I' -- I es inactivo
	WHERE country_id 
	IN (SELECT id FROM persona.country WHERE name_country = 'Perú');

-- 4. Ejecutemos el merge para sincronizar

-- 5. Exploremos resultados

--------------------------------------------------------------------------------
-----<> DELETE > Permite borrar datos de una tabla.
/*	
-----<> sintaxis:
	DELETE FROM name_table
	WHERE {condición}
*/

-- 1. Exploremos la tabla producto -> SELECT * FROM producto.product

-- 2. Eliminar los productos de la categoría proyectores
DELETE FROM PRODUCTO.product
WHERE category = 'Proyectores'
GO

-- 3. Eliminar todos los productos de la tabla product
DELETE FROM PRODUCTO.product
GO

-- 4. Exploramos la tabla product y veremos que ahora ya no existen registros.

--------------------------------------------------------------------------------
-----<> TRUNCATE > Permite borrar datos de una tabla y reinicia el Identity.
/*	
-----<> sintaxis:
	TRUNCATE TABLE name_table;
*/

-- 1. Listar registros de la tabla inventory (inventario)
SELECT * FROM PRODUCTO.inventory
GO

-- 2. Eliminar registros de tabla inventory (inventario)
DELETE FROM PRODUCTO.inventory
GO

-- 3. Insertamos un producto en inventory (inventario)
INSERT INTO PRODUCTO.inventory
	(description, category, stock, price)
VALUES
	('All in one HP', 'Computadora', 100, 3520.70)
GO

-- 4. Listar registros de tabla inventory
SELECT * FROM PRODUCTO.inventory
GO

-- 5. Eliminar y reiniciar el identity de la tabla sale (venta)
TRUNCATE TABLE PRODUCTO.inventory
GO

-- 6. Insertamos un producto en inventory (inventario)
INSERT INTO PRODUCTO.inventory
	(description, category, stock, price)
VALUES
	('All in one HP', 'Computadora', 100, 3520.70)
GO

-- 7. Listar registros de tabla inventory
SELECT * FROM PRODUCTO.inventory
GO

-- Verificamos que se ha insertado el registro y reinciado el identity