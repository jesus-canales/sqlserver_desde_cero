-- ----------------------------------------------------------------------------------
-- Tema		: Procedimientos Almacenados - STORE PROCEDURES
-- Profesor : Jesús Canales
-- Curso    : Base de Datos 2 
-- ----------------------------------------------------------------------------------

--- <> ¿Qué son los Procedimientos almacenados (SP)?
--- Es una rutina que puede aceptar parámetros de entrada
--- Permite realizar acciones y devolver el estado de éxito y los parámetros de salida.

--- <> Ventajas
--- Reducir el tiempo de ejecución
--- El tráfico de red 
--- Permite la modularidad
--- Mejorar la seguridad de la base de datos (prevenir inyección SQL)

-- Poner en uso BD Master
USE master
GO

-- Crear base de datos dbPersons
IF DB_ID (N'dbPersons') IS NOT NULL
	DROP DATABASE dbPersons
GO
CREATE DATABASE dbPersons
GO

USE dbPersons
GO

-- Creamos la tabla Person
DROP TABLE IF EXISTS person
CREATE TABLE person
(
	id int identity(1, 1), -- identificador principal
	names varchar(80), -- nombres
	last_names varchar(150), -- apellidos
	birthday date, -- fecha de nacimiento
	email varchar(100), -- correo electrónico
	status char(1) default ('A') -- estado de registro, por default es A
	CONSTRAINT person_pk PRIMARY KEY (id) -- asignación de clave principal
)
GO

-- Inserción de registro
SET DATEFORMAT dmy;
INSERT INTO person 
	(names, last_names, birthday, email)
VALUES
	('Jesús', 'Canales Guando', '11/07/1980', 'jesuscanales@outlook.com'),
	('Ysabel', 'Rodríguez Cáceres', '17/10/1980', 'ysabel.rodriguez@gmail.com')
GO

-- Listamos registros activos
SELECT 
	p.names As 'Nombres',
	p.last_names AS 'Apellidos',
	FORMAT(p.birthday, 'dd/MM/yyyy', 'es-es') AS 'Fecha Nacimiento'
FROM person p
WHERE p.status = 'A'
GO
SELECT * FROM person
-- Editamos registro
SET DATEFORMAT dmy;
UPDATE person 
	SET 
		names = 'Fernando', 
		last_names = 'Canales Rodríguez',
		birthday = '03/05/1990'
	WHERE
		id = 2
GO

-- Eliminamos registro (eliminado lógico)
UPDATE person 
	SET 
		status = 'I'
	WHERE
		id = 2
GO
--- <> Procedimientos almacenados para un CRUD

-- Procedimiento almacenado para insertar registro
DROP PROCEDURE IF EXISTS insertar_person
GO 
CREATE PROCEDURE insertar_person (
	-- Definimos los parámetros para el procedimiento almacenado
	@nombres varchar(90), 
	@apellidos varchar(150),
	@fecha_nacimiento date,
	@correo varchar(100)
)
AS
BEGIN
	BEGIN TRY
		-- Validamos que todas la variables contengan datos
		IF @nombres IS NULL OR @apellidos IS NULL OR @fecha_nacimiento IS NULL OR @correo IS NULL
		BEGIN
            RAISERROR('Todos los datos de los campos son obligatorios.', 16, 1);
            RETURN;
        END
		-- Si todas las variables tienen datos procedemos a insertarlas
		INSERT INTO person (names, last_names, birthday, email)
		VALUES (@nombres, @apellidos, @fecha_nacimiento, @correo)
		-- Listamos el registro ingresado e imprimimos mensaje de confirmación
		SELECT 
			 p.id AS 'Identificador',
			 p.names AS 'Nombres',
			 p.last_names AS 'Apellidos',
			 FORMAT(p.birthday, 'dd/MM/yyyy', 'es-es') AS 'Fecha Nacimiento'
		FROM person p
		WHERE p.status = 'A' and p.id = (SELECT MAX(id) FROM person p)
		PRINT 'Los datos han sido ingresados correctamente.'
	END TRY
	-- Manejo de error si algún dato es ingresado erróneamente
	BEGIN CATCH
        PRINT 'Error al insertar los datos de la persona.';
        PRINT ERROR_MESSAGE();
    END CATCH
END

