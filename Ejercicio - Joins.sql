/*
    SELECT <columnas o *>
    FROM <nombre tabla 1> AS <alias 1>
    <TIPO JOIN> <nombre tabla 2> AS <alias 2> ON <alias 1>.<nombre columna> = <alias 2>.<nombre columna>
*/
use Ecomerce
-- Obtener las ventas junto con el nombre del cliente
SELECT TOP 10 * FROM sell.ventas
SELECT TOP 10 * FROM cli.clientes
SELECT 
    TOP 10 
    v.venta_id,
    v.fecha_venta,
    v.total_venta,
    c.nombre,
    c.apellido
FROM sell.ventas AS v
JOIN cli.clientes AS c ON v.cliente_id = c.cliente_id
-- Ver todos los clientes, incluso los que no han comprado nada.
SELECT 
    c.nombre,
    c.apellido,
    count(v.venta_id) cantidad_compras
FROM cli.clientes AS c
LEFT JOIN sell.ventas AS v ON c.cliente_id = v.cliente_id
GROUP BY c.nombre, c.apellido
ORDER BY cantidad_compras ASC

--Ver detalle de ventas con nombre del producto y categoría.
SELECT TOP 10 * FROM sell.detalle_ventas

SELECT TOP 10 * FROM sell.productos

SELECT TOP 10 * FROM sell.categoria

SELECT
    v.fecha_venta,
    p.codigo_barras,
    p.nombre_producto,
    c.categoria,
    dv.cantidad,
    dv.precio_unitario,
    dv.cantidad * dv.precio_unitario AS total 
FROM sell.detalle_ventas AS dv
JOIN sell.ventas v on dv.venta_id = v.venta_id
JOIN sell.productos AS p ON dv.producto_id = p.producto_id
JOIN sell.categoria AS c ON p.categoria_id = c.categoria_id
-- Ver todas las combinaciones posibles entre clientes y categorías
SELECT 
    c.nombre,
    c.apellido,
    cat.categoria
FROM cli.clientes c
CROSS JOIN sell.categoria cat

select count(*) from cli.clientes
select count(*) from sell.categoria




-- ==================================================================================================================================================
select * from cli.tarjetas_credito
select * from sell.detalle_carrito_compras
select * from cli.clientes

-- ==================================================================================================================================================
-- Ejercicio 1: Obtener todas las tarjetas de crédito registradas para cada cliente
-- =========================================================================
-- Se utiliza INNER JOIN para mostrar solo los clientes que tienen tarjetas
-- y las tarjetas asociadas a esos clientes.
SELECT
    c.cliente_id,
    c.nombre,
    c.apellido,
    tc.tarjeta_id,
    tc.numero_tarjeta, 
    tc.fecha_vencimiento,
    tc.cvv             
FROM cli.clientes AS c
INNER JOIN cli.tarjetas_credito AS tc ON c.cliente_id = tc.cliente_id;

-- =========================================================================
-- Ejercicio 2: Obtener todos los carritos junto con los productos y sus marcas
-- =========================================================================
-- Se utilizan INNER JOINs para conectar carritos, sus detalles y los productos.
-- La tabla sell.productos tiene una columna llamada marca
-- Si la marca está en otra tabla, se necesitará un JOIN adicional.
SELECT
    sc.carrito_id,
    p.nombre_producto,
    p.marca, 
    dcc.cantidad 
FROM sell.carrito_compras AS sc
INNER JOIN sell.detalle_carrito_compras AS dcc ON sc.carrito_id = dcc.carrito_id
INNER JOIN sell.productos AS p ON dcc.producto_id = p.producto_id;

-- =========================================================================
-- Ejercicio 3: Obtener todos los clientes que no tiene tarjeta de credito registrada
-- =========================================================================
-- Se utiliza LEFT JOIN desde clientes hacia tarjetas_credito.
-- La condición WHERE tc.tarjeta_id IS NULL filtra para encontrar solo aquellos clientes para los cuales no se encontró una tarjeta correspondiente.

SELECT
    c.cliente_id,
    c.nombre,
    c.apellido,
    c.correo_electronico 
FROM cli.clientes AS c
LEFT JOIN cli.tarjetas_credito AS tc ON c.cliente_id = tc.cliente_id WHERE tc.tarjeta_id IS NULL; 
-- Identifica filas donde no hubo coincidencia en la tabla de tarjetas

