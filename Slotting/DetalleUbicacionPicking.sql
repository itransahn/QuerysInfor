SELECT 
Codigo,
ubicacion,
(SELECT 
top 1 isnull(suppliername, '')
FROM 
WMWHSE51.RECEIPTDETAIL R 
WHERE R.sku = Codigo)as Proveedor,
(SELECT 
MAX(r.datereceived)
FROM 
WMWHSE51.RECEIPTDETAIL R 
WHERE R.sku = Codigo)as Entrada,
(SELECT 
MAX(r.pickeddate)
FROM 
WMWHSE51.PICKDETAIL R 
WHERE R.sku = Codigo)as Salida,
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
ISNULL(lot.sku, 'NO ASIGNADO') as Codigo,
ISNULL(s.descr, 'NO ASIGNADO') as Descripcion,
ISNULL(L.putawayzone,'NO ASIGNADO') as Zona,
ISNULL(ALS.altsku   , 'NO ASIGNADO') as EAN13,
ISNULL(locationtype , 'NO ASIGNADO') as Tipo_Ubicacion,
(
CASE lot.status
WHEN 'OK' then 'NO'
ELSE 'SI'
END
)as Bloqueada,
L.loc as ubicacion
FROM WMWHSE51.LOTXLOCXID lot 
LEFT JOIN WMWHSE51.SKU S  ON lot.sku = S.sku
LEFT JOIN WMWHSE51.ALTSKU ALS ON lot.sku = ALS.sku AND ALS.TYPE like '%EAN13%'
RIGHT JOIN WMWHSE51.LOC L  ON lot.loc = l.loc
WHERE  l.loclevel = 1 --AND lot.sku like '%BV440048%'
)T0
-- WMWHSE51.RECEIPTDETAIL R 
-- WHERE R.sku like '%BV440048%'




SELECT COUNT(*),'' FROM LOC WHERE loclevel = 1 /*6996*/