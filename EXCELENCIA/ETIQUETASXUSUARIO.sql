--ETUQUETAS POR USUARIO--
SELECT 
UA.ITRNKEY AS IDTAREA,
UA.ACTYPE AS TIPO,
IT.FROMID AS ETIQUETAORIGEN,--1
IT.TOID AS ETIQUETADESTINO,--2
UA.TYPE ,
(CASE UA.TYPE WHEN  'PA' THEN 'ALMACENAJE'
WHEN 'RP' THEN 'REABASTECIMIENTO'
WHEN 'RC' THEN 'RECEPCION'
WHEN 'ASSTPK' THEN 'PICKING ASISTIDO'
WHEN 'ASSTMV' THEN 'EXTRACCION ASISTIDO'
WHEN 'PK' THEN 'PICKING'
WHEN 'ASSTPA' THEN 'ALMACENAJE ASISTIDO'
WHEN 'MV' THEN 'EXTRACCION'
WHEN 'ASSTPA' THEN 'ALMACENAJE ASISTIDO' 
ELSE 'TIPO '+UA.TYPE+' NO TRADUCIDO'END) AS TIPOOPERACION,--3
CAST(DATEADD(HOUR,-6,UA.ADDDATE) AS DATE) AS FECHA,--4
DATEPART(HOUR, CONVERT(DATETIME,DATEADD(hour, -6, UA.ADDDATE), 111))AS HORA,--5
UA.USERID AS USUARIO,--6
UA.EQUIPMENTID AS EQUIPO,--7
IT.FROMLOC AS UBICACIONRIGEN,--8
IT.TOLOC AS UBICACIONDESTINO,--9
IT.SKU as ARTICULO,--10
S.DESCR AS DESCRIPCION,--11
(CASE WHEN P.CASECNT IS NULL OR P.CASECNT = 0 THEN 0 ELSE IT.QTY/P.CASECNT END) AS CANTIDADCAJAS,--12
IT.QTY AS CANTIDADUNIDADES,
UA.STARTTIME AS INICIO,--13
UA.ENDTIME AS FIN--14
FROM WMWHSE51.USERACTIVITY AS UA
INNER JOIN WMWHSE51.ITRN AS IT
ON UA.ITRNKEY = IT.ITRNKEY
INNER JOIN WMWHSE51.SKU AS S
ON IT.SKU = S.SKU AND IT.storerkey = S.storerkey
INNER JOIN WMWHSE51.PACK AS P
ON IT.PACKKEY = P.PACKKEY

----INDICEPRODUCCIONXETIQUETAS---
SELECT 
COUNT(USERACTIVITYKEY) AS MOVIMIENTOS,
TIPOOPERACION,
FECHA,
HORA,
USUARIO,
EQUIPO,
SUM(CANTIDADCAJAS) AS CANTIDADCAJAS, 
SUM(CANTIDADUNIDADES) AS CANTIDADUNIDADES
FROM(
SELECT 
UA.TYPE ,
IT.FROMID AS ETIQUETAORIGEN,
IT.TOID AS ETIQUETADESTINO,
UA.USERACTIVITYKEY,
(CASE UA.TYPE WHEN  'PA' THEN 'ALMACENAJE'
WHEN 'RP' THEN 'REABASTECIMIENTO'
WHEN 'RC' THEN 'RECEPCION'
WHEN 'ASSTPK' THEN 'PICKING ASISTIDO'
WHEN 'ASSTMV' THEN 'EXTRACCION ASISTIDO'
WHEN 'PK' THEN 'PICKING'
WHEN 'ASSTPA' THEN 'ALMACENAJE ASISTIDO'
WHEN 'MV' THEN 'EXTRACCION'
WHEN 'ASSTPA' THEN 'ALMACENAJE ASISTIDO' 
ELSE 'TIPO '+UA.TYPE+' NO TRADUCIDO'END) AS TIPOOPERACION,
CAST(DATEADD(HOUR,-6,UA.ADDDATE) AS DATE) AS FECHA,
DATEPART(HOUR, CONVERT(DATETIME,DATEADD(hour, -6, UA.ADDDATE), 111))AS HORA,
UA.USERID AS USUARIO,
UA.EQUIPMENTID AS EQUIPO,
(IT.QTY/P.CASECNT)AS CANTIDADCAJAS,
IT.QTY AS CANTIDADUNIDADES
FROM WMWHSE51.ITRN AS IT
INNER JOIN WMWHSE51.USERACTIVITY AS UA
ON UA.ITRNKEY = IT.ITRNKEY
INNER JOIN WMWHSE51.SKU AS S
ON S.SKU = IT.SKU AND S.storerkey = IT.storerkey
INNER JOIN WMWHSE51.PACK AS P
ON IT.PACKKEY = P.PACKKEY
WHERE DATEPART(HOUR, CONVERT(DATETIME,DATEADD(hour, -6, UA.ADDDATE), 111)) = 10 AND CAST(DATEADD(HOUR,-6,UA.ADDDATE) AS DATE) = '2024-02-20' AND UA.TYPE LIKE 'PA'
)T0
GROUP BY TIPOOPERACION, FECHA, HORA, USUARIO, EQUIPO

