
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================

--ESTOS CAMBIOS NO FUERON APLICADOS PARA RESOLVER LA SEGUNDA SECCION YA QUE SOLO ESTAN RELACIONADOS CON LAS PRIMERAS 4 RESPUESTAS

--NO AGREGFE INSERSION DE DARTOS POQUE NO SON TABLAS QUE SE TRABAJARNO ACTUALIZARN POR LO REQUERIDO EN LA SEGUNDA SECCION

--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================

--le cree una nueva db llamda BellezaPerfecta  para no utilizar la master ya que ahi estoy trabajando otras tablas.
CREATE DATABASE BellezaPerfecta;
GO 

USE BellezaPerfecta;
GO
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ===================================================================
-- Script para  la ESTRUCTURA MEJORADA de la Base de Datos BellezaPerfecta
-- Schema: BellezaPerfecta_Mejorada
-- ORGANIZADO EN DOS FASES: 
--   1. Creación de Tablas
--   2. Adición de Constraints, Índices y Datos Iniciales
-- ===================================================================

-- Crear el nuevo schema para la estructura mejorada
CREATE SCHEMA BellezaPerfecta_Mejorada;
GO

CREATE TABLE BellezaPerfecta_Mejorada.Sucursal (
  id_sucursal INT PRIMARY KEY IDENTITY,
  nombre VARCHAR(255) NOT NULL UNIQUE,
  direccion VARCHAR(500) NULL,
  telefono VARCHAR(20) NULL,
  fecha_apertura DATE NULL,
  activo BIT NOT NULL DEFAULT 1,
  fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP
);
GO

CREATE TABLE BellezaPerfecta_Mejorada.Marca (
  id_marca INT PRIMARY KEY IDENTITY,
  nombre VARCHAR(100) NOT NULL UNIQUE,
  descripcion VARCHAR(255) NULL,
  fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP
);
GO

-- -----------------------------------------------------
-- Tabla: BellezaPerfecta_Mejorada.Proveedor
-- -----------------------------------------------------
CREATE TABLE BellezaPerfecta_Mejorada.Proveedor (
  id_proveedor INT PRIMARY KEY IDENTITY,
  nombre VARCHAR(255) NOT NULL,
  nit VARCHAR(20) NULL UNIQUE,
  direccion VARCHAR(500) NULL,
  telefono_contacto VARCHAR(20) NULL,
  email_contacto VARCHAR(255) NULL,
  fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP
);
GO

-- -----------------------------------------------------
-- Tabla: BellezaPerfecta_Mejorada.RolEmpleado
-- -----------------------------------------------------
CREATE TABLE BellezaPerfecta_Mejorada.RolEmpleado (
  id_rol INT PRIMARY KEY IDENTITY,
  nombre_rol VARCHAR(100) NOT NULL UNIQUE,
  descripcion VARCHAR(255) NULL
);
GO

-- -----------------------------------------------------
-- Tabla: BellezaPerfecta_Mejorada.Cliente
-- -----------------------------------------------------
CREATE TABLE BellezaPerfecta_Mejorada.Cliente (
  id_cliente INT PRIMARY KEY IDENTITY,
  nombres VARCHAR(255) NOT NULL,
  apellidos VARCHAR(255) NOT NULL,
  fecha_nacimiento DATE NULL,
  genero CHAR(1) NULL CHECK (genero IN ('M', 'F', 'O')), 
  ocupacion VARCHAR(100) NULL,
  estado_civil VARCHAR(50) NULL, 
  num_identificacion VARCHAR(50) NULL UNIQUE, 
  nit VARCHAR(20) NULL,
  email VARCHAR(255) NULL UNIQUE, 
  telefono VARCHAR(20) NOT NULL, 
  direccion VARCHAR(500) NULL,
  id_departamento INT NULL, -- FK se añadirá después
  contacto_emergencia_nombre VARCHAR(255) NULL,
  contacto_emergencia_telefono VARCHAR(20) NULL,
  fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP
);
GO

