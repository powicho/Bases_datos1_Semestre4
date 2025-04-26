--Filtros con WHERE==========================================================================================
-----------------------------------------------------------------------------------------------------------------
--Listar todos los productos con un precio mayor a 500.

SELECT * FROM sell.productos
WHERE precio >= 500
-----------------------------------------------------------------------------------------------------------------
--Mostrar los clientes cuyo nombre empieza con la letra 'J'.

SELECT * FROM cli.clientes
WHERE nombre LIKE 'J%' 
-----------------------------------------------------------------------------------------------------------------
 --Obtener todas las ventas realizadas en el año 2024. (Tip: usa YEAR() para extraer el año de fecha_venta)  

 SELECT * FROM sell.ventas
 where YEAR(fecha_venta) = 2024
 -----------------------------------------------------------------------------------------------------------------
 --Listar productos de la marca 'LG' o 'Sony'.

SELECT * FROM sell.productos
WHERE nombre_producto LIKE '%LG%' OR nombre_producto LIKE '%SONY%';
-----------------------------------------------------------------------------------------------------------------
--Mostrar los productos que no tienen categoría asignada.

SELECT * FROM sell.productos
WHERE categoria_id is null-- para ver cuales no tienen una categoria asignada
-----------------------------------------------------------------------------------------------------------------
--Obtener los carritos que están abandonados.

SELECT * FROM sell.carrito_compras
where abandonado = 1
-----------------------------------------------------------------------------------------------------------------
--Mostrar las tarjetas de crédito que vencen en el año actual.  (Tip: usa YEAR(fecha_vencimiento) = YEAR(GETDATE()))  

select * from cli.tarjetas_credito
where year(fecha_vencimiento) = year(getdate())
-----------------------------------------------------------------------------------------------------------------
--Listar productos con stock entre 10 y 50 unidades.

SELECT * FROM sell.productos
where stock > 10 and stock <50
-----------------------------------------------------------------------------------------------------------------
--Obtener clientes cuyo apellido contiene la letra “z” (sin importar posición). 
SELECT * FROM cli.clientes
WHERE apellido LIKE '%Z%' 
-----------------------------------------------------------------------------------------------------------------
--Listar los productos cuyo nombre no contiene la palabra “Cable”.

SELECT * FROM sell.productos
where nombre_producto  not like '%cable%' 
-----------------------------------------------------------------------------------------------------------------
--Obtener las ventas con total_venta entre 1000 y 5000, excluyendo exactamente 3000.

SELECT * FROM sell.ventas 
where total_venta > 100 and  total_venta < 500 and total_venta not between 300 and 399
-----------------------------------------------------------------------------------------------------------------
--Mostrar los productos con stock menor a 5 o nulo.

SELECT * FROM sell.productos
where stock is null or stock <=5 
-----------------------------------------------------------------------------------------------------------------
--Listar las ventas que no tienen cliente asignado.

SELECT * FROM sell.ventas 
where cliente_id is null 
-----------------------------------------------------------------------------------------------------------------
--Mostrar todos los clientes cuyo nombre no empieza con vocal. (Tip: usa NOT LIKE 'A%' AND NOT LIKE 'E%'...)  
SELECT * FROM cli.clientes
WHERE nombre not LIKE '[A-E-I-O-U]%' 

--Agrupaciones (GROUP BY) y filtros (HAVING):==========================================================================================
-----------------------------------------------------------------------------------------------------------------
--Contar cuántos productos hay por cada categoría.
select * from sell.productos

SELECT 
categoria_id, 
COUNT(*) cantidad_productos 
FROM sell.productos
GROUP BY categoria_id
ORDER BY cantidad_productos DESC
-----------------------------------------------------------------------------------------------------------------
--Obtener el total de ventas por cliente.
select * from sell.ventas

SELECT cliente_id,
SUM(total_venta) as total_compras
FROM sell.ventas 
GROUP BY cliente_id
order by cliente_id
-----------------------------------------------------------------------------------------------------------------
--Listar los clientes que han realizado más de 3 ventas.
--dudas
SELECT
    c.cliente_id,
    c.nombre,
    c.apellido,
    SUM(dv.cantidad) AS total_cantidad 
FROM cli.clientes c
JOIN sell.ventas v ON c.cliente_id = v.cliente_id 

JOIN sell.detalle_ventas dv ON v.venta_id = dv.venta_id 
GROUP BY c.cliente_id, c.nombre, c.apellido 
HAVING SUM(dv.cantidad) > 3; 

select * from cli.clientes
select * from sell.detalle_ventas
select * from sell.ventas
-----------------------------------------------------------------------------------------------------------------
--Mostrar la cantidad de productos por marca.

select * from sell.productos

SELECT 
    marca,
    COUNT(*) cantidad_productos 
FROM sell.productos
GROUP BY marca
ORDER BY cantidad_productos DESC
-----------------------------------------------------------------------------------------------------------------
--Obtener el promedio de precios por categoría.

select * from sell.productos

SELECT 
categoria_id, 
AVG(precio) as promedio_precio 
FROM sell.productos
GROUP BY categoria_id
ORDER BY promedio_precio  DESC
-----------------------------------------------------------------------------------------------------------------
--Mostrar las fechas en que se realizaron más de 2 ventas. (Tip: agrupar por fecha_venta)
--duda
select * from sell.detalle_ventas
select * from sell.ventas

