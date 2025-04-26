/* AGRUPACIONES: GROUP BY , HAVING

    SELECT 
        <columna_agrupadora>,
        <funcion_agrupacion>(<columna_agregada>)
    FROM tabla
    GROUP BY <columna_agrupadora>

    COUNT(*) = Contar filas
    SUM(columna) = Sumar los valores de una columna
    AVG(columna) = Calcular el promedio de los valores de una columna
    MIN(columna) = Valor mínimo de una columna
    MAX(columna) = Valor máximo de una columna  
*/

SELECT 
    marca,
    COUNT(*) cantidad_productos 
FROM sell.productos
GROUP BY marca
ORDER BY cantidad_productos DESC

SELECT 
    marca,
    SUM(stock) unidades_x_marca
FROM sell.productos
GROUP BY marca
ORDER BY unidades_x_marca DESC

SELECT
    MONTH(fecha_venta) mes,
    AVG(total_venta) ticket_promedio
FROM sell.ventas
GROUP BY MONTH(fecha_venta)
ORDER BY MONTH(fecha_venta)

SELECT
    MONTH(fecha_venta) mes,
    MIN(total_venta) factura_mas_pequeña
FROM sell.ventas
GROUP BY MONTH(fecha_venta)
ORDER BY MONTH(fecha_venta)

SELECT
    MONTH(fecha_venta) mes,
    MAX(total_venta) factura_mas_pequeña
FROM sell.ventas
GROUP BY MONTH(fecha_venta)
ORDER BY MONTH(fecha_venta)

-- Obtener el total de ventas por cliente
SELECT 
    cliente_id,
    SUM(total_venta) as total_compras
FROM sell.ventas 
GROUP BY cliente_id

-- Obtener el top 10 de mejores clientes
SELECT 
    TOP 10
    CONCAT(c.nombre, ' ' ,c.apellido) nombre,
    SUM(v.total_venta) as total_compras
FROM sell.ventas v 
JOIN cli.clientes c on v.cliente_id = c.cliente_id
GROUP BY c.nombre, c.apellido
ORDER BY total_compras DESC


-- ================================================
-- Objetivo: Encontrar clientes que realizaron más de 3 compras en un mismo mes
-- Usamos filtros de fecha, agrupaciones, y HAVING para lograrlo
-- ================================================

-- Paso 1: Explorar la tabla de ventas
SELECT * FROM sell.ventas;

-- Paso 2: Verificar ventas en un rango de fechas (enero 2021)
SELECT * 
FROM sell.ventas
WHERE fecha_venta BETWEEN '2021-01-01' AND '2021-01-31';

-- Paso 3: Unir ventas con clientes para obtener nombres
SELECT 
    v.venta_id, 
    c.nombre,
    c.apellido,
    v.fecha_venta,
    v.total_venta 
FROM sell.ventas v
JOIN cli.clientes c ON v.cliente_id = c.cliente_id
WHERE fecha_venta BETWEEN '2021-01-01' AND '2021-01-31';

-- Paso 4: Usar CONCAT para mostrar el nombre completo del cliente
SELECT 
    v.venta_id, 
    CONCAT(c.nombre, ' ', c.apellido) AS cliente,
    v.fecha_venta,
    v.total_venta     
FROM sell.ventas v
JOIN cli.clientes c ON v.cliente_id = c.cliente_id
WHERE fecha_venta BETWEEN '2021-01-01' AND '2021-01-31';

-- Paso 5: Contar cuántas compras hizo cada cliente en el mes
SELECT 
    CONCAT(c.nombre, ' ', c.apellido) AS cliente,
    COUNT(*) AS cantidad_compras
FROM sell.ventas v
JOIN cli.clientes c ON v.cliente_id = c.cliente_id
WHERE fecha_venta BETWEEN '2021-01-01' AND '2021-01-31'
GROUP BY c.nombre, c.apellido;

-- Paso 6: Agrupar también por mes y filtrar clientes con más de 3 compras
SELECT 
    MONTH(v.fecha_venta) AS mes, 
    CONCAT(c.nombre, ' ', c.apellido) AS cliente,
    COUNT(*) AS cantidad_compras
FROM sell.ventas v
JOIN cli.clientes c ON v.cliente_id = c.cliente_id
WHERE fecha_venta BETWEEN '2021-01-01' AND '2021-01-31'
GROUP BY MONTH(v.fecha_venta), c.nombre, c.apellido
HAVING COUNT(*) > 3
ORDER BY cantidad_compras DESC;
