SELECT DISTINCT OLA,
                PEDIDO,
                PROPIETARIO,
                FechaCreacionOla,
                ESTADO,
                id_ESTADO,
                TIENDA,
                U_PEDIDAS,
                U_PREPARADAS,
                (U_PEDIDAS / FactorEmpaque) as C_PEDIDAS,
                (U_PREPARADAS / FactorEmpaque) as C_PREPARADAS,
                ((U_PREPARADAS / FactorEmpaque) / (U_PEDIDAS / FactorEmpaque)* 100) as Cumplimiento,
                ( CASE
                      WHEN id_ESTADO = -1 then 'Desconocida'
                      WHEN id_ESTADO = 0 then 'Orden Vacía'
                      WHEN id_ESTADO = 02 then 'Creada Externamente'
                      WHEN id_ESTADO = 04 then 'Creada Internamente'
                      WHEN id_ESTADO = 06 then 'No asignada'
                      WHEN id_ESTADO = 08 then 'Convertido'
                      WHEN id_ESTADO = 09 then 'No iniciada'
                      WHEN id_ESTADO = 10 then 'Por lotes'
                      WHEN id_ESTADO = 11 then 'Parte preasignada'
                      WHEN id_ESTADO = 12 then 'Preasignado'
                      WHEN id_ESTADO = 13 then 'Lanzada'
                      WHEN id_ESTADO = 14 then 'Preparación'
                      WHEN id_ESTADO = 15 then 'Preparación'
                      WHEN id_ESTADO = 16 then 'Preparación'
                      WHEN id_ESTADO = 17 then 'Preparación'
                      WHEN id_ESTADO = 18 then 'Preparación'
                      WHEN id_ESTADO = 22 then 'Preparación'
                      WHEN id_ESTADO = 25 then 'Preparación'
                      WHEN id_ESTADO = 51 then 'Preparación'
                      WHEN id_ESTADO = 52 then 'Preparación'
                      WHEN id_ESTADO = 53 then 'Preparación'
                      WHEN id_ESTADO = 55 then 'Preparado'
                      WHEN id_ESTADO = 57 then 'Preparado'
                      WHEN id_ESTADO = 61 then 'Preparado'
                      WHEN id_ESTADO IN (68,
                                         75,
                                         78,
                                         82,
                                         88,
                                         92,
                                         94,
                                         95,
                                         96,
                                         97) then 'Preparado'
                      WHEN id_ESTADO = 98 then 'Cancelada Externamente'
                      WHEN id_ESTADO = 99 then 'Cancelada Internamente'
                      ELSE 'Sin estado'
                  END )as EstadoEspañol,
                AlTSKU,
                sku,
                FactorEmpaque,
                UbicacionOrigen,
                FechaPicking,
                usuarioPicador,
                (CASE
                     WHEN UnidadesBloqueadas = 0 then 0
                     ELSE (UnidadesBloqueadas/FactorEmpaque)
                 END) as C_BLOQUEADAS,
                (CASE
                     WHEN U_DISPONIBLES = 0 then 0
                     ELSE (U_DISPONIBLES/FactorEmpaque)
                 END) as C_DISPONIBLES,
                DetalleArticulo
