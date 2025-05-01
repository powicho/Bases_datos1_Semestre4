select * from [cli].[clientes]
select * from [cli].[tarjetas_credito]
select * from [dbo].[clientes]
select * from [dbo].[facturas]
select * from [dim].[cliente]
select * from [sell].[carrito_compras]
select * from [sell].[categoria]
select * from [sell].[detalle_carrito_compras]
select * from [sell].[detalle_ventas]
select * from [sell].[productos]
select * from [sell].[ventas]

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 1: Concatenación de Nombre Completo
-- Combina el nombre y apellido de los clientes en una sola columna llamada "Nombre Completo".
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
    cliente_id,
    nombre + ' ' + apellido AS "Nombre Completo"
FROM
    [cli].[clientes];

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 2: Longitud de Correo Electrónico
-- Calcula la longitud del correo electrónico de los clientes. (Asumo esto por el título, aunque el texto repite el ej 1)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
    cliente_id,
    correo_electronico,
    LEN(correo_electronico) AS "Longitud Correo"
FROM
    [cli].[clientes];

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 3: Fecha de Vencimiento de la Tarjeta de Crédito
-- Calcula cuántos días faltan para la fecha de vencimiento de las tarjetas de crédito y muestra el resultado en una columna llamada "Días para Vencimiento".
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
    tarjeta_id,
    cliente_id,
    numero_tarjeta,
    fecha_vencimiento,
    DATEDIFF(day, GETDATE(), fecha_vencimiento) AS "Días para Vencimiento"
FROM
    [cli].[tarjetas_credito];

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 4: Nombres de Productos en Mayúsculas
-- Muestra los nombres de los productos en mayúsculas en una columna llamada "Nombre Producto Mayúsculas".
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
    producto_id,
    UPPER(nombre_producto) AS "Nombre Producto Mayúsculas"
FROM
    [sell].[productos];

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 5: Cantidad de Caracteres en Descripción de Producto
-- Calcula la cantidad de caracteres en la descripción de cada producto y muestra el resultado en una columna llamada "Longitud Descripción".
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
    producto_id,
    nombre_producto,
    LEN(descripcion) AS "Longitud Descripción"
FROM
    [sell].[productos];

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 6: Precio Promedio por Categoría
-- Calcula el precio promedio de los productos en cada categoría y muestra el resultado junto con el nombre de la categoría en una columna llamada "Precio Promedio".
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
    c.categoria,
    AVG(p.precio) AS "Precio Promedio"
FROM
    [sell].[productos] p
INNER JOIN
    [sell].[categoria] c ON p.categoria_id = c.categoria_id
GROUP BY
    c.categoria_id, c.categoria
ORDER BY
    c.categoria;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 8: Fecha de Última Venta (Nota: No hay Ejercicio 7 en el PDF)
-- Encuentra la fecha de la última venta realizada y muestra el resultado en una columna llamada "Última Venta".
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
    MAX(fecha_venta) AS "Última Venta"
FROM
    [sell].[ventas];

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 9: Número de Ventas por Cliente
-- Cuenta cuántas ventas ha realizado cada cliente y muestra el resultado en una columna llamada "Número de Ventas".
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
    c.cliente_id,
    c.nombre,
    c.apellido,
    COUNT(v.venta_id) AS "Número de Ventas"
FROM
    [cli].[clientes] c
INNER JOIN
    [sell].[ventas] v ON c.cliente_id = v.cliente_id
GROUP BY
    c.cliente_id, c.nombre, c.apellido
ORDER BY
    c.cliente_id;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 10: Cantidad de Productos por Cliente en Carrito
-- Calcula cuántos productos (suma de cantidades) tiene cada cliente en su carrito de compras (activo) y muestra el resultado en una columna llamada "Productos en Carrito".
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
    c.cliente_id,
    c.nombre,
    c.apellido,
    SUM(ISNULL(dcc.cantidad, 0)) AS "Productos en Carrito" -- Suma las cantidades de los detalles
FROM
    [cli].[clientes] c
LEFT JOIN -- Usamos LEFT JOIN para incluir clientes sin carritos activos
    [sell].[carrito_compras] cc ON c.cliente_id = cc.cliente_id AND cc.abandonado = 0
LEFT JOIN
    [sell].[detalle_carrito_compras] dcc ON cc.carrito_id = dcc.carrito_id
GROUP BY
    c.cliente_id, c.nombre, c.apellido
ORDER BY
    c.cliente_id;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 11: Total de Ventas por Mes
-- Calcula el total de ventas realizado en cada mes y muestra el resultado junto con el nombre del mes en una columna llamada "Total Ventas".
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
    YEAR(fecha_venta) AS Anio,
    DATENAME(month, fecha_venta) AS Mes,
    MONTH(fecha_venta) AS MesNumero, -- Añadido para ordenar correctamente
    SUM(total_venta) AS "Total Ventas"
FROM
    [sell].[ventas]
GROUP BY
    YEAR(fecha_venta),
    MONTH(fecha_venta),
    DATENAME(month, fecha_venta)
ORDER BY
    Anio,
    MesNumero;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 12: Porcentaje de Stock Agotado
-- Calcula el porcentaje de productos cuyo stock está agotado (stock = 0) y muestra el resultado en una columna llamada "Porcentaje Agotado".
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
    (SUM(CASE WHEN stock = 0 THEN 1.0 ELSE 0.0 END) * 100.0) / COUNT(*) AS "Porcentaje Agotado"
