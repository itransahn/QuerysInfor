SELECT 
WD.WAVEKEY AS DESPACHO
,TIENDA
,ST.DESCRIPTION AS TIENDANOMBRE
,WD.EDITDATE AS FECHA
,PEDIDO
,UNIDADES
,UNIDADES/PA.CASECNT AS CAJAS
,CODIGO
,SK.DESCR AS DESCRIPCION
,ETIQUETA
FROM(
SELECT 
OD.ORDERKEY AS PEDIDO
,O.CONSIGNEEKEY AS TIENDA
,OD.SKU AS CODIGO
,(CASE 
WHEN OD.status <> 95 THEN (OD.QTYPICKED) 
ELSE (OD.SHIPPEDQTY) END) AS UNIDADES
,OD.ID AS ETIQUETA
,OD.PACKKEY AS FACTOR
FROM WMWHSE51.ORDERDETAIL AS OD
LEFT JOIN WMWHSE51.ORDERS AS O
ON OD.ORDERKEY = O.ORDERKEY
)T0
LEFT JOIN WMWHSE51.SKU AS SK
ON T0.CODIGO = SK.SKU
LEFT JOIN WMWHSE51.PACK AS PA
ON T0.FACTOR = PA.PACKKEY
LEFT JOIN WMWHSE51.STORER AS ST
ON T0.TIENDA = ST.STORERKEY
LEFT JOIN WMWHSE51.WAVEDETAIL AS WD
ON T0.PEDIDO = WD.ORDERKEY