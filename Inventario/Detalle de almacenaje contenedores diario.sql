ETIQUETA
ZONA
PROVEEDOR
CODIGO
UBICACION
EAN13
DUN14
DESCRIPCION
RECEPCION
TIPOUBICACION
DIAS
RANGO
CAJASPORPALLET
CAJAS
UNIDADES
VENCIMIENTO
ULTIMARECEPCION
ULTIMAPREPARACION

SELECT 
ISNULL(LLI.ID,'-') AS ETIQUETA
,LO.PUTAWAYZONE AS ZONA
,RE.SUPPLIERNAME AS PROVEEDOR
,LLI.SKU AS CODIGO
,LLI.LOC AS UBICACION
,AL.ALTSKU AS EAN13
,AL2.ALTSKU AS DUN14
,SK.DESCR AS DESCRIPCION
,RD.DATERECEIVED AS RECEPCION
,LO.LOCATIONTYPE AS TIPOUBICACION
,DATEDIFF(DAY,RD.DATERECEIVED,GETDATE()) DIAS /*DIAS ALMACENAMIENTO*/
,(CASE WHEN DATEDIFF(DAY,RD.DATERECEIVED,GETDATE()) >=120 THEN '6. (120 ó Más)' 
    ELSE (CASE WHEN DATEDIFF(DAY,RD.DATERECEIVED,GETDATE()) >=60
            THEN '5. (60-120)'
            ELSE (CASE WHEN DATEDIFF(DAY,RD.DATERECEIVED,GETDATE()) >=45
                    THEN '4. (45-60)'
                    ELSE (CASE WHEN DATEDIFF(DAY,RD.DATERECEIVED,GETDATE()) >=30
                            THEN '3. (30-45)'
                            ELSE (CASE WHEN DATEDIFF(DAY,RD.DATERECEIVED,GETDATE()) > 15
                                    THEN '2. (15-30)'
                                    ELSE '1. (15 ó Menos)'
                                  END)
                         END)
                  END)
          END)
END) AS RANGO
,(PA.PALLETHI*PA.PALLETTI) AS CAJASPORPALLET
,(LLI.QTY/PA.CASECNT) AS CAJAS
,LLI.QTY AS UNIDADES
,RD.LOTTABLE05 AS VENCIMIENTO
,(SELECT max(DATERECEIVED)DATERECEIVED FROM WMWHSE51.RECEIPTDETAIL AS RD1
 where RD.SKU = LLI.SKU AND RD.STORERKEY = LLI.STORERKEY) AS ULTIMARECEPCION
,(SELECT MAX(OD.actualshipdate) AS actualshipdate FROM WMWHSE51.ORDERDETAIL AS OD
 WHERE OD.SKU = LLI.SKU AND OD.STORERKEY = LLI.STORERKEY) AS ULTIMAPREPARACION
FROM WMWHSE51.LOTXLOCXID AS LLI
LEFT JOIN WMWHSE51.LOC AS LO
ON LLI.LOC = LO.LOC
LEFT JOIN WMWHSE51.RECEIPTDETAIL AS RD
ON LLI.ID = RD.TOID
LEFT JOIN WMWHSE51.RECEIPT RE
ON RD.RECEIPTKEY = RE.RECEIPTKEY
LEFT JOIN WMWHSE51.ALTSKU AS AL
ON LLI.SKU = AL.SKU AND AL.TYPE LIKE 'EAN13' AND LLI.STORERKEY = AL.STORERKEY
LEFT JOIN WMWHSE51.ALTSKU AS AL2
ON LLI.SKU = AL2.SKU AND AL2.TYPE LIKE 'DUN14' AND LLI.STORERKEY = AL2.STORERKEY
LEFT JOIN WMWHSE51.SKU AS SK
ON LLI.SKU = SK.SKU AND LLI.STORERKEY = SK.STORERKEY
LEFT JOIN WMWHSE51.PACK AS PA
ON RD.PACKKEY = PA.PACKKEY

WHERE LLI.QTY > 0 and LLI.STORERKEY LIKE '1770142' and LEN(LLI.ID) > 2



SELECT * FROM WMWHSE51.ALTSKU where SKU in(
'1018790',
'1001788',
'1001788',
'1021237',
'1019444',
'1019444',
'1018695',
'1000007',
'1000007',
'1000111',
'1000115'
) /*para ver los codigos alternativos*/


SELECT * FROM WMWHSE51.PACK WHERE PACKKEY LIKE 'LC_12T_4H_48P_6C_1018790'


SELECT MAX(actualshipdate) AS actualshipdate, 'A' FROM WMWHSE51.ORDERDETAIL WHERE SKU LIKE '1018790'