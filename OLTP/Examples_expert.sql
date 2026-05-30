/*
===========================================================
EJERCICIOS NIVEL EXPERTO
BASE DE DATOS: SISTEMA DE RIESGO CREDITICIO
===========================================================

Objetivo:
Aplicar consultas analíticas, indicadores financieros,
riesgo crediticio, funciones de agregación, CTE,
subconsultas y funciones ventana.

===========================================================
EJERCICIO 1
===========================================================

Construir un score crediticio simplificado:

score_final =
(score_riesgo * 0.5)
+
((ingresos_mensuales / 1000) * 0.3)
-
(nivel_endeudamiento * 0.2)

Clasificar el resultado en:

- Bajo Riesgo
- Riesgo Medio
- Alto Riesgo

===========================================================
EJERCICIO 2
===========================================================

Calcular la tasa de aprobación de solicitudes.

Formula:

(Aprobadas / Total Solicitudes) * 100

Mostrar:

- Total solicitudes
- Total aprobadas
- Porcentaje de aprobación

===========================================================
EJERCICIO 3
===========================================================

Calcular el ratio de morosidad.

Formula:

(Cuotas Pendientes / Total Cuotas) * 100

Mostrar:

- Total cuotas
- Cuotas pendientes
- Ratio de morosidad

===========================================================
EJERCICIO 4
===========================================================

Identificar clientes de alto riesgo.

Condiciones:

- Score de riesgo menor a 500
- Nivel de endeudamiento mayor a 70
- Deuda activa en otras entidades mayor a 20,000

Mostrar:

- Cliente
- Score
- Nivel endeudamiento
- Deuda externa

===========================================================
EJERCICIO 5
===========================================================

Construir un ranking de exposición crediticia.

Formula:

Exposición =
Saldo Crédito
+
Deuda Activa
+
Deuda Activa Otras Entidades

Ordenar de mayor a menor.

===========================================================
EJERCICIO 6
===========================================================

Detectar clientes con señales tempranas de incumplimiento.

Condiciones:

- Más de 3 cuotas pendientes
- Score de riesgo menor a 600

Mostrar:

- Cliente
- Número de cuotas pendientes
- Score de riesgo

===========================================================
EJERCICIO 7
===========================================================

Calcular el ingreso mensual recomendado.

Formula:

Ingreso Recomendado =
Total Cuotas Activas * 3

Mostrar:

- Cliente
- Cuotas activas
- Ingreso recomendado

===========================================================
EJERCICIO 8
===========================================================

Calcular la concentración de cartera por producto.

Formula:

(Monto Producto / Total Cartera) * 100

Mostrar:

- Producto
- Total desembolsado
- Participación %

===========================================================
EJERCICIO 9
===========================================================

Calcular el porcentaje de utilización de línea.

Formula:

(Deuda Activa / Línea Crédito) * 100

Mostrar:

- Cliente
- Línea de crédito
- Deuda activa
- Utilización %

===========================================================
EJERCICIO 10
===========================================================

Detectar clientes potencialmente sobreendeudados.

Formula:

(Deuda Total / Ingresos Mensuales)

Considerar:

Deuda Total =
Deuda Activa
+
Deuda Activa Otras Entidades

Mostrar únicamente clientes cuyo ratio sea mayor a 0.50

===========================================================
EJERCICIO 11
===========================================================

Construir un ranking de empresas por exposición financiera.

Considerar solamente personas jurídicas.

Ordenar por:

- Saldo crédito
- Deuda activa
- Deuda externa

===========================================================
EJERCICIO 12
===========================================================

Encontrar clientes que tienen cuentas bancarias
pero nunca han solicitado créditos.

Mostrar:

- Cliente
- Número de cuentas

===========================================================
EJERCICIO 13
===========================================================

Encontrar clientes que poseen créditos
pero no registran ningún pago.

Mostrar:

- Cliente
- Número de crédito
- Monto del crédito

===========================================================
EJERCICIO 14
===========================================================

Detectar anomalías crediticias.

Regla:

Monto Crédito > Valor Patrimonio

Mostrar:

- Cliente
- Patrimonio
- Monto crédito

===========================================================
EJERCICIO 15
===========================================================

Identificar clientes con patrimonio comprometido.

Formula:

Patrimonio Neto Simulado =
Valor Patrimonio
-
(Deuda Activa + Deuda Externa)

Mostrar los clientes cuyo patrimonio neto
sea negativo.

===========================================================
EJERCICIO 16
===========================================================

Construir un Dashboard General utilizando
una única consulta.

Indicadores requeridos:

- Total Clientes
- Total Solicitudes
- Total Créditos
- Total Desembolsado
- Total Pagos
- Total Cuotas
- Ratio Morosidad

===========================================================
EJERCICIO 17
===========================================================

Analizar la tendencia mensual de solicitudes.

Mostrar:

- Año
- Mes
- Cantidad solicitudes

Ordenar cronológicamente.

===========================================================
EJERCICIO 18
===========================================================

Determinar el mes con mayor desembolso.

Mostrar:

- Año
- Mes
- Total desembolsado

Ordenar de mayor a menor.

===========================================================
EJERCICIO 19
===========================================================

Proyectar ingresos futuros por intereses.

Considerar únicamente:

- Cuotas pendientes
- Cuotas parcialmente pagadas

Mostrar:

- Crédito
- Intereses pendientes
- Total proyectado

===========================================================
EJERCICIO 20
===========================================================

Construir un Semáforo Crediticio.

Reglas:

Verde:
Score > 700

Amarillo:
Score entre 500 y 700

Rojo:
Score < 500

Mostrar:

- Cliente
- Score
- Semáforo

===========================================================
BONUS 1
===========================================================

Top 10 clientes con mayor deuda consolidada.

Formula:

Saldo Crédito
+
Deuda Activa
+
Deuda Externa

===========================================================
BONUS 2
===========================================================

Generar un ranking de clientes utilizando
la función DENSE_RANK().

Ordenar por:

- Monto total desembolsado

===========================================================
BONUS 3
===========================================================

Construir una clasificación ABC de clientes.

A = Top 20%
B = Siguiente 30%
C = Restante 50%

Basado en:

Monto total de créditos.

===========================================================
BONUS 4
===========================================================

Identificar clientes con riesgo de refinanciación.

Condiciones:

- Más de 5 cuotas pendientes
- Saldo crédito > 50% del monto original

===========================================================
BONUS 5
===========================================================

Construir un reporte ejecutivo con:

- Cliente
- Número de créditos
- Total desembolsado
- Total pagado
- Saldo pendiente
- Score riesgo
- Nivel endeudamiento

Ordenado por mayor saldo pendiente.
===========================================================
*/