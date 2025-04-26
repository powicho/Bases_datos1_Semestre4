--================================================================================================================================================
--================================================================================================================================================
--EQUIPO DE DYLAN TELON, LUIS AVILA, RODRIGO BONILLA==============================================================================================
--================================================================================================================================================
--Este proyecto se trabajo cada quien con su archivo individual donde cada quien encontro las soluciones apropiadas a cada ejericio.==============
--Se compararon respuestas y se dio retroalimentacion para llegar al objetivo final.==============================================================
--================================================================================================================================================
--================================================================================================================================================
--------------------------------------------------------------------------------------------------------------------------------------------------
--🔹 Reto 1 – Top compradores del año
--Mostrar los 5 clientes que más dinero han gastado en total durante el último año, ordenados del mayor al menor

  select * from cli.clientes
  select * from sell.ventas
  --intento inical desade donde se trabajo el ejercicio
--  select top 5
--    c.cliente_id,
--    c.nombre,
--    c.apellido,
--    SUM(v.total_venta) AS Total_Gastado,
--	CAST(v.fecha_venta as DATE) as fecha
--from cli.clientes  as c
--inner join sell.ventas as v on c.cliente_id = v.cliente_id
--WHERE YEAR(v.fecha_venta) = 2021 
--group by  c.cliente_id, c.nombre, c.apellido, CAST(v.fecha_venta AS DATE)
--order by Total_Gastado desc

  select top 5
    c.cliente_id,
    c.nombre,
    c.apellido,
    SUM(v.total_venta) AS Total_Gastado
	--CAST(v.fecha_venta as DATE) as fecha
from cli.clientes  as c
inner join sell.ventas as v on c.cliente_id = v.cliente_id
WHERE YEAR(v.fecha_venta) = 2021 
group by  c.cliente_id, c.nombre, c.apellido--, CAST(v.fecha_venta AS DATE)
order by Total_Gastado desc

--mediante el select top 5 solo se encapsulan los primeros 5 datos que se quieren mostrar con lo que pide la consulta
-- se obtienen los datos de sus respectivas tablas y se aplica un sum al total de las ventas para sabar cuales son los clientes que mas han gastado sumando todas las ventas 
--luego del join se aplica un where el cual nmos mostrara unicamente el año el cual se iguala a  2021 y no se hace un get a date ya qu esta base de datos que nos paso solo tiene valores del 2021
-- ultimo se agrupan las columnas y como se ordenaran las filas segun el total gastado

--------------------------------------------------------------------------------------------------------------------------------------------------
--🔹 Reto 2 – Categorías sin productos vendidos
--Encontrar las categorías que no han tenido ningún producto vendido.
SELECT * FROM sell.productos
 select cantidad from sell.detalle_ventas where cantidad != 0
  select * from sell.categoria

--Lo que esta consulta no son productos que nunca se vendieron. 
--Lo que te muestra son los registros  de ventas que ocurrieron en 2021, pero muestra la cantidad  de los productos y categorias en esas ventas registradas que fueron 0.
 select
dv.venta_id,
v.categoria_id,
COUNT(*) cantidad_productos,
vOG.fecha_venta,
dv.cantidad as cantidad_vendidos
from sell.productos as v
left join sell.detalle_ventas as dv on dv.producto_id = v.producto_id
left join sell.ventas as vOG on vOG.venta_id = dv.venta_id
WHERE YEAR(vOG.fecha_venta) = 2021 -- este o no este este where no afecta ya que la base de datos solo tiene fechas relacionadas a 2021
group by v.categoria_id, dv.cantidad, dv.venta_id, vOG.fecha_venta 
having dv.cantidad = 0
order by   v.categoria_id asc, dv.venta_id asc; 

  --con este se ejecuta con left joins para conocer cuales categorias no se han vendido en sell ventas y sell detalle ventas
  --pero no devuelve nada ya que todos los productos almenos 1 vez han sido vendidos un producto de cada categoria o una categoria a sido vendido almenos 1 vez
  SELECT
    c.categoria_id,   
    c.categoria       
FROM sell.categoria AS c 
LEFT JOIN Sell.productos AS p ON c.categoria_id = p.categoria_id
LEFT JOIN sell.detalle_ventas AS dv ON p.producto_id = dv.producto_id
GROUP BY c.categoria_id, c.categoria
HAVING COUNT(dv.producto_id) = 0;
	
------------------------------------------------------------------------------------------------------------------------------------------------
--🔹 Reto 3 – Días con mayor volumen de ventas
--Listar los 3 días con más cantidad de productos vendidos (sumando todas las ventas del día).

select * from sell.ventas
select * from sell.detalle_ventas

  --intento inical desade donde se trabajo el ejercicio=-------------------------------------