-- Insertando registro desde procedimiento almacenado
SET DATEFORMAT dmy;
EXEC insertar_person 
	@nombres = 'Lucia Manuela', 
	@apellidos = 'Chumpitaz Rodríguez', 
	@fecha_nacimiento = '25/11/1982', 
	@correo = 'lucia.chumpitaz@gmail.com';
GO

-- Procedimiento almacenado para editar registro
DROP PROCEDURE IF EXISTS editar_person
GO 
CREATE PROCEDURE editar_person (
	-- Definimos parámetros obligatorios y opcionales
	@identificador int, --2
	@nombres varchar(90) = null, 
	@apellidos varchar(150) = null,
	@fecha_nacimiento date = null,
	@correo varchar(100) = null
)
AS
BEGIN
	BEGIN TRY
		-- Validamos si el id ingresado pertence a algún registro de la tabla
		DECLARE @person_existe INT;
		SELECT @person_existe = COUNT(*)
		FROM person p
		WHERE p.id = @identificador;
		IF @person_existe = 0
		BEGIN 
            RAISERROR(N'El identificador no existe en la tabla', 16, 1);
			RETURN;
		END
		-- Procedemos a la actualización de datos en base a los parámetros ingresados
		BEGIN TRANSACTION
			UPDATE person 
			 SET 
				names = ISNULL(@nombres, names),
				last_names = ISNULL(@apellidos, last_names),
				birthday = ISNULL(@fecha_nacimiento, birthday),
				email = ISNULL(@correo, email)
			WHERE id = @identificador;
			-- Listamos el registro que se ha actualizado
			SELECT 
				 p.id AS 'Identificador',
				 p.names AS 'Nombres',
				 p.last_names AS 'Apellidos',
				 p.email AS 'Correo',
				 FORMAT(p.birthday, 'dd/MM/yyyy', 'es-es') AS 'Fecha Nacimiento'
			FROM person p
			WHERE p.id = @identificador;
		COMMIT TRANSACTION;
	END TRY
	-- Manejo de error al ingresar un dato erróneo al actualizar datos
	BEGIN CATCH
		ROLLBACK TRANSACTION;
		PRINT 'Se produjo un error al actualizar datos de la persona';
		PRINT ERROR_MESSAGE();
	END CATCH
END
GO

-- Editando algunos datos de un registro de la tabla person
EXEC editar_person 
	@identificador = 3, --dato obligatorio 
	@correo = 'juan.guerra@vallegrande.edu.pe'

-- Editar registro: @identificador, @nombres, @apellidos, @fecha_nacimiento, @correo
EXEC editar_person 
	@identificador = 2,
	@nombres = 'Oscar',
	@apellidos = 'Ávila Reyes',
	@fecha_nacimiento = '06/06/1996',
	@correo = 'oscar.avila@outlook.com';
GO

-- Listar registros activos O inactivos
DROP PROCEDURE IF EXISTS listar_registros
GO
CREATE PROCEDURE listar_registros
(
	@estado char(1)
)
AS
BEGIN
	-- Listar registros dependediendo el valor del estado
	SELECT 
	p.id AS 'Identificador',
	p.names AS 'Nombres',
	p.last_names AS 'Apellidos',
	FORMAT(p.birthday, 'dd/MM/yyyy', 'es-es') AS 'Fecha Nacimiento'
	FROM person p
	WHERE p.status = @estado
END
GO

-- 
EXEC listar_registros @estado = 'A';
EXEC listar_registros @estado = 'I';

-- Procedimiento almacenado para cambiar de estado un registro
DROP PROCEDURE IF EXISTS estado_person
GO
CREATE PROCEDURE estado_person
(
	@identificador int,
	@nuevo_estado char(1)
)
AS
BEGIN
	BEGIN TRY
		-- Validamos si existe o no el id de la persona
		IF NOT EXISTS (SELECT 1 FROM person p WHERE P.id = @identificador)
		BEGIN
			RAISERROR('El id proporcionado no existe en la tabla.', 16, 1);
			RETURN;
		END
		-- Procedemos a la actualización del estado
		UPDATE person
			SET status = @nuevo_estado 
		WHERE 
			id = @identificador

		IF @nuevo_estado = 'A'
			BEGIN
				PRINT 'Se ha activado correctamente a la persona'
			END
		ELSE IF @nuevo_estado = 'I'
			BEGIN
				PRINT 'Se ha desactivado correctamente a la persona'
			END
		-- Listamos el registro que ha cambiado de estado
		SELECT * FROM person p WHERE p.id = @identificador;
	END TRY
	-- Manejo de error 
	BEGIN CATCH
		PRINT 'Se ha producido un error al momento de cambiar de estado a la persona';
		PRINT ERROR_MESSAGE();
	END CATCH
