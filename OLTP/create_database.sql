--- Creacion de base de datos

CREATE DATABASE pdan_bd_sistema_riesgo_crediticio;
GO

--- Seleccionar base de datos
USE pdan_bd_sistema_riesgo_crediticio;
GO

--- Creación de tablas

--- Clientes

CREATE TABLE clientes (
id INT IDENTITY(1,1) PRIMARY KEY,
tipo_cliente VARCHAR(1) NOT NULL
);

--- Personas Naturales

CREATE TABLE personas_naturales(
id INT IDENTITY(1,1) PRIMARY KEY,
numero_documento VARCHAR(15) UNIQUE NOT NULL,
nombres VARCHAR(255) NOT NULL,
apellido_paterno VARCHAR(255) NOT NULL,
apellido_materno VARCHAR(255) NOT NULL,
celular VARCHAR(20) UNIQUE NOT NULL,
direccion VARCHAR(255) NOT NULL,
ubigeo CHAR(6) NULL,
fecha_nacimiento DATE NOT NULL,
estado_civil VARCHAR(10) NOT NULL,
genero VARCHAR(10) NOT NULL,
situacion_laboral VARCHAR(100) NULL,
cliente_id INT UNIQUE NOT NULL,
CONSTRAINT fk_clientes_persona_natural FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

-- Personas juridicas
CREATE TABLE personas_juridicas( id INT IDENTITY(1,1) PRIMARY KEY, ruc VARCHAR(11) UNIQUE NOT NULL, razon_social VARCHAR(255) NOT NULL, nombre_comercial VARCHAR(255) NULL, tipo_empresa VARCHAR(100) NOT NULL, representante_legal VARCHAR(200) NOT NULL,sector_economico VARCHAR(100) NULL, direccion VARCHAR(255) NOT NULL, ubigeo CHAR(6) NULL, telefono VARCHAR(20) NULL, correo VARCHAR(255) NULL, fecha_constitucion DATE NOT NULL, estado_empresa VARCHAR(50) NOT NULL,	inicio_actividades DATE NOT NULL,numero_empleados INT NULL,cliente_id INT UNIQUE NOT NULL, CONSTRAINT fk_clientes_persona_juridica FOREIGN KEY (cliente_id) REFERENCES clientes(id) );

-- Tipos_cuenta

CREATE TABLE tipos_cuenta (
id INT IDENTITY(1,1) PRIMARY KEY,
nombre VARCHAR(100) UNIQUE NOT NULL,
descripcion VARCHAR (255) NULL);

-- Cuentas

CREATE TABLE cuentas(
id INT IDENTITY(1,1) PRIMARY KEY,
num_cuenta VARCHAR (50) UNIQUE NOT NULL,
cci VARCHAR(55) UNIQUE NOT NULL,
num_tarjeta VARCHAR(30) UNIQUE NOT NULL,
fecha_creacion DATETIME NOT NULL,
moneda VARCHAR(50) NOT NULL,
saldo MONEY NOT NULL,
tipo_cuenta_id INT NOT NULL,
CONSTRAINT fk_tipos_cuenta FOREIGN KEY (tipo_cuenta_id) REFERENCES tipos_cuenta(id)
);

-- cuentas_clientes

CREATE TABLE cuentas_clientes (
id INT IDENTITY(1,1) PRIMARY KEY,
cliente_id INT NOT NULL,
cuenta_id INT NOT NULL,
CONSTRAINT fk_cliente_cuentas FOREIGN KEY (cliente_id) REFERENCES clientes(id),
CONSTRAINT fk_cuentas_cliente FOREIGN KEY (cuenta_id) REFERENCES cuentas(id)
);

-- Productos crediticios

CREATE TABLE productos_crediticios (
id INT IDENTITY(1,1) PRIMARY KEY,
nombre VARCHAR(155) UNIQUE NOT NULL,
monto_minimo MONEY NOT NULL,
monto_maximo MONEY NOT NULL,
tasa_interes_minima DECIMAL(9,2) NOT NULL,
tasa_interes_maxima DECIMAL(9,2) NOT NULL,
plazo_minimo_meses INT NOT NULL,
plazo_maximo_meses INT NOT NULL,
estado VARCHAR(55),
created_at DATETIME NOT NULL,
updated_at DATETIME NOT NULL,
deleted_at DATETIME NULL
);

-- Solicitudes

CREATE TABLE solicitudes ( 
id INT IDENTITY(1,1) PRIMARY KEY, 
cliente_id INT NOT NULL, 
producto_crediticio_id INT NOT NULL,
codigo_solicitud VARCHAR(50) NOT NULL,
fecha_solicitud DATETIME NOT NULL,
monto_solicitado DECIMAL(18,2) NOT NULL,
moneda_solicitada VARCHAR(10) NOT NULL, 
estado VARCHAR(50) NOT NULL, 
CONSTRAINT CHK_monto_solicitado CHECK (monto_solicitado >= 1000),
CONSTRAINT CHK_moneda_solicitada CHECK (moneda_solicitada IN ('PEN', 'USD', 'EUR')),
CONSTRAINT UQ_solicitudes_codigo UNIQUE (codigo_solicitud),
CONSTRAINT FK_solicitudes_clientes FOREIGN KEY (cliente_id) REFERENCES clientes(id),
CONSTRAINT FK_solicitudes_productos_crediticios FOREIGN KEY (producto_crediticio_id) REFERENCES productos_crediticios(id) );

-- Evaluaciones crediticias

CREATE TABLE evaluaciones_crediticias 
( id INT IDENTITY(1,1) PRIMARY KEY, 
solicitud_id INT NOT NULL, 
score_riesgo DECIMAL(10,2) NOT NULL,
nivel_endeudamiento DECIMAL(10,2) NOT NULL,
deuda_activa MONEY NOT NULL,
deuda_activa_otras_entidades MONEY NOT NULL, 
linea_credito MONEY NOT NULL, 
linea_credito_otras_entidades MONEY NOT NULL,
valor_patrimonio MONEY NOT NULL, 
ingresos_mensuales MONEY NOT NULL,
resultado VARCHAR(100) NOT NULL,
CONSTRAINT FK_evaluaciones_solicitudes        FOREIGN KEY (solicitud_id)        REFERENCES solicitudes(id));-- creditosCREATE TABLE creditos(    id INT IDENTITY(1,1) PRIMARY KEY,    evaluacion_crediticia_id INT UNIQUE NOT NULL,    monto MONEY NOT NULL,    plazo_meses INT NOT NULL,    tea DECIMAL(10,2) NOT NULL,    tcea DECIMAL(10,2) NOT NULL,    valor_cuota MONEY NOT NULL,    fecha_inicio DATE NOT NULL,    fecha_fin DATE NOT NULL,    fecha_desembolso DATETIME NOT NULL,    numero_credito INT UNIQUE NOT NULL ,    fecha_vencimiento DATE NOT NULL,    estado VARCHAR(100) NOT NULL,    saldo_credito MONEY NOT NULL,    desgravamen MONEY NOT NULL,    CONSTRAINT FK_creditos        FOREIGN KEY (evaluacion_crediticia_id)        REFERENCES evaluaciones_crediticias(id));--cuotasCREATE TABLE cuotas (    id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,    credito_id INT NOT NULL,    num_cuota INT NOT NULL,    fecha_vencimiento DATETIME NOT NULL,    capital MONEY NOT NULL,    intereses MONEY NOT NULL,    seguros MONEY NOT NULL,    total_cuota MONEY NOT NULL,    estado VARCHAR(30) NOT NULL,    tasa_mora DECIMAL(10,2) NOT NULL,    saldo_cuota MONEY NOT NULL,    CONSTRAINT FK_cuotas_creditos FOREIGN KEY (credito_id) REFERENCES creditos(id),	CONSTRAINT chk_total_cuota CHECK (total_cuota=(capital+intereses+seguros)),	CONSTRAINT chk_saldo_cuota CHECK(saldo_cuota<=(capital+intereses+seguros)));-- PagosCREATE TABLE pagos (    id INT IDENTITY(1,1) PRIMARY KEY,    num_operacion VARCHAR(50) UNIQUE,    monto DECIMAL(18,2),    fecha_pago DATETIME,    metodo_pago VARCHAR(50),    observaciones  VARCHAR(200));-- detalle_cuotas_pagosCREATE TABLE detalle_cuotas_pagos(	id INT IDENTITY(1,1) PRIMARY KEY,	cuota_id INT NOT NULL,	pago_id INT NOT NULL,	monto_pagado MONEY NOT NULL,	FOREIGN KEY (cuota_id) REFERENCES cuotas(id),	FOREIGN KEY (pago_id) REFERENCES pagos(id));