Create database dbi_Servicios2025

------------------------Creacion de tablas------------------------

----------------------------CLientes------------------------------
CREATE TABLE Clientes (
    Cliente_id INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(200),
    correo VARCHAR(100),
    telefono VARCHAR(20),
);

----------------------------Rutas----------------------------------
CREATE TABLE Rutas (
    Ruta_id INT IDENTITY(1,1) NOT NULL,
    descripcion VARCHAR(200),
    tiempo_estimado INT,
);

----------------------------Pedidos---------------------------------
CREATE TABLE Pedidos (
    Pedido_id INT IDENTITY(1,1) NOT NULL,
    Fecha_solicitud DATETIME NOT NULL,
    productos VARCHAR(100),
    direccion_entrega VARCHAR(200),
    Cliente_id INT NOT NULL,
    Ruta_id INT NOT NULL,
);

----------------------------Detalle_Pedido--------------------------
CREATE TABLE Detalle_Pedido (
    Detalle_pedido_id INT IDENTITY(1,1) NOT NULL,
    Pedido_id INT NOT NULL,
    producto VARCHAR(100) NOT NULL,
    cantidad INT NOT NULL,
);

----------------------------Vehiculos--------------------------------
CREATE TABLE Vehiculos (
    Vehiculo_id INT IDENTITY(1,1) NOT NULL,
    placa VARCHAR(20) NOT NULL,
    tipo VARCHAR(50),
    capacidad INT,
    estado VARCHAR(20),
);

----------------------------Entregas---------------------------------
CREATE TABLE Entregas (
    Entrega_id INT IDENTITY(1,1) NOT NULL,
    Detalle_pedido_id INT NOT NULL,
	Fecha_entrega DATETIME NOT NULL,
	Conductor_id INT NOT NULL,
    Vehiculo_id INT NOT NULL,
    estado VARCHAR(20),
);

----------------------------Conductores-------------------------------
CREATE TABLE Conductores (
    Conductor_id INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    identificacion VARCHAR(20) NOT NULL,
    licencia VARCHAR(20),
    telefono VARCHAR(20),
);
-----------------------------------------------------------------------

----------------------------Consultas----------------------------------

-----------------------------------------------------------------------
Drop table Clientes
Drop table Rutas
Drop table Pedidos
Drop table Detalle_Pedido
Drop table Vehiculos
Drop table Entregas
Drop table Conductores
-----------------------------------------------------------------------
select * from Clientes
select * from Rutas
select * from Pedidos
select * from Detalle_Pedido
select * from Vehiculos
select * from Entregas
select * from Conductores
-----------------------------------------------------------------------

----------------------------Alter Tables-------------------------------
--------------------------Claves primarias-----------------------------

-------------------------------CLientes--------------------------------
ALTER TABLE Clientes 
ADD CONSTRAINT PK_Clientes PRIMARY KEY (Cliente_id);

-------------------------------Rutas-----------------------------------
ALTER TABLE Rutas
ADD CONSTRAINT PK_Rutas PRIMARY KEY (Ruta_id);

----------------------------Pedidos------------------------------------
ALTER TABLE Pedidos 
ADD CONSTRAINT PK_Pedidos PRIMARY KEY (Pedido_id);

----------------------------Detalle_Pedido-----------------------------
ALTER TABLE Detalle_Pedido
ADD CONSTRAINT PK_DetallePedido PRIMARY KEY (Detalle_pedido_id);

----------------------------Vehiculos----------------------------------
ALTER TABLE Vehiculos 
ADD CONSTRAINT PK_Vehiculos PRIMARY KEY (Vehiculo_id);

----------------------------Entregas------------------------------------
ALTER TABLE Entregas 
ADD CONSTRAINT PK_Entregas PRIMARY KEY (Entrega_id);

----------------------------Conductores---------------------------------
ALTER TABLE Conductores 
ADD CONSTRAINT PK_Conductores PRIMARY KEY (Conductor_id);

------------------------------------------------------------------------
--------------------------Claves foraneas-------------------------------

-------------Pedidos, relación con Clientes y Rutas---------------------
ALTER TABLE Pedidos 
ADD CONSTRAINT FK_Pedidos_Clientes FOREIGN KEY (Cliente_id) REFERENCES Clientes(Cliente_id),
    CONSTRAINT FK_Pedidos_Rutas FOREIGN KEY (Ruta_id) REFERENCES Rutas(Ruta_id);


---------------Detalle_Pedido, relación con Pedidos---------------------
ALTER TABLE Detalle_Pedido 
ADD CONSTRAINT FK_DetallePedido_Pedidos FOREIGN KEY (Pedido_id) REFERENCES Pedidos(Pedido_id);

--------Entregas, relación con Pedidos, Conductores y Vehículos----------
ALTER TABLE Entregas 
ADD CONSTRAINT FK_Entregas_Detalle_Pedidos FOREIGN KEY (Detalle_pedido_id) REFERENCES Detalle_Pedido(Detalle_pedido_id),
    CONSTRAINT FK_Entregas_Conductores FOREIGN KEY (Conductor_id) REFERENCES Conductores(Conductor_id),
    CONSTRAINT FK_Entregas_Vehiculos FOREIGN KEY (Vehiculo_id) REFERENCES Vehiculos(Vehiculo_id);

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------Consultas----------------------------------
SELECT 
    TABLE_NAME, 
    CONSTRAINT_NAME, 
    CONSTRAINT_TYPE
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'dbo'


--TABLE_NAME = Nombre de la tabla en la base de datos
--CONSTRAINT_NAME = Nombre de la restricción
--CONSTRAINT_TYPE = Tipo de la restricción la cual puede ser de 4 tipos CHECK,UNIQUE,PRIMARY KEY,FOREIGN KEY

--TABLE_SCHEMA = Nombre del esquema de la tabla, se usa para seleccionar solo las tablas que pertenecen a un esquema específico, en este caso, dbo



