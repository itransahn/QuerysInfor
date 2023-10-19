
SELECT Cant ,
       CODIGOORDEN ,
       PROVEEDOR ,
       CODIGO ,
       EAN13 ,
       DESCRIPCION ,
       FACTOR ,
       UNIDADESPEDIDAS ,
       (CASE
            WHEN UNIDADESPEDIDAS = 0
                 OR FACTOR = 0 THEN 0.0
            ELSE UNIDADESPEDIDAS/FACTOR
        END) AS CAJASPEDIDAS ,
       UNIDADESRECIBIDAS ,
       (CASE
            WHEN UNIDADESRECIBIDAS = 0
                 OR FACTOR = 0 THEN 0
            ELSE UNIDADESRECIBIDAS/FACTOR
        END) AS CAJASRECIBIDAS ,
       DIFERENCIAUNIDADES ,
       (CASE
            WHEN DIFERENCIAUNIDADES = 0
                 OR FACTOR = 0 THEN 0
            ELSE DIFERENCIAUNIDADES/FACTOR
        END) AS DIFERENCIACAJAS ,
       (CASE
            WHEN UNIDADESPEDIDAS = 0
                 OR PALLETIZADO = 0 THEN 0
            ELSE UNIDADESPEDIDAS/PALLETIZADO
        END) AS PALLETESPERADO ,
       (CASE
            WHEN UNIDADESRECIBIDAS = 0
                 OR PALLETIZADO = 0 THEN 0
            ELSE UNIDADESRECIBIDAS/PALLETIZADO
        END) ASPALLETRECIBIDO
FROM
    ( SELECT 1 as Cant,
             MAX(RD.RECEIPTKEY) AS CODIGOORDEN,
             MAX(RD.SUPPLIERKEY) AS PROVEEDOR,
             RD.SKU AS CODIGO,
             MAX(AL.ALTSKU) AS EAN13,
             MAX(SK.DESCR) AS DESCRIPCION,
             MAX(PA.CASECNT) AS FACTOR,
             SUM(RD.QTYEXPECTED) AS UNIDADESPEDIDAS,
             SUM(RD.QTYRECEIVED) AS UNIDADESRECIBIDAS,
             SUM((RD.QTYRECEIVED-RD.QTYEXPECTED)) AS DIFERENCIAUNIDADES,
             MAX(PA.PALLET) AS PALLETIZADO
     FROM WMWHSE51.RECEIPTDETAIL AS RD
     LEFT JOIN WMWHSE51.SKU AS SK ON RD.SKU = SK.SKU
     AND RD.STORERKEY = SK.STORERKEY
     LEFT JOIN WMWHSE51.ALTSKU AS AL ON RD.SKU = AL.SKU
     AND AL.TYPE LIKE 'EAN13'
     LEFT JOIN WMWHSE51.PACK AS PA ON RD.PACKKEY = PA.PACKKEY --WHERE RD.RECEIPTKEY LIKE '0000000321'

     GROUP BY RD.SKU )T0