-- -----------------------------------------------------
-- Tabla: BellezaPerfecta_Mejorada.Empleado
-- -----------------------------------------------------
CREATE TABLE BellezaPerfecta_Mejorada.Empleado (
  id_empleado INT PRIMARY KEY IDENTITY,
  nombre VARCHAR(255) NOT NULL,
  apellidos VARCHAR(255) NOT NULL,
  fecha_nacimiento DATE NULL,
  genero CHAR(1) NULL CHECK (genero IN ('M', 'F', 'O')),
  direccion VARCHAR(500) NULL,
  estado_civil VARCHAR(50) NULL,
  num_identificacion VARCHAR(50) NOT NULL UNIQUE, 
  email VARCHAR(255) NOT NULL UNIQUE,
  telefono VARCHAR(20) NOT NULL,
  id_rol INT NOT NULL, -- FK se añadirá después
  id_sucursal INT NOT NULL, -- FK se añadirá después
  fecha_contratacion DATE NOT NULL,
  fecha_baja DATE NULL,
  activo BIT NOT NULL DEFAULT 1,
  fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP
);
GO

-- -----------------------------------------------------
-- Tabla: BellezaPerfecta_Mejorada.Producto (Catálogo general)
-- -----------------------------------------------------
CREATE TABLE BellezaPerfecta_Mejorada.Producto (
  id_producto INT PRIMARY KEY IDENTITY,
  nombre VARCHAR(255) NOT NULL,
  descripcion TEXT NULL,
  id_marca INT NOT NULL, -- FK se añadirá después
  id_proveedor INT NULL, -- FK se añadirá después
  precio_venta_sugerido DECIMAL(10,2) NOT NULL,
  costo_promedio DECIMAL(10,2) NULL, 
  unidad_medida VARCHAR(50) NULL, 
  tipo VARCHAR(10) NOT NULL CHECK (tipo IN ('Insumo', 'Venta')), 
  activo BIT NOT NULL DEFAULT 1,
  fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
  fecha_actualizacion DATETIME NULL
);
GO

-- -----------------------------------------------------
-- Tabla: BellezaPerfecta_Mejorada.Stock (Inventario por Sucursal)
-- -----------------------------------------------------
CREATE TABLE BellezaPerfecta_Mejorada.Stock (
  id_stock INT PRIMARY KEY IDENTITY,
  id_producto INT NOT NULL, -- FK se añadirá después
  id_sucursal INT NOT NULL, -- FK se añadirá después
  cantidad_disponible DECIMAL(10,2) NOT NULL DEFAULT 0, 
  punto_reorden DECIMAL(10,2) NULL,
  ubicacion_almacen VARCHAR(100) NULL, 
  fecha_ultima_actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP
);
GO

-- -----------------------------------------------------
-- Tabla: BellezaPerfecta_Mejorada.Servicio (Catálogo general)
-- -----------------------------------------------------
CREATE TABLE BellezaPerfecta_Mejorada.Servicio (
  id_servicio INT PRIMARY KEY IDENTITY,
  nombre VARCHAR(255) NOT NULL,
  descripcion TEXT NULL,
  precio DECIMAL(10,2) NOT NULL,
  comision_base DECIMAL(6,4) NOT NULL, 
  duracion_estimada_minutos INT NULL, 
  activo BIT NOT NULL DEFAULT 1,
  fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
  fecha_actualizacion DATETIME NULL
);
GO

-- -----------------------------------------------------
-- Tabla: BellezaPerfecta_Mejorada.Cita
-- -----------------------------------------------------
CREATE TABLE BellezaPerfecta_Mejorada.Cita (
  id_cita INT PRIMARY KEY IDENTITY,
  id_cliente INT NOT NULL, -- FK se añadirá después
  id_empleado_especialista INT NOT NULL, -- FK se añadirá después
  id_servicio INT NOT NULL, -- FK se añadirá después
  id_sucursal INT NOT NULL, -- FK se añadirá después
  fecha_hora_cita DATETIME NOT NULL,
  estado_cita VARCHAR(20) NOT NULL CHECK (estado_cita IN ('Programada', 'Confirmada', 'Realizada', 'Cancelada', 'No Asistio')),
  notas_cita TEXT NULL,
  fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP
);
GO

-- -----------------------------------------------------
-- Tabla: BellezaPerfecta_Mejorada.HistoriaClinica (Cabecera, 1 por cliente)
-- -----------------------------------------------------
CREATE TABLE BellezaPerfecta_Mejorada.HistoriaClinica (
  id_historia INT PRIMARY KEY IDENTITY,
  id_cliente INT NOT NULL UNIQUE, -- FK se añadirá después
  alergias_conocidas TEXT NULL,
  condiciones_preexistentes TEXT NULL,
  medicamentos_actuales TEXT NULL,
  fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
  fecha_ultima_actualizacion DATETIME NULL
);
GO

