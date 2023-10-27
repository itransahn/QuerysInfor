SELECT
PEDIDO
,OLA
,MAX(FECHAGENERACION) AS FECHAGENERACION
,MAX(ESTADOPEDIDO) AS ESTADOPEDIDO
,MAX(ESTADOOLA) AS ESTADOOLA
,MAX(TIENDA) AS TIENDA
,MAX(NOMBRETIENDA) AS NOMBRETIENDA
,SUM(UNIDADSOLICITADA/FACTOR) AS CAJASSOLICITADAS
,SUM(UNIDADESSERVIDAS/FACTOR) AS CAJASSERVIDADAS
,(SUM(UNIDADESSERVIDAS)/SUM(UNIDADSOLICITADA)) AS AVANCE
FROM(
    SELECT 
OD.ORDERKEY AS PEDIDO,
ISNULL(WD.WAVEKEY,'--') AS OLA,
OD.ADDDATE AS FECHAGENERACION,
O.STATUS AS ESTADOPEDIDO,
ISNULL(W.STATUS,'--') AS ESTADOOLA,
O.CONSIGNEEKEY AS TIENDA,
ISNULL(ST.DESCRIPTION,'--') AS NOMBRETIENDA,
OD.ORIGINALQTY AS UNIDADSOLICITADA,
PA.CASECNT AS FACTOR,
OD.SHIPPEDQTY AS UNIDADESSERVIDAS,
OD.SKU AS CODIGO
FROM WMWHSE51.ORDERDETAIL AS OD
LEFT JOIN WMWHSE51.ORDERS AS O
ON OD.ORDERKEY = O.ORDERKEY
LEFT JOIN WMWHSE51.STORER AS ST
ON O.CONSIGNEEKEY = ST.STORERKEY
LEFT JOIN WMWHSE51.WAVEDETAIL AS WD
ON OD.ORDERKEY = WD.ORDERKEY
LEFT JOIN WMWHSE51.WAVE AS W
ON WD.WAVEKEY = W.WAVEKEY
LEFT JOIN WMWHSE51.PACK AS PA
ON OD.PACKKEY = PA.PACKKEY
)T0
GROUP BY PEDIDO, OLA