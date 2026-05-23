USE pdan_bd_sistema_riesgo_crediticio;
GO

--------------------------------------
-- PRODUCTOS CREDITICIOS
--------------------------------------

INSERT INTO productos_crediticios
(
nombre,
monto_minimo,
monto_maximo,
tasa_interes_minima,
tasa_interes_maxima,
plazo_minimo_meses,
plazo_maximo_meses,
estado,
created_at,
updated_at
)

VALUES

(
'Prestamo Personal',
1000,
50000,
10.50,
35.00,
6,
60,
'activo',
GETDATE(),
GETDATE()
),

(
'Credito Hipotecario',
50000,
500000,
7.50,
15.00,
60,
360,
'activo',
GETDATE(),
GETDATE()
),

(
'Credito Vehicular',
10000,
120000,
8.50,
18.00,
12,
72,
'activo',
GETDATE(),
GETDATE()
),

(
'Linea de Credito',
3000,
80000,
12.00,
25.00,
12,
48,
'activo',
GETDATE(),
GETDATE()
),

(
'Credito Empresarial',
10000,
1000000,
9.50,
22.00,
12,
120,
'activo',
GETDATE(),
GETDATE()
);

GO

SELECT*FROM productos_crediticios;

--------------------------------------
-- SOLICITUDES
--------------------------------------

;WITH numeros AS
(
SELECT TOP 75
ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) n
FROM sys.objects
)

INSERT INTO solicitudes
(
cliente_id,
producto_crediticio_id,
codigo_solicitud,
fecha_solicitud,
monto_solicitado,
moneda_solicitada,
estado
)

SELECT

((n-1)%36)+1,

((n-1)%5)+1,

'SOL-'+RIGHT('00000'+CAST(n AS VARCHAR),5),

DATEADD
(
DAY,
-(ABS(CHECKSUM(NEWID()))%365),
GETDATE()
),

CAST(
(ABS(CHECKSUM(NEWID()))%90000)+3000
AS DECIMAL(18,2)
),

CASE n%3
WHEN 0 THEN 'PEN'
WHEN 1 THEN 'USD'
ELSE 'EUR'
END,

CASE n%4
WHEN 0 THEN 'ingresado'
WHEN 1 THEN 'en evaluacion'
WHEN 2 THEN 'aprobada'
ELSE 'desestimado'
END

FROM numeros;

GO

SELECT*FROM solicitudes;

SELECT pc.nombre, COUNT(*)
FROM solicitudes s
INNER JOIN productos_crediticios pc ON pc.id=s.producto_crediticio_id
WHERE s.estado='aprobada'AND 
YEAR(s.fecha_solicitud)='2026'
GROUP BY pc.nombre

SELECT MONTH(GETDATE());

--------------------------------------
-- EVALUACIONES CREDITICIAS
--------------------------------------
TRUNCATE TABLE evaluaciones_crediticias;
GO


INSERT INTO evaluaciones_crediticias
(
solicitud_id,
score_riesgo,
nivel_endeudamiento,
deuda_activa,
deuda_activa_otras_entidades,
linea_credito,
linea_credito_otras_entidades,
valor_patrimonio,
ingresos_mensuales,
resultado
)

SELECT

s.id,

CAST(
(ABS(CHECKSUM(NEWID()))%600)+300
AS DECIMAL(10,2)
),

CAST(
(ABS(CHECKSUM(NEWID()))%90)
AS DECIMAL(10,2)
),

CAST(
(ABS(CHECKSUM(NEWID()))%30000)
AS DECIMAL(18,2)
),

CAST(
(ABS(CHECKSUM(NEWID()))%25000)
AS DECIMAL(18,2)
),

CAST(
(ABS(CHECKSUM(NEWID()))%50000)
AS DECIMAL(18,2)
),

CAST(
(ABS(CHECKSUM(NEWID()))%30000)
AS DECIMAL(18,2)
),

CAST(
(ABS(CHECKSUM(NEWID()))%500000)+20000
AS DECIMAL(18,2)
),

CAST(
(ABS(CHECKSUM(NEWID()))%15000)+1200
AS DECIMAL(18,2)
),

CASE

WHEN s.estado='aprobada'
THEN 'Aprobado'

WHEN s.estado='desestimado'
THEN 'Rechazado'

WHEN s.estado='en evaluacion'
THEN 'En análisis'

ELSE 'Pendiente'

END

FROM solicitudes s;

GO

SELECT*FROM creditos;

SELECT*FROM evaluaciones_crediticias WHERE resultado='Aprobado';


-----------------------------------------
-- GENERAR CREDITOS CON CUENTA DE DESEMBOLSO
-----------------------------------------

INSERT INTO creditos
(
evaluacion_crediticia_id,
cuenta_id,
monto,
plazo_meses,
tea,
tcea,
valor_cuota,
fecha_inicio,
fecha_fin,
fecha_desembolso,
numero_credito,
fecha_vencimiento,
estado,
saldo_credito,
desgravamen
)

SELECT

ec.id,

cc.cuenta_id,

s.monto_solicitado,

plazos.plazo_meses,

CAST(
((ABS(CHECKSUM(NEWID()))%15)+8)
AS DECIMAL(10,2)
),

CAST(
((ABS(CHECKSUM(NEWID()))%18)+10)
AS DECIMAL(10,2)
),

CAST(
s.monto_solicitado/plazos.plazo_meses
AS DECIMAL(18,2)
),

fecha.fecha_credito,

DATEADD(
MONTH,
plazos.plazo_meses,
fecha.fecha_credito
),

fecha.fecha_credito,

100000+ec.id,

DATEADD(
MONTH,
plazos.plazo_meses,
fecha.fecha_credito
),

CASE
WHEN ABS(CHECKSUM(NEWID()))%4=0
THEN 'desembolsado'
ELSE 'vigente'
END,

s.monto_solicitado,

CAST(
s.monto_solicitado*0.015
AS DECIMAL(18,2)
)

FROM evaluaciones_crediticias ec

INNER JOIN solicitudes s
ON ec.solicitud_id=s.id

CROSS APPLY
(
SELECT TOP 1
cuenta_id
FROM cuentas_clientes cc
WHERE cc.cliente_id=s.cliente_id
ORDER BY NEWID()
) cc

CROSS APPLY
(
SELECT
(ABS(CHECKSUM(NEWID()))%60)+12
AS plazo_meses
) plazos

CROSS APPLY
(
SELECT
DATEADD(
DAY,
(ABS(CHECKSUM(NEWID()))%15),
s.fecha_solicitud
)
AS fecha_credito
) fecha

WHERE ec.resultado='Aprobado';

GO


SELECT*FROM creditos;