END
GO

-- Cambiar el estado A o I de una persona
SELECT * FROM person p;
EXEC estado_person @identificador = 1, @nuevo_estado = 'I';
EXEC estado_person @identificador = 2, @nuevo_estado = 'A';

-- Listar los procedimientos almacenados que hemos creado
SELECT name FROM sys.procedures
WHERE type_desc = 'SQL_STORED_PROCEDURE';

-- Procedimiento almacenado para centrarlizar operaciones CRUD
DROP PROCEDURE IF EXISTS gestion_person
GO
CREATE PROCEDURE gestion_person
(
	-- Declaramos variables
	@operacion char(1),
	@identificador int = null,
	@estado char(1) = null,
	@nuevo_estado char(1) = null,
	@nombres varchar(90) = null, 
	@apellidos varchar(150) = null,
	@fecha_nacimiento date = null,
	@correo varchar(100) = null
)
AS
BEGIN
	BEGIN TRY
	-- Operación de inserción
	IF @operacion = 'C' -- CREATE
	BEGIN
		EXEC insertar_person 
			@nombres, 
			@apellidos, 
			@fecha_nacimiento, 
			@correo;
	END
	-- Operación de listado de registros
	ELSE IF @operacion = 'R' -- READ
	BEGIN
		EXEC listar_registros @estado
	END
	-- Operación de edición de datos de registro
	ELSE IF @operacion = 'U' -- UPDATE
	BEGIN
		EXEC editar_person 
				@identificador,
				@nombres,
				@apellidos,
				@fecha_nacimiento,
				@correo;
	END
	-- Operación de eliminado lógico de registro
	ELSE IF @operacion = 'D' -- DELETE (LOGICO)
	BEGIN
		EXEC estado_person
				@identificador, 
				@nuevo_estado = 'I';
	END
	-- Operación de activación o restauración de registro
	ELSE IF @operacion = 'A' -- atrás o recuperar
	BEGIN
		EXEC estado_person
				@identificador, 
				@nuevo_estado = 'A';
	END
	ELSE
        BEGIN
         RAISERROR('Operación no válida.', 16, 1);
        END
	END TRY
	-- Manejo de error
    BEGIN CATCH
        PRINT 'Error al procesar la operación. Intente con una operación válida (C para insertar, R para listar, U para editar, D para eliminar y A para recuperar registro inactivo).';
        PRINT ERROR_MESSAGE();
    END CATCH
END 
GO

-- Probando Inserción
SET DATEFORMAT dmy;
EXEC gestion_person 
	@operacion = 'C', 
	@nombres = 'Fernando', 
	@apellidos = 'Canales Rodríguez', 
	@fecha_nacimiento = '17/09/2010', 
	@correo = 'pablo.canales@gmail.com';

-- Listar registros
EXEC gestion_person @operacion = 'R', @estado = 'A';  -- Listar los activos
EXEC gestion_person @operacion = 'R', @estado = 'I';  -- Listar los inactivos

-- Editar registros
EXEC gestion_person 
		@operacion = 'U',
		@identificador = 3, 
		@correo = 'nuevo.correo@vallegrande.edu.pe';

-- Editar registro: @identificador, @nombres, @apellidos, @fecha_nacimiento, @correo
EXEC gestion_person 
	@operacion = 'U', 
	@identificador = 6,
	@nombres = 'Soy el nuevo',
	@apellidos = 'Chanca Guerra',
	@fecha_nacimiento = '07/07/1997',
	@correo = 'nuevo.usuario@outlook.com';
GO

-- Eliminar registro a través de ID
EXEC gestion_person 
		@operacion = 'D',
		@identificador = 4;

-- Restaurar un registro eliminado a través de ID
EXEC gestion_person 
		@operacion = 'H',
		@identificador = 7;