-- -----------------------------------------------------
-- Tabla: BellezaPerfecta_Mejorada.RegistroHistoria (Detalle cronológico)
-- -----------------------------------------------------
CREATE TABLE BellezaPerfecta_Mejorada.RegistroHistoria (
  id_registro_historia INT PRIMARY KEY IDENTITY,
  id_historia INT NOT NULL, -- FK se añadirá después
  id_cita INT NULL, -- FK se añadirá después
  id_empleado_especialista INT NOT NULL, -- FK se añadirá después
  id_sucursal INT NOT NULL, -- FK se añadirá después
  fecha_registro DATETIME NOT NULL,
  diagnostico TEXT NULL,
  tratamiento_realizado TEXT NULL, 
  procedimientos_efectuados TEXT NULL, 
  notas_seguimiento TEXT NULL
);
GO

-- -----------------------------------------------------
-- Tabla: BellezaPerfecta_Mejorada.Factura_Encabezado
-- -----------------------------------------------------
CREATE TABLE BellezaPerfecta_Mejorada.Factura_Encabezado (
  id_factura_encabezado INT PRIMARY KEY IDENTITY,
  id_cliente INT NOT NULL, -- FK se añadirá después
  id_sucursal INT NOT NULL, -- FK se añadirá después
  id_cita INT NULL, -- FK se añadirá después
  fecha_emision DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  serie_factura VARCHAR(10) NULL, 
  numero_factura VARCHAR(20) NULL, 
  subtotal DECIMAL(12,2) NOT NULL DEFAULT 0, 
  impuestos DECIMAL(10,2) NOT NULL DEFAULT 0, 
  descuentos DECIMAL(10,2) NOT NULL DEFAULT 0,
  total_factura DECIMAL(12,2) NOT NULL DEFAULT 0, 
  estado_factura VARCHAR(20) NOT NULL CHECK (estado_factura IN ('Emitida', 'Pagada', 'Anulada'))
);
GO

-- -----------------------------------------------------
-- Tabla: BellezaPerfecta_Mejorada.Facturas_Detalle
-- -----------------------------------------------------
CREATE TABLE BellezaPerfecta_Mejorada.Facturas_Detalle (
  id_factura_detalle INT PRIMARY KEY IDENTITY,
  id_factura_encabezado INT NOT NULL, -- FK se añadirá después
  id_producto INT NULL, -- FK se añadirá después
  id_servicio INT NULL, -- FK se añadirá después
  naturaleza CHAR(1) NOT NULL CHECK (naturaleza IN ('B', 'S')), 
  descripcion_item VARCHAR(255) NOT NULL, 
  cantidad INT NOT NULL,
  precio_unitario DECIMAL(10,2) NOT NULL, 
  subtotal_linea DECIMAL(12,2) NOT NULL, 
  impuesto_linea DECIMAL(10,2) NOT NULL DEFAULT 0,
  descuento_linea DECIMAL(10,2) NOT NULL DEFAULT 0,
  total_linea DECIMAL(12,2) NOT NULL,
  id_empleado_atiende INT NOT NULL -- FK se añadirá después
);
GO

-- -----------------------------------------------------
-- Tabla: BellezaPerfecta_Mejorada.Pago
-- -----------------------------------------------------
CREATE TABLE BellezaPerfecta_Mejorada.Pago (
  id_pago INT PRIMARY KEY IDENTITY,
  id_factura_encabezado INT NOT NULL, -- FK se añadirá después
  id_sucursal INT NOT NULL, -- FK se añadirá después
  fecha_pago DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  monto_pagado DECIMAL(12,2) NOT NULL,
  metodo_pago VARCHAR(50) NOT NULL CHECK (metodo_pago IN ('Efectivo', 'Tarjeta Credito', 'Tarjeta Debito', 'Transferencia', 'Cheque', 'Otro')),
  referencia_pago VARCHAR(100) NULL, 
  id_empleado_recibe INT NOT NULL -- FK se añadirá después
);
GO

