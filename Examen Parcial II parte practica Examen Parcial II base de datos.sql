--le cree una nueva db llamda BellezaPerfecta  para no utilizar la master ya que ahi estoy trabajando otras tablas.
USE BellezaPerfecta;
GO
------------------------------------------------------------------------------------------------------------------------------------------------------------
select * from parcialii.cliente
select * from parcialii.departamento
select * from parcialii.empleado
select * from parcialii.factura_encabezado
select * from parcialii.facturas_detalle
select * from parcialii.producto
select * from parcialii.servicio
------------------------------------------------------------------------------------------------------------------------------------------------------------
--1.¿Cuál es el producto más vendido en nuestra clínica?
select * from parcialii.producto
select * from parcialii.facturas_detalle
 
 select top 1
 p.id_producto,
 p.nombre,
 sum (fd.cantidad) as producto_masVendido
 from parcialii.producto as p
 join   parcialii.facturas_detalle as fd on  p.id_producto = fd.id_producto
 WHERE  fd.naturaleza = 'B' 
 group by p.id_producto, p.nombre 
 order by producto_masVendido desc


------------------------------------------------------------------------------------------------------------------------------------------------------------
--2.¿Cuál es el producto que ha generado la mayor ganancia en ventas?
select * from parcialii.facturas_detalle
select * from parcialii.producto

 select top 1
 p.id_producto,
 p.nombre,
 sum (fd.total - p.costo * fd.cantidad) as producto_masVendido
 from parcialii.producto as p
 join   parcialii.facturas_detalle as fd on  p.id_producto = fd.id_producto
 WHERE  fd.naturaleza = 'B' 
 group by p.id_producto, p.nombre 
 order by producto_masVendido desc
 -- sum (fd.total - p.costo * fd.cantidad) as producto_masVendido esto muestra el calculo del costo del producto la cantidad que se vendio y el total para dar cuanta ganancia a dejado 
  --segunb el desc
------------------------------------------------------------------------------------------------------------------------------------------------------------
--3.¿Cuál es el producto que ha generado la menor ganancia en ventas?
select * from parcialii.facturas_detalle

 select top 1
 p.id_producto,
 p.nombre,
 sum (fd.total - p.costo * fd.cantidad) as producto_MenosVendido
 from parcialii.producto as p
 join   parcialii.facturas_detalle as fd on  p.id_producto = fd.id_producto
 WHERE  fd.naturaleza = 'B' 
 group by p.id_producto, p.nombre 
 order by producto_MenosVendido asc

  -- sum (fd.total - p.costo * fd.cantidad) as producto_MenosVendido esto muestra el calculo del costo del producto la cantidad que se vendio y el total para dar cuanta perdida o menor ganancia a dejado 
  --segunb el asc
------------------------------------------------------------------------------------------------------------------------------------------------------------
--4.¿Cuál es la cantidad total de productos que hemos vendido hasta la fecha?
select * from parcialii.facturas_detalle

select 
 sum (fd.cantidad) as producto_masVendido
 from parcialii.facturas_detalle as fd 
 WHERE  fd.naturaleza = 'B' 
 --se suma la cantridada de los productros de cantidad especificaondo su seccion o naturaleza b
------------------------------------------------------------------------------------------------------------------------------------------------------------
--5.¿Cuál es el cliente que ha provocado el mayor gasto en nuestros servicios?
select * from parcialii.facturas_detalle
select * from parcialii.cliente
select * from parcialii.factura_encabezado
select * from parcialii.servicio

select top 1
pc.id_cliente,
pc.nombres,
sum(pfd.total) as Gasto_total_cliente
from parcialii.cliente as pc
left join parcialii.factura_encabezado as pfe on pc.id_cliente = pfe.id_cliente
left join  parcialii.facturas_detalle as pfd on pfd.id_factura_encabezado = pfe.id_factura_encabezado
group by pc.id_cliente, pc.nombres
order by Gasto_total_cliente desc

------------------------------------------------------------------------------------------------------------------------------------------------------------
--6.¿Cuál es el cliente que nos ha generado mayor monto de compra?
select * from parcialii.factura_encabezado
select * from parcialii.cliente
select * from parcialii.facturas_detalle
select * from parcialii.servicio

select top 1
pc.id_cliente,
pc.nombres,
sum(pfe.total) as Monto_total_cliente
from parcialii.cliente as pc
join parcialii.factura_encabezado as pfe on pc.id_cliente = pfe.id_cliente
group by pc.id_cliente, pc.nombres
order by Monto_total_cliente desc

 -- sum (fd.total - p.costo * fd.cantidad)XXXXXXXXXXXXXX

