-- -----------------------------------------------------------------------------
-- Tema     : Data Manipulation Language (DML) - JOIN's 
-- Profesor : Jesús Canales
-- Curso    : Base de Datos A1 
--------------------------------------------------------------------------------
---<> Para tener en cuenta <>---
--- Permiten combinar datos relacionados de múltiples tablas.
--- Las declaraciones JOIN se pueden especificar en la cláusula FROM o WHERE.
--- Se recomienda especificarlas en la cláusula FROM.

---<> Tipos de JOIN's <>---
--- Inner Join (combinación interna)
--- Left outer JOIN, Right outer JOIN y Full outer JOIN (combinación externa)
--- Cross JOIN (combinación cruzada)

---<> Recursos para la clase <>---
--- Utilizaremos la base de datos Enrollment.
--- Diseño físico de la base de datos Enrollment: https://bit.ly/3sgWE2K  
--- Implementar script de estructura y datos de la base de datos.
--- Poner en uso Enrollment --> USE dbEnrollment;
--------------------------------------------------------------------------------
---<> Inner Join (combinación interna) <>---

-- 1. Listar registros de la tabla carrera_detalle (careers_detail)
SELECT * FROM careers_detail
GO

-- 2. Utilizando careers_detail, listar nombre, descripción, duración de la carrera
SELECT
	c.names as 'Carrera',
	c.descriptions as 'Descripción',
	c.durations as 'Duración (años)',
	cd.course_code as 'Código de curso',
	cd.teachers_id as 'Profesor del curso'
FROM CAREERS_DETAIL as cd
INNER JOIN careers c on cd.careers_id = c.id
GO

-- 3. Utilizando careers_detail, listar nombre de curso.
-- 4. Utilizando careers_detail, listar nombre carrera, curso y profesor
--------------------------------------------------------------------------------
---<> Left  Outer Join (combinación externa) <>---

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

-- 3. Listar sólo los estudiantes matriculados
--------------------------------------------------------------------------------
---<> Right Outer Join (combinación externa) <>---

-- 1. Listar las matrículas con datos de los vendedores o matriculadores
SELECT 
	* 
FROM enrollment e
RIGHT OUTER JOIN seller s
ON e.seller_code = s.code
GO

-- 2. Listar los matriculadores que han realizado matrículas
SELECT 
	DISTINCT s.* 
FROM enrollment e
RIGHT OUTER JOIN seller s
ON e.seller_code = s.code
WHERE e.seller_code is not null
GO

-- 3. Listar los matriculadores que no han realizado matrículas
--------------------------------------------------------------------------------
---<> Full Outer Join (combinación externa) <>---

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
---<> Cross Outer Join (combinación cruzada) <>---

-- 1. Combinaciones de todas las matrículas con todos los estudiantes
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