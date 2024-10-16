
/* Crear base de datos con valores predeterminados SalesTechNet */
CREATE DATABASE dbSalestechNet
GO

/* Listar base de datos del server local */
SELECT name, database_id, create_date  
FROM sys.databases;  
GO

/* Poner en uso base de datos dbSalesTechNet */
USE dbSalestechNet
GO

/* Crear esquema llamado Ventas */
CREATE SCHEMA Ventas
GO

/* Crear esquema llamado RRHH */
CREATE SCHEMA RRHH
GO

/* Listar esquemas de base de datos */
SELECT * FROM sys.schemas;
GO

/* Procedemos a crear una tabla Cliente con los campos: DNI, Nombres y Apellidos */
CREATE TABLE TBCLIENTE
(
	DNI char(8),
	NOMBRES varchar(60),
	APELLIDOS varchar(90)
)
GO

/* Listar las tablas de la base de datos */
SELECT * FROM sys.tables ---veremos que el schema_id = 1 que es el esquema dbo

/* Transferir la tabla Cliente al esquema Venta */
ALTER SCHEMA Ventas
TRANSFER dbo.TBCLIENTE
GO

/* Crear una tabla Producto con los campos: Codigo, Descripción y Precio */
/* Transferir la tabla Producto al esquema Ventas */

/* Crear una tabla Vendedor con los campos: DNI, Nombres, Apellidos y Cargo */
/* Transferir la tabla Producto al esquema RRHH */

/*** Tipos de Datos de Usuario ***/

-- Listar los tipos de datos de SQL Server Local
SELECT NAME FROM systypes;

/* Crear tipo de usuario con Procedimiento Almacenado */
SP_ADDTYPE fono, 'char(9)', 'NULL'
GO

-- Crear tipo de dato SEXO (1 caracter)
-- Crear tipo de dato DNI (8 caracter)
-- Crear tipo de dato PRECIO (decimal 8,2)

/* Crear tipos de usuario con CREATE TYPE */
CREATE TYPE SUELDO FROM decimal(8,2) NOT NULL
GO

-- Crear tipo de dato FNACIMIENTO (date)
CREATE TYPE FNACIMIENTO FROM DATE NOT NULL
GO

-- Crear tipo de dato STOCK (int)

/* Eliminar tipos de datos de usuario */
SP_DROPTYPE SUELDO --- Utilizando procedimiento almacenado
GO

DROP TYPE FNACIMIENTO -- Utilizando DROP TYPE
GO

/*** Tipos de Tablas ***/
-- Tablas temporales locales
CREATE TABLE #TBTPRODUCTOS
(
	ID int,
	PRODUCTO varchar(60),
	DESCRIPCION varchar(100)
)
GO
--- Solo se ejecuta en la sesión que fue creada
SELECT * FROM #TBTPRODUCTOS
GO

-- Tablas temporales globales
CREATE TABLE ##CATEGORIAS
(
	CODIGO char(3),
	NOMBRE varchar(20),
	DESCRIPCION varchar(100)
)
GO

--- Estarán disponibles en todas las sesiones abiertas 
SELECT * FROM ##CATEGORIAS
GO

-- Variable tipos tabla (se tiene que ejecutar en bloque)
DECLARE @TBCOLABORADOR TABLE
(
	CODIGO char(5),
	NOMBRES varchar(60),
	APELLIDOS varchar(100)
)
SELECT * FROM @TBCOLABORADOR
GO

-- Tablas Físicas
CREATE TABLE TBPROVEEDOR
(
	RUC char(11),
	RAZ_SOCIAL varchar(100),
	UBIGEO char(6)
)
GO

SELECT * FROM TBPROVEEDOR
GO

-- Creamos un filegroup y le asociamos a un archivo físico
ALTER DATABASE dbSalestechNet
ADD FILEGROUP VENTAS2023
GO

--- Verificamos la creación del filgroup
SELECT * FROM sys.filegroups

--- Asociamos un nuevo archivo físico
ALTER DATABASE dbSalestechNet
ADD FILE
(
	NAME = 'data_ventas_2023', 
	--FILENAME = 'c:\DATA\data_ventas_2023.ndf',
	FILENAME = '/var/opt/mssql/data/data_ventas_2023.ndf',
	SIZE = 100MB
)
TO FILEGROUP VENTAS2023
GO

--- Verificamos la asociación de archivo físico creado
SELECT * FROM sys.database_files
GO

-- Creamos un filegroup y le asociamos a un archivo físico
ALTER DATABASE dbSalestechNet
ADD FILEGROUP VENTAS2024
GO
ALTER DATABASE dbSalestechNet
ADD FILE
(
	NAME = 'data_ventas_2024', 
	---FILENAME = 'c:\DATA\data_ventas_2024.ndf',
	FILENAME = '/var/opt/mssql/data/data_ventas_2024.ndf',
	SIZE = 100MB
)
TO FILEGROUP VENTAS2024
GO

-- Creamos un filegroup y le asociamos a un archivo físico
ALTER DATABASE dbSalestechNet
ADD FILEGROUP VENTAS2025
GO
ALTER DATABASE dbSalestechNet
ADD FILE
(
	NAME = 'data_ventas_2025', 
	---FILENAME = 'c:\DATA\data_ventas_2025.ndf',
	FILENAME = '/var/opt/mssql/data/data_ventas_2025.ndf',
	SIZE = 100MB
)
TO FILEGROUP VENTAS2025
GO


-- Función de partición
CREATE PARTITION FUNCTION fnpNumerador(int)
AS RANGE LEFT
FOR VALUES(50, 200)
GO

-- Crear esquema de partición
CREATE PARTITION SCHEME scpIdentificador
AS PARTITION fnpNumerador
TO('VENTAS2023','VENTAS2024', 'VENTAS2025')
GO

-- Creamos la tabla Particionada
CREATE TABLE VENTA
(
	ID int,
	CODCLIENTE char(4),
	CODVENDEDOR char(4),
	FECVENTA date
) ON scpIdentificador(ID)
GO

-- Insertamos los primeros registros
SET DATEFORMAT dmy
INSERT INTO VENTA
VALUES
(10, 'C001', 'V001', '10/05/2023'),
(60, 'C003', 'V005', '20/05/2024'),
(250, 'C007', 'V002', '10/05/2025')
GO

-- Verificando que los registros hayan ingresado en su partición respectiva
SELECT * , $PARTITION.fnpNumerador(id) AS 'NUMERO PARTICIÓN'
FROM VENTA
GO

-- Insertando más registros de prueba
SET DATEFORMAT dmy
INSERT INTO VENTA
VALUES
(25, 'C001', 'V001', '10/05/2023'),
(115, 'C003', 'V005', '20/05/2024'),
(300, 'C007', 'V002', '10/05/2025')
GO