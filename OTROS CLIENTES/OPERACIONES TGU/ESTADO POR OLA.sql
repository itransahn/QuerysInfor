SELECT 
ORDERKEY,
MAX(Tienda) as Tienda,
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
SELECT top 1 CAST(dateadd(hour, -6, WDD.adddate) as datetime) from WMWHSE51.WAVEDETAIL  WDD
 WHERE WDD.WAVEKEY = Ola
) as FechaCreacionOla,
MAX(PROPIETARIO) as PROPIETARIO,
MAX(UsuarioCreadorOla) as UsuarioCreadorOla,
( SELECT top 1 description from WMWHSE51.codelkup C WHERE C.CODE = MAX(EstadoOla) and c.listname like '%WVPROCESS%' ) as EstadoEspañol,
MAX(EstadoOla) as IdEstado,
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
  ( SELECT top 1 w.INPROCESS from WMWHSE51.PICKDETAIL  PD  
    INNER JOIN WMWHSE51.WAVE W ON w.wavekey = PD.wavekey ) as EstadoOla,
  ISNULL(MAX(substring(OT.newallocationstrategy,6,5)), 'PICKTO') as Ubicaciones,
  MAX(WA.ADDWHO) as UsuarioCreadorOla,
  MAX(OST.DESCRIPTION) as EstadoEspañol
FROM     WMWHSE51.ORDERS OD
LEFT JOIN WMWHSE51.ORDERDETAIL OT ON OT.ORDERKEY = OD.ORDERKEY 
LEFT JOIN WMWHSE51.SKU SK ON   OT.SKU = SK.SKU AND SK.STORERKEY = OT.STORERKEY 
LEFT JOIN WMWHSE51.PACK PK ON SK.PACKKEY = PK.PACKKEY 
LEFT JOIN WMWHSE51.ALTSKU alt ON   OT.sku = alt.sku and alt.TYPE = 'EAN13'
LEFT JOIN WMWHSE51.ORDERSTATUSSETUP OST ON OD.status = OST.CODE  AND OST.WHSEID = OD.WHSEID
LEFT JOIN WMWHSE51.WAVEDETAIL WA ON OD.ORDERKEY = WA.ORDERKEY
WHERE     OD.status <> 95
GROUP BY OD.ORDERKEY, OT.sku, pk.CASECNT
)T0 where ola is not null
group by Ola