/* FILTROS Y AGRUPACIONES: WHERE, GROUP BY y HAVING
    SELECT * FROM <nombre_tabla>
    WHERE <condición 1> AND ... AND <condición n> 

    Comparaciones directas:
        = 
        <> 
        < 
        > 
        <= 
        >=
    Rango inclusivo
        BETWEEN ... AND ...
    Valores específicos
        IN (...)
    Indentificación de patrones
        LIKE '%...%'
    Negar condiciónes
        NOT 
        NOT IN (...)
        NOT LIKE '%...%'
        NOT BETWEEN ... AND ...
    Detectar valores nulos
        IS NULL
        IS NOT NULL
    Operadores lógicos AND, OR, ()
        <condición 1> AND <condición 2>
        <condición 1> OR <condición 2>
        (<condición 1> AND <condición 2>) OR <condición 3>
*/

-- Comparaciones directas
SELECT * FROM sell.productos
WHERE precio = 120

SELECT * FROM sell.productos
WHERE stock <> 100

SELECT * FROM sell.productos
WHERE marca <> 'TechWizards'

SELECT * FROM sell.productos
WHERE precio > 500

SELECT * FROM sell.productos
WHERE precio < 500

SELECT * FROM sell.productos
WHERE precio >= 500

SELECT * FROM sell.productos
WHERE precio <= 500

-- Rango inclusivo
SELECT * FROM sell.productos
WHERE precio BETWEEN 150 AND 200

SELECT * FROM sell.productos
WHERE precio >= 150 AND precio <= 200

-- Valores específicos
SELECT * FROM sell.productos
WHERE marca IN ( 'TechWizards','ElecMasters')

-- Indentificación de patrones | Expresiones Regulares
SELECT * FROM sell.productos
WHERE nombre_producto LIKE 'P%' --Comienza con 

SELECT * FROM sell.productos
WHERE nombre_producto LIKE '%g' --Termina con

SELECT * FROM sell.productos
WHERE nombre_producto LIKE '%l%' -- Contiene

SELECT * FROM cli.clientes
WHERE correo_electronico LIKE '%.gov%' -- Contiene

SELECT * FROM cli.clientes
WHERE nombre LIKE '___' -- Cantidad específica de caracteres

SELECT * FROM cli.clientes
WHERE nombre LIKE 'F___' -- Cantidad específica de caracteres

SELECT * FROM sell.productos
WHERE nombre_producto LIKE '%[0-4]%' -- Rango de números

SELECT * FROM sell.productos
WHERE nombre_producto LIKE '[A-D]%' -- Rango de letras

SELECT * FROM sell.productos
WHERE nombre_producto LIKE '[^A-D]%' -- Rango de letras

-- Negar condiciónes
SELECT * FROM sell.productos
WHERE marca NOT IN ( 'TechWizards','ElecMasters')

SELECT * FROM cli.clientes
WHERE correo_electronico NOT LIKE '%.gov%' -- Contiene

SELECT * FROM sell.productos
WHERE precio NOT BETWEEN 150 AND 200

-- Detectar valores nulos
SELECT * FROM cli.clientes
WHERE telefono IS NULL

SELECT * FROM cli.clientes
WHERE telefono IS NOT NULL

-- Operadores lógicos AND, OR, ()
SELECT * FROM sell.productos
WHERE (precio > 100 AND stock <= 200) OR nombre_producto LIKE 'A%'


-- Productos sin categoria
SELECT 
    nombre_producto
FROM sell.productos
WHERE stock <= 10

-- Ventas con total mayor a 1000
SELECT 
    venta_id, 
    total_venta
FROM sell.ventas
WHERE total_venta > 500