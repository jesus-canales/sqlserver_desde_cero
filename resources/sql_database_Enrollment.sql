/* Poner en uso BD Master */
USE master
GO

/* Crear base de datos dbEnrollmentStudent */
IF DB_ID (N'dbEnrollment') IS NOT NULL
	DROP DATABASE dbEnrollment
GO
CREATE DATABASE dbEnrollment
GO

/* Poner en uso base de datos dbMatriculas */
USE dbEnrollment
GO

----<>TABLAS

/* 01 Tabla student (estudiante) */
CREATE TABLE student
(
	id int identity(1,1), --clave principal
	names varchar(60), --nombres
	last_names varchar(90), --apellidos
	email varchar(100), --correo electrónico
	register_date date default getdate(), --fecha de registro
	birthday date, --fecha de cumpleaños
	status char(1) default ('A'), --estado
	CONSTRAINT client_pk PRIMARY KEY (id),
	CONSTRAINT email_unique UNIQUE (email)
)
GO

/* 02 Crear tabla teachers */
CREATE TABLE TEACHERS
(
	id int identity(1,1),
	register_date date default getdate(),
	names varchar(70),
	last_names varchar(150),
	specialty varchar(120),
	phone char(9),
	email varchar(120),
	status char(1) default 'A'
	CONSTRAINT teachers_pk PRIMARY KEY (id)
)
GO

/* 03 Crear tabla seller (vendedor) */
CREATE TABLE seller
(
	code char(4),
	names varchar(70),
	last_names varchar(120),
	email varchar(90),
	birthday date,
	place varchar(150),
	salary decimal(8,2) default 'Lima',
	status char(1) default 'A',
	CONSTRAINT seller_pk PRIMARY KEY (code)
)
GO

/* 04 Crear tabla campus (sede) */
CREATE TABLE CAMPUS
(
	code char(4),
	register_date date default getdate(),
	name varchar(100),
	direction varchar(150),
	place varchar(150),
	status char(1) default 'A'
	CONSTRAINT campus_pk PRIMARY KEY (code)
)
GO

/* 05 Crear tabla course (curso) */
CREATE TABLE course
(
	code char(4),
	names varchar(100),
	credits int,
	status char(1) default 'A',
	CONSTRAINT course_pk PRIMARY KEY (code)
)
GO

/* 06 Tabla careers (carreras) */
CREATE TABLE careers
(
	id int identity(1,1), --clave principal
	names varchar(90), --nombre de carrera
	descriptions varchar(2500), --breve descripción de carrera
	durations int, --número de ciclos de duración
	register_date date default getdate(), --fecha de registro de carrera
	status char(1) default ('A'), --estado
	CONSTRAINT careers_pk PRIMARY KEY (id)
)
GO

/* 07 Crear tabla careers detail */
CREATE TABLE CAREERS_DETAIL
(
	id int identity(1,1),
	careers_id int,
	course_code char(4),
	teachers_id int
)
GO

/* 08 Crear tabla enrollment */
CREATE TABLE ENROLLMENT
(
	id int identity(1,1),
	register_date date default getdate(),
	student_id int,
	seller_code char(4),
	careers_id int,
	campus_code char(4),
	price decimal(8,2),
	start_date date,
	status char(1) default ('A')
	CONSTRAINT enrollment_pk PRIMARY KEY (id)
)
GO

----<>RESTRICCIONES


----<>RELACIONES

--- 1. Un curso puede llevarse o dictarse en una o varias carreras
ALTER TABLE careers_detail
	ADD CONSTRAINT careers_detail_course FOREIGN KEY (course_code)
	REFERENCES course (code)
GO

--- 2. Un profesor puede dictar uno o muchos cursos en una carrera
ALTER TABLE careers_detail
	ADD CONSTRAINT careers_detail_teacher FOREIGN KEY (teachers_id)
	REFERENCES teachers (id)
GO

--- 3. Una carrera puede tener uno o muchos detalles
ALTER TABLE careers_detail
	ADD CONSTRAINT careers_careers_detail FOREIGN KEY (careers_id)
	REFERENCES careers (id)
GO

--- 4. Un estudiante puede matricularse en una o mucas carreras
ALTER TABLE enrollment
	ADD CONSTRAINT enrollment_student FOREIGN KEY (student_id)
	REFERENCES student (id)
GO

--- 5. Un vendedor o matriculador puede registrar una o muchas matrículas
ALTER TABLE enrollment
	ADD CONSTRAINT enrollment_seller FOREIGN KEY (seller_code)
	REFERENCES seller (code)
GO

--- 6. Una carrera se puede registrar en una o muchas matrículas
ALTER TABLE enrollment
	ADD CONSTRAINT enrollment_careers FOREIGN KEY (careers_id)
	REFERENCES careers (id)
GO

--- 7. Una sede puede ser considerada en una o muchas matrículas
ALTER TABLE enrollment
	ADD CONSTRAINT enrollment_campus FOREIGN KEY (campus_code)
	REFERENCES campus (code)
GO
