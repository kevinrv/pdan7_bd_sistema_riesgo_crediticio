📊 CASO PROPUESTO
“Sistema de Análisis de Riesgo Crediticio para Entidad Bancaria”
🏦 Contexto del negocio

El banco FinanRisk Perú es una entidad financiera que otorga productos crediticios a personas naturales y jurídicas. En los últimos años, el banco ha experimentado un incremento en la morosidad de sus clientes, lo cual ha impactado negativamente en su rentabilidad.

Actualmente, el proceso de evaluación crediticia es parcialmente manual y no permite un análisis integral del cliente, ya que la información se encuentra dispersa en distintos sistemas.

Por ello, el banco ha decidido desarrollar un Sistema de Análisis de Riesgo Crediticio, que permita:

Evaluar el nivel de riesgo de los clientes antes de otorgar un crédito
Monitorear el comportamiento de pago de los clientes
Detectar clientes potencialmente riesgosos de forma anticipada
Generar indicadores y reportes para la toma de decisiones
🎯 Objetivo del sistema

Diseñar una base de datos que permita:

Registrar información completa de los clientes
Gestionar solicitudes y otorgamientos de créditos
Analizar el comportamiento histórico de pagos
Calcular indicadores de riesgo crediticio
Clasificar a los clientes según su nivel de riesgo
🧩 Alcance funcional

El sistema debe contemplar las siguientes áreas:

1. 👤 Gestión de Clientes

El banco maneja dos tipos de clientes:

Personas naturales
DNI, nombres, apellidos, fecha de nacimiento
ingresos mensuales
situación laboral
Personas jurídicas
RUC, razón social
sector económico
ingresos anuales

Un cliente puede tener múltiples cuentas y múltiples créditos.

2. 💳 Productos Crediticios

El banco ofrece distintos tipos de créditos:

Préstamo personal
Crédito hipotecario
Crédito vehicular
Línea de crédito

Cada producto tiene:

tasa de interés
plazo máximo
monto mínimo y máximo
3. 📝 Solicitudes de Crédito

Antes de otorgar un crédito, el cliente realiza una solicitud que incluye:

Fecha de solicitud
Monto solicitado
Producto crediticio
Estado (aprobado, rechazado, en evaluación)

Cada solicitud es evaluada mediante un score crediticio.

4. 📊 Evaluación de Riesgo

Para cada solicitud se calcula un score de riesgo basado en:

historial crediticio
nivel de endeudamiento
ingresos
comportamiento de pagos

El resultado clasifica al cliente en:

Bajo riesgo
Riesgo medio
Alto riesgo
5. 📅 Créditos y Plan de Pagos

Cuando una solicitud es aprobada:

Se genera un crédito
Se define un cronograma de cuotas

Cada cuota tiene:

número de cuota
fecha de vencimiento
monto
estado (pagado, pendiente, vencido)
6. 💰 Pagos

Los clientes realizan pagos asociados a cuotas:

fecha de pago
monto pagado
tipo de pago

Un pago puede cubrir una o varias cuotas.

7. ⚠️ Seguimiento de Riesgo

El sistema debe permitir:

Identificar cuotas vencidas
Calcular días de mora
Detectar clientes en riesgo
Registrar alertas
📈 Reglas de negocio clave
Un cliente puede tener múltiples créditos, pero cada crédito pertenece a un solo cliente
Un crédito proviene de una sola solicitud aprobada
Una solicitud pertenece a un solo cliente
Un cliente puede tener múltiples solicitudes
Cada crédito tiene múltiples cuotas
Una cuota puede ser pagada en partes o en su totalidad
El score de riesgo se calcula en cada solicitud (no es fijo)
