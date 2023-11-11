SELECT 
distinct
CAST(Fecha as date) as FECHA,
(
    CASE WHEN SUM(C_PEDIDAS) = 0 OR FACTOR = 0 THEN 0
    ELSE SUM(C_PEDIDAS)/FACTOR END
) as 'Cantidad Pedida',
(
    CASE WHEN SUM(C_PREPARADAS) = 0 OR FACTOR = 0 THEN 0
    ELSE SUM(C_PREPARADAS)/FACTOR END
) as 'Cantidad Servida',
(
CASE 
WHEN SUM(C_PREPARADAS) > 0 OR SUM(C_PEDIDAS)  > 0 then 
(SUM(C_PREPARADAS) / SUM(C_PEDIDAS) ) 
ELSE 0
END
)as Cumplimiento,
Propietario
FROM 
(
SELECT 
distinct
DATEADD(hour,-6,OD.ADDDATE) as Fecha,
(OD.ORIGINALQTY) as C_PEDIDAS,
p.casecnt AS FACTOR,
od.orderkey,
(
CASE 
WHEN OD.status <> 95 THEN (OD.QTYPICKED) 
ELSE  OD.SHIPPEDQTY   END
) as C_PREPARADAS,
OD.storerKey as Propietario,
OD.sku as SKU,
p.casecnt as FactorEmpaque
FROM WMWHSE51.ORDERDETAIL OD
LEFT JOIN WMWHSE51.sku s on OD.sku = s.sku AND S.storerKey = OD.storerKey
LEFT JOIN WMWHSE51.pack p on s.packkey = p.packkey
WHERE OD.status not in (04,02,17) and OD.storerKey like '%1770142%'
)ABC
GROUP by CAST(Fecha as date), Propietario, FACTOR