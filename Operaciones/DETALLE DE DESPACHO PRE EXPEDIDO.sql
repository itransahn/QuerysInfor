SELECT 
MAX(O.STATUS) AS ESTADO
,WD.WAVEKEY AS OLA
,MAX(W.ADDDATE) AS FECHALANZAMIENTO
,SUM(OD.SHIPPEDQTY) AS BULTOSENVIADOS
,SUM(OD.ORIGINALQTY) AS BULTOSPEDIDOS
,SUM(OD.PROCESSEDQTY) AS BULTOSPREPARADOS
,SUM(OD.QTYPICKED) AS BULTOSPICK
,MAX(PD.ID) AS ETIQUETAS
,MAX(TL.ADDDATE) AS FECHAPREEXPEDICION
,MAX(w.EDITWHO) AS USUARIO
,O.CONSIGNEEKEY AS TIENDA
,ST.DESCRIPTION AS NOMBRETIENDA
,O.ORDERKEY AS PEDIDO
,PD.LOC AS CANAL
,OD.SKU AS CODIGO
FROM WMWHSE51.ORDERDETAIL AS OD
LEFT JOIN WMWHSE51.WAVEDETAIL AS WD ON OD.ORDERKEY = WD.ORDERKEY
LEFT JOIN WMWHSE51.WAVE AS W ON WD.WAVEKEY = W.WAVEKEY
LEFT JOIN WMWHSE51.ORDERS AS O ON OD.ORDERKEY = O.ORDERKEY
LEFT JOIN WMWHSE51.STORER AS ST ON O.CONSIGNEEKEY = ST.STORERKEY
LEFT JOIN WMWHSE51.PACK AS PA ON OD.PACKKEY = PA.PACKKEY 
LEFT JOIN WMWHSE51.TRANSMITLOG AS TL ON WD.WAVEKEY = TL.KEY1 
LEFT JOIN WMWHSE51.PICKDETAIL AS PD ON OD.ORDERKEY = PD.ORDERKEY 
where O.STATUS IN ('55','95') 
--and wd.wavekey like '0000000166'
GROUP BY OD.SKU, O.CONSIGNEEKEY, ST.DESCRIPTION, PD.LOC, O.ORDERKEY, WD.WAVEKEY