------------------------------------------------------------------------------------------------------------------------------------------------------------
--7.Podrías proporcionarme un listado de nuestros clientes junto con sus edades, y además un reporte de cuántos clientes tenemos en cada rango de edad?
select * from parcialii.cliente

-- Calcular la edad
SELECT 
pc.nombres,
pc.apellidos,
pc.fecha_nacimiento, 
DATEDIFF(YEAR, pc.fecha_nacimiento, GETDATE()) AS EdadCalculada 
FROM  parcialii.cliente AS pc
ORDER BY  EdadCalculada desc 

--a.18-25 años
SELECT 
pc.nombres,
pc.apellidos,
pc.fecha_nacimiento, 
DATEDIFF(YEAR, pc.fecha_nacimiento, GETDATE()) AS EdadCalculada 
FROM  parcialii.cliente AS pc
WHERE DATEDIFF(YEAR, pc.fecha_nacimiento, GETDATE()) BETWEEN 18 AND 25
ORDER BY  EdadCalculada desc 
--no hay clientes de esas edades 

--b.26-35 años
SELECT 
pc.nombres,
pc.apellidos,
pc.fecha_nacimiento, 
DATEDIFF(YEAR, pc.fecha_nacimiento, GETDATE()) AS EdadCalculada 
FROM  parcialii.cliente AS pc
WHERE DATEDIFF(YEAR, pc.fecha_nacimiento, GETDATE()) BETWEEN 26 AND 35 
ORDER BY  EdadCalculada desc 
--existen clienntes desde 27 años en adelante

--c.36-45 años
SELECT 
pc.nombres,
pc.apellidos,
pc.fecha_nacimiento, 
DATEDIFF(YEAR, pc.fecha_nacimiento, GETDATE()) AS EdadCalculada 
FROM  parcialii.cliente AS pc
WHERE DATEDIFF(YEAR, pc.fecha_nacimiento, GETDATE()) BETWEEN 36 AND 45 
ORDER BY  EdadCalculada desc 
--si hay clientes ene se rango

--d.46-65 años
SELECT 
pc.nombres,
pc.apellidos,
pc.fecha_nacimiento, 
DATEDIFF(YEAR, pc.fecha_nacimiento, GETDATE()) AS EdadCalculada 
FROM  parcialii.cliente AS pc
WHERE DATEDIFF(YEAR, pc.fecha_nacimiento, GETDATE()) BETWEEN 46 AND 65 
ORDER BY  EdadCalculada desc 
--si hay clientes ene se rango pero nomas nos llegaron a 49


--e.Más de 66 años
SELECT 
pc.nombres,
pc.apellidos,
pc.fecha_nacimiento, 
DATEDIFF(YEAR, pc.fecha_nacimiento, GETDATE()) AS EdadCalculada 
FROM  parcialii.cliente AS pc
WHERE DATEDIFF(YEAR, pc.fecha_nacimiento, GETDATE()) > 65
ORDER BY  EdadCalculada desc 
--no hay clientes de esas edades 

------------------------------------------------------------------------------------------------------------------------------------------------------------
--8.¿Cuál es el total de ventas que hemos realizado cada mes?
select * from parcialii.factura_encabezado
select * from parcialii.facturas_detalle

--Todas las ventas en la base de datos estan creadas en el mes de abril 
select 
YEAR(pfe.fecha) AS AñoVenta, -- año de la venta
MONTH(pfe.fecha) AS MesVenta,   -- número del mes 1-12
DATENAME(MONTH, pfe.fecha) AS NombreMes, -- Nombre del mes
SUM(pfe.total) AS TotalVentasDelMes -- Suma el total para ese año o mes 
from parcialii.factura_encabezado as pfe
GROUP BY YEAR(pfe.fecha),  MONTH(pfe.fecha),  DATENAME(MONTH, pfe.fecha) -- como se van agrupar los datos de las fechas 
ORDER BY  AñoVenta, MesVenta;

------------------------------------------------------------------------------------------------------------------------------------------------------------
--9.¿Cuál es el promedio de ventas por cliente en nuestra clínica?
select * from parcialii.factura_encabezado
select * from parcialii.facturas_detalle

--promedio de ventas de todos los clientes
-- Paso 1
WITH GastoTotalPorCliente AS (
    SELECT SUM(fe.total) AS GastoTotal 
    FROM parcialii.factura_encabezado AS fe
    GROUP BY fe.id_cliente -- Agrupa solo por cliente
)
-- Paso 2
SELECT  AVG(GastoTotal) AS PromedioVentasPorCliente 
FROM GastoTotalPorCliente;
--esta solucion no es mia es de internet porque no sabuia como agruparlos todos pero mediante whit se puede encapsular y asignarle un nombre o valor a un select 
--para luego poder modificarlo que hay dentro de el que en este caso seria el avg ya que no pude encontrar como hacerlo con having o where poder afectar un sum de todas
--las venas y luego sacar el promedio en el mismo select

