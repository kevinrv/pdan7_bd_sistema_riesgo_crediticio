USE pdan_bd_sistema_riesgo_crediticio;
GO

--Contar cuántos clientes existen por tipo de cliente.
SELECT
	CASE WHEN tipo_cliente = 'J' 
		THEN 'Cliente Juridico'
		ELSE 'Cliente Persona Natural' 
	END AS 'Tipo cliente', 
	COUNT(*) AS 'Num_clientes'
FROM clientes
GROUP BY tipo_cliente;

--Mostrar cuántas cuentas tiene cada cliente.

SELECT  
	cliente.id,
	CASE 
	WHEN pj.razon_social IS NULL 
		THEN CONCAT(nt.apellido_paterno,' ', nt.apellido_paterno, ' ', nt.nombres)
	ELSE pj.razon_social END AS 'cliente',
    cliente.tipo_cliente,
    COUNT(cc.cuenta_id) AS cantidad_cuentas
FROM clientes cliente
LEFT JOIN cuentas_clientes cc ON cliente.id = cc.cliente_id
LEFT JOIN personas_naturales nt ON nt.cliente_id=cliente.id AND cliente.tipo_cliente='N'
LEFT JOIN personas_juridicas pj ON pj.cliente_id=cliente.id AND cliente.tipo_cliente='J'
WHERE pj.id IS NOT NULL OR nt.id IS NOT NULL
GROUP BY 
	cliente.id,
	cliente.tipo_cliente,
	pj.razon_social,
	nt.apellido_paterno, 
	nt.apellido_paterno,
	nt.nombres
ORDER BY cantidad_cuentas DESC;

--Calcular el saldo total por moneda.
Select moneda, sum(saldo) as saldo_total 
from cuentas
group by moneda
--Mostrar el monto promedio solicitado por producto crediticio.
SELECT 
    pc.id,
    pc.nombre,
    AVG(s.monto_solicitado) AS monto_promedio_solicitado,
    COUNT(s.id) AS cantidad_solicitudes,
    MIN(s.monto_solicitado) AS monto_minimo,
    MAX(s.monto_solicitado) AS monto_maximo
FROM productos_crediticios pc
LEFT JOIN solicitudes s ON pc.id = s.producto_crediticio_id
GROUP BY pc.id, pc.nombre
ORDER BY monto_promedio_solicitado DESC;

--Mostrar cuántas solicitudes existen por estado.

SELECT estado, COUNT(*) AS 'num_solicitudes'
FROM solicitudes
GROUP BY estado;


--Obtener el promedio del score de riesgo.

SELECT s.estado,AVG(score_riesgo)
FROM evaluaciones_crediticias ec 
INNER JOIN solicitudes s ON s.id=ec.solicitud_id
GROUP BY s.estado;
--Mostrar el total desembolsado por estado de crédito.
SELECT*FROM creditos;
Select estado, sum(monto) as monto from creditosgroup by estado;
--Mostrar el número de cuotas pendientes por crédito.
SELECT*FROM creditos;

SELECT 
	credito_id,
	COUNT(*) AS 'num_cuotas'
FROM cuotas 
WHERE
	estado='pendiente'
GROUP BY credito_id
ORDER BY 2 DESC;


--Mostrar el total pagado por método de pago.
SELECT
metodo_pago,
COUNT(*) AS 'total_pagado'
FROM pagos
GROUP BY metodo_pago
ORDER BY 2 DESC;


--Mostrar el promedio de ingresos mensuales según resultado de evaluación.

SELECT
resultado,
AVG(ingresos_mensuales) AS 'promedio_ingresos_mensuales'
FROM evaluaciones_crediticias
GROUP BY resultado
ORDER BY 2 DESC;

--Mostrar cuántos créditos tiene cada cliente.
SELECT  
	cliente.id,
	CASE 
	WHEN pj.razon_social IS NULL 
		THEN CONCAT(nt.apellido_paterno,' ', nt.apellido_paterno, ' ', nt.nombres)
	ELSE pj.razon_social END AS 'cliente',
    cliente.tipo_cliente,
	COUNT(DISTINCT c.id) AS 'num_creditos'
FROM clientes cliente
LEFT JOIN personas_naturales nt ON nt.cliente_id=cliente.id AND cliente.tipo_cliente='N'
LEFT JOIN personas_juridicas pj ON pj.cliente_id=cliente.id AND cliente.tipo_cliente='J'
INNER JOIN solicitudes s ON s.cliente_id=cliente.id
INNER JOIN evaluaciones_crediticias ec ON ec.solicitud_id=s.id
INNER JOIN creditos c ON c.evaluacion_crediticia_id=ec.id
WHERE pj.id IS NOT NULL OR nt.id IS NOT NULL
GROUP BY 
	cliente.id,
	cliente.tipo_cliente,
	pj.razon_social,
	nt.apellido_paterno, 
	nt.apellido_paterno,
	nt.nombres
ORDER BY 4 DESC;


--Mostrar los 5 clientes con más cuentas.

SELECT  
	cliente.id,
	CASE 
	WHEN pj.razon_social IS NULL 
		THEN CONCAT(nt.apellido_paterno,' ', nt.apellido_paterno, ' ', nt.nombres)
	ELSE pj.razon_social END AS 'cliente',
    cliente.tipo_cliente,
    COUNT(cc.cuenta_id) AS cantidad_cuentas
FROM clientes cliente
LEFT JOIN cuentas_clientes cc ON cliente.id = cc.cliente_id
LEFT JOIN personas_naturales nt ON nt.cliente_id=cliente.id AND cliente.tipo_cliente='N'
LEFT JOIN personas_juridicas pj ON pj.cliente_id=cliente.id AND cliente.tipo_cliente='J'
WHERE pj.id IS NOT NULL OR nt.id IS NOT NULL
GROUP BY 
	cliente.id,
	cliente.tipo_cliente,
	pj.razon_social,
	nt.apellido_paterno, 
	nt.apellido_paterno,
	nt.nombres
HAVING
	COUNT(cc.cuenta_id) IN	(SELECT TOP 5 COUNT(*) FROM cuentas_clientes GROUP BY cliente_id ORDER BY 1 DESC)

ORDER BY cantidad_cuentas DESC;
