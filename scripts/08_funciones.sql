---------------------------------------------------------------------------------
-- Tema     : Funciones en SQL Server 
-- Profesor : Jesús Canales
-- Curso    : Base de Datos A1 
---------------------------------------------------------------------------------
---<> Función de tabla en línea <>---
--- Retorna una tabla que es el resultado de una única instrucción SELECT

--- Crear base de datos dbEnrollmentStudent
USE MASTER
GO
IF DB_ID('dbFunctios') IS NOT NULL
	DROP DATABASE dbFunctios
GO
CREATE DATABASE dbFunctios
GO
USE dbFunctios
GO

--- Crear tabla Student 
CREATE TABLE student (
	id int IDENTITY(1,1), -- inserta un número entero por cada registro
	names VARCHAR(60) NOT NULL,
	last_names VARCHAR (90)NOT NULL,
	email VARCHAR(100) NOT NULL,
	register_date DATE DEFAULT (GETDATE()),-- fecha en que se registra
	birthday DATE, -- yyyy-mm-dd
	status CHAR(1) DEFAULT 'A', -- A activo | I inactivo
	PRIMARY KEY (id)
)
GO

--- Insertar registros en la tabla student */
SET DATEFORMAT dmy;
INSERT INTO student
	(names, last_names, email, birthday)
VALUES
	('Juana', 'Garro Montero', 'juana.garro@outlook.com', '10/05/1981'),
	('Gloria', 'Ramírez Godoy', 'gloria.ramirez@gmail.com', '19/07/1982'),
	('Tomás', 'Ávila Chumpitaz', 'tomas.avila@yahoo.com', '20/07/1980'),
	('Luisa', 'Ruíz Pérez', 'luisa.ruiz@gmail.com', '05/06/1990'),
	('Carla', 'Campos Poma', 'carla.campos@hotmail.com', '25/03/1992'),
	('Mario', 'Varela Paredes', 'mario.varela@yahoo.com', '20/06/1999'),
	('Gabriel', 'Martínez Ríos', 'gabriel.martinez@outlook.com', '10/03/2000'),
	('Hilario', 'Juárez Barrios', 'hilario.juarez@gmail.com', '02/01/2003'),
	('Rosario', 'Vargas Pérez', 'rosario.vargas@gmail.com', '01/10/1990'),
	('Oscar', 'Valerio Cárdenas', 'oscar.valerio@yahoo.com', '02/03/1995')
GO

--- Listar registros de tabla student
SELECT * FROM student;

--- Función para listar estudiantes en base al año de nacimiento
CREATE FUNCTION studens_year
(
	@year int
)
RETURNS TABLE
AS
	RETURN(
	SELECT s.names, s.last_names, s.email
	FROM student s
	WHERE YEAR(s.birthday) = @year
	);
GO

--- Probando la función de tabla en línea
SELECT * FROM studens_year( '2000');
SELECT * FROM studens_year( '1990');
SELECT * FROM studens_year( '1991');


---<> Función escalar <>---
--- Devuelve un único valor basado en los parámetros de entrada. 
CREATE FUNCTION contar_usuarios_correo
(
	@correo varchar(80)
)
RETURNS INT
AS
BEGIN
	DECLARE @total int
	SELECT @total = count(*)
	FROM student s
	WHERE s.email like '%' + @correo
	RETURN @total
END

SELECT dbo.contar_usuarios_correo('yahoo.com') AS total

DROP FUNCTION contar_usuarios_correo
