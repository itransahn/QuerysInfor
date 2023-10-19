SELECT 
CodigoProveedor,
Proveedor,
Propietario,
SUM(Bultos) as Bultos,
count(Etiqueta) as Pallets
FROM 
(
SELECT 
L.LOC as Ubicacion, 
isnull(L.storerKey,'NUEVO') as Propietario,
L.ID as Etiqueta, 
L.sku as Articulo,
isnull(R.suppliercode,'NUEVO') as CodigoProveedor,
isnull(S.DESCRIPTION,'NUEVO') as Proveedor,
L.qty as Unidades,
p.CASECNT as FE,
(CASE WHEN L.qty = 0 OR p.CASECNT = 0 THEN 0 ELSE L.qty / p.CASECNT END ) as Bultos
from WMWHSE51.LOTXLOCXID L
LEFT JOIN WMWHSE51.RECEIPTDETAIL RE ON L.id = RE.TOID
LEFT JOIN WMWHSE51.RECEIPT R ON  RE.RECEIPTKEY = R.RECEIPTKEY 
LEFT JOIN WMWHSE51.PACK    P ON  RE.packkey = P.packkey
LEFT JOIN WMWHSE51.STORER S ON R.SUPPLIERCODE = S.STORERKEY
 WHERE L.qty > 0 AND RE.TOID is not null 
)T
group by 
CodigoProveedor,
Proveedor,
Propietario