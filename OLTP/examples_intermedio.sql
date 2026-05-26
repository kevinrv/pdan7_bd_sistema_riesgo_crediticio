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

SELECT  	cliente.id,	CASE 
	WHEN pj.razon_social IS NULL 
		THEN CONCAT(nt.apellido_paterno,' ', nt.apellido_paterno, ' ', nt.nombres)
	ELSE pj.razon_social END AS 'cliente',    cliente.tipo_cliente,    COUNT(cc.cuenta_id) AS cantidad_cuentasFROM clientes clienteLEFT JOIN cuentas_clientes cc ON cliente.id = cc.cliente_idLEFT JOIN personas_naturales nt ON nt.cliente_id=cliente.id AND cliente.tipo_cliente='N'
LEFT JOIN personas_juridicas pj ON pj.cliente_id=cliente.id AND cliente.tipo_cliente='J'GROUP BY 	cliente.id,	cliente.tipo_cliente,	pj.razon_social,	nt.apellido_paterno, 	nt.apellido_paterno,	nt.nombresORDER BY cantidad_cuentas DESC;

--Calcular el saldo total por moneda.
Select moneda, sum(saldo) as saldo_total from cuentasgroup by moneda
--Mostrar el monto promedio solicitado por producto crediticio.



--Mostrar cuántas solicitudes existen por estado.
--Obtener el promedio del score de riesgo.
--Mostrar el total desembolsado por estado de crédito.
--Mostrar el número de cuotas pendientes por crédito.
--Mostrar el total pagado por método de pago.
--Mostrar el promedio de ingresos mensuales según resultado de evaluación.
--Mostrar cuántos créditos tiene cada cliente.
--Mostrar los 5 clientes con más cuentas.