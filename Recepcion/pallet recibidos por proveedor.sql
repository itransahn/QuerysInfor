SELECT
FechaRecibido, OrdenCompra, codProveedor,
ST.DESCRIPTION AS Proveedor,
COUNT(Pallets) as Pallets,
SUM(Bultos/FE) as Bultos,
MAX(PROPIETARIO) as Propietario,
MAX(FECHA) AS FECHA,
MAX(CAST(FECHA AS date)) AS fechafiltro
FROM (
    SELECT 
    DATEADD(hour, -6 ,RE.datereceived) AS FECHA, 
    (CONVERT(VARCHAR,(DATEADD(hour, -6 ,RE.datereceived)),103)) as FechaRecibido,
    RE.EXTERNRECEIPTKEY as OrdenCompra,
    R.SUPPLIERCODE as codProveedor,
    RE.TOID as Pallets,
    Re.qtyreceived as Bultos,
    re.sku as Articulo,
    p.CASECNT as FE,
    RE.storerKey AS PROPIETARIO
    FROM WMWHSE51.RECEIPTDETAIL RE 
    LEFT JOIN WMWHSE51.RECEIPT R 
    ON RE.RECEIPTKEY = R.RECEIPTKEY 
    LEFT JOIN WMWHSE51.PACK P 
    ON RE.packkey = P.packkey 
    WHERE RE.TOID is not null 
    AND Re.qtyreceived > 0)T 
LEFT JOIN WMWHSE51.STORER AS ST
ON T.codProveedor = ST.STORERKEY
group by FechaRecibido, OrdenCompra, codProveedor, st.DESCRIPTION