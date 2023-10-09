SELECT 
MAX(Tienda) as Tienda,
(SELECT DISTINCT COUNT(W1.ORDERKEY) FROM WMWHSE51.WAVEDETAIL AS W1 WHERE W1.WAVEKEY = OLA) AS ORDENXOLA,
(SELECT COUNT(DISTINCT PD.ORDERKEY) FROM WMWHSE51.PICKDETAIL AS PD WHERE PD.WAVEKEY = OLA) AS ORDENXOLAXETIQUETA,
(CASE WHEN
(SELECT COUNT(DISTINCT PD.ORDERKEY) FROM WMWHSE51.PICKDETAIL AS PD WHERE PD.WAVEKEY = OLA) <> 
(SELECT DISTINCT COUNT(W1.ORDERKEY) FROM WMWHSE51.WAVEDETAIL AS W1 WHERE W1.WAVEKEY = OLA) THEN
'ERROR'
ELSE
'OK'
END) VALIDACION,
--MAX(FechaCreacionPedido) as FechaCreacionOla,
SUM(CantidadPedida) as C_PEDIDAS,
SUM(CantidadProcesada) as C_PREPARADAS,
( SUM(CantidadPedida) - SUM(CantidadProcesada)  ) as C_PENDIENTES,
(
CASE 
WHEN SUM(CantidadProcesada) > 0 THEN 
  (  SUM(CantidadProcesada) / SUM(CantidadPedida))
ELSE 0
END  
) as Cumplimiento,
Ola,
(
    SELECT top 1 CAST(WDD.adddate as date) from WMWHSE51.WAVEDETAIL  WDD
  WHERE WDD.WAVEKEY = Ola
) as FechaCreacionOla,
-- isnull(MAX(Ubicaciones),'--') as CANAL,
MAX(PROPIETARIO) as PROPIETARIO,
-- id_Estado,
-- (
--          CASE
--          WHEN  id_ESTADO = -1  then 'Desconocida'
--          WHEN  id_ESTADO = 0   then 'Orden Vacía'
--          WHEN  id_ESTADO = 02  then 'Creada Externamente'
--          WHEN  id_ESTADO = 04  then 'Creada Internamente'
--          WHEN  id_ESTADO = 06  then 'No asignada'
--          WHEN  id_ESTADO = 08  then 'Convertido'
--          WHEN  id_ESTADO = 09  then 'No iniciada'
--          WHEN  id_ESTADO = 10  then 'Por lotes'
--          WHEN  id_ESTADO = 11  then 'Parte preasignada'
--          WHEN  id_ESTADO = 12  then 'Preasignado'
--          WHEN  id_ESTADO = 13  then 'Lanzada'
--          WHEN  id_ESTADO = 14  then 'Preparación'
--          WHEN  id_ESTADO = 15  then 'Preparación'
--          WHEN  id_ESTADO = 16  then 'Preparación'
--          WHEN  id_ESTADO = 17  then 'Preparación'
--          WHEN  id_ESTADO = 18  then 'Preparación'
--          WHEN  id_ESTADO = 22  then 'Preparación'
--          WHEN  id_ESTADO = 25  then 'Preparación'
--          WHEN  id_ESTADO = 29  then 'Preparado'
--          WHEN  id_ESTADO = 51  then 'Preparación'
--          WHEN  id_ESTADO = 52  then 'Preparación'
--          WHEN  id_ESTADO = 53  then 'Preparación'
--          WHEN  id_ESTADO = 55  then 'Preparado'
--          WHEN  id_ESTADO = 57  then 'Preparado'
--          WHEN  id_ESTADO = 61  then 'Preparado'
--          WHEN  id_ESTADO IN (68,75,78,82,88,92,94,95,96,97) then 'Preparado'
--          WHEN  id_ESTADO = 98 then 'Cancelada Externamente'
--          WHEN  id_ESTADO = 99 then 'Cancelada Internamente'
--          ELSE 'Sin estado'
--          END
--         )as EstadoEspañol,
-- MAX(EstadoEspañol) as EstadoEspañol,
        MAX(UsuarioCreadorOla) as UsuarioCreadorOla,
