--Mostrar los clientes cuyo score de riesgo sea mayor al promedio general.

SELECT AVG(score_riesgo) FROM evaluaciones_crediticias;
SELECT
DISTINCT
	s.cliente_id, 
	CASE 
	WHEN pj.razon_social IS NULL 
		THEN CONCAT(nt.apellido_paterno,' ', nt.apellido_paterno, ' ', nt.nombres)
	ELSE pj.razon_social END AS 'cliente',
    cliente.tipo_cliente,
		score_riesgo
FROM evaluaciones_crediticias ec
	INNER JOIN solicitudes s ON s.id=ec.solicitud_id
	INNER JOIN clientes cliente ON cliente.id=s.cliente_id
	LEFT JOIN personas_naturales nt ON nt.cliente_id=cliente.id AND cliente.tipo_cliente='N'
	LEFT JOIN personas_juridicas pj ON pj.cliente_id=cliente.id AND cliente.tipo_cliente='J'
WHERE 
	 score_riesgo > (SELECT AVG(score_riesgo) FROM evaluaciones_crediticias) AND
	 (pj.id IS NOT NULL OR nt.id IS NOT NULL);


--Mostrar créditos cuyo monto sea mayor al promedio del producto solicitado.

SELECT
c.*,
pc.nombre
FROM creditos c
INNER JOIN evaluaciones_crediticias ec ON c.evaluacion_crediticia_id=ec.id
INNER JOIN solicitudes s ON s.id=ec.solicitud_id
INNER JOIN productos_crediticios pc ON pc.id=s.producto_crediticio_id
WHERE c.monto > (SELECT AVG(c1.monto)
FROM creditos c1
INNER JOIN evaluaciones_crediticias ec1 ON c1.evaluacion_crediticia_id=ec1.id
INNER JOIN solicitudes s1 ON s1.id=ec1.solicitud_id
WHERE s1.producto_crediticio_id=pc.id);

SELECT
pc.nombre,
AVG(monto)
FROM creditos c
INNER JOIN evaluaciones_crediticias ec ON c.evaluacion_crediticia_id=ec.id
INNER JOIN solicitudes s ON s.id=ec.solicitud_id
INNER JOIN productos_crediticios pc ON pc.id=s.producto_crediticio_id
GROUP BY pc.nombre;

--Mostrar el cliente con el mayor monto total solicitado.
--Mostrar las cuotas cuyo saldo pendiente supere el promedio de saldos.
--Mostrar los clientes que poseen más de una cuenta en diferentes monedas.
--Mostrar las empresas con más de dos créditos aprobados.
--Mostrar el porcentaje de solicitudes aprobadas versus desestimadas.
--Mostrar el crédito con la mayor cantidad de cuotas pendientes.
--Obtener el ranking de clientes según monto total desembolsado.
--Mostrar el porcentaje de endeudamiento promedio por producto crediticio.
--Encontrar clientes que nunca solicitaron un crédito.
--Mostrar los clientes cuyo patrimonio supere tres veces sus ingresos anuales.
--Calcular la mora potencial por crédito:
--Saldo pendiente + intereses
--Mostrar los créditos cuyo saldo actual represente más del 50% del monto inicial.
--Mostrar las cuotas pagadas fuera de su fecha de vencimiento.