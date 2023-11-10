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
  (  SUM(CantidadProcesada) / nullif (SUM(CantidadPedida),0))
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
SUM(OT.ORIGINALQTY/ nullif(Pk.CASECNT,0))  as CantidadPedida,
(
CASE 
WHEN MAX(OT.status) <> 95 THEN 
SUM(ABS(OT.QTYPICKED)/ nullif(Pk.CASECNT,0) )
ELSE 
SUM(ABS(OT.PROCESSEDQTY)/nullif(Pk.CASECNT,0))
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
        WHERE qty > 0 and status = 'HOLD'  and LD.sku = OT.SKU )/ nullif(Pk.CASECNT,0), 0) as CajasBloqueadas,

  ISNULL((SELECT  SUM(LD.qty)  FROM
  WMWHSE51.LOTXLOCXID LD
  WHERE qty > 0 and status = 'OK' and LD.sku = OT.SKU)/ nullif(Pk.CASECNT,0),0) as CajasDISPONIBLES,
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
WHERE     OD.status <> 95 and od.STORERKEY like '%1770142%'
GROUP BY OD.ORDERKEY, OT.sku, pk.CASECNT
)T0 where ola is not null
group by Ola