( SELECT top 1 description from WMWHSE51.codelkup C WHERE C.CODE = MAX(EstadoOla) and c.listname like '%WAVESTATUS%' ) as EstadoEspañol,
( SELECT top 1 MAX(PDD.LOC) FROM WMWHSE51. PICKDETAIL PDD 
LEFT JOIN WMWHSE51.LOC LCC ON PDD.loc = LCC.LOC 
WHERE PDD.WAVEKEY = Ola AND LCC.locationcategory = 'OTHER' ) as CANAL
FROM 
(
    SELECT
MAX(OD.C_COMPANY) as Tienda,
MAX(cast(DATEADD(hour,-6,OD.ADDDATE) as date)) as FechaCreacionPedido,
--PD.WAVEKEY AS OLA ,
isnull(MAX(alt.ALTSKU), '--') as EAN13,
SUM(OT.ORIGINALQTY/Pk.CASECNT)  as CantidadPedida,
(
CASE 
WHEN MAX(OT.status) <> 95 THEN 
SUM(ABS(OT.QTYPICKED)/Pk.CASECNT)
ELSE 
SUM(ABS(OT.PROCESSEDQTY)/Pk.CASECNT)
END
) as CantidadProcesada,
-- SUM(PD.qty/Pk.CASECNT) as CantidadSevida,
-- string_agg(PD.FROMLOC,',') as UbicaciónOrigen,
MAX(OT.STORERKEY) as PROPIETARIO,
OT.sku as Articulo,
MAX(SK.descr) as Descripcion,
OD.ORDERKEY,
isnull((SELECT  SUM(LD.qty)   FROM
        WMWHSE51.LOTXLOCXID LD
        WHERE qty > 0 and status = 'HOLD'  and LD.sku = OT.SKU )/pk.CASECNT, 0) as CajasBloqueadas,

  ISNULL((SELECT  SUM(LD.qty)  FROM
  WMWHSE51.LOTXLOCXID LD
  WHERE qty > 0 and status = 'OK' and LD.sku = OT.SKU)/pk.CASECNT,0) as CajasDISPONIBLES,
  ( SELECT top 1 PD.WAVEKEY from WMWHSE51.PICKDETAIL  PD  WHERE OD.ORDERKEY = PD.ORDERKEY ) as Ola,

  ( SELECT top 1 w.status from WMWHSE51.PICKDETAIL  PD  
    INNER JOIN WMWHSE51.WAVE W ON w.wavekey = PD.wavekey
  WHERE OD.ORDERKEY = PD.ORDERKEY ) as EstadoOla,

  -- isnull((select
  --   STUFF(
  --   ( SELECT DISTINCT CAST(',' AS varchar(MAX)) + FROMLOC
  --     FROM          WMWHSE51.PICKDETAIL PD1
  --           WHERE
  --                   PD1.ORDERKEY = OD.ORDERKEY AND PD1.sku = OT.sku FOR XML PATH('') ), 1, 1, '')),'--')
  ISNULL(MAX(substring(OT.newallocationstrategy,6,5)), 'PICKTO') as Ubicaciones,
  MAX(OT.EDITWHO) as UsuarioCreadorOla,
  MAX(OST.DESCRIPTION) as EstadoEspañol
FROM     WMWHSE51.ORDERS OD
LEFT JOIN WMWHSE51.ORDERDETAIL OT ON OT.ORDERKEY = OD.ORDERKEY 
-- LEFT JOIN WMWHSE51.PICKDETAIL  PD ON OD.ORDERKEY = PD.ORDERKEY AND OT.sku = PD.sku
LEFT JOIN WMWHSE51.SKU SK ON   OT.SKU = SK.SKU AND SK.STORERKEY = OT.STORERKEY 
LEFT JOIN WMWHSE51.PACK PK ON SK.PACKKEY = PK.PACKKEY 
LEFT JOIN WMWHSE51.ALTSKU alt ON   OT.sku = alt.sku and alt.TYPE = 'EAN13'
LEFT JOIN WMWHSE51.ORDERSTATUSSETUP OST ON OD.status = OST.CODE  AND OST.WHSEID = OD.WHSEID
WHERE     OD.status <> 95
GROUP BY OD.ORDERKEY, OT.sku, pk.CASECNT
)T0 where ola is not null
group by Ola