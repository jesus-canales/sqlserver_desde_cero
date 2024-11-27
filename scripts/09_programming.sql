---------------------------------------------------------------------------------
-- Tema     : Programación con SQL 
-- Profesor : Jesús Canales
-- Curso    : Base de Datos  
---------------------------------------------------------------------------------
---<> Variables <>---
-- Entidad a la que se asigna un valor y que puede cambiar durante el proceso.
-- Sintaxis:
--	  DECLARE @name_variable <datatype>
--	  SET @name_variable = <value initial>

--- 1. Imprimir un mensaje
DECLARE @mensaje varchar(100)
SET @mensaje = 'Hola mundo...'
PRINT @mensaje
GO

--- 2. Sumar números
DECLARE @numero_uno int = 30, @numero_dos int = 70, @suma int
SET @suma = @numero_uno + @numero_dos
PRINT 'El valor de la sumatoria es: ' + convert(char(3), @suma)
GO
---------------------------------------------------------------------------------
--- 3. Concatenar cadenas de texto
DECLARE @nombre varchar(60), @apellido varchar(90)
SET @nombre = 'Julián'
SET @apellido = 'Poma Reyes'
PRINT 'Persona: ' + UPPER(@apellido) + ', ' + @nombre

--- 4. Calcular edad a partir de una fecha de nacimiento
SET DATEFORMAT dmy;
DECLARE @fecha_nacimiento date, @edad int
SET @fecha_nacimiento = '06/06/2006'
SET @edad = DATEDIFF(year, @fecha_nacimiento, getdate())
PRINT 'Tu edad es: ' + convert(char(2), @edad)

--- 5. Calcular total para factura
DECLARE @monto decimal(8,2) = 1000, @igv decimal(8,2), @total decimal(8,2)
SET @igv = @monto * 0.18
SET @total = @monto + @igv
PRINT 'El monto es: ' + 'S/. ' + convert(char(10), @monto)
PRINT 'El IGV es: ' + 'S/. ' + convert(char(10), @igv)
PRINT 'El total es: ' + 'S/. ' + convert(char(10), @total)

---------------------------------------------------------------------------------
---<> Recursos para la clase <>---
--- Utilizaremos la base de datos Enrollment.
--- Diseño físico de la base de datos Enrollment: https://bit.ly/3sgWE2K  
--- Implementar script de estructura y datos de la base de datos.
--- Poner en uso Enrollment --> USE dbEnrollment;

--- 1. Obtener datos de profesor a partir de su id
SET DATEFORMAT dmy;
DECLARE @id int, @fecha_registro date, @nombres varchar(60), @apellidos varchar(100)
DECLARE @especialidad varchar(90), @celular char(9), @correo varchar(100)
SET @id = 1
SELECT 
	@fecha_registro =  register_date,
	@nombres = names,
	@apellidos = last_names,
	@especialidad = specialty,
	@celular = phone,
	@correo = email
FROM teachers 
WHERE id = @id
PRINT 'Se registró el: ' + convert(varchar(10), @fecha_registro)
PRINT 'Apellidos y nombres: ' + concat(upper(@apellidos), ', ', @nombres)
PRINT 'Especialidad: ' + @especialidad
PRINT 'Celular: ' + @celular
PRINT 'Correo electrónico: ' + @correo
GO

--------------------------------------------------------------------------------
--- 2. A partir de id de carrera obtener nombre de carrera y cursos respectivos
DECLARE @id_career int = 2
SELECT TOP 1
	ca.names AS 'Item',
	'Carrera Profesional' AS 'Tipo'
FROM careers_detail cd
INNER JOIN careers ca
ON cd.careers_id = ca.id
INNER JOIN course c
ON cd.course_code = c.code
WHERE ca.id = @id_career
UNION
SELECT 
	c.names AS 'Curso',
	'Curso' AS 'Tipo'
FROM careers_detail cd
INNER JOIN careers ca
ON cd.careers_id = ca.id
INNER JOIN course c
ON cd.course_code = c.code
WHERE ca.id = @id_career
ORDER BY Tipo
GO
--------------------------------------------------------------------------------
---<> Estructura Condicional IF <>---

---   Utilice IF tal como lo haría en cualquier otro lenguaje de programación para 
---   ejecutar una declaración o un grupo de declaraciones basadas en una expresión      
--    que debe evaluarse como VERDADERO o FALSO.

--- Sintaxis:
--- IF <condition> 
---		BEGIN
---			<statement1>
---			<statement2>
---		END
--- ELSE
---		BEGIN
---			<statement1>
---			<statement2>
---		END


--------------------------------------------------------------------------------
-- 1. Devolver si es mayor o menor de edad en base a la fecha de nacimiento
SET DATEFORMAT dmy;
DECLARE @fecha_nacimiento date, @edad int
SET @fecha_nacimiento = '11/12/1979'
SET @edad = DATEDIFF(year, @fecha_nacimiento, getdate())
IF @edad >= 18 
	BEGIN
		PRINT 'Tu edad es: ' + convert(char(2), @edad)
		PRINT 'Eres mayor de edad'
	END
ELSE
	BEGIN
		PRINT 'Tu edad es: ' + convert(char(2), @edad)
		PRINT 'Eres menor de edad'
	END
GO

-- 2. Ingresa una nota y devuelve si es aprobatoria o desaprobatoria
-- 3. Ingrese dos números y devuelve el mayor de ellos
--------------------------------------------------------------------------------
-- 2. A partir del id del profesor obtener si tiene cursos asignados o no
DECLARE @id_profesor int = 2, @cantidad_cursos int
SELECT @cantidad_cursos = count(*) FROM careers_detail cd
INNER JOIN course c ON  cd.course_code = c.code
INNER JOIN teachers t ON cd.teachers_id = t.id
WHERE t.id = @id_profesor
IF @cantidad_cursos > 0
	BEGIN
		PRINT 'Cursos asignados: ' + convert(char(2), @cantidad_cursos)
		PRINT 'El profesor tiene cursos asignados.'
	END
