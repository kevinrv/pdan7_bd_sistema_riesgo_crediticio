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

CREATE TABLE personas_juridicas( id INT IDENTITY(1,1) PRIMARY KEY, ruc VARCHAR(11) UNIQUE NOT NULL, razon_social VARCHAR(255) NOT NULL, nombre_comercial VARCHAR(255) NULL, tipo_empresa VARCHAR(100) NOT NULL, representante_legal VARCHAR(200) NOT NULL,sector_economico VARCHAR(100) NULL, direccion VARCHAR(255) NOT NULL, ubigeo CHAR(6) NULL, telefono VARCHAR(20) NULL, correo VARCHAR(255) NULL, fecha_constitucion DATE NOT NULL, estado_empresa VARCHAR(50) NOT NULL, inicio_actividades DATE NOT NULL,numero_empleados INT NOT NULL,cliente_id INT UNIQUE NOT NULL, CONSTRAINT fk_clientes_persona_juridica FOREIGN KEY (cliente_id) REFERENCES clientes(id) );