--promedio individual por cliente individual
select 
sum(pfe.total) as suma_total_cliente ,
AVG(pfe.total) as Promedio_ventas
from parcialii.factura_encabezado as pfe
GROUP BY pfe.id_cliente 
 
------------------------------------------------------------------------------------------------------------------------------------------------------------
--10.¿Quién es el empleado que ha realizado más ventas en nuestra clínica?
select * from parcialii.facturas_detalle
select * from parcialii.empleado

select top 1
pe.nombre,
pe.apellidos,
sum (pfe.total) as total_vendedor
from parcialii.empleado as pe
join parcialii.facturas_detalle as pfe on pe.id_empleado = pfe.id_vendedor
group by pe.nombre, pe.apellidos
order by total_vendedor desc

------------------------------------------------------------------------------------------------------------------------------------------------------------
--11.¿Cuál es el total de ingresos que hemos generado en cada año y mes?
select * from parcialii.factura_encabezado
select * from parcialii.producto
select * from parcialii.servicio

----Todas las ventas en la base de datos estan creadas en el mes de abril de 1 solo año 

SELECT 
    YEAR(fe.fecha) AS AnioVenta,
    MONTH(fe.fecha) AS MesVenta,
    DATENAME(MONTH, fe.fecha) AS NombreMes,
    SUM(fd.total) AS IngresoBrutoTotalDelMes, -- ingreso mes
    
    -- Suma de la GANANCIA calculada para cada línea de detalle
    SUM(
        CASE 
            -- Producto: Ganancia = Ingreso Línea - Costo Línea
            WHEN fd.naturaleza = 'B' THEN (fd.total - (p.costo) * fd.cantidad) 
            -- Servicio: Ganancia = Ingreso Línea (asumiendo costo 0)
            WHEN fd.naturaleza = 'S' THEN fd.total 
            ELSE 0 
        END
    ) AS GananciaEstimadaDelMes -- Este es el valor que buscas

FROM 
    parcialii.factura_encabezado AS fe 
INNER JOIN 
    parcialii.facturas_detalle AS fd ON fe.id_factura_encabezado = fd.id_factura_encabezado
LEFT JOIN parcialii.producto AS p ON fd.id_producto = p.id_producto AND fd.naturaleza = 'B' 
GROUP BY 
    YEAR(fe.fecha), 
    MONTH(fe.fecha), 
    DATENAME(MONTH, fe.fecha) 
ORDER BY 
    AnioVenta, 
    MesVenta;


--intento inicial
----Todas las ventas en la base de datos estan creadas en el mes de abril de 1 solo año 
--select 
--YEAR(pfe.fecha) AS AñoVenta, -- año de la venta
--MONTH(pfe.fecha) AS MesVenta,   -- número del mes 1-12
--DATENAME(MONTH, pfe.fecha) AS NombreMes, -- Nombre del mes
--SUM(pfe.total) AS TotalVentasDelMes, -- Suma el total para ese año o mes 
--sum(p.costo) as total_costos,
--sum(ser.precio) as totalPrecio
--from parcialii.factura_encabezado as pfe
--INNER JOIN parcialii.facturas_detalle AS fd ON pfe.id_factura_encabezado = fd.id_factura_encabezado
--LEFT JOIN  parcialii.producto AS p ON fd.id_producto = p.id_producto AND fd.naturaleza = 'B' 
-- left JOIN  parcialii.servicio AS ser ON fd.id_producto = ser.id_servicio AND fd.naturaleza = 'S' 
--GROUP BY YEAR(pfe.fecha),  MONTH(pfe.fecha),  DATENAME(MONTH, pfe.fecha) -- como se van agrupar los datos de las fechas 
--ORDER BY  AñoVenta, MesVenta;
 -- sum (fd.total - p.costo * fd.cantidad)XXXXXXXXXXXXXX
------------------------------------------------------------------------------------------------------------------------------------------------------------
--12.¿Cuál es el promedio de precio de nuestros productos por marca
select * from parcialii.producto

--promedio por produto in  divudal
SELECT 
    p.id_marca,    
    AVG(p.precio) AS PrecioPromedio 
FROM  parcialii.producto AS p
GROUP BY  p.id_marca                       
ORDER BY  p.id_marca;        

-- promedioo gneneral de los productos 
SELECT 
    AVG(p.precio) AS PrecioPromedioGeneral 
FROM 
    parcialii.producto AS p
------------------------------------------------------------------------------------------------------------------------------------------------------------