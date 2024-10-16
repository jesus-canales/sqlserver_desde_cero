/* Poner en uso BD Master */
USE master
GO

/* Crear base de datos dbCompuTech */
IF DB_ID (N'dbCompuTech') IS NOT NULL
	DROP DATABASE dbCompuTech
GO
CREATE DATABASE dbCompuTech
GO

/* Poner en uso base de datos dbCompuTech */
USE dbCompuTech
GO

/* Crear esquemas: PERSONA, PRODUCTO, VENTAS */
CREATE SCHEMA PERSONA
GO
CREATE SCHEMA PRODUCTO
GO
CREATE SCHEMA VENTAS
GO

/* Creamos tabla country desde el esquema persona */
CREATE TABLE PERSONA.country
(
	id int identity(100,1), 
	name_country varchar(80),
	CONSTRAINT pk_country PRIMARY KEY (id)
)
GO

/* Creamos tabla client desde el esquema persona */
CREATE TABLE PERSONA.client
(
	id int identity(1,1),
	names varchar(60),
	last_names varchar(90),
	email varchar(100),
	register_date date default getdate(),
	birthday date,
	country_id int,
	status char(1) default ('A'),
	CONSTRAINT client_pk PRIMARY KEY (id),
	CONSTRAINT email_unique UNIQUE (email),
	CONSTRAINT fk_cliente_country FOREIGN KEY (country_id)
	REFERENCES persona.country (id)
)
GO

/* Crear tabla product desde el esquema PRODUCTO */
CREATE TABLE PRODUCTO.product
(
	code char(3),
	description varchar(120),
	category varchar(90),
	stock int,
	price decimal(8,2),
	status char(1) default ('A'),
	CONSTRAINT product_pk PRIMARY KEY (code),
	CONSTRAINT stock_quantity CHECK(stock >0),
	CONSTRAINT price CHECK(price >0)
)
GO

/* Crear tabla sale desde el esquema VENTAS */
CREATE TABLE VENTAS.sale
(
	id int identity(1,1),
	register_date date default getdate(),
	client_id int,
	status char(1) default ('A'),
	CONSTRAINT sale_pk PRIMARY KEY (id)
)
GO

/* Crear tabla sale_detail desde el esquema VENTAS */
CREATE TABLE VENTAS.sale_detail
(
	id int identity(1,1),
	sale_id int,
	product_code char(3),
	quantity int,
	CONSTRAINT sale_detail_pk PRIMARY KEY (id),
	CONSTRAINT quantity CHECK(quantity > 0)
)
GO

/* Creamos relación entre tablas sale y client */
ALTER TABLE VENTAS.sale
	ADD CONSTRAINT sale_client FOREIGN KEY (client_id)
	REFERENCES PERSONA.client (id)
GO

/* Creamos relación entre tablas sale_detail y product */
ALTER TABLE VENTAS.sale_detail
	ADD CONSTRAINT sale_detail_product FOREIGN KEY (product_code)
	REFERENCES PRODUCTO.product (code)
GO

/* Creamos relación entre tablas sale y sale_detail */
ALTER TABLE VENTAS.sale_detail
	ADD CONSTRAINT sale_detail_sale FOREIGN KEY (sale_id)
	REFERENCES VENTAS.sale (id)
GO

/* Insertar registros en la tabla country */
INSERT INTO persona.country
	(name_country)
VALUES
	('Perú'), ('Colombia'), ('Chile'), ('Brasil'), ('Ecuador')
GO

/* Insertar registros en la tabla client */
SET DATEFORMAT dmy;
INSERT INTO persona.client
	(names, last_names, email, birthday, country_id)