-- -----------------------------------------------------
-- Tabla: BellezaPerfecta_Mejorada.Comision
-- -----------------------------------------------------
CREATE TABLE BellezaPerfecta_Mejorada.Comision (
  id_comision INT PRIMARY KEY IDENTITY,
  id_empleado INT NOT NULL, -- FK se añadirá después
  id_factura_detalle INT NOT NULL, -- FK se añadirá después
  id_sucursal INT NOT NULL, -- FK se añadirá después
  fecha_generacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  periodo_pago DATE NOT NULL, 
  base_comisionable DECIMAL(12,2) NOT NULL, 
  tasa_comision DECIMAL(6,4) NOT NULL, 
  monto_comision DECIMAL(10,2) NOT NULL, 
  estado_pago VARCHAR(20) NOT NULL CHECK (estado_pago IN ('Pendiente', 'Pagada', 'Retenida', 'Cancelada')),
  fecha_pago_comision DATE NULL
);
GO

-- ===================================================================
-- FASE 2: CONSTRAINTS (FOREIGN KEYS), ÍNDICES Y DATOS INICIALES
-- ===================================================================

-- Constraints e Índices para Cliente
ALTER TABLE BellezaPerfecta_Mejorada.Cliente
  ADD CONSTRAINT FK_Cliente_Departamento FOREIGN KEY (id_departamento) 
  REFERENCES parcialii.Departamento(id_departamento) -- Asume reutilización de parcialii.Departamento
  ON DELETE SET NULL ON UPDATE CASCADE;
GO
CREATE INDEX idx_cliente_email ON BellezaPerfecta_Mejorada.Cliente(email) WHERE email IS NOT NULL; -- Índice en no nulos
GO 
CREATE INDEX idx_cliente_num_identificacion ON BellezaPerfecta_Mejorada.Cliente(num_identificacion) WHERE num_identificacion IS NOT NULL;
GO 

-- Constraints e Índices para Empleado
ALTER TABLE BellezaPerfecta_Mejorada.Empleado
  ADD CONSTRAINT FK_Empleado_Rol FOREIGN KEY (id_rol) REFERENCES BellezaPerfecta_Mejorada.RolEmpleado(id_rol)
  ON DELETE RESTRICT ON UPDATE CASCADE;
GO
ALTER TABLE BellezaPerfecta_Mejorada.Empleado
  ADD CONSTRAINT FK_Empleado_Sucursal FOREIGN KEY (id_sucursal) REFERENCES BellezaPerfecta_Mejorada.Sucursal(id_sucursal)
  ON DELETE RESTRICT ON UPDATE CASCADE;
GO
CREATE INDEX idx_empleado_email ON BellezaPerfecta_Mejorada.Empleado(email);
GO
CREATE INDEX idx_empleado_num_identificacion ON BellezaPerfecta_Mejorada.Empleado(num_identificacion);
GO

-- Constraints para Producto
ALTER TABLE BellezaPerfecta_Mejorada.Producto
  ADD CONSTRAINT FK_Producto_Marca FOREIGN KEY (id_marca) REFERENCES BellezaPerfecta_Mejorada.Marca(id_marca)
  ON DELETE RESTRICT ON UPDATE CASCADE;
GO
ALTER TABLE BellezaPerfecta_Mejorada.Producto
  ADD CONSTRAINT FK_Producto_Proveedor FOREIGN KEY (id_proveedor) REFERENCES BellezaPerfecta_Mejorada.Proveedor(id_proveedor)
  ON DELETE SET NULL ON UPDATE CASCADE;
GO

-- Constraints para Stock
ALTER TABLE BellezaPerfecta_Mejorada.Stock
  ADD CONSTRAINT UQ_Stock_Producto_Sucursal UNIQUE (id_producto, id_sucursal);
GO
ALTER TABLE BellezaPerfecta_Mejorada.Stock
  ADD CONSTRAINT FK_Stock_Producto FOREIGN KEY (id_producto) REFERENCES BellezaPerfecta_Mejorada.Producto(id_producto)
  ON DELETE CASCADE ON UPDATE CASCADE;
GO
ALTER TABLE BellezaPerfecta_Mejorada.Stock
  ADD CONSTRAINT FK_Stock_Sucursal FOREIGN KEY (id_sucursal) REFERENCES BellezaPerfecta_Mejorada.Sucursal(id_sucursal)
  ON DELETE CASCADE ON UPDATE CASCADE; -- O RESTRICT según reglas de negocio
GO

-- Constraints e Índices para Cita
ALTER TABLE BellezaPerfecta_Mejorada.Cita
  ADD CONSTRAINT FK_Cita_Cliente FOREIGN KEY (id_cliente) REFERENCES BellezaPerfecta_Mejorada.Cliente(id_cliente)
  ON DELETE CASCADE ON UPDATE CASCADE; -- O RESTRICT
