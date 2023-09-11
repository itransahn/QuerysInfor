SELECT 
DISTINCT
I.sku     as Codigo, 
s.descr  as Descripcion,
I.TOLOC as Ubicacion,
isnull(ALS.altsku,'') as EAN13,
i.adddate as Fecha,
i.addwho  as Usuario,
(I.qty / nullif(p.CASECNT,0) )  as Cajas,
I.qty as Unidades,
ISNULL(I.TOID,'') as Etiqueta,
ISNULL(I.sourcetype, '') as Origen,
isnull( A.notes ,'') as Comentario,
I.itrnkey
FROM WMWHSE51.LOTXLOCXID lot
LEFT JOIN WMWHSE51.ITRN I ON  lot.LOC = I.TOLOC and lot.sku = I.sku
LEFT JOIN WMWHSE51.SKU S  ON I.sku = S.sku
LEFT JOIN WMWHSE51.PACK P ON s.packkey = p.packkey
LEFT JOIN WMWHSE51.ADJUSTMENTDETAIL A ON i.itrnkey = a.itrnkey
LEFT JOIN WMWHSE51.ALTSKU ALS ON I.sku = ALS.sku AND ALS.TYPE like '%EAN13%'
where lot.QTY > 0 and I.TRANTYPE like '%AJ%' AND i.sku = '5460400'
AND I.sku IN (
SELECT T.sku
FROM WMWHSE51.ITRN T
WHERE t.sku = I.sku AND i.toloc = t.toloc AND i.toid = t.toid
GROUP BY T.sku 
HAVING SUM(qty) <> 0
)