ELSE 
	BEGIN
		PRINT 'Cursos asignados: ' + convert(char(2), @cantidad_cursos)
		PRINT 'El profesor no tiene cursos asignados.'
	END
SELECT 
	c.names AS 'Curso',
	concat(last_names, ', ', t.names) AS 'Profesor'
FROM careers_detail cd
INNER JOIN course c ON  cd.course_code = c.code
INNER JOIN teachers t ON cd.teachers_id = t.id
WHERE t.id = @id_profesor

-- 3. A través el id del estudiante mostrar si se ha matriculado o no, y a qué carrera

--------------------------------------------------------------------------------
---<> Estructura CASE <>---

---   Microsoft define CASE como una expresión que evalúa una lista de condiciones y     
---   devuelve una de las múltiples expresiones de resultados posibles.

--- Sintaxis:
--- CASE <input_expression>
---   WHEN <when_expression> THEN result_expression [ ...n ]
---   [ ELSE else_result_expression ]
--- END

--- 1. Mostrar Activo (A) e Inactivo (I)
SELECT 
	s.last_names AS 'Apellidos', s.names AS 'Nombres', s.email AS 'Email',
	CASE
		WHEN s.status = 'A' THEN 'Activo'
		WHEN s.status = 'I' THEN 'Inactivo'
	ELSE 'No válido'
	END AS 'Estado'		
FROM student s
GO
--------------------------------------------------------------------------------

--- 2. Determinar si el seller nació en el primer, segundo, tercer o cuarto trimestre
SET DATEFORMAT dmy;
SELECT 
	UPPER(last_names) AS 'Apellidos', 
	names AS 'Nombres',
	email AS 'Correo Electrónico',
	place as 'Lugar de procedencia',
	FORMAT(birthday, 'dd-MMM-yyyy', 'es-es' ) AS 'Fecha de Nacimiento',
	CASE 
		WHEN MONTH(birthday) between 1 and 3 THEN 'Nació en el primer trimestre'
		WHEN MONTH(birthday) between 4 and 6 THEN 'Nació en el segundo trimestre'
		WHEN MONTH(birthday) between 7 and 9 THEN 'Nació en el tercer trimestre'
		WHEN MONTH(birthday) between 10 and 12 THEN 'Nació en el cuarto trimestre'
	ELSE 'Fuera de rango'
	END AS 'Fecha'
FROM seller
GO

--------------------------------------------------------------------------------
---<> Estructura While <>---
---   Se utiliza para recorrer el código mientras una condición aún es verdadera.

--- Sintaxis:
--	WHILE expression_logica
--		BEGIN
--			 <sql_statement | statement_block>
--		END

-- 1. Tabla de multiplicar
DECLARE @multiplicador int = 0, @multiplicando int = 8, @producto int
PRINT 'Tabla de Multiplicar del ' + convert(char(2), @multiplicando)
PRINT '------------------------------'
WHILE @multiplicador <= 12 
BEGIN
	SET @producto = @multiplicando * @multiplicador
	PRINT convert(char(2), @multiplicando) + ' X ' + convert(char(2), @multiplicador) + ' = ' + convert(char(2), @producto) 
    SET @multiplicador += 1; 
END
GO
--------------------------------------------------------------------------------

-- 2. Devolver un id de estudiante con el prefijo E de 4 caracteres (E001, E002, ...)

DECLARE @numero int, @inicio int = 1
DECLARE @estudiante varchar(60)

SET @numero = (SELECT COUNT(*) FROM student)

PRINT 'Listado de Estudiantes'
PRINT '----------------------'

WHILE @inicio <= @numero
	BEGIN
		SET @estudiante = (SELECT s.names FROM student s WHERE s.id = @inicio)
		PRINT 'E' + FORMAT(@inicio, '000') + ' | ' + @estudiante
		SET @inicio +=1
	END
GO

--------------------------------------------------------------------------------
---<> Manejo de Errores TRY / CATCH <>---

-- 1. 
SELECT * FROM course co;
ALTER TABLE course
	ADD CONSTRAINT number_credits CHECK(credits <= 3)
GO

INSERT INTO course (code, names, credits)
VALUES ('C008', 'Base de Datos Avanzado', 5);

BEGIN TRY
	INSERT INTO course (code, names, credits)
	VALUES ('C008', 'Base de Datos Avanzado', 5);
	SELECT 'El curso se ha insertado correctamente' AS 'mensaje'
END TRY
BEGIN CATCH
	PRINT 'Código de error: ' + convert(char(4), ERROR_NUMBER()) -- código de error
	PRINT ERROR_MESSAGE()
	PRINT 'Ha ocurrido un error en la inserción'
END CATCH

--------------------------------------------------------------------------------

---<> Anatomía de los errores  <>---

-- 1. Mensaje de error: SELECT * FROM sys.messages
-- Listado de mensajes de error

-- 2. Nivel de gravedad error: pueden ser
-- 0 -  1  : Mensajes informativos
-- 11 - 16 : Errores que el usuario puede corregir (violación de restricciones, etc.)
-- 17 - 24 : otros errores (problemas de software, errores fatales)

-- 3. Estado del error:
--        1: si SQL Server muestra un error
--    0-255: si planteamos nuestro propio error, podemos elegir entre 0 y 255

-- 4. Línea de error: Indica en qué línea ocurrió el error

INSERT INTO course (code, names, credits)
VALUES ('C008', 'Base de Datos Avanzado', 5);

--------------------------------------------------------------------------------
---<> Transacciones  <>---
