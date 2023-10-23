SELECT DISTINCT
O.adddate,
O.C_COMPANY as Tienda,
O.EXTERNORDERKEY,
O.orderkey,
OD.sku,
O.storerkey as CodigoPropietario,
(OD.originalqty / p.CASECNT ) as CajasPedidas,
S.descr as Articulo,
(SELECT top 1 description 
from wmwhse51.STORER ST 
WHERE ST.storerkey = O.storerkey ) as Propietario,
(SELECT TOP 1 LOC FROM WMWHSE51.PICKDETAIL AS PI WHERE PI.SKU = OD.SKU 
AND PI.ORDERKEY = O.orderkey) AS UBICACION
,(SELECT (SUM(LO.QTY)/ p.CASECNT) AS CANTIDAD FROM WMWHSE51.LOTXLOCXID AS LO
WHERE LO.SKU = OD.SKU GROUP BY LO.SKU) AS STOCK,
isnull((SELECT MIN( left(cast(ltt.LOTTABLE05 as date),10)) 
        FROM wmwhse51.LOTATTRIBUTE ltt WHERE ltt.sku = OD.sku), 
'Sin Stock') as FechaVencimiento
FROM wmwhse51.ORDERS as O
LEFT JOIN wmwhse51.ORDERDETAIL as OD ON O.orderkey = OD.orderkey
LEFT JOIN wmwhse51.sku as s on OD.sku = s.sku
LEFT JOIN wmwhse51.PACK as p on OD.packkey = p.packkey