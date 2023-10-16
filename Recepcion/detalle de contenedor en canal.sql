SELECT 
LC.id as Etiqueta,
LC.loc as Canal, 
LC.QTY as Unidades,
(
CASE P.CASECNT
WHEN 0 THEN 0.0
ELSE
LC.QTY/ISNULL(P.CASECNT,0)
END
) as Cajas,
LC.sku as Articulo,
S.descr as Descripcion,
ALT.ALTSKU as EAN13,
LC.STORERKEY as PROPIETARIO,
L.locationtype as 'Tipo de Ubicacion',
L.locationcategory as 'Categoria de Ubicacion',
DATEADD(hour,-6,datereceived) as 'Fecha de Recepcion',
REC.REFERENCEDOCUMENT as OrdenCompra,
(
CASE 
WHEN SUBSTRING(LC.loc,3,1) = '1' THEN 'Entrada'
WHEN SUBSTRING(LC.loc,3,1) = '2' THEN 'Salida'
ELSE 'Pickto'
END
) as TipoCanal,
(
CASE TRANTYPE
WHEN 'DP' then 'Recepción'
WHEN 'WD' then 'Reparación'
WHEN 'MV' then 'Movimiento Stock'
WHEN 'AJ' then 'Ajustes'
ELSE 'Sin Operacion'
END
) as Operacion,
isnull(( SELECT TOP 1 LCC.loc FROM WMWHSE51.LOTXLOCXID LCC WHERE LCC.SKU = LC.sku AND LCC.loc like 'P%' ), 'Sin Ub. Pick') as 'Ubicacion Picking',
(CASE 
WHEN DATEDIFF(HH,CONVERT(DATE,DATEADD(hour,-6,LC.ADDDATE)),GETDATE()) > 24 THEN RTRIM(CONVERT(CHAR,CONVERT(INT,DATEDIFF(HH,CONVERT(DATE,DATEADD(hour,-6,LC.ADDDATE)),GETDATE()))/24)) + ' d'
ELSE RTRIM(CONVERT(CHAR,DATEDIFF(HH,CONVERT(TIME, DATEADD(hour,-6,LC.ADDDATE)),CAST(GETDATE() AS TIME)))) + ' h'END )AS TiempoEnCanal,
( SELECT TOP 1 R.SUPPLIERNAME from WMWHSE51.RECEIPT R WHERE r.RECEIPTKEY = REC.RECEIPTKEY ) as Proveedor
FROM  WMWHSE51.LOTXLOCXID LC 
LEFT JOIN WMWHSE51.LOC  L on Lc.loc = L.loc 
LEFT JOIN WMWHSE51.SKU  S on Lc.sku = S.sku 
LEFT JOIN WMWHSE51.pack P on S.packkey = p.packkey
LEFT JOIN WMWHSE51.ALTSKU ALT on S.sku = ALT.sku AND ALT.TYPE = 'EAN13'
LEFT JOIN WMWHSE51.RECEIPTDETAIL REC on LC.ID = REC.toid
LEFT JOIN WMWHSE51.ITRN ITR on Lc.id = ITR.toid and lc.sku = ITR.sku  and lc.loc = ITR.TOLOC
WHERE lc.qty > 0 and  L.locationcategory like '%OTHER%'