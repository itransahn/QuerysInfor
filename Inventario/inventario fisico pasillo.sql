/* columnas requeridas
sector
pasillo
columna
nivel
contenedor
codigo
ean13
descripcion
etiqueta
vencimiento
cajas
unidades
*/
/* columnas solo diseño
fisico
diferencia
*/

SELECT 
LO.PUTAWAYZONE AS ZONA
,LLI.LOC AS UBICACION
,LLI.SKU AS CODIGO
,AL.ALTSKU EAN13
,SK.DESCR AS DESCRIPCION
,LLI.ID AS ETIQUETA
,vLLI.LOTTABLE05 VENCIMIENTO
,(LLI.QTY/PA.CASECNT) AS CAJAS
,LLI.QTY AS UNIDADES
FROM WMWHSE51.LOTXLOCXID AS LLI
LEFT JOIN WMWHSE51.LOC AS LO
ON LLI.LOC = LO.LOC
LEFT JOIN WMWHSE51.ALTSKU AS AL
ON LLI.SKU = AL.SKU AND AL.TYPE LIKE 'EAN13' AND LLI.STORERKEY = AL.STORERKEY
LEFT JOIN WMWHSE51.SKU AS SK
ON LLI.SKU = SK.SKU AND LLI.STORERKEY = SK.STORERKEY
LEFT JOIN WMWHSE51.vITLotxLocxId_Lottables AS vLLI
ON LLI.LOC = vLLI.LOC AND LLI.ID = vLLI.ID
LEFT JOIN WMWHSE51.PACK AS PA
ON SK.PACKKEY = PA.PACKKEY


/*inteinto de segmentar las ubicaciones*/
SELECT 
STRING_SPLIT(LOC,'-'), A
FROM WMWHSE51.LOTXLOCXID

SELECT 
value
,COUNT(value) AS CONTAR
FROM WMWHSE51.LOTXLOCXID
CROSS APPLY STRING_SPLIT(LOC, '-',1)
WHERE LOC LIKE '14-100-2-1'
GROUP BY value

/*devuelve el valor correspondiente a lo que se indica en el campo for*/
SELECT   
[0], [1], [2], [3]  
FROM (
SELECT 
VALUE, COUNT(LOC) AS CONTAR
FROM WMWHSE51.LOTXLOCXID
CROSS APPLY STRING_SPLIT(LOC, '-')
WHERE LOC LIKE '14-100-2-1'
GROUP BY VALUE
ORDER BY VALUE
) AS SourceTable  
PIVOT  
(   
max(VALUE)  
FOR CONTAR IN ([0], [1], [2], [3])  
) AS PivotTable;