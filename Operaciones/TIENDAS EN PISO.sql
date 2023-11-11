SELECT 
ROW_NUMBER() over ( order by DESPACHO asc ) as  FILA
,MAX(ST.DESCRIPTION) AS TIENDA
,DESPACHO
,SUM(UNIDADES) AS UNIDADES
,SUM(BULTOS) AS BULTOS
,COUNT(ETIQUETAS) AS ETIQUETA
--,MAX(ESTADO) AS ESTADO
,MAX(CK.DESCRIPTION) AS ESTADO
,MAX(CANALES) AS CANALES
,MAX(PREEXPEDICION) AS PREEXPEDICION
,CAST(PREEXPEDICION AS DATE) AS FECHAFILTRO
FROM(SELECT
O.CONSIGNEEKEY AS TIENDA
,PD.WAVEKEY AS DESPACHO
,PD.QTY AS UNIDADES
,PD.UOMQTY AS BULTOS
,PD.ID ETIQUETAS
,W.STATUS AS ESTADO
,PD.LOC AS CANALES
,TL.ADDDATE AS PREEXPEDICION
--,ESCANEO
FROM WMWHSE51.PICKDETAIL AS PD
LEFT JOIN WMWHSE51.WAVE AS W
ON PD.WAVEKEY = W.WAVEKEY
LEFT JOIN WMWHSE51.TRANSMITLOG AS TL
ON PD.WAVEKEY = TL.KEY1
LEFT JOIN WMWHSE51.ORDERS AS O
ON PD.ORDERKEY = O.ORDERKEY
WHERE pd.STORERKEY like '%1770142%'
)T0 
LEFT JOIN WMWHSE51.STORER AS ST
ON T0.TIENDA = ST.STORERKEY
LEFT JOIN WMWHSE51.LOC AS L
ON T0.CANALES = L.LOC AND L.LOCATIONTYPE LIKE 'OTHER'
LEFT JOIN WMWHSE51.CODELKUP AS CK 
ON T0.ESTADO = CK.CODE AND CK.LISTNAME LIKE '%WAVE%'
GROUP BY DESPACHO, PREEXPEDICION