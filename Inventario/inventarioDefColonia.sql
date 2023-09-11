
SELECT 
DISTINCT
lot.sku as Codigo,
s.descr  as Descripcion,
isnull(ALS.altsku , '') as EAN13,
isnull(ALS1.altsku, '') as DUN14,
p.CASECNT as FactorEmpaque,
lot.qty as Unidades,
(lot.qty / nullif(p.CASECNT,0) )  as Cajas,
LOT.storerkey as Propietario
FROM WMWHSE51.LOTXLOCXID lot
LEFT JOIN WMWHSE51.SKU S  ON lot.sku = S.sku
LEFT JOIN WMWHSE51.ALTSKU ALS ON lot.sku = ALS.sku AND ALS.TYPE like '%EAN13%'
LEFT JOIN WMWHSE51.ALTSKU ALS1 ON lot.sku = ALS1.sku AND ALS1.TYPE like '%DUN14%'
LEFT JOIN WMWHSE51.PACK P ON s.packkey = p.packkey
WHERE lot.qty > 0 AND LOT.storerkey like '%1770142%'