VALUES
('Luisa', 'Ruíz Pérez', 'luisa.ruiz@gmail.com', '05/06/1990', 100),
('Carla', 'Campos Poma', 'carla.campos@hotmail.com', '25/03/1992', 102),
('Mario', 'Varela Paredes', 'mario.varela@yahoo.com', '20/06/1999', 101),
('Gabriel', 'Martínez Ríos', 'gabriel.martinez@outlook.com', '10/03/2000', 100),
('Hilario', 'Juárez Barrios', 'hilario.juarez@gmail.com', '02/01/2003', 102),
('Rosario', 'Vargas Pérez', 'rosario.vargas@gmail.com', '01/10/1990', 104),
('Oscar', 'Valerio Cárdenas', 'oscar.valerio@yahoo.com', '02/03/1995', 103),
('Fabiola', 'Yupanqui Ríos', 'fabiola.yupanqui@yahoo.com', '02/07/1999', 100),
('Fernando', 'Ruíz Pérez', 'fernando.ruiz@outlook.com', '12/09/2005', 102),
('Yolanda', 'Dávila Apolaya', 'yolanda.davila@gmail.com', '02/09/2003', 100),
('Carmen', 'Zavala Romero', 'carmen.zavala@yahoo.com', '06/06/2006', 102),
('Eduardo', 'Torres Sánchez', 'eduardo.torres@outlook.com', '10/05/1997', 103),
('Sofía', 'Humareda Julian', 'sofia.humareda@hotmail.com', '20/07/2001', 102),
('María', 'Soria Humareda', 'maria.soria@gmail.com', '12/11/2000', 101),
('Jonás', 'Bolaños Meza', 'jonas.bolanos@outlook.com', '20/05/2005', 100),
('Valeria', 'Tarazona Poma', 'valeria.tarazona@yahoo.com', '09/06/2006', 104),
('Gloria', 'Vasquez Iturrizaga', 'gloria.vasquez@yahoo.com', '07/04/2001', 100),
('Selene', 'Ancajima Araujo', 'selene.ancajima@outlook.com', '09/06/2006', 102),
('Máximo', 'Guerra Prieto', 'maximo.guerra@gmail.com', '02/08/2001', 102),
('Marlón', 'Huapaya Chumpitaz', 'marlon.huapaya@gmail.com', '03/10/2006', 100);

/* Listar los registros de clientes */
SELECT * FROM persona.client
GO

/* Creamos tabla client_actives desde el esquema persona */
CREATE TABLE PERSONA.client_active
(
	id int,
	names varchar(60),
	last_names varchar(90),
	email varchar(100),
	birthday date,
	status char(1) default ('A'),
	CONSTRAINT client_actives_pk PRIMARY KEY (id)
)
GO

/* Listar registros de tabla client_active */
SELECT * FROM persona.client_active
GO

/* Insertar registros en la tabla PRODUCTO */
INSERT INTO PRODUCTO.product
	(code, description, category, stock, price)
VALUES
	('P01', 'Adaptor | HUB USB', 'Accesorio', 60, 177),
	('P02', 'Soporte RAC', 'Accesorio', 30, 188.50),
	('P03', 'Impresora EPSON Workforce', 'Impresoras', 100, 1982.50),
	('P04', 'Impresora HP Deskjet', 'Impresoras', 200, 261.50),
	('P05', 'Impresora Fotográfica EPSON', 'Impresoras', 50, 2182.50),
	('P06', 'Ecran 120 Xtreme', 'Proyectores', 20, 338.50),
	('P07', 'Ecran 313 Xtreme', 'Proyectores', 40, 492.50)
GO

/* Listar registros de tabla client_active */
SELECT * FROM PRODUCTO.product
GO

/* Insertar registros en tabla sale (venta) */
INSERT INTO VENTAS.sale
	(client_id)
VALUES
	(9), (2), (6), (13), (10)
GO

/* Crear tabla product desde el esquema PRODUCTO */
CREATE TABLE PRODUCTO.inventory
(
	id int identity(100, 1),
	description varchar(120),
	category varchar(90),
	stock int,
	price decimal(8,2),
	status char(1) default ('A'),
	CONSTRAINT inventory_pk PRIMARY KEY (id),
)
GO

/* Insertar registros en la tabla inventory */
INSERT INTO PRODUCTO.inventory
	(description, category, stock, price)
VALUES
	('Adaptor | HUB USB', 'Accesorio', 60, 177),
	('Soporte RAC', 'Accesorio', 30, 188.50),
	('Impresora EPSON Workforce', 'Impresoras', 100, 1982.50),
	('Impresora HP Deskjet', 'Impresoras', 200, 261.50),
	('Impresora Fotográfica EPSON', 'Impresoras', 50, 2182.50),
	('Ecran 120 Xtreme', 'Proyectores', 20, 338.50),
	('Ecran 313 Xtreme', 'Proyectores', 40, 492.50)
GO

/* Listar registros de tabla inventory */
SELECT * FROM PRODUCTO.inventory
GO