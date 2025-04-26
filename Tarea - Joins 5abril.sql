-- =========================================================================
-- Ejercicio 1: Obtén una lista de todos los productos junto con sus detalles de ventas,
-- mostrando todos los productos independientemente de si se han vendido o no.
-- =========================================================================
-- LEFT JOIN desde la tabla principal  hacia la tabla secundaria.
-- Esto asegura que cada producto de la tabla 'productos' aparezca al menos una vez en el resultado.
SELECT
    p.producto_id,
    p.nombre_producto,
    p.codigo_barras,
    p.marca,
    p.precio AS precio_unitario_producto, -- Precio actual del producto
    p.stock,
    dv.venta_id,
    dv.venta_id,
    dv.cantidad AS cantidad_vendida,
    dv.precio_unitario AS precio_unitario_venta -- Precio al momento de la venta
FROM
    sell.productos AS p
LEFT JOIN
    sell.detalle_ventas AS dv ON p.producto_id = dv.producto_id
ORDER BY -- Opcional: ordenar para ver más claro
    p.nombre_producto, dv.venta_id;

-- =========================================================================
-- Ejercicio 2: Encuentra todos los clientes junto con sus tarjetas de crédito,
-- incluso si algunos clientes no han registrado ninguna tarjeta.
-- =========================================================================
-- LEFT JOIN desde la tabla principal (clientes) hacia la tabla secundaria (tarjetas_credito).
-- Esto asegura que cada cliente de la tabla 'clientes' aparezca.
SELECT
    c.cliente_id,
    c.nombre,
    c.apellido,
    c.correo_electronico,
    c.direccion, 
    c.telefono,
    tc.tarjeta_id,
    tc.numero_tarjeta,
    tc.fecha_vencimiento,
    tc.cvv
FROM
    cli.clientes AS c
LEFT JOIN
    cli.tarjetas_credito AS tc ON c.cliente_id = tc.cliente_id
ORDER BY
    c.apellido, c.nombre;

-- =========================================================================
-- Ejercicio 3: Obtén una lista de todos los productos junto con sus detalles de ventas,
-- mostrando todos los productos independientemente de si se han vendido o no.
-- =========================================================================
-- LEFT JOIN desde productos para incluir todos los productos, vendidos o no.
SELECT
    p.producto_id,
	p.nombre_producto,
	p.codigo_barras, 
	p.marca, p.precio AS precio_unitario_producto, p.stock,
    dv.venta_id, dv.venta_id, dv.cantidad AS cantidad_vendida, dv.precio_unitario AS precio_unitario_venta
FROM
    sell.productos AS p
LEFT JOIN
    sell.detalle_ventas AS dv ON p.producto_id = dv.producto_id
ORDER BY
    p.nombre_producto, dv.venta_id;

-- =========================================================================
-- Ejercicio 4: Encuentra todos los clientes junto con sus direcciones de envío,
-- incluso si algunos clientes no tienen ninguna dirección registrada.
-- =========================================================================
-- La información de la dirección  se encuentra directamente en la tabla 'cli.clientes'.
SELECT
    c.cliente_id,
    c.nombre,
    c.apellido,
    c.correo_electronico,
    c.telefono,
    c.direccion -- La dirección ya está en esta tabla
FROM
    cli.clientes AS c
ORDER BY
    c.apellido, c.nombre;
-- Nota: Si la dirección estuviera en una tabla separada (ej: cli.direcciones_envio),
-- entonces SÍ usaríamos LEFT JOIN desde cli.clientes hacia esa tabla.

-- =========================================================================
-- Ejercicio 5: Obtén una lista de todos los productos *en stock* junto con sus detalles de ventas,
-- mostrando todos los productos (en stock) independientemente de si se han vendido o no.
-- =========================================================================
-- Primero se usa LEFT JOIN desde productos hacia detalle_ventas para obtener la info de ventas
SELECT
    p.producto_id,
    p.nombre_producto,
    p.marca,
    p.stock, 
    dv.venta_id,
    dv.venta_id,
    dv.cantidad AS cantidad_vendida,
    dv.precio_unitario AS precio_unitario_venta
FROM
    sell.productos AS p
LEFT JOIN
    sell.detalle_ventas AS dv ON p.producto_id = dv.producto_id
WHERE
    p.stock > 0 
ORDER BY
    p.nombre_producto, dv.venta_id;

-- =========================================================================
-- Ejercicio 6: Encuentra todos los clientes junto con sus detalles de ventas,
-- incluso si algunos clientes no han realizado ninguna compra.
-- =========================================================================
-- LEFT JOIN desde la tabla principal hacia la tabla secundaria.
SELECT
    c.cliente_id,
    c.nombre,
    c.apellido,
    c.correo_electronico,
    v.venta_id,
    v.fecha_venta,
    v.total_venta
FROM
    cli.clientes AS c
LEFT JOIN
    sell.ventas AS v ON c.cliente_id = v.cliente_id
ORDER BY
    c.apellido, c.nombre, v.fecha_venta; -- Opcional: ordenar

-- =========================================================================
-- Ejercicio 7: Obtén una lista de todos los productos en stock junto con sus detalles de ventas,
-- mostrando todos los productos (en stock) independientemente de si se han vendido o no.
-- =========================================================================
-- Se aplica el mismo razonamiento: LEFT JOIN desde productos

SELECT
    p.producto_id, p.nombre_producto, p.marca, p.stock,
    dv.venta_id, dv.venta_id, dv.cantidad AS cantidad_vendida, dv.precio_unitario AS precio_unitario_venta
FROM
    sell.productos AS p
LEFT JOIN
    sell.detalle_ventas AS dv ON p.producto_id = dv.producto_id
WHERE
    p.stock > 0
ORDER BY
    p.nombre_producto, dv.venta_id;

-- =========================================================================
-- Ejercicio 8: Encuentra todos los clientes junto con sus tarjetas de crédito,
-- incluso si algunos clientes no han registrado ninguna tarjeta.
-- =========================================================================
-- Se aplica el mismo razonamiento: LEFT JOIN desde clientes
-- hacia tarjetas_credito para incluir a todos los clientes, tengan o no tarjeta registrada.
SELECT
    c.cliente_id, c.nombre, c.apellido, c.correo_electronico, c.direccion, c.telefono,
    tc.tarjeta_id, tc.numero_tarjeta, tc.fecha_vencimiento, tc.cvv
FROM
    cli.clientes AS c
LEFT JOIN
    cli.tarjetas_credito AS tc ON c.cliente_id = tc.cliente_id
ORDER BY
    c.apellido, c.nombre;

-- =========================================================================
-- Ejercicio 9: Obtén una lista de todos los productos vendidos junto con sus detalles de ventas,
-- mostrando todos los productos independientemente de si se han vendido o no.
-- =========================================================================
SELECT
    p.producto_id,
    p.nombre_producto,
    p.marca,
    p.stock,
    -- Columnas del detalle de venta (serán NULL si el producto nunca se vendió)
    dv.venta_id,
    dv.venta_id,
    dv.cantidad AS cantidad_vendida,
    dv.precio_unitario AS precio_unitario_venta
FROM
    sell.productos AS p
LEFT JOIN -- Muestra todos los productos, tengan o no ventas
    sell.detalle_ventas AS dv ON p.producto_id = dv.producto_id
ORDER BY
    p.nombre_producto, dv.venta_id;
-- =========================================================================