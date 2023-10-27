SELECT
PEDIDO
,CODIGO
,TIENDA
,NOMBRETIENDA
,FECHA
,DESCRIPCION
,PAQUETE
,UNIDADES
,(UNIDADES/PA.CASECNT) AS CAJAS
,FECHACADUCIDAD
FROM(
    SELECT 
O.ORDERKEY AS PEDIDO
,OD.SKU AS CODIGO
,MAX(O.CONSIGNEEKEY) AS TIENDA
,MAX(ST.DESCRIPTION) AS NOMBRETIENDA
,MAX(O.ADDDATE) AS FECHA
,MAX(SK.DESCR) AS DESCRIPCION
,MAX(OD.PACKKEY) AS PAQUETE
,(
CASE 
WHEN MAX(O.status) <> 95 THEN 
SUM(ABS(OD.QTYPICKED))
ELSE 
SUM(ABS(OD.PROCESSEDQTY))
END
) AS UNIDADES
,MAX(OD.LOTTABLE05) FECHACADUCIDAD
FROM WMWHSE51.ORDERS AS O
LEFT JOIN WMWHSE51.ORDERDETAIL AS OD
ON O.ORDERKEY = OD.ORDERKEY
LEFT JOIN WMWHSE51.STORER AS ST
ON O.CONSIGNEEKEY = ST.STORERKEY
LEFT JOIN WMWHSE51.SKU AS SK
ON OD.SKU = SK.SKU
GROUP BY O.ORDERKEY, OD.SKU
)T0
LEFT JOIN WMWHSE51.PACK AS PA
ON T0.PAQUETE = PA.PACKKEY
