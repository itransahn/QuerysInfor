SELECT 
TIENDA,
PEDIDO,
SUM(SOLICITADO) AS SOLICITADO,
SUM(PROCESADO)  AS PROCESADO,
( SUM(SOLICITADO) - SUM(PROCESADO) ) as DIFERENCIA, 
CODEERP,
Descripcion,
UbicacionPicking,
SUM(stockPicking) AS stockPicking
FROM
(
Select 
O.CONSIGNEEKEY AS TIENDA,
od.orderkey as PEDIDO,
-- o.totalqty as orderQTY,
-- p.qty as pickQTY,
-- p.uomqty as pickUOM,
(OD.ORIGINALQTY / NULLIF(pa.CASECNT,0)) AS SOLICITADO,
(
CASE WHEN OD.status <> 95 THEN (OD.QTYPICKED / NULLIF(pa.CASECNT,0)) 
ELSE (OD.SHIPPEDQTY / NULLIF(pa.CASECNT,0)) END) AS PROCESADO,
s.sku as CODEERP,
s.descr as Descripcion,
l.loc   as UbicacionPicking,
(l.qty/ NULLIF(pa.CASECNT,0))   as stockPicking
from WMWHSE51.ORDERS O
LEFT JOIN WMWHSE51.PICKDETAIL   p on o.orderkey = p.orderkey
LEFT JOIN WMWHSE51.ORDERDETAIL od on o.orderkey = od.orderkey
LEFT JOIN WMWHSE51.sku          s on od.sku    = s.sku
LEFT JOIN WMWHSE51.lotxlocxid   l on od.sku    = l.sku
LEFT JOIN WMWHSE51.loc         lc on l.loc     = lc.loc
LEFT JOIN WMWHSE51.pack        pa on s.PACKKEY = pa.PACKKEY
WHERE --o.carrierroutestatus like '%PENDING%' 
o.STORERKEY like '%1770142%'
AND lc.loclevel = 1
)T0
GROUP BY 
TIENDA,
PEDIDO,
CODEERP,
Descripcion,
UbicacionPicking
HAVING ( SUM(SOLICITADO) - SUM(PROCESADO) ) > 0