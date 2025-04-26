-- Crear base de datos 
CREATE DATABASE Libreria;
USE Libreria;

------------------------------------------------------------
-- Creación de Tablas
------------------------------------------------------------

-- Crear tabla clientes
CREATE TABLE clientes (
    cliente_id INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) NOT NULL,
    telefono VARCHAR(15),
    direccion VARCHAR(255),
    CONSTRAINT UQ_clientes_correo UNIQUE (correo)
);

-- Crear tabla libros
CREATE TABLE libros (
    libro_id INT IDENTITY(1,1) NOT NULL,
    titulo VARCHAR(150) NOT NULL,
    autor VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL
);


-- Crear tabla pedidos
CREATE TABLE pedidos (
    pedido_id INT IDENTITY(1,1) NOT NULL,
    cliente_id INT NOT NULL,
    fecha_pedido DATETIME NOT NULL,
    total DECIMAL(10,2) NOT NULL
);

-- Crear tabla detalle_pedido
CREATE TABLE detalle_pedido (
    detalle_id INT IDENTITY(1,1) NOT NULL,
    pedido_id INT NOT NULL,
    libro_id INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL
);

------------------------------------------------------------
-- Agregar Constraints mediante ALTER TABLE
------------------------------------------------------------

-- Claves primarias
ALTER TABLE clientes
ADD CONSTRAINT PK_clientes PRIMARY KEY (cliente_id);

ALTER TABLE libros
ADD CONSTRAINT PK_libros PRIMARY KEY (libro_id);

ALTER TABLE pedidos
ADD CONSTRAINT PK_pedidos PRIMARY KEY (pedido_id);

ALTER TABLE detalle_pedido
ADD CONSTRAINT PK_detalle_pedido PRIMARY KEY (detalle_id);

-- Claves foráneas

-- En pedidos, relacionar cliente_id con clientes(cliente_id)
ALTER TABLE pedidos
ADD CONSTRAINT FK_pedidos_clientes FOREIGN KEY (cliente_id)
    REFERENCES clientes(cliente_id);

-- En detalle_pedido, relacionar pedido_id con pedidos(pedido_id)
ALTER TABLE detalle_pedido
ADD CONSTRAINT FK_detalle_pedido_pedidos FOREIGN KEY (pedido_id)
    REFERENCES pedidos(pedido_id);

-- En detalle_pedido, relacionar libro_id con libros(libro_id)
ALTER TABLE detalle_pedido
ADD CONSTRAINT FK_detalle_pedido_libros FOREIGN KEY (libro_id)
    REFERENCES libros(libro_id);

-------------------------------------------------------------
-- Operaciones CRUD
-------------------------------------------------------------


--Create/Instert---------------------------------------------
-- Insertar al menos 3 clientes
INSERT INTO clientes (nombre, correo, telefono, direccion)
VALUES
('Juan Perez', 'juan.perez@mail.com', '555-1234', 'Calle 1, Ciudad A'),
('Maria Lopez', 'maria.lopez@mail.com', '555-5678', 'Avenida 2, Ciudad B'),
('Carlos Garcia', 'carlos.garcia@mail.com', '555-9012', 'Boulevard 3, Ciudad C');

-- Insertar 5 libros
INSERT INTO libros (titulo, autor, precio, stock)
VALUES
('Aprendiendo SQL', 'Autor A', 25.50, 10),
('Programación en Python', 'Autor B', 30.00, 5),
('Introducción a Java', 'Autor C', 20.75, 8),
('Diseño de Bases de Datos', 'Autor D', 35.00, 3),
('Desarrollo Web', 'Autor E', 40.00, 7);

-- Insertar 2 pedidos (usando cliente_id 1 y 2, que ya existen)
INSERT INTO pedidos (cliente_id, fecha_pedido, total)
VALUES
(1, GETDATE(), 55.50),
(2, GETDATE(), 75.25);

-- Insertar detalles de pedido
--- l= libros p= pedidos
INSERT INTO detalle_pedido (pedido_id, libro_id, cantidad, precio_unitario)
SELECT p.pedido_id, l.libro_id, 1, l.precio
FROM pedidos p
JOIN libros l ON l.libro_id IN (1, 3)  -- Selecciona libros específicos
WHERE p.pedido_id = 4;

-- Inserta registros en la tabla detalle_pedido tomando datos de otras tablas
-- Se seleccionan el pedido_id y libro_id desde las tablas pedidos y libros
-- Se asigna una cantidad fija de 1 y se toma el precio del libro
-- Se filtran los libros para que solo sean los de libro_id 2 y 4
-- Se asegura que los detalles se relacionen con el pedido de ID 5

INSERT INTO detalle_pedido (pedido_id, libro_id, cantidad, precio_unitario)
SELECT p.pedido_id, l.libro_id, 1, l.precio
FROM pedidos p
JOIN libros l ON l.libro_id IN (2, 4)
WHERE p.pedido_id = 5;
--------------------------------------------------------------------------------


--Read/Consultar datos mediante un select---------------------------------------
-- Obtener todos los clientes registrados
SELECT * FROM clientes;

-- Listar los libros disponibles en la tienda
SELECT * FROM libros;

-- Consultar los pedidos de un cliente específico 
SELECT * FROM pedidos WHERE cliente_id = 1;

-- Mostrar los detalles de un pedido determinado 
SELECT dp.detalle_id, dp.pedido_id, dp.libro_id, dp.cantidad, dp.precio_unitario, l.titulo
FROM detalle_pedido dp
JOIN libros l ON dp.libro_id = l.libro_id
WHERE dp.pedido_id = 5;
---------------------------------------------------------------------------------------------


-- Update ------------------------------------------------------------------------------------

-- Modificar la dirección de un cliente 
UPDATE clientes
SET direccion = 'Nueva Dirección, Ciudad A'
WHERE cliente_id = 1;

-- Cambiar el precio de un libro (por ejemplo, libro_id = 1)
UPDATE libros
SET precio = 27.00
WHERE libro_id = 1;

-- Actualizar la cantidad de un libro en un pedido 
UPDATE detalle_pedido
SET cantidad = 2
WHERE detalle_id = 1;
----------------------------------------------------------------------------------------------------


-------Delete---------------------------------------------------------------------------------------
-- Eliminar un cliente específico 
DELETE FROM clientes
WHERE cliente_id = 3;

-- Borrar un libro del inventario 
DELETE FROM libros
WHERE libro_id = 5;

-- Eliminar un pedido y asegurar la eliminación de los detalles asociados
-- Primero eliminar los detalles asociados, luego el pedido.
DELETE FROM detalle_pedido
WHERE pedido_id = 4;

DELETE FROM pedidos
WHERE pedido_id = 4;
------------------------------------------------------------------------------------------------------

-- Consultas a tablas
SELECT * FROM dbo.pedidos;
SELECT * FROM dbo.clientes;
SELECT * FROM dbo.detalle_pedido;
SELECT * FROM dbo.libros;

drop table dbo.detalle_pedido