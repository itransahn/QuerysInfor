SELECT 
Codigo,
ubicacion,
/* Proveedor */
(SELECT 
top 1 isnull(suppliername, '')
FROM 
WMWHSE51.RECEIPTDETAIL R 
WHERE R.sku = Codigo)as Proveedor,
/* Entrada */
(SELECT 
MAX(r.datereceived)
FROM 
WMWHSE51.RECEIPTDETAIL R 
WHERE R.sku = Codigo)as Entrada,
/* Salida */
(SELECT 
MAX(r.pickeddate)
FROM 
WMWHSE51.PICKDETAIL R 
WHERE R.sku = Codigo)as Salida,
/* Stock */
(
SELECT 
SUM(lot.qty/ NULLIF(p1.CASECNT,0))
FROM WMWHSE51.LOTXLOCXID lot 
LEFT JOIN WMWHSE51.SKU S1  ON lot.sku = S1.sku
LEFT JOIN WMWHSE51.PACK P1 ON s1.packkey = p1.packkey
WHERE lot.sku = Codigo AND lot.loc = ubicacion
) as Stock,
Descripcion,
Zona,
Tipo_Ubicacion,
Bloqueada,
ISNULL(EAN13 , '' ) as  EAN13
FROM
(
SELECT 
lot.sku as Codigo,
s.descr  as Descripcion,
ISNULL(L.putawayzone,'') as Zona,
ISNULL(ALS.altsku   , '') as EAN13,
ISNULL(locationtype , '') as Tipo_Ubicacion,
(
CASE lot.status
WHEN 'OK' then 'NO'
ELSE 'SI'
END
)as Bloqueada,
lot.loc as ubicacion
FROM
WMWHSE51.LOTXLOCXID lot 
LEFT JOIN WMWHSE51.SKU S  ON lot.sku = S.sku
LEFT JOIN WMWHSE51.ALTSKU ALS ON lot.sku = ALS.sku AND ALS.TYPE like '%EAN13%'
LEFT JOIN WMWHSE51.LOC L  ON lot.loc = l.loc
WHERE lot.qty > 0 AND l.loclevel = 1 --AND lot.sku like '%BV440048%'
)T0
-- WMWHSE51.RECEIPTDETAIL R 
-- WHERE R.sku like '%BV440048%'