--- esto es fin--

SELECT
UA.ITRNKEY AS IDTAREA,
UA.ACTYPE AS TIPO,
IT.FROMID AS ETIQUETAORIGEN,--1
IT.TOID AS ETIQUETADESTINO,--2
UA.TYPE ,
(CASE UA.TYPE WHEN  'PA' THEN 'ALMACENAJE'
WHEN 'RP' THEN 'REABASTECIMIENTO'
WHEN 'RC' THEN 'RECEPCION'
WHEN 'ASSTPK' THEN 'PICKING ASISTIDO'
WHEN 'ASSTMV' THEN 'EXTRACCION ASISTIDO'
WHEN 'PK' THEN 'PICKING'
WHEN 'ASSTPA' THEN 'ALMACENAJE ASISTIDO'
WHEN 'MV' THEN 'EXTRACCION'
WHEN 'ASSTPA' THEN 'ALMACENAJE ASISTIDO'
ELSE 'TIPO '+UA.TYPE+' NO TRADUCIDO'END) AS TIPOOPERACION,--3
CAST(DATEADD(HOUR,-6,UA.ADDDATE) AS DATE) AS FECHA,--4
DATEPART(HOUR, CONVERT(DATETIME,DATEADD(hour, -6, UA.ADDDATE), 111))AS HORA,--5
UA.USERID AS USUARIO,--6
UA.EQUIPMENTID AS EQUIPO,--7
IT.FROMLOC AS UBICACIONRIGEN,--8
IT.TOLOC AS UBICACIONDESTINO,--9
IT.SKU as ARTICULO,--10
S.DESCR AS DESCRIPCION,--11
(CASE WHEN P.CASECNT IS NULL OR P.CASECNT = 0 THEN 0 ELSE IT.QTY/P.CASECNT END) AS CANTIDADCAJAS,--12
IT.QTY AS CANTIDADUNIDADES,
UA.STARTTIME AS INICIO,--13
UA.ENDTIME AS FIN--14
FROM WMWHSE51.USERACTIVITY AS UA
INNER JOIN WMWHSE51.ITRN AS IT
ON UA.ITRNKEY = IT.ITRNKEY
INNER JOIN WMWHSE51.SKU AS S
ON IT.SKU = S.SKU AND IT.storerkey = S.storerkey
INNER JOIN WMWHSE51.PACK AS P
ON IT.PACKKEY = P.PACKKEY
UNION ALL
SELECT
UA.ITRNKEY AS IDTAREA,
UA.ACTYPE AS TIPO,
PD.DROPID AS ETIQUETAORIGEN,--1
PD.ID AS ETIQUETADESTINO,--2
UA.TYPE ,
(CASE UA.TYPE WHEN  'PA' THEN 'ALMACENAJE'
WHEN 'RP' THEN 'REABASTECIMIENTO'
WHEN 'RC' THEN 'RECEPCION'
WHEN 'ASSTPK' THEN 'PICKING ASISTIDO'
WHEN 'ASSTMV' THEN 'EXTRACCION ASISTIDO'
WHEN 'PK' THEN 'PICKING'
WHEN 'ASSTPA' THEN 'ALMACENAJE ASISTIDO'
WHEN 'MV' THEN 'EXTRACCION'
WHEN 'ASSTPA' THEN 'ALMACENAJE ASISTIDO'
ELSE 'TIPO '+UA.TYPE+' NO TRADUCIDO'END) AS TIPOOPERACION,--3
CAST(DATEADD(HOUR,-6,UA.ADDDATE) AS DATE) AS FECHA,--4
DATEPART(HOUR, CONVERT(DATETIME,DATEADD(hour, -6, UA.ADDDATE), 111))AS HORA,--5
UA.USERID AS USUARIO,--6
UA.EQUIPMENTID AS EQUIPO,--7
PD.FROMLOC AS UBICACIONRIGEN,--8
PD.TOLOC AS UBICACIONDESTINO,--9
PD.SKU as ARTICULO,--10
S.DESCR AS DESCRIPCION,--11
(CASE WHEN P.CASECNT IS NULL OR P.CASECNT = 0 THEN 0 ELSE PD.QTY/P.CASECNT END) AS CANTIDADCAJAS,--12
PD.QTY AS CANTIDADUNIDADES,
UA.STARTTIME AS INICIO,--13
UA.ENDTIME AS FIN--14
FROM WMWHSE51.USERACTIVITY AS UA
INNER JOIN WMWHSE51.PICKDETAIL AS PD
ON UA.PICKDETAILKEY = PD.PICKDETAILKEY
INNER JOIN WMWHSE51.SKU AS S
ON PD.SKU = S.SKU AND PD.storerkey = S.storerkey
INNER JOIN WMWHSE51.PACK AS P
ON PD.PACKKEY = P.PACKKEY


select * from WMWHSE51.USERACTIVITY
where type in('PK','ASSTPK')