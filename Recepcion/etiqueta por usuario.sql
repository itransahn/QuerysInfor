SELECT
ETIQUETAORIGEN
,ETIQUETA
,TAREA
,FECHARECEPCION
,FECHAALMACENAJE
,USUARIO
,UBICACIONORIGEN
,UBICACIONDESTINO
,CODIGO
,UNIDADES
,(CASE WHEN UNIDADES = 0 OR FACTOR = 0 THEN 0
ELSE UNIDADES/FACTOR END) AS CAJAS
,DESCRIPCION
FROM(select
'' as ETIQUETAORIGEN,
rd.toid AS ETIQUETA,
'Recepcion'  as TAREA,
CAST(rd.adddate AS DATE) AS FECHARECEPCION,
CAST(rd.editdate AS DATE) AS FECHAALMACENAJE,
rd.addwho AS USUARIO,
'' as UBICACIONORIGEN,
rd.toloc AS UBICACIONDESTINO,
rd.sku AS CODIGO,
rd.qtyreceived as UNIDADES,
p.CASECNT as FACTOR,
s.descr as DESCRIPCION
from WMWHSE51.receiptdetail rd
LEFT JOIN WMWHSE51.sku s ON rd.sku = s.sku
LEFT JOIN WMWHSE51.pack p on rd.packkey =  p.packkey
where rd.toid is not null and rd.qtyreceived > 0
UNION ALL
select
td.fromid AS ETIQUETAORIGEN,
td.toid AS ETIQUETA,
'Almacenamiento' as TAREA,
CAST(td.adddate AS DATE) AS FECHARECEPCION,
CAST(td.editdate AS DATE) AS FECHAALMACENAJE,
td.addwho AS USUARIO,
td.fromloc AS UBICACIONORIGEN,
td.toloc AS UBICACIONDESTINO,
td.sku AS CODIGO,
td.qty as UNIDADES,
p.CASECNT as FACTOR,
s.descr as DESCRIPCION
from WMWHSE51.taskdetail td
LEFT JOIN WMWHSE51.sku s ON td.sku = s.sku
LEFT JOIN WMWHSE51.pack p on s.packkey =  p.packkey
 where tasktype  like '%PA%')T0