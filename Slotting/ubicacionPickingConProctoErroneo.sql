SELECT 
lot.sku, 
s.descr as Descripcion,
lot.loc as Ubicacion,
ISNULL(lot.id ,'') as Etiqueta,
l.loclevel as Nivel,
(
CASE l.status 
WHEN 'OK' THEN 'APTO'
ELSE 'Bloqueado'
END   
)as Estado
FROM WMWHSE51.LOTXLOCXID lot
LEFT JOIN WMWHSE51.sku s ON lot.sku  = s.sku
AND s.storerkey = lot.storerkey
LEFT JOIN WMWHSE51.loc l on lot.loc = l.loc
WHERE lot.loc
IN (
SELECT 
lot.loc
FROM WMWHSE51.LOTXLOCXID lot
LEFT JOIN WMWHSE51.LOC AS LO1 ON lot.LOC = LO1.LOC
where lot.qty > 0 and LO1.loclevel = 1
AND lot.loc not like '%MP50-1-1%'
group by lot.loc
HAVING count(distinct lot.sku) > 1  
)