GO
ALTER TABLE BellezaPerfecta_Mejorada.Cita
  ADD CONSTRAINT FK_Cita_Empleado FOREIGN KEY (id_empleado_especialista) REFERENCES BellezaPerfecta_Mejorada.Empleado(id_empleado)
  ON DELETE RESTRICT ON UPDATE CASCADE;
GO
ALTER TABLE BellezaPerfecta_Mejorada.Cita
  ADD CONSTRAINT FK_Cita_Servicio FOREIGN KEY (id_servicio) REFERENCES BellezaPerfecta_Mejorada.Servicio(id_servicio)
  ON DELETE RESTRICT ON UPDATE CASCADE;
GO
ALTER TABLE BellezaPerfecta_Mejorada.Cita
  ADD CONSTRAINT FK_Cita_Sucursal FOREIGN KEY (id_sucursal) REFERENCES BellezaPerfecta_Mejorada.Sucursal(id_sucursal)
  ON DELETE RESTRICT ON UPDATE CASCADE;
GO
CREATE INDEX idx_cita_fecha ON BellezaPerfecta_Mejorada.Cita(fecha_hora_cita);
GO
CREATE INDEX idx_cita_cliente ON BellezaPerfecta_Mejorada.Cita(id_cliente);
GO
CREATE INDEX idx_cita_empleado ON BellezaPerfecta_Mejorada.Cita(id_empleado_especialista);
GO

-- Constraints para HistoriaClinica
ALTER TABLE BellezaPerfecta_Mejorada.HistoriaClinica
  ADD CONSTRAINT FK_Historia_Cliente FOREIGN KEY (id_cliente) REFERENCES BellezaPerfecta_Mejorada.Cliente(id_cliente)
  ON DELETE CASCADE ON UPDATE CASCADE;
GO

-- Constraints para RegistroHistoria
ALTER TABLE BellezaPerfecta_Mejorada.RegistroHistoria
  ADD CONSTRAINT FK_RegistroH_Historia FOREIGN KEY (id_historia) REFERENCES BellezaPerfecta_Mejorada.HistoriaClinica(id_historia)
  ON DELETE CASCADE ON UPDATE CASCADE;
GO
ALTER TABLE BellezaPerfecta_Mejorada.RegistroHistoria
  ADD CONSTRAINT FK_RegistroH_Cita FOREIGN KEY (id_cita) REFERENCES BellezaPerfecta_Mejorada.Cita(id_cita)
  ON DELETE SET NULL ON UPDATE CASCADE;
GO
ALTER TABLE BellezaPerfecta_Mejorada.RegistroHistoria
  ADD CONSTRAINT FK_RegistroH_Empleado FOREIGN KEY (id_empleado_especialista) REFERENCES BellezaPerfecta_Mejorada.Empleado(id_empleado)
  ON DELETE RESTRICT ON UPDATE CASCADE;
GO
ALTER TABLE BellezaPerfecta_Mejorada.RegistroHistoria
  ADD CONSTRAINT FK_RegistroH_Sucursal FOREIGN KEY (id_sucursal) REFERENCES BellezaPerfecta_Mejorada.Sucursal(id_sucursal)
  ON DELETE RESTRICT ON UPDATE CASCADE;
GO

-- Constraints e Índices para Factura_Encabezado
ALTER TABLE BellezaPerfecta_Mejorada.Factura_Encabezado
  ADD CONSTRAINT FK_FactEnc_Cliente FOREIGN KEY (id_cliente) REFERENCES BellezaPerfecta_Mejorada.Cliente(id_cliente)
  ON DELETE RESTRICT ON UPDATE CASCADE;
GO
ALTER TABLE BellezaPerfecta_Mejorada.Factura_Encabezado
  ADD CONSTRAINT FK_FactEnc_Sucursal FOREIGN KEY (id_sucursal) REFERENCES BellezaPerfecta_Mejorada.Sucursal(id_sucursal)
  ON DELETE RESTRICT ON UPDATE CASCADE;
GO
ALTER TABLE BellezaPerfecta_Mejorada.Factura_Encabezado
  ADD CONSTRAINT FK_FactEnc_Cita FOREIGN KEY (id_cita) REFERENCES BellezaPerfecta_Mejorada.Cita(id_cita)
  ON DELETE SET NULL ON UPDATE CASCADE;
