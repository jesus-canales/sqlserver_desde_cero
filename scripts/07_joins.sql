-- -----------------------------------------------------------------------------
-- Tema     : Data Manipulation Language (DML) - JOIN's 
-- Profesor : Jes�s Canales
-- Curso    : Base de Datos A1 
--------------------------------------------------------------------------------
---<> Para tener en cuenta <>---
--- Permiten combinar datos relacionados de m�ltiples tablas.
--- Las declaraciones JOIN se pueden especificar en la cl�usula FROM o WHERE.
--- Se recomienda especificarlas en la cl�usula FROM.

---<> Tipos de JOIN's <>---
--- Inner Join (combinaci�n interna)
--- Left outer JOIN, Right outer JOIN y Full outer JOIN (combinaci�n externa)
--- Cross JOIN (combinaci�n cruzada)

---<> Recursos para la clase <>---
--- Utilizaremos la base de datos Enrollment.
--- Dise�o f�sico de la base de datos Enrollment: https://bit.ly/3sgWE2K  
--- Implementar script de estructura y datos de la base de datos.
--- Poner en uso Enrollment --> USE dbEnrollment;
--------------------------------------------------------------------------------
---<> Inner Join (combinaci�n interna) <>---

-- 1. Listar registros de la tabla carrera_detalle (careers_detail)
SELECT * FROM careers_detail
GO

-- 2. Utilizando careers_detail, listar nombre, descripci�n, duraci�n de la carrera
SELECT
	c.names as 'Carrera',
	c.descriptions as 'Descripci�n',
	c.durations as 'Duraci�n (a�os)',
	cd.course_code as 'C�digo de curso',
	cd.teachers_id as 'Profesor del curso'
FROM CAREERS_DETAIL as cd
INNER JOIN careers c on cd.careers_id = c.id
GO

-- 3. Utilizando careers_detail, listar nombre de curso.
-- 4. Utilizando careers_detail, listar nombre carrera, curso y profesor
--------------------------------------------------------------------------------
---<> Left  Outer Join (combinaci�n externa) <>---

-- 1. Listar estudiantes matriculados y no matriculados
SELECT 
	* 
FROM student s
LEFT OUTER JOIN enrollment e
ON s.id =e.student_id
GO

-- 2. Listar estudiantes no matriculados
SELECT 
	* 
FROM student s
LEFT OUTER JOIN enrollment e
ON s.id =e.student_id
WHERE e.student_id is null
GO

-- 3. Listar s�lo los estudiantes matriculados
--------------------------------------------------------------------------------
---<> Right Outer Join (combinaci�n externa) <>---

-- 1. Listar las matr�culas con datos de los vendedores o matriculadores
SELECT 
	* 
FROM enrollment e
RIGHT OUTER JOIN seller s
ON e.seller_code = s.code
GO

-- 2. Listar los matriculadores que han realizado matr�culas
SELECT 
	DISTINCT s.* 
FROM enrollment e
RIGHT OUTER JOIN seller s
ON e.seller_code = s.code
WHERE e.seller_code is not null
GO

-- 3. Listar los matriculadores que no han realizado matr�culas
--------------------------------------------------------------------------------
---<> Full Outer Join (combinaci�n externa) <>---

-- 1. Une los registros de ambas tablas mencionadas (left y right todo en uno)
SELECT 
	* 
FROM student s
LEFT OUTER JOIN enrollment e ON s.id =e.student_id
GO

SELECT 
	* 
FROM student s
RIGHT OUTER JOIN enrollment e ON s.id =e.student_id
GO

SELECT 
	* 
FROM student s
FULL OUTER JOIN enrollment e ON s.id =e.student_id
GO
--------------------------------------------------------------------------------
---<> Cross Outer Join (combinaci�n cruzada) <>---

-- 1. Combinaciones de todas las matr�culas con todos los estudiantes
SELECT 
	*
FROM enrollment e
CROSS JOIN student s
GO

-- 2. Combinaciones de los detalles de carrera con los cursos existentes
SELECT 
	*
FROM CAREERS_DETAIL cd
CROSS JOIN course c
GO





--------------------------------------------------------------------------------
---<> UNION <>---

-- 1. Listar vendedores, profesores y estudiantes
SELECT 
	CONCAT(last_names, ', ', names) as 'Apellidos y Nombres',
	'Vendedor' as 'Tipo'
FROM seller
UNION
SELECT 
	CONCAT(last_names, ', ', names) as 'Apellidos y Nombres',
	'Profesor' as 'Tipo'
FROM teachers
UNION
SELECT
	CONCAT(last_names, ', ', names) AS 'Apellidos y Nombres',
	'Estudiante' as 'Tipo'
FROM student
ORDER BY 'Tipo'
GO

-- 2. Listar cantidad de vendedores, profesores y estudiantes
SELECT 
	'Vendedor' as 'Tipo',
	COUNT(*) AS 'Total'
FROM seller
UNION
SELECT 
	'Profesor' as 'Tipo',
	COUNT(*)
FROM teachers
UNION
SELECT
	'Estudiante' as 'Tipo',
	COUNT(*)
FROM student
ORDER BY 'Tipo'
GO