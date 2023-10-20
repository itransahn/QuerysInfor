SELECT 
FechaRecibido,
OrdenCompra,
Articulo,
MAX(Descripcion) as Descripcion,
MAX(EAN13) as EAN13,
SUM(Bultos) as Bultos,
SUM(Unidades) as Unidades ,
FechaVencimiento,
MAX(Proveedor) as Proveedor,
MAX(storerKey) as Propietario,
MAX(UsuarioReceptor) as UsuarioReceptor,
MAX(FE) as 'Factor de Empaque',
MAX(FECHACORTA) AS FECHACORTA
FROM 
(
SELECT
CAST(RE.datereceived AS DATE) AS FECHACORTA,
DATEADD(hour, -6 ,RE.datereceived) as FechaRecibido, 
RE.REFERENCEDOCUMENT as OrdenCompra,
RE.sku as Articulo,
s.DESCR as Descripcion,
L.ALTSKU as EAN13,
(Re.qtyreceived / p.CASECNT ) as Bultos,
Re.qtyreceived as Unidades,
p.CASECNT as FE,
DATEADD(hour, -6 ,RE.LOTTABLE05) as FechaVencimiento,
R.SUPPLIERNAME as Proveedor,
RE.storerKey,
RE.ADDWHO as UsuarioReceptor
FROM WMWHSE51.RECEIPTDETAIL RE
LEFT JOIN WMWHSE51.RECEIPT R ON RE.RECEIPTKEY = R.RECEIPTKEY 
LEFT JOIN WMWHSE51.PACK    P ON RE.packkey = P.packkey
LEFT JOIN WMWHSE51.ALTSKU  L ON RE.sku = L.sku AND L.TYPE LIKE '%EAN13%'
LEFT JOIN WMWHSE51.sku     s ON RE.sku = s.sku
WHERE RE.TOID is not null AND 
Re.qtyreceived > 0
)T
---WHERE OrdenCompra like '%TGU%'
GROUP BY Articulo, OrdenCompra, FechaRecibido, FechaVencimiento