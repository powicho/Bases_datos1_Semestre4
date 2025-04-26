------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Ejemplo 1 – UNION (Clientes únicos de dos fuentes)
SELECT TOP 3 nombre, apellido FROM cli.clientes
UNION
SELECT TOP 3 nombre, apellido FROM dim.cliente

SELECT TOP 3 nombre, apellido FROM cli.clientes

SELECT TOP 3 nombre, apellido FROM dim.cliente
--Respuesta: Nos devuelve los clientes únicos, estén en una tabla y en la otra.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejemplo 2 – UNION ALL (Permite duplicados)
SELECT TOP 3 nombre, apellido FROM cli.clientes
UNION ALL
SELECT TOP 3 nombre, apellido FROM dim.cliente
--Respuesta: Nos devuelve los registros completos de ambas consultas, incluyendo los duplicados.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Ejemplo 3 – INTERSECT (Clientes comunes)
SELECT TOP 3 nombre, apellido FROM cli.clientes
INTERSECT
SELECT TOP 3 nombre, apellido FROM dim.cliente
--Respuesta: Nos obtiene solo los registros que aparecen en ambas tablas/consultas
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Ejemplo 4 – EXCEPT (Clientes únicos en producción)
DELETE FROM sell.detalle_carrito_compras WHERE carrito_id IN 
(SELECT carrito_id FROM sell.carrito_compras WHERE cliente_id IN 
(SELECT cliente_id FROM cli.clientes WHERE cliente_id >=50 AND cliente_id <60))

DELETE FROM sell.detalle_ventas WHERE venta_id IN 
(SELECT venta_id FROM sell.ventas WHERE cliente_id IN 
(SELECT cliente_id FROM cli.clientes WHERE cliente_id >=50 AND cliente_id <60))

DELETE FROM sell.carrito_compras WHERE cliente_id IN 
(SELECT cliente_id FROM cli.clientes WHERE cliente_id >=50 AND cliente_id <60)

DELETE FROM sell.ventas WHERE cliente_id IN 
(SELECT cliente_id FROM cli.clientes WHERE cliente_id >=50 AND cliente_id <60)

DELETE FROM cli.tarjetas_credito WHERE cliente_id IN 
(SELECT cliente_id FROM cli.clientes WHERE cliente_id >=50 AND cliente_id <60)

DELETE FROM cli.clientes WHERE cliente_id >=50 AND cliente_id < 60

SELECT nombre, apellido FROM dim.cliente
EXCEPT
SELECT nombre, apellido FROM cli.clientes
--Resultado: Nos devuelve los clientes que están solo en la tabla de dimenisión pero no es la tabla operativa.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--SQL INJECTION EJEMPLO
SELECT TOP 20 producto_id, nombre_producto FROM sell.productos
UNION
SELECT TOP 20 producto_id, NULL FROM sell.detalle_carrito_compras
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT NULL, NULL, NULL FROM sell.carrito_compras
UNION
SELECT NULL, NULL, NULL
UNION
SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME FROM INFORMATION_SCHEMA.TABLES
UNION
SELECT nombre, contrasena, NULL FROM cli.clientes
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



























