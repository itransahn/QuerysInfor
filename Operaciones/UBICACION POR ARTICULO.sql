SELECT 
UBICACION
,CODIGO
,(CASE WHEN CANTIDAD = 0 OR PA.CASECNT = 0 THEN 0
ELSE CANTIDAD/PA.CASECNT END) AS CAJAS
,EAN13
,LOTE
,ETIQUETA
FROM(
SELECT 
LO.LOC AS UBICACION
,SK.DESCR AS DESCRIPCION
,LO.SKU AS CODIGO
,LO.QTY AS CANTIDAD
,AL.ALTSKU AS EAN13
,LO.LOT AS LOTE
,LO.ID AS ETIQUETA
,SK.PACKKEY AS FACTOR
FROM WMWHSE51.LOTXLOCXID AS LO
LEFT JOIN WMWHSE51.ALTSKU AS AL
ON LO.SKU = AL.SKU AND AL.TYPE LIKE '%EAN13%'
LEFT JOIN WMWHSE51.SKU AS SK
ON LO.SKU = SK.SKU
WHERE LO.QTY > 0
)T0
LEFT JOIN WMWHSE51.PACK AS PA
ON T0.FACTOR = PA.PACKKEY
LEFT JOIN WMWHSE51.LOC AS LC
ON T0.UBICACION = LC.LOC AND LC.LOCATIONTYPE LIKE 'OTHER' AND LC.LOCLEVEL > 0