select 
v.fecha_venta,
sum(dv.cantidad) as cantidad_por_fecha
from sell.ventas v
join sell.detalle_ventas dv on v.venta_id = dv.venta_id
group by v.fecha_venta
having sum(dv.cantidad) > 2

-----------------------------------------------------------------------------------------------------------------
--Listar los productos vendidos (por producto_id) junto con la cantidad total vendida.

select * from sell.detalle_ventas

select
producto_id,
sum(cantidad) as cantidad_vendida
from sell.detalle_ventas
GROUP BY producto_id;    
--join sell.ventas v on v.total_venta = v.venta_id
--group by producto_id
-----------------------------------------------------------------------------------------------------------------
--Listar los productos con un promedio de precio unitario en ventas mayor a 300. (Tip: usar detalle_ventas)

select * from sell.detalle_ventas
--no hay prodectos con precio unitario que llegen o sean mas de 100
select
producto_id,
AVG(precio_unitario) as precio_promedio
from sell.detalle_ventas
GROUP BY producto_id   
having AVG(precio_unitario)>100
 -----------------------------------------------------------------------------------------------------------------
 --Mostrar cuántos carritos hay por cliente.
 select * from sell.carrito_compras

 select
 cliente_id,
 count(*) as carrito_id
 from sell.carrito_compras
 group by   cliente_id
 -----------------------------------------------------------------------------------------------------------------
 --Obtener el total de unidades vendidas por producto. Mostrar solo los productos que se han vendido más de 100 unidades.
 
select * from sell.detalle_ventas

select 
producto_id,
sum(cantidad) as unidades_totales
from sell.detalle_ventas
group by producto_id
having sum(cantidad)>100
-----------------------------------------------------------------------------------------------------------------
--Listar los clientes con un monto total de compras superior a Q5000.

select * from sell.ventas

select 
cliente_id,
--venta_id,
sum(total_venta) as compra_superior
from sell.ventas
group by cliente_id
having sum(total_venta) > 5000
-----------------------------------------------------------------------------------------------------------------
--Mostrar el número de tarjetas de crédito registradas por cliente.
select * from cli.tarjetas_credito

 select
 cliente_id,
 count(*) as tarjetas_id
 from cli.tarjetas_credito
 group by   cliente_id
 -----------------------------------------------------------------------------------------------------------------
--Listar categorías con más de 3 productos.
 select * from sell.productos

select 
producto_id,
sum(categoria_id) as categorias_3
from sell.productos 
group by producto_id 
having sum(categoria_id) > 3
-----------------------------------------------------------------------------------------------------------------
--Obtener las marcas con un stock total (sumado entre productos) mayor a 500.
 select * from sell.productos
 --no pasan de los 500
 select 
 marca,
 sum(stock) as mayor_500
 from sell.productos
 group by marca
ORDER BY mayor_500 DESC

 -----------------------------------------------------------------------------------------------------------------
 --Listar los días con ventas totales superiores a Q2000.
 --duda
 select * from sell.ventas

 -- CAST es para quitar la parte de la hora si 'fecha_venta' es datetime
 SELECT
 CAST(fecha_venta as DATE) as fecha,
 sum(total_venta) facturas_2000
FROM sell.ventas
GROUP BY CAST(fecha_venta AS DATE)
having sum(total_venta) > 2000
ORDER BY fecha

------------------------------------------------------------------------------------------------------------------
--Consultas complejas:===========================================================================================
 -----------------------------------------------------------------------------------------------------------------
--Encuentre el número total de ventas realizadas en cada mes durante el último año.
  select * from sell.ventas

  --solo hay fechas del 2021 si se busca un año antes no sale nada 
 SELECT
 CAST(fecha_venta as DATE) as fecha,
 count(venta_id) ventas_totales
FROM sell.ventas
WHERE YEAR(fecha_venta) < 2022 
GROUP BY CAST(fecha_venta AS DATE)
--having COUNT(fecha_venta) < 500 
ORDER BY fecha

 -----------------------------------------------------------------------------------------------------------------
 --Seleccione el nombre y el total de compras realizadas por cada cliente, pero solo para aquellos clientes cuyo total de compras supere 100 dolares.
 select * from sell.ventas
 
select 
c.cliente_id,
--venta_id,
c.nombre,
sum(v.total_venta) as compra_superior
from sell.ventas as v
join cli.clientes as c on v.cliente_id = c.cliente_id
group by c.cliente_id, c.nombre
having sum(total_venta) > 100

 -----------------------------------------------------------------------------------------------------------------
 --Encuentre el producto más vendido en cada categoría.
  select * from sell.productos
   select * from sell.detalle_ventas

SELECT 
v.categoria_id, 
SUM(dv.cantidad) as cantidad_total 
FROM sell.productos as v
join sell.detalle_ventas dv on v.producto_id = dv.producto_id
GROUP BY categoria_id
ORDER BY cantidad_total  DESC

 -----------------------------------------------------------------------------------------------------------------
 --Seleccione el nombre del producto y la cantidad vendida para los productos que hayan sido vendidos más de 20 veces.

   select * from sell.productos
   select * from sell.detalle_ventas


    select * from sell.productos 

select
dv.producto_id,
v.nombre_producto,
sum(dv.cantidad) as cantidad_vendida
from sell.detalle_ventas dv

join sell.productos v on  v.producto_id = dv.producto_id
GROUP BY dv.producto_id, v.nombre_producto
having sum(dv.cantidad) > 20

	--pude solito lets go
 -----------------------------------------------------------------------------------------------------------------