GO
CREATE INDEX idx_factenc_cliente ON BellezaPerfecta_Mejorada.Factura_Encabezado(id_cliente);
GO
CREATE INDEX idx_factenc_fecha ON BellezaPerfecta_Mejorada.Factura_Encabezado(fecha_emision);
GO

-- Constraints para Facturas_Detalle
ALTER TABLE BellezaPerfecta_Mejorada.Facturas_Detalle
  ADD CONSTRAINT FK_FactDet_Encabezado FOREIGN KEY (id_factura_encabezado) REFERENCES BellezaPerfecta_Mejorada.Factura_Encabezado(id_factura_encabezado)
  ON DELETE CASCADE ON UPDATE CASCADE;
GO
ALTER TABLE BellezaPerfecta_Mejorada.Facturas_Detalle
  ADD CONSTRAINT FK_FactDet_Producto FOREIGN KEY (id_producto) REFERENCES BellezaPerfecta_Mejorada.Producto(id_producto)
  ON DELETE RESTRICT ON UPDATE CASCADE;
GO
ALTER TABLE BellezaPerfecta_Mejorada.Facturas_Detalle
  ADD CONSTRAINT FK_FactDet_Servicio FOREIGN KEY (id_servicio) REFERENCES BellezaPerfecta_Mejorada.Servicio(id_servicio)
  ON DELETE RESTRICT ON UPDATE CASCADE;
GO
ALTER TABLE BellezaPerfecta_Mejorada.Facturas_Detalle
  ADD CONSTRAINT FK_FactDet_Empleado FOREIGN KEY (id_empleado_atiende) REFERENCES BellezaPerfecta_Mejorada.Empleado(id_empleado)
  ON DELETE RESTRICT ON UPDATE CASCADE;
GO

-- Constraints para Pago
ALTER TABLE BellezaPerfecta_Mejorada.Pago
  ADD CONSTRAINT FK_Pago_FacturaEnc FOREIGN KEY (id_factura_encabezado) REFERENCES BellezaPerfecta_Mejorada.Factura_Encabezado(id_factura_encabezado)
  ON DELETE RESTRICT ON UPDATE CASCADE; -- O CASCADE si al anular factura se borran pagos?
GO
ALTER TABLE BellezaPerfecta_Mejorada.Pago
  ADD CONSTRAINT FK_Pago_Sucursal FOREIGN KEY (id_sucursal) REFERENCES BellezaPerfecta_Mejorada.Sucursal(id_sucursal)
  ON DELETE RESTRICT ON UPDATE CASCADE;
GO
ALTER TABLE BellezaPerfecta_Mejorada.Pago
  ADD CONSTRAINT FK_Pago_Empleado FOREIGN KEY (id_empleado_recibe) REFERENCES BellezaPerfecta_Mejorada.Empleado(id_empleado)
  ON DELETE RESTRICT ON UPDATE CASCADE;
GO

-- Constraints e Índices para Comision
ALTER TABLE BellezaPerfecta_Mejorada.Comision
  ADD CONSTRAINT FK_Comision_Empleado FOREIGN KEY (id_empleado) REFERENCES BellezaPerfecta_Mejorada.Empleado(id_empleado)
  ON DELETE RESTRICT ON UPDATE CASCADE;
GO
ALTER TABLE BellezaPerfecta_Mejorada.Comision
  ADD CONSTRAINT FK_Comision_FactDet FOREIGN KEY (id_factura_detalle) REFERENCES BellezaPerfecta_Mejorada.Facturas_Detalle(id_factura_detalle)
  ON DELETE RESTRICT ON UPDATE CASCADE; -- O CASCADE?
GO
ALTER TABLE BellezaPerfecta_Mejorada.Comision
  ADD CONSTRAINT FK_Comision_Sucursal FOREIGN KEY (id_sucursal) REFERENCES BellezaPerfecta_Mejorada.Sucursal(id_sucursal)
  ON DELETE RESTRICT ON UPDATE CASCADE;
GO
CREATE INDEX idx_comision_empleado_periodo ON BellezaPerfecta_Mejorada.Comision(id_empleado, periodo_pago);
GO

--==================================================================================================================================
--==================================================================================================================================
-- Fin del Script de Creación de Estructura Mejorada. (RELACIONADO A LAS PRIMERAS 4 PREGUNTAS)
--==================================================================================================================================
--==================================================================================================================================