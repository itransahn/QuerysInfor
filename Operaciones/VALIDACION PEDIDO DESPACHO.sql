SELECT distinct
CAST(Fecha as date) as FECHA,
SUM(C_PEDIDAS)      as 'Cantidad Pedida',
SUM(C_PREPARADAS)   as 'Cantidad Servida',
(CASE WHEN SUM(C_PREPARADAS) > 0 then 
(SUM(C_PREPARADAS) / SUM(C_PEDIDAS)) ELSE 0 END
)as Cumplimiento,
Propietario,
PEDIDO,
OLA
FROM (
SELECT distinct
OD.ORDERKEY AS PEDIDO,
WD.WAVEKEY AS OLA,
DATEADD(hour,-6,OD.ADDDATE) as Fecha,
(CASE WHEN OD.ORIGINALQTY = 0 OR p.casecnt = 0 THEN 0 
ELSE
(OD.ORIGINALQTY/p.casecnt)END) as C_PEDIDAS,
(
CASE WHEN p.casecnt = 0 THEN 0
WHEN OD.status <> 95 THEN 
ISNULL(OD.QTYPICKED,0) / ISNULL(p.casecnt,0) 
ELSE  ISNULL(OD.SHIPPEDQTY,0) / ISNULL(p.casecnt,0)   END
) as C_PREPARADAS,
OD.storerKey as Propietario,
OD.sku as SKU,
p.casecnt as FactorEmpaque
FROM WMWHSE51.ORDERDETAIL OD
LEFT JOIN WMWHSE51.sku s on OD.sku = s.sku AND S.storerKey = OD.storerKey
LEFT JOIN WMWHSE51.pack p on s.packkey = p.packkey
LEFT JOIN WMWHSE51.WAVEDETAIL AS WD ON OD.ORDERKEY = WD.ORDERKEY
WHERE OD.status not in (04,02,17) --and OD.storerKey like 'M%'
)ABC
GROUP by CAST(Fecha as date), Propietario, PEDIDO, OLA