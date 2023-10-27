SELECT
CAST(RD.DATERECEIVED AS DATE) AS FECHA,
CAST(RD.ADDDATE AS DATE) AS FECHACORTA,
RD.TOID AS ETIQUETA,
RD.RECEIPTKEY AS CODIGOASN,
RD.REFERENCEDOCUMENT AS CODIGOORDEN,
SUM((RD.QTYRECEIVED/PA.CASECNT)) AS CAJAS,
SUM(RD.QTYRECEIVED) AS UNIDADES,
RD.SKU AS CODIGO,
MAX(AL.ALTSKU) AS EAN13,
MAX(SK.DESCR) AS DESCRIPCION
FROM WMWHSE51.RECEIPTDETAIL AS RD
LEFT JOIN WMWHSE51.SKU AS SK
ON RD.SKU = SK.SKU AND RD.STORERKEY = SK.STORERKEY
LEFT JOIN WMWHSE51.PACK AS PA
ON RD.PACKKEY = PA.PACKKEY
LEFT JOIN WMWHSE51.ALTSKU AS AL
ON RD.SKU = AL.SKU AND AL.TYPE LIKE 'EAN13'
WHERE RD.QTYRECEIVED > 0
GROUP BY RD.RECEIPTKEY, RD.SKU, RD.DATERECEIVED, RD.TOID, RD.ADDDATE, RD.REFERENCEDOCUMENT