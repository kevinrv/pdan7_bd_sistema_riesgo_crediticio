/*
===========================================================
CURSO: MODELAMIENTO DE DATOS Y SQL SERVER
TEMA: PROCEDIMIENTOS ALMACENADOS, FUNCIONES Y VISTAS
CASO: SISTEMA DE RIESGO CREDITICIO
===========================================================

NIVEL: BÁSICO, INTERMEDIO, AVANZADO Y EXPERTO

Objetivo:
Desarrollar objetos de base de datos reutilizables
para automatizar consultas, cálculos y procesos
del negocio bancario.

===========================================================
SECCIÓN I - VISTAS
===========================================================

-----------------------------------------------------------
EJERCICIO V01 - BÁSICO
-----------------------------------------------------------

Crear una vista que muestre el listado de clientes
(personas naturales) incluyendo:

- Id Cliente
- Número Documento
- Nombres completos
- Celular
- Situación laboral

Nombre sugerido:
vw_clientes_naturales*/

CREATE VIEW vw_clientes_naturales AS 
SELECT
	c.id AS 'Id Cliente',
	nt.numero_documento AS 'Número Documento',
	CONCAT(nt.apellido_paterno,' ',nt.apellido_materno,' ',nt.nombres) AS 'Nombres completos',
	celular AS 'Celular',
	situacion_laboral AS 'Situación laboral'
FROM clientes c 
INNER JOIN personas_naturales nt ON nt.cliente_id=c.id;



SELECT*FROM vw_clientes_naturales;

/*

-----------------------------------------------------------
EJERCICIO V02 - BÁSICO
-----------------------------------------------------------

Crear una vista que muestre el listado de
personas jurídicas incluyendo:

- RUC
- Razón social
- Tipo empresa
- Sector económico
- Estado empresa*/

CREATE VIEW vw_clientes_juridicos AS 
SELECT
	c.id AS 'Id Cliente',
	pj.ruc AS 'RUC',
	pj.razon_social AS 'Razón social',
	pj.tipo_empresa AS 'Tipo empresa',
	pj.sector_economico AS 'Sector económico',
	pj.estado_empresa AS 'Estado empresa'
FROM clientes c 
INNER JOIN personas_juridicas pj ON pj.cliente_id=c.id;

SELECT*FROM vw_clientes_juridicos;
/*

-----------------------------------------------------------
EJERCICIO V03 - BÁSICO
-----------------------------------------------------------

Crear una vista que muestre todas las cuentas
junto con:

- Número cuenta
- Moneda
- Saldo
- Tipo cuenta

-----------------------------------------------------------
EJERCICIO V04 - INTERMEDIO
-----------------------------------------------------------

Crear una vista que muestre todas las solicitudes.

Incluir:

- Código solicitud
- Fecha solicitud
- Cliente
- Producto crediticio
- Monto solicitado
- Estado

-----------------------------------------------------------
EJERCICIO V05 - INTERMEDIO
-----------------------------------------------------------

Crear una vista que muestre las evaluaciones
crediticias.

Incluir:

- Cliente
- Score riesgo
- Nivel endeudamiento
- Ingresos mensuales
- Resultado evaluación

-----------------------------------------------------------
EJERCICIO V06 - INTERMEDIO
-----------------------------------------------------------

Crear una vista denominada:

vw_creditos_vigentes

Mostrar únicamente créditos vigentes.

-----------------------------------------------------------
EJERCICIO V07 - AVANZADO
-----------------------------------------------------------

Crear una vista de cartera crediticia.

Mostrar:

- Número crédito
- Cliente
- Producto
- Monto
- Saldo crédito
- Estado

-----------------------------------------------------------
EJERCICIO V08 - AVANZADO
-----------------------------------------------------------

Crear una vista de cuotas pendientes.

Mostrar:

- Crédito
- Número cuota
- Fecha vencimiento
- Total cuota
- Saldo pendiente

-----------------------------------------------------------
EJERCICIO V09 - EXPERTO
-----------------------------------------------------------

Crear una vista de indicadores generales.

Mostrar:

- Total clientes
- Total solicitudes
- Total créditos
- Total desembolsado

(Utilizar subconsultas)
*/

CREATE VIEW vw_indicadores_generales AS
SELECT
(SELECT COUNT(*) FROM clientes) as 'Total clientes',
(SELECT COUNT(*) FROM solicitudes) as 'Total solicitudes',
(SELECT COUNT(*) FROM creditos) as 'Total créditos',
(SELECT SUM(monto) FROM creditos) as 'Total desembolsado';

SELECT*FROM vw_indicadores_generales;