FROM
    [sell].[productos];

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 13: Cantidad de Productos Vendidos por Categoría
-- Cuenta cuántos productos (suma de cantidades de detalle_ventas) de cada categoría se han vendido y muestra el resultado junto con el nombre de la categoría en una columna llamada "Productos Vendidos".
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
    c.categoria,
    SUM(dv.cantidad) AS "Productos Vendidos"
FROM
    [sell].[detalle_ventas] dv
INNER JOIN
    [sell].[productos] p ON dv.producto_id = p.producto_id
INNER JOIN
    [sell].[categoria] c ON p.categoria_id = c.categoria_id
GROUP BY
    c.categoria_id, c.categoria
ORDER BY
    c.categoria;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 14: Tarjeta de Crédito Más Antigua
-- Encuentra la tarjeta de crédito más antigua (interpretado como la fecha de vencimiento más temprana) registrada por cada cliente y muestra el resultado en una columna llamada "Tarjeta Crédito Antigua".
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
    c.cliente_id,
    c.nombre,
    c.apellido,
    MIN(tc.fecha_vencimiento) AS "Tarjeta Crédito Antigua" -- Fecha de vencimiento más temprana
FROM
    [cli].[clientes] c
INNER JOIN
    [cli].[tarjetas_credito] tc ON c.cliente_id = tc.cliente_id
GROUP BY
    c.cliente_id, c.nombre, c.apellido
ORDER BY
    c.cliente_id;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 15: Precio Total de Productos en Carrito de Compras
-- Calcula el precio total (cantidad * precio unitario del producto) de todos los productos en el carrito de compras (activo) de cada cliente y muestra el resultado en una columna llamada "Precio Total Carrito".
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
    c.cliente_id,
    c.nombre,
    c.apellido,
    SUM(ISNULL(dcc.cantidad * p.precio, 0)) AS "Precio Total Carrito"
FROM
    [cli].[clientes] c
LEFT JOIN -- Usamos LEFT JOIN para incluir clientes sin carritos activos
    [sell].[carrito_compras] cc ON c.cliente_id = cc.cliente_id AND cc.abandonado = 0
LEFT JOIN
    [sell].[detalle_carrito_compras] dcc ON cc.carrito_id = dcc.carrito_id
LEFT JOIN
    [sell].[productos] p ON dcc.producto_id = p.producto_id
GROUP BY
    c.cliente_id, c.nombre, c.apellido
ORDER BY
    c.cliente_id;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 16: Cantidad de Clientes por Dirección
-- Cuenta cuántos clientes tienen la misma dirección y muestra el resultado junto con la dirección en una columna llamada "Clientes por Dirección".
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
    direccion,
    COUNT(cliente_id) AS "Clientes por Dirección"
FROM
    [cli].[clientes]
WHERE
    direccion IS NOT NULL AND direccion <> '' -- Excluir direcciones nulas o vacías si aplica
GROUP BY
    direccion
ORDER BY
    "Clientes por Dirección" DESC, direccion;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 17: Productos con Precio Superior al Promedio
-- Muestra los productos cuyo precio es superior al precio promedio de todos los productos. La columna de resultado debe llamarse "Productos Precio Superior Promedio". (Se mostrarán los detalles del producto).
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
    producto_id,
    nombre_producto,
    precio AS "Productos Precio Superior Promedio" -- Mostrando el precio, como indica el nombre solicitado
FROM
    [sell].[productos]
WHERE
    precio > (SELECT AVG(precio) FROM [sell].[productos])
ORDER BY
    precio DESC;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 18: Fecha de Primera Venta por Cliente
-- Encuentra la fecha de la primera venta realizada por cada cliente y muestra el resultado en una columna llamada "Primera Venta".
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
    c.cliente_id,
    c.nombre,
    c.apellido,
    MIN(v.fecha_venta) AS "Primera Venta"
FROM
    [cli].[clientes] c
INNER JOIN
    [sell].[ventas] v ON c.cliente_id = v.cliente_id
GROUP BY
    c.cliente_id, c.nombre, c.apellido
ORDER BY
    c.cliente_id;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 19: Cantidad de Productos en Categoría Específica
-- Cuenta cuántos productos pertenecen a una categoría específica y muestra el resultado junto con el nombre de la categoría en una columna llamada "Productos por Categoría". (Se muestra para todas las categorías, añadir WHERE si es una específica).
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
    c.categoria,
    COUNT(p.producto_id) AS "Productos por Categoría"
FROM
    [sell].[productos] p
INNER JOIN
    [sell].[categoria] c ON p.categoria_id = c.categoria_id
GROUP BY
    c.categoria_id, c.categoria
ORDER BY
    c.categoria;

-- Ejemplo si quisieras solo para una categoría específica, por ejemplo 'Audio' (suponiendo ID 1):
/*
SELECT
    c.categoria,
    COUNT(p.producto_id) AS "Productos por Categoría"
FROM
    [sell].[productos] p
INNER JOIN
    [sell].[categoria] c ON p.categoria_id = c.categoria_id
WHERE
    c.categoria = 'Audio' -- O puedes usar c.categoria_id = 1 si conoces el ID
GROUP BY
    c.categoria_id, c.categoria;
*/
------------------------------------