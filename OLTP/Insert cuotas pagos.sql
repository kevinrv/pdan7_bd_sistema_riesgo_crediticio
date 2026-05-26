USE pdan_bd_sistema_riesgo_crediticio;
GO

-----------------------------------------
-- GENERAR CUOTAS (CORREGIDO)
-----------------------------------------

;WITH numeros AS
(
SELECT TOP (360)
ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) n
FROM sys.objects a
CROSS JOIN sys.objects b
)

INSERT INTO cuotas
(
credito_id,
num_cuota,
fecha_vencimiento,
capital,
intereses,
seguros,
total_cuota,
estado,
tasa_mora,
saldo_cuota
)

SELECT

c.id,

n.n,

DATEADD
(
MONTH,
n.n,
c.fecha_inicio
),

valores.capital,

valores.intereses,

valores.seguros,

valores.capital
+
valores.intereses
+
valores.seguros,

estado.estado_cuota,

ROUND((ABS(CHECKSUM(NEWID()))%8)+2,2),

CASE

WHEN estado.estado_cuota='pendiente'
THEN
valores.capital
+
valores.intereses
+
valores.seguros

WHEN estado.estado_cuota='pagada parcialmente'
THEN
ROUND(
(
valores.capital
+
valores.intereses
+
valores.seguros
)*0.40,2)

ELSE 0

END

FROM creditos c

INNER JOIN numeros n
ON n.n<=c.plazo_meses

CROSS APPLY
(
SELECT

ROUND(c.valor_cuota*0.80,2) capital,

ROUND(c.valor_cuota*0.15,2) intereses,

ROUND(c.valor_cuota*0.05,2) seguros

) valores

CROSS APPLY
(
SELECT

CASE
WHEN ABS(CHECKSUM(NEWID()))%4=0
THEN 'pendiente'

WHEN ABS(CHECKSUM(NEWID()))%4=1
THEN 'pagada parcialmente'

ELSE 'pagada'
END

AS estado_cuota

) estado;

GO

SELECT*FROM creditos;


SELECT*FROM cuotas; 




TRUNCATE TABLE detalle_cuotas_pagos;
TRUNCATE TABLE pagos;

GO

-----------------------------------------
-- GENERAR PAGOS CONSISTENTES
-----------------------------------------
SELECT*FROM pagos;


INSERT INTO pagos
(
num_operacion,
monto,
fecha_pago,
metodo_pago,
observaciones
)

SELECT

CONCAT(
'OP-',
RIGHT('000000'+CAST(c.id AS VARCHAR),6)
),

CASE

WHEN c.estado='pagada'
THEN c.total_cuota

WHEN c.estado='pagada parcialmente'
THEN c.total_cuota-c.saldo_cuota

END,

DATEADD
(
DAY,
ABS(CHECKSUM(NEWID()))%10,
c.fecha_vencimiento
),

CASE ABS(CHECKSUM(NEWID()))%4
WHEN 0 THEN 'Transferencia'
WHEN 1 THEN 'Yape'
WHEN 2 THEN 'Tarjeta'
ELSE 'Ventanilla'
END,

'Pago automático generado'

FROM cuotas c

WHERE c.estado<>'pendiente';

GO
--- Insert detalle cuotas
INSERT INTO detalle_cuotas_pagos
(
cuota_id,
pago_id,
monto_pagado
)

SELECT
c.id,
p.id,
p.monto

FROM cuotas c
INNER JOIN pagos p
ON p.num_operacion=
CONCAT(
'OP-',
RIGHT('000000'+CAST(c.id AS VARCHAR),6)
)

WHERE c.estado<>'pendiente';

GO


SELECT*FROM detalle_cuotas_pagos;