/*
-----------------------------------------------------------
EJERCICIO V10 - EXPERTO
-----------------------------------------------------------

Crear una vista de riesgo crediticio.

Clasificar clientes:

- Riesgo Bajo
- Riesgo Medio
- Riesgo Alto

Según score_riesgo.

===========================================================
SECCIÓN II - FUNCIONES ESCALARES
===========================================================

-----------------------------------------------------------
EJERCICIO F01 - BÁSICO
-----------------------------------------------------------

Crear una función que reciba:

@fecha_nacimiento

Y retorne:

Edad actual del cliente.

Nombre sugerido:

fn_calcular_edad
*/

SELECT
YEAR(GETDATE()) - YEAR(fecha_nacimiento) AS 'Edad'
FROM personas_naturales
WHERE cliente_id=1;

CREATE FUNCTION fn_calcular_edad(@fecha_nacimiento DATE)
RETURNS INT
AS 

BEGIN
DECLARE @edad INT;

SET @edad = YEAR(GETDATE()) - YEAR(@fecha_nacimiento);

return @edad
END


SELECT dbo.fn_calcular_edad('1990-05-05') AS 'edad'


SELECT nt.*, dbo.fn_calcular_edad(nt.fecha_nacimiento) AS 'edad'
FROM personas_naturales nt;

/*
-----------------------------------------------------------
EJERCICIO F02 - BÁSICO
-----------------------------------------------------------

Crear una función que reciba:

@monto

Y retorne:

IGV incluido.

-----------------------------------------------------------
EJERCICIO F03 - BÁSICO
-----------------------------------------------------------

Crear una función que reciba:

@score

Y retorne:

- Bajo
- Medio
- Alto

Según el score recibido.*/

ALTER FUNCTION fn_score_clasificacion (@score DECIMAL(9,2))
RETURNS VARCHAR(25)
AS 
BEGIN

DECLARE @clsf VARCHAR(25);
SET @clsf = (SELECT CASE 
WHEN @score<200 THEN 'bajo'
WHEN @score<400 THEN 'Medio'
ELSE 'Alto' END);

RETURN @clsf
END

SELECT dbo.fn_score_clasificacion(422)

/*

-----------------------------------------------------------
EJERCICIO F04 - INTERMEDIO
-----------------------------------------------------------

Crear una función que reciba:

@saldo_credito

Y retorne:

Clasificación:

- Normal
- Observado
- Crítico

-----------------------------------------------------------
EJERCICIO F05 - INTERMEDIO
-----------------------------------------------------------

Crear una función que reciba:

@ingresos
@deudas

Y retorne:

Porcentaje de endeudamiento.

-----------------------------------------------------------
EJERCICIO F06 - INTERMEDIO
-----------------------------------------------------------

Crear una función que reciba:

@capital
@intereses
@seguros

Y retorne:

Total cuota.

-----------------------------------------------------------
EJERCICIO F07 - AVANZADO
-----------------------------------------------------------

Crear una función que reciba:

@monto_credito
@plazo

Y retorne:

Valor estimado de cuota.

-----------------------------------------------------------
EJERCICIO F08 - AVANZADO
-----------------------------------------------------------

Crear una función que reciba:

@fecha_vencimiento

Y retorne:

Cantidad de días de atraso.

-----------------------------------------------------------
EJERCICIO F09 - EXPERTO
-----------------------------------------------------------

Crear una función que reciba:

@score
@endeudamiento

Y retorne:

Nivel de riesgo:

- Verde
- Amarillo
- Rojo

-----------------------------------------------------------
EJERCICIO F10 - EXPERTO
-----------------------------------------------------------

Crear una función que reciba:

@cliente_id

Y retorne:

Exposición crediticia total.

Considerar:

Saldo crédito +
Deuda activa +
Deuda externa.

===========================================================
SECCIÓN III - FUNCIONES TABULARES
===========================================================

-----------------------------------------------------------
EJERCICIO FT01 - INTERMEDIO
-----------------------------------------------------------

Crear una función tabular que retorne
todos los créditos vigentes.
*/

CREATE FUNCTION fn_creditos_vigentes()
RETURNS TABLE
AS
RETURN(SELECT*FROM creditos WHERE estado='vigente')


SELECT*FROM dbo.fn_creditos_vigentes()
/*
-----------------------------------------------------------
EJERCICIO FT02 - INTERMEDIO
-----------------------------------------------------------

Crear una función tabular que reciba:

@cliente_id

Y retorne:

Todos sus créditos.

-----------------------------------------------------------
EJERCICIO FT03 - AVANZADO
-----------------------------------------------------------

Crear una función tabular que reciba:

@estado_credito

Y retorne:

Créditos filtrados por estado.

*/

CREATE FUNCTION fn_creditos_estado(@estado VARCHAR(50))
RETURNS TABLE
AS
RETURN(SELECT*FROM creditos WHERE estado=@estado)
END



SELECT*FROM dbo.fn_creditos_estado('desembolsado')



