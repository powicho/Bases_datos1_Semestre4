------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--UNION: Combina y elimina duplicados.
--UNION ALL: Combina sin eliminar duplicados.
--INTERSECT: Muestra solo los registros comunes entre ambas tablas.
--EXCEPT: Muestra los registros de la primera tabla que no se encuentran en la segunda.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 1: ¿Clientes duplicados?
SELECT nombre, apellido FROM cli.clientes
UNION 
SELECT nombre, apellido FROM dim.cliente

Select nombre, apellido, count(*) from cli.clientes group by nombre, apellido
Select nombre, apellido, count(*) from dim.cliente group by nombre, apellido

Select nombre, apellido, count(*) as total from
(select nombre, apellido FROM cli.clientes union all SELECT nombre, apellido FROM dim.cliente)
As combinado group by nombre, apellido HAVING COUNT(*) > 1;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 2: Todos los nombres, incluso si se repiten
SELECT top 20 nombre, apellido FROM cli.clientes
UNION all
SELECT top 20 nombre, apellido FROM dim.cliente
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 3: ¿Clientes sincronizados?
SELECT top 50 nombre, apellido FROM cli.clientes
intersect
SELECT top 50 nombre, apellido FROM dim.cliente
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 4: Clientes sin tarjeta de crédito
SELECT cliente_id FROM cli.clientes
EXCEPT
SELECT cliente_id FROM cli.tarjetas_credito;

SELECT * FROM cli.tarjetas_credito
SELECT * FROM cli.clientes
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 5: Clientes que nunca han comprado
SELECT cliente_id FROM cli.clientes
EXCEPT
SELECT cliente_id FROM sell.ventas;

SELECT * FROM sell.ventas
SELECT * FROM cli.clientes
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 6: Productos en venta o en carrito
SELECT producto_id, SUM(cantidad) AS total_cantidad
FROM (SELECT producto_id, cantidad FROM sell.detalle_ventas UNION  SELECT producto_id, cantidad FROM sell.detalle_carrito_compras  ) 
AS productos
GROUP BY producto_id
ORDER BY producto_id;

SELECT * FROM sell.ventas
SELECT * FROM sell.carrito_compras
SELECT * FROM sell.categoria
SELECT * FROM sell.detalle_carrito_compras
SELECT * FROM sell.detalle_ventas
SELECT * FROM sell.productos
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 7: ¿Qué productos llaman la atención?
SELECT producto_id, SUM(cantidad) AS total_cantidad
FROM (SELECT producto_id, cantidad FROM sell.detalle_ventas intersect  SELECT producto_id, cantidad FROM sell.detalle_carrito_compras) 
AS productos
GROUP BY producto_id
ORDER BY producto_id
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 8: Productos ignorados por los compradores
-- el catálogo tiene 59 productos y la tabla de ventas tiene 19859 registros, significa que todos los productos en el catálogo han sido vendidos múltiples veces.
SELECT producto_id FROM sell.productos
Except
SELECT producto_id FROM sell.detalle_ventas;

SELECT * FROM sell.detalle_ventas
SELECT * FROM sell.productos

-- Ver canrtidad de productos de manera individual 
SELECT COUNT(*) FROM sell.productos;
SELECT COUNT(DISTINCT producto_id) FROM sell.detalle_ventas;
-- Comparar todos los productos en el catálogo con los productos vendidos
--DISTINCT es una palabra clave en SQL que se utiliza para eliminar filas duplicadas en los resultados de una consulta.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 9: Del carrito... pero nunca comprados
-- al tener en cuenta la cantidad me arroja los id de los productos del excep pero con la condicion de motrar la cantidad que existe en las ventas
SELECT producto_id, SUM(cantidad) AS total_cantidad
FROM (SELECT producto_id, cantidad FROM sell.detalle_carrito_compras EXCEPT SELECT producto_id, cantidad FROM sell.detalle_ventas) 
AS productos
GROUP BY producto_id
ORDER BY producto_id

SELECT * FROM sell.detalle_carrito_compras
SELECT * FROM sell.detalle_ventas

-- Ver canrtidad de productos de manera individual 
SELECT COUNT(DISTINCT producto_id) FROM sell.detalle_carrito_compras;
SELECT COUNT(DISTINCT producto_id) FROM sell.detalle_ventas;

-- al existir la misma cantidad de productos en las 2 tablas segun el id me arrojara 0 o ninguna fila por er
SELECT producto_id FROM sell.detalle_carrito_compras
EXCEPT
SELECT producto_id FROM sell.detalle_ventas;
--Si un producto está en el catálogo pero no tiene ventas asociadas, aparecerá en el resultado.
--Si un producto tiene al menos una venta asociada, no aparecerá en el resultado.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 10: Productos vendidos, pero no visibles
SELECT producto_id FROM sell.detalle_ventas
EXCEPT
SELECT producto_id FROM sell.productos;


-- verificacion de datos
SELECT COUNT(producto_id) FROM sell.detalle_ventas;
SELECT COUNT(DISTINCT producto_id) FROM sell.detalle_ventas;

SELECT COUNT(producto_id) FROM sell.productos;
SELECT COUNT(DISTINCT producto_id) FROM sell.productos;

SELECT * FROM sell.detalle_ventas
SELECT * FROM sell.productos
--La consulta no arroja resultados porque todos los productos vendidos están presentes en el catálogo.
--No hay productos vendidos que no estén disponibles en el catálogo actual.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------