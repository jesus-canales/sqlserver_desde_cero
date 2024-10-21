/* Poner en uso dbE	nrollment */
USE dbEnrollment
GO

/* Insertar registros en la tabla student */
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

/* Insertar registros en la tabla seller */
SET DATEFORMAT dmy;
INSERT INTO seller
	(code, names, last_names, email, birthday, place, salary)
VALUES
	('S001', 'Dario', 'Solorzano Barrios', 'dario.solorzano@instituto.edu.pe', '20/04/1999', 'Arequipa', 2500),
	('S002', 'Camila', 'Barrios Pérez', 'camila.barrios@instituto.edu.pe', '25/12/2000', 'Lima', 2575),
	('S003', 'Luisa', 'Palomino Chumpitaz', 'luisa.palomino@instituto.edu.pe', '27/10/2002', 'Trujillo', 2800),
	('S004', 'María Fe', 'Vásquez Guerra', 'maria.vasquez@instituto.edu.pe', '17/06/1998', 'Piura', 2750),
	('S005', 'Eduardo Alberto', 'Manzo Vargas', 'eduardo.manzo@instituto.edu.pe', '25/11/1999', 'Lima', 2900)
GO

/* Insertar registros en la tabla teachers */
INSERT INTO teachers 
	(names, last_names, specialty, phone, email)
VALUES
	('Adrian', 'Chumpitaz Pérez', 'Tecnología', '997744123', 'adrian.chumpitaz@instituto.edu.pe'),
	('Zoila', 'Guerrero Paz', 'Administración', '974123658', 'zoila.guerrero@instituto.edu.pe'),
	('Marcos', 'Reyes Valenzuela', 'Marketing', '985214721', 'marcos.reyes@instituto.edu.pe'),
	('Camila', 'Ortíz Ramos', 'Comunicaciones', '925136847', 'camila.ortiz@instituto.edu.pe'),
	('Fabiola', 'Yupanqui Ríos', 'Tecnología ', '985147236', 'fabiola.yupanqui@instituto.edu.pe')
GO

/* Insertar registros en la tabla curso */
INSERT INTO course
	(code, names, credits)
VALUES
	('CO01', 'Algoritmos y estructuras de datos', 2),
	('CO02', 'Herramientas Ofimática', 1),
	('CO03', 'Base de Datos', 3),
	('CO04', 'Lenguaje de Programación I', 2),
	('CO05', 'Redacçión profesional', 2)
GO

/* Insertar registros en la tabla careers */
INSERT INTO careers
	(names, descriptions, durations)
VALUES
	('Administración de empresas', 'Abarca todas aquellas actividades relacionadas con el buen funcionamiento y aprovechamiento de los recursos (dinero, insumos, personas, tiempo, entre otros.) de la organización para generar valor para sus clientes y colaboradores.', 3),
	('Computación e Informática', 'es una carrera que te permite desarrollar sistemas de información multiplataforma para lograr soluciones integrales que contribuyan con el incremento de la productividad de las organizaciones, sobre la base del manejo de las tecnologías de la información y el desarrollo de competencias personales y laborales.', 3),
	('Publicidad y Branding', 'Administra procesos y recursos de comunicación publicitaria, para dar a conocer un producto o un servicio, posicionándolo en el mercado, a través de mensajes que lleguen al corazón de los consumidores.', 3),
	('Animación Digital', 'Se trata de realizar contenido audiovisual con propósitos educativos, comerciales o de entretenimiento, aplicando las herramientas de la edición de video, la post producción, la producción audiovisual, etc.', 3),
	('Gestión de Recursos Humano', 'abarca todas aquellas actividades relacionadas con la contratación, desarrollo de capacidades y potencial de los equipos, y la retención y crecimiento de los mismos.', 3)
GO

GO

/* Insertar registros en la tabla careers_detail */
INSERT INTO CAREERS_DETAIL
	(careers_id, course_code,teachers_id)
VALUES
	(1, 'CO05', 2),
	(1, 'CO02', 1),
	(2, 'CO01', 5),
	(2, 'CO02', 1),
	(3, 'CO05', 4)
GO

/* Insertar registros en la tabla campus */
INSERT INTO CAMPUS
	(code, name, direction, place)
VALUES
	('C001', 'Lima Centro', 'Av. Mariscal Oscar B. 3866-4070', 'Lima'),
	('C002', 'San Juan de Lurigancho', 'Av. Próceres de la Independencia 3023', 'Lima'),
	('C003', 'Arequipa', 'Av. Porongoche 500', 'Arequipa'),
	('C004', 'Trujillo', 'Av. del Ejército 889', 'Trujillo'),
	('C005', 'Piura', 'Calle Los Girasoles 466', 'Piura')
GO

/* Insertar registros en la tabla enrollment */
SET DATEFORMAT dmy;
INSERT INTO enrollment
	(student_id, seller_code, careers_id, campus_code, price, start_date)
VALUES
	(2, 'S001', 1, 'C002', 600, '01/03/2023'),
	(3, 'S001', 1, 'C002', 600, '01/03/2023'),
	(4, 'S001', 1, 'C002', 600, '01/03/2023'),
	(10, 'S002', 2, 'C001', 650, '15/03/2023'),
	(5, 'S004', 4, 'C003', 650, '10/12/2023')
GO

SELECT * FROM student;
SELECT * FROM seller;
SELECT * FROM teachers;
SELECT * FROM course;
SELECT * FROM campus;
SELECT * FROM careers;
SELECT * FROM careers_detail;
SELECT * FROM enrollment;