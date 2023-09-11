Select 
ISNULL(ALS.ALTSKU, '') as CodigoAlternativo,
s.sku   as Codigo,
s.descr as Descripcion,
ISNULL(ALS.type, '') as Formato,
P.CASECNT as Factor,
l.loc as Ubicacion,
(l.qty / nullif(p.CASECNT,0)) as Stock
FROM WMWHSE51.ALTSKU ALS 
LEFT JOIN  WMWHSE51.sku s on als.sku = s.sku
LEFT JOIN WMWHSE51.PACK P ON s.packkey = p.packkey
LEFT JOIN WMWHSE51.LOTXLOCXID l ON ALS.sku = l.sku
WHERE  L.qty > 0 AND ALS.altsku IN (
select 
ALS.altsku
FROM WMWHSE51.ALTSKU ALS
GROUP BY  ALS.altsku
HAVING count(*) > 1
)


/* SKU AGRUPADO */

Select
als.sku as Codigo,
ISNULL(ALS.ALTSKU, '') as CodigoAlternativo,
ISNULL(MAX(s.descr), '') as Descripcion,
ISNULL(ALS.type , '')  as Formato,
ISNULL(P.CASECNT, 0) as Factor,
ISNULL((
SELECT 
SUM(lot.qty/ NULLIF(p1.CASECNT,0))
FROM WMWHSE51.LOTXLOCXID lot 
LEFT JOIN WMWHSE51.SKU S1  ON lot.sku = S1.sku
LEFT JOIN WMWHSE51.PACK P1 ON s1.packkey = p1.packkey
WHERE lot.sku = als.sku
),0) as Stock
FROM WMWHSE51.ALTSKU ALS 
LEFT JOIN  WMWHSE51.sku s on als.sku = s.sku
LEFT JOIN WMWHSE51.PACK P ON ALS.packkey = p.packkey
WHERE  ALS.altsku IN  (
select 
ALS.altsku
FROM WMWHSE51.ALTSKU ALS
WHERE ALS.ALTSKU not like '%00000000000000%'
GROUP BY  ALS.altsku
HAVING count(*) > 1
) 
GROUP BY ALS.ALTSKU, als.sku, P.CASECNT, ALS.type