FROM
    (SELECT W.WAVEKEY AS OLA,
            PD.STORERKEY AS PROPIETARIO,
            DATEADD(hour,-6,W.ADDDATE) as FechaCreacionOla,
            PD.SKU,
            MAX(PD.fromloc) as UbicacionOrigen,
            MAX(PD.pickeddate) as FechaPicking,
            MAX(PD.PICKEDBYUSER) as usuarioPicador,
            MAX(SK.descr) as DetalleArticulo,
            isnull(
                       ( SELECT TOP 1 DESCRIPTION
                        FROM WMWHSE51.ORDERSTATUSSETUP OST
                        INNER JOIN WMWHSE51.ORDERS OD ON OD.STATUS =OST.CODE
                        AND OST.WHSEID=OD.WHSEID
                        WHERE OD.ORDERKEY=PD.ORDERKEY ),'Ola Creada') AS ESTADO,

         ( SELECT TOP 1 code
          FROM WMWHSE51.ORDERSTATUSSETUP OST
          INNER JOIN WMWHSE51.ORDERS OD ON OD.STATUS =OST.CODE
          AND OST.WHSEID=OD.WHSEID
          WHERE OD.ORDERKEY=PD.ORDERKEY ) AS id_ESTADO,

         ( SELECT TOP 1 OD.C_COMPANY
          FROM WMWHSE51.ORDERS OD
          WHERE OD.ORDERKEY=PD.ORDERKEY) AS TIENDA,
            CONVERT(DATE,PD.ADDDATE) AS FECHA_CREACION,

         ( SELECT SUM(OT.ORIGINALQTY)
          FROM WMWHSE51.ORDERS OD
          INNER JOIN WMWHSE51.ORDERDETAIL OT ON OD.ORDERKEY = OT.ORDERKEY
          WHERE OT.ORDERKEY=PD.ORDERKEY
              AND OT.SKU =PD.SKU ) AS U_PEDIDAS,

         ( SELECT SUM(OT.QTYPICKED)
          FROM WMWHSE51.ORDERS OD
          INNER JOIN WMWHSE51.ORDERDETAIL OT ON OD.ORDERKEY = OT.ORDERKEY
          WHERE OT.ORDERKEY=PD.ORDERKEY
              AND OT.SKU =PD.SKU ) AS U_PREPARADAS1,
            ( CASE
                  WHEN
                           ( SELECT TOP 1 code
                            FROM WMWHSE51.ORDERSTATUSSETUP OST
                            INNER JOIN WMWHSE51.ORDERS OD ON OD.STATUS =OST.CODE
                            AND OST.WHSEID=OD.WHSEID
                            WHERE OD.ORDERKEY=PD.ORDERKEY ) <> 95 then
                           ( SELECT SUM(OT.QTYPICKED)
                            FROM WMWHSE51.ORDERS OD
                            INNER JOIN WMWHSE51.ORDERDETAIL OT ON OD.ORDERKEY = OT.ORDERKEY
                            WHERE OT.ORDERKEY=PD.ORDERKEY
                                AND OT.SKU =PD.SKU )
                  ELSE
                           ( SELECT SUM(OT.SHIPPEDQTY)
                            FROM WMWHSE51.ORDERS OD
                            INNER JOIN WMWHSE51.ORDERDETAIL OT ON OD.ORDERKEY = OT.ORDERKEY
                            WHERE OT.ORDERKEY=PD.ORDERKEY
                                AND OT.SKU =PD.SKU )
              END ) U_PREPARADAS,
            (
                 ( SELECT SUM(OT.QTYPICKED)
                  FROM WMWHSE51.ORDERS OD
                  INNER JOIN WMWHSE51.ORDERDETAIL OT ON OD.ORDERKEY = OT.ORDERKEY
                  WHERE OT.ORDERKEY=PD.ORDERKEY
                      AND OT.SKU =PD.SKU )/PK.CASECNT) AS C_PREPARADAS,
            (
                 ( SELECT SUM(OT.ORIGINALQTY)
                  FROM WMWHSE51.ORDERS OD
                  INNER JOIN WMWHSE51.ORDERDETAIL OT ON OD.ORDERKEY = OT.ORDERKEY
                  WHERE OT.ORDERKEY=PD.ORDERKEY
                      AND OT.SKU =PD.SKU )/PK.CASECNT) AS C_PEDIDAS,

         (SELECT TOP 1 ALTSKU
          from WMWHSE51.ALTSKU alt
          WHERE alt.sku = PD.sku
              AND alt.TYPE = 'EAN13' ) as AlTSKU,

         (SELECT TOP 1 CASECNT
          from WMWHSE51.PACK PACk1
          WHERE pack1.packkey = sk.packkey ) as FactorEmpaque,
            isnull(
                       (SELECT SUM(LD.qty)
                        FROM WMWHSE51.LOTXLOCXID LD
                        WHERE qty > 0
                            and status = 'HOLD'
                            and LD.sku = SK.SKU ), 0) as UnidadesBloqueadas,
            ISNULL(
                       (SELECT SUM(LD.qty)
                        FROM WMWHSE51.LOTXLOCXID LD
                        WHERE qty > 0
                            and status = 'OK'
                            and LD.sku = SK.SKU),0) as U_DISPONIBLES,
            PD.ORDERKEY AS PEDIDO
     FROM WMWHSE51.WAVE w
     LEFT JOIN WMWHSE51.PICKDETAIL PD ON W.WAVEKEY = PD.WAVEKEY
     LEFT  JOIN WMWHSE51.SKU SK ON SK.SKU = PD.SKU
     LEFT  JOIN WMWHSE51.PACK PK ON PK.PACKKEY = SK.PACKKEY AND SK.STORERKEY = PD.STORERKEY AND PD.STORERKEY LIKE '%TGU%' OR PD.STORERKEY LIKE '%SPS%'
     GROUP BY W.WAVEKEY,
              PD.ORDERKEY,
              SK.SKU,
              PD.SKU,
              PK.CASECNT,
              CONVERT(DATE,PD.ADDDATE),
              W.ADDDATE,
              sk.packkey,
              PD.STORERKEY )t0
WHERE FechaCreacionOla between DATEADD(DAY,-5,getdate()) and getdate()