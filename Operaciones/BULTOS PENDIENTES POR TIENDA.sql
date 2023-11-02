SELECT 
MAX(TIPO) AS TIPO
,TIENDA
--,MAX(PEDIDO) AS PEDIDO
,SUM(SOLICITADO-PROCESADO)/PA.CASECNT AS BULTOS
FROM (
SELECT 
OD.ORDERKEY AS PEDIDO
,OD.PACKKEY AS PAQUETE
,O.CONSIGNEEKEY AS TIENDA
,SUM(OD.ORIGINALQTY) AS SOLICITADO
,O.SUSR1 AS TIPO
,(CASE WHEN OD.status <> 95 THEN SUM(OD.QTYPICKED) 
ELSE SUM(OD.SHIPPEDQTY) END) AS PROCESADO
FROM WMWHSE51.ORDERDETAIL AS OD
INNER JOIN WMWHSE51.ORDERS AS O
ON OD.ORDERKEY = O.ORDERKEY
WHERE O.STATUS NOT IN (95, 55) AND O.STORERKEY LIKE '1770142'
GROUP BY OD.ORDERKEY, OD.STATUS, OD.PACKKEY, O.CONSIGNEEKEY, O.SUSR1
)T0
LEFT JOIN WMWHSE51.PACK AS PA
ON T0.PAQUETE = PA.PACKKEY
GROUP BY TIENDA, PA.CASECNT