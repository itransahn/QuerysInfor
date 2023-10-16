SELECT FechaOrden,
       SUM(Unidades) as Unidades,
       SUM(Cajas) as Cajas,
       SUM(Pallets) as Pallets,
       Orden,
       CodProveedor,
       ST.DESCRIPTION AS Proveedor,
       Propietario
FROM
    (select sku,
            qtyExpected as Unidades,
            (qtyExpected / nullif(p.CASECNT, 0)) as Cajas,
            (qtyExpected / nullif(p.pallet, 0)) as Pallets,
            RD.RECEIPTKEY as Orden,
            (P.pallet / nullif(p.CASECNT,0)) as Paletizado,
            RC.SUPPLIERCODE as CodProveedor,
            RC.ADDDATE AS FechaOrden,
            Rd.storerkey as Propietario
     from wmwhse51.RECEIPTDETAIL RD
     LEFT JOIN wmwhse51.pack p on RD.packkey = p.packkey
     LEFT JOIN wmwhse51.RECEIPT AS RC ON RD.RECEIPTKEY = RC.RECEIPTKEY
     WHERE qtyExpected > 0 )t0
     LEFT JOIN WMWHSE51.STORER AS ST
ON T0.CodProveedor = ST.STORERKEY
Group by Orden,
         CodProveedor,
         Propietario,
         FechaOrden,
         ST.DESCRIPTION