----select top 3
--SUM(v.total_venta) AS Total_Gastado,
--CAST(v.fecha_venta as DATE) as fecha
--from sell.ventas as v
--GROUP BY CAST(v.fecha_venta AS DATE)
--ORDER BY fecha

select top 3 
CAST(v.fecha_venta AS DATE) AS Dia, 
sUM(dv.cantidad) AS Total_Productos
--CAST(v.fecha_venta as DATE) as fecha
from sell.ventas as v
join sell.detalle_ventas as dv on v.venta_id = dv.venta_id
GROUP BY CAST(v.fecha_venta AS DATE)
ORDER BY Total_Productos desc

 -- Los pasos son, primero: encontrar las tablas que necesito sacar la informacion.
  --segundo: segun lo que pide la instruccion extraer los datos que son los fecha de la venta y cantidad de productos. pero teniendo un select para encontrar el top 3
  --o los primeros 3 segun lo requirido

--------------------------------------------------------------------------------------------------------------------------------------------------
--🔹 Reto 4 – Productos con mejor desempeño en stock
--Mostrar los productos que han vendido más del 50% de su stock actual.

SELECT * FROM sell.productos
 select * from sell.detalle_ventas 
 select * from sell.ventas 
 
 --como todos han venido hasta mil significa que todos han vendido mas que su stock nomal
 SELECT
    p.producto_id,
    p.nombre_producto,
    p.stock AS StockActual,          
    SUM(dv.cantidad) AS TotalVendido
FROm sell.productos AS p         
INNER JOIN sell.detalle_ventas AS dv ON p.producto_id = dv.producto_id 
GROUP BY p.producto_id, p.nombre_producto, p.stock                      
HAVING SUM(dv.cantidad) > (p.stock * 0.5) AND p.stock > 0              
ORDER BY p.producto_id
 --Llegue a esta solucion con pasos sencillos, primero: encontrar las tablas que necesito sacar la informacion.
  --segundo: segun lo que pide la instruccion extraer los datos que son los productos id, stock, cantidad y el nombre de los productos ya que con ello confirmo puedo trabajary comprobar los porcentajes
  --mediante la logica del sum aplicada del having donde la cantidad tiene que ser mayor al stock * 0.5 (50%) y el stock mayor a 0 
  --pero todos han venido hasta mil significa que todos han vendido mas que su stock nomal  y rompe mas alla del 50% y pasa mas del 100% de ventas segun el stock
 

  --intento inical desade donde se trabajo el ejercicio=-------------------------------------
 -- select 
 -- --stock, cantidad vendida, producto id, venta id.
 --  dv.venta_id,
 -- v.producto_id,
 --v.stock,
 --dv.cantidad, count(*) cantidad_vendida
 --from sell.productos as v
 --join sell.detalle_ventas as dv on v.producto_id = dv.producto_id
 --group by    dv.venta_id, v.stock,  dv.cantidad, v.producto_id

--------------------------------------------------------------------------------------------------------------------------------------------------
--🔹 Reto 5 – Clientes sin compras pero con carritos
--Encontrar los clientes que no han realizado ninguna compra, pero tienen al menos un carrito creado.

-- clientes, carrito, ventas. 
 select * from cli.clientes
  select * from sell.carrito_compras

 select venta_id from sell.ventas where venta_id = 0

  select DISTINCT 
  cl.cliente_id,
  cc.carrito_id,
  count (v.venta_id) as ventas_con_sin_carrito
  from sell.carrito_compras as cc
  left join cli.clientes as cl on cl.cliente_id = cc.cliente_id
  left join sell.ventas as v on cl.cliente_id = v.cliente_id
  WHERE v.venta_id IS NULL --tambien devuelve con valores 0 o nulos 
  group by  cc.carrito_id, cl.cliente_id
  --having count (v.venta_id) = 0 --tambien devuelve con valores 0 o nulos 
  order by  cl.cliente_id asc 
  --Llegue a esta solucion con pasos sencillos, primero: encontrar las tablas que necesito sacar la informacion.
  --segundo: segun lo que pide la instruccion extraer los datos que son los clientes id, carrito id y las ventas ya que con ello confirmo si existe alguna compra de parte del cliente
  --esto mediante el id de las ventas ya que estan estrechamente relacionadas con los cliente id mediante el left join, a lo cual al buscar venta id 0 no devuelve nada porque
  --el cliente 733 no realizo ninguna compra a lo cual no genero ninguna venta pero si tiene un carrito o 4 carritos relacionados.
  --y el distinc es para hacer una distincion de los los dato comparando todos lo datos existentes mediante las constultas del where, group by t order by
--------------------------------------------------------------------------------------------------------------------------------------------------
