USE pdan_bd_sistema_riesgo_crediticio;
GO

INSERT INTO tipos_cuenta
(nombre,descripcion)
VALUES
('Cuenta Ahorro','Cuenta de ahorro para personas naturales'),
('Cuenta Corriente','Cuenta para operaciones frecuentes'),
('Cuenta Sueldo','Cuenta para depósitos de planilla'),
('Cuenta CTS','Cuenta de compensación por tiempo de servicio'),
('Cuenta Empresarial','Cuenta para empresas'),
('Cuenta Premium','Cuenta para clientes preferentes');
GO


-----------------------------------------
-- GENERAR 100 CUENTAS
-----------------------------------------

;WITH numeros AS
(
    SELECT TOP 99
    ROW_NUMBER() OVER(ORDER BY (SELECT NULL))+1 numero
    FROM sys.objects
)

INSERT INTO cuentas
(
num_cuenta,
cci,
num_tarjeta,
fecha_creacion,
moneda,
saldo,
tipo_cuenta_id
)

SELECT

'104500'+RIGHT('000000'+CAST(numero AS VARCHAR),6),

'002104500'+RIGHT('000000'+CAST(numero AS VARCHAR),6),

'453212345678'+RIGHT('0000'+CAST(numero AS VARCHAR),4),

DATEADD(
DAY,
-(ABS(CHECKSUM(NEWID()))%700),
GETDATE()
),

CASE numero%3
WHEN 0 THEN 'PEN'
WHEN 1 THEN 'USD'
ELSE 'EUR'
END,

CAST(
(ABS(CHECKSUM(NEWID()))%45000)+500
AS DECIMAL(18,2)
),

((numero-1)%6)+1

FROM numeros;

GO

SELECT*FROM cuentas;
SELECT*FROM cuentas_clientes

SELECT YEAR(fecha_creacion),moneda, SUM(saldo) AS 'sum_saldo'
FROM cuentas
GROUP BY YEAR(fecha_creacion),moneda
ORDER BY 1;
-- Cuentas clientes
;WITH cuentas_numeradas AS
(
SELECT
id,
ROW_NUMBER() OVER(ORDER BY id) fila
FROM cuentas
)

INSERT INTO cuentas_clientes
(
cliente_id,
cuenta_id
)

SELECT

((fila-1)%36)+1,
id

FROM cuentas_numeradas;

GO

SELECT*FROM cuentas_clientes;

SELECT cliente_id, COUNT(*)
FROM cuentas_clientes
GROUP BY cliente_id;


SELECT cuenta_id, COUNT(*)
FROM cuentas_clientes
GROUP BY cuenta_id;