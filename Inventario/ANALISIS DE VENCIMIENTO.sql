/*esto es un comentario*/
SELECT DISTINCT
(LT.QTY/PA.CASECNT) AS 'CANTIDADCAJAS',
LT.LOC,
LT.ID,
LT.SKU,
SK.DESCR,
LT.LOTTABLE05,
SK.SHELFLIFE AS 'DIAS SALIDA',
DATEDIFF(DAY,getdate(),LT.LOTTABLE05)as 'DIAS PARA VENCIMIENTO',
(CASE 
    WHEN (LT.LOTTABLE05>DATEADD(DAY,SK.SHELFLIFE,GETDATE()))
    THEN 'FECHA CORRECTA'ELSE 'PRECADUCADO'END) AS 'ALERTA DE VENCIMIENTO',
AL.ALTSKU AS EAN13,RC.DATERECEIVED,
RC.EXTERNRECEIPTKEY as OrdenCompra,
RC.DATERECEIVED as FechadeRecepción 
FROM WMWHSE52.vITLotxLocxId_Lottables AS LT 
LEFT JOIN WMWHSE52.SKU AS SK 
ON LT.SKU = SK.SKU LEFT JOIN WMWHSE52.PACK AS PA 
ON SK.PACKKEY = PA.PACKKEY 
LEFT JOIN WMWHSE52.ALTSKU AS AL 
ON SK.SKU = AL.SKU AND AL.TYPE = 'EAN13'
LEFT JOIN WMWHSE52.RECEIPTDETAIL AS RC 
ON LT.ID = RC.TOID AND SK.SKU = RC.SKU 




git add .

git pull origin Dandino

git commit -m "cambios analisis"

git push -u origin Dandino



SELECT
LLI.STORERKEY,
LLI.SKU,
RD.ADDWHO  AS 'USUARIO',
LLI.LOC AS 'UBICACION',
(LLI.QTY/ (SELECT TOP 1 PA.CASECNT
FROM WMWHSE52.PACK PA
INNER JOIN WMWHSE52.SKU SK
ON SK.PACKKEY = PA.PACKKEY WHERE SK.SKU = LLI.SKU and sk.STORERKEY = LLI.STORERKEY)) AS 'CANTIDADCAJAS',
LLI.ID 'ETIQUETA',
LLI.LOT AS 'LOTEINTERNO',
RD.RECEIPTKEY,
RD.DATERECEIVED AS 'FECHARECEPCION',
(SELECT TOP 1 DESCR FROM WMWHSE52.SKU AS SK
    WHERE SK.SKU = LLI.SKU)AS 'DESCRIPCIONARTICULO',
LT.LOTTABLE05 AS 'FECHAVENCIMIENTO',
LT.LOTTABLE06 AS 'LOTEDEREPROPIETARIO',
DATEDIFF(DAY,getdate(),LT.LOTTABLE05) as 'DIAS PARA VENCIMIENTO',
RD.DATERECEIVED as FechadeRecepción ,
locationtype as 'TIPODELOCACION',
lo.PUTAWAYZONE,
(
CASE 
WHEN H.hold = 1 then 'Bloqueada'
Else 'Apto'
END    
) as 'Estado'
FROM wmwhse52.LOTXLOCXID AS LLI
LEFT JOIN WMWHSE52.RECEIPTDETAIL AS RD ON  LLI.ID = RD.TOID AND RD.TOID is not null AND LLI.SKU = RD.SKU
AND ( RD.DATERECEIVED = ( SELECT MAX(RTTT.DATERECEIVED) from WMWHSE52.RECEIPTDETAIL RTTT WHERE RTTT.TOID = LLI.ID ) )
INNER JOIN WMWHSE52.LOTATTRIBUTE AS LT ON LT.LOT = LLI.LOT AND LT.SKU = LLI.SKU
LEFT JOIN WMWHSE52.LOC AS LO ON LLI.LOC = LO.LOC
LEFT JOIN WMWHSE52.INVENTORYHOLD   H on LLI.loc = H.loc
LEFT JOIN WMWHSE52.vInventoryHold IH on LLI.loc = IH.loc 
or LLI.id = IH.id AND H.inventoryholdkey  = IH.inventoryholdkey 
AND IH.qty > 0
WHERE 
LLI.QTY > 0 AND LLI.STORERKEY LIKE '%MOLINO%' AND LLI.ID LIKE 'RECMO20230004648'