select
FechaCreacion
,(CASE WHEN USUARIORECEPCION = 'IonExtension' THEN PROPIETARIO
ELSE USUARIORECEPCION END) AS USUARIORECEPCION
,FECHARECEPCION
,ORDENCLIENTE
,CODIGOASN
,PROPIETARIO
,CANTIDADRECIBIDA
,CANTIDADESPERADA
,CODIGOARTICULO
,DESCRIPCIONARTICULO
,CODIGOALMANCE
,(CASE WHEN CANTIDADRECIBIDA = 0 OR CANTIDADESPERADA = 0 THEN 0
ELSE (CANTIDADRECIBIDA/CANTIDADESPERADA) END) AS CUMPLIMIENTO
,EAN13
,FACTOR
,CANTIDADETIQUETA
,PROVEEDOR
,FECHAVENCIMIENTO
,isnull((select
  STUFF(
  ( SELECT DISTINCT CAST(',' AS varchar(MAX)) + PD1.lottable06
    FROM WMWHSE51.RECEIPTDETAIL PD1
          WHERE PD1.RECEIPTKEY = CODIGOASN AND PD1.SKU = CODIGOARTICULO
          FOR XML PATH('') ), 1, 1, ' ')),'--')AS LOTE
from (
select 
MAX(RD.ADDDATE) AS FechaCreacion,
MAX(RD.DATERECEIVED) AS FECHARECEPCION,
MAX(RD.ADDWHO) AS USUARIORECEPCION,
MAX(RD.REFERENCEDOCUMENT) AS ORDENCLIENTE,
MAX(RD.RECEIPTKEY) AS CODIGOASN,
SUM(RD.QTYRECEIVED) AS CANTIDADRECIBIDA,
SUM(RD.QTYEXPECTED) AS CANTIDADESPERADA,
RD.SKU AS CODIGOARTICULO,
MAX(SK.DESCR) AS DESCRIPCIONARTICULO,
MAX(RD.STORERKEY) AS PROPIETARIO,
MAX(RD.WHSEID) AS CODIGOALMANCE,
MAX(PA.CASECNT) AS FACTOR,
COUNT(RD.TOID) AS CANTIDADETIQUETA,
MAX(RC.SUPPLIERCODE) AS PROVEEDOR,
MAX(RD.lottable05) AS FECHAVENCIMIENTO,
MAX(AL.ALTSKU) AS EAN13
from wmwhse51.RECEIPTDETAIL as RD
LEFT JOIN wmwhse51.SKU AS SK
ON RD.SKU = SK.SKU AND RD.STORERKEY = SK.STORERKEY
LEFT JOIN wmwhse51.PACK AS PA
ON RD.PACKKEY = PA.PACKKEY
LEFT JOIN wmwhse51.RECEIPT AS RC
ON RD.RECEIPTKEY = RC.RECEIPTKEY
LEFT JOIN wmwhse51.ALTSKU AS AL
ON RD.SKU = AL.SKU 
AND RD.STORERKEY = AL.STORERKEY
AND AL.TYPE LIKE '%EAN13%'
GROUP BY  RD.SKU
)t0