/*

-----------------------------------------------------------
EJERCICIO FT04 - AVANZADO
-----------------------------------------------------------

Crear una función tabular que reciba:

@anio

Y retorne:

Solicitudes registradas en dicho año.

-----------------------------------------------------------
EJERCICIO FT05 - EXPERTO
-----------------------------------------------------------

Crear una función tabular que reciba:

@score_minimo

Y retorne:

Clientes cuyo score sea superior
al valor recibido.

===========================================================
SECCIÓN IV - PROCEDIMIENTOS ALMACENADOS
===========================================================

-----------------------------------------------------------
EJERCICIO SP01 - BÁSICO
-----------------------------------------------------------

Crear un procedimiento almacenado para
listar todos los clientes.

Nombre sugerido:

usp_listar_clientes

*/

CREATE PROCEDURE usp_listar_clientes

AS
BEGIN
select*from clientes;

END

EXEC usp_listar_clientes;

/*

-----------------------------------------------------------
EJERCICIO SP02 - BÁSICO
-----------------------------------------------------------

Crear un procedimiento almacenado que reciba:

@cliente_id

Y muestre los datos del cliente.

-----------------------------------------------------------
EJERCICIO SP03 - BÁSICO
-----------------------------------------------------------

Crear un procedimiento almacenado para
listar todos los productos crediticios.

-----------------------------------------------------------
EJERCICIO SP04 - INTERMEDIO
-----------------------------------------------------------

Crear un procedimiento almacenado que reciba:

@estado

Y muestre las solicitudes según estado.

-----------------------------------------------------------
EJERCICIO SP05 - INTERMEDIO
-----------------------------------------------------------

Crear un procedimiento almacenado que reciba:

@fecha_inicio
@fecha_fin

Y muestre las solicitudes dentro
del rango de fechas.

-----------------------------------------------------------
EJERCICIO SP06 - INTERMEDIO
-----------------------------------------------------------

Crear un procedimiento almacenado que reciba:

@cliente_id

Y muestre todos los créditos
del cliente.

-----------------------------------------------------------
EJERCICIO SP07 - AVANZADO
-----------------------------------------------------------

Crear un procedimiento almacenado que reciba:

@credito_id

Y muestre el cronograma de cuotas.

-----------------------------------------------------------
EJERCICIO SP08 - AVANZADO
-----------------------------------------------------------

Crear un procedimiento almacenado para
calcular la deuda pendiente de un crédito.

-----------------------------------------------------------
EJERCICIO SP09 - AVANZADO
-----------------------------------------------------------

Crear un procedimiento almacenado para
mostrar los clientes morosos.

Considerar:

Clientes con al menos una cuota pendiente.

-----------------------------------------------------------
EJERCICIO SP10 - AVANZADO
-----------------------------------------------------------

Crear un procedimiento almacenado que reciba:

@cliente_id

Y muestre:

- Créditos
- Cuotas
- Pagos

Del cliente.

-----------------------------------------------------------
EJERCICIO SP11 - EXPERTO
-----------------------------------------------------------

Crear un procedimiento almacenado para
aprobar una solicitud.

Proceso:

1. Cambiar estado solicitud.
2. Registrar evaluación.
3. Generar crédito.

(Utilizar transacción)

-----------------------------------------------------------
EJERCICIO SP12 - EXPERTO
-----------------------------------------------------------

Crear un procedimiento almacenado para
registrar un pago.

Proceso:

1. Registrar pago.
2. Registrar detalle.
3. Actualizar saldo cuota.

(Utilizar transacción)

-----------------------------------------------------------
EJERCICIO SP13 - EXPERTO
-----------------------------------------------------------

Crear un procedimiento almacenado para
refinanciar un crédito.

Proceso:

1. Cambiar estado crédito.
2. Generar nuevo crédito.
3. Registrar observación.

-----------------------------------------------------------
EJERCICIO SP14 - EXPERTO
-----------------------------------------------------------

Crear un procedimiento almacenado que
genere un reporte ejecutivo.

Mostrar:

- Total cartera
- Total desembolsado
- Total pendiente
- Total morosidad

-----------------------------------------------------------
EJERCICIO SP15 - EXPERTO
-----------------------------------------------------------

Crear un procedimiento almacenado que
genere automáticamente el ranking de clientes
por exposición crediticia.

===========================================================
RETO FINAL
===========================================================

Diseñar un módulo completo de consulta
crediticia utilizando:

✓ 2 Vistas
✓ 2 Funciones Escalares
✓ 1 Función Tabular
✓ 3 Procedimientos Almacenados

El resultado debe permitir:

- Consultar cliente
- Consultar créditos
- Consultar pagos
- Calcular riesgo
- Mostrar indicadores
===========================================================
*/