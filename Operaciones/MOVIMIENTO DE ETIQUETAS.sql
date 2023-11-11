SELECT 
distinct
DATEADD(hour,-6, i.adddate) as adddate ,
isnull(i.SKU,'--') as SKU,
isnull(s.descr,'--') as descr,
i.STORERKEY as idPropietario,
i.addwho as 'Usuario Añadió',
i.editwho as 'Usuario Modificó',
(
CASE TRANTYPE
WHEN 'DP' then 'Recepción'
WHEN 'WD' then 'Expedición'
WHEN 'MV' then 'Movimiento Stock'
WHEN 'AJ' then 'Ajustes'
ELSE '--'
END
) as Movimiento,
TRANTYPE AS Movimiento2,
isnull(i.RECEIPTKEY ,'--') as OrdenEntrada, 
isnull(i.TOID ,'--') as EtiquetaNueva,
isnull(i.fromloc,'--') as Desde,
isnull(i.TOLOC ,'--')as Hacia,
isnull(i.LOT,'--') as Lote,
(CASE WHEN i.qty = 0 OR p.casecnt = 0 THEN 0
ELSE i.qty / p.casecnt END ) as Cantidad,
isnull(i.FROMID, '--') as EtiquetaContenedor,
isnull(TD.WAVEKEY,'--') as Ola,
(CASE TD.TASKTYPE
WHEN 'CC' then 'Ciclo Cuenta'
WHEN 'CO' then 'Consolidación'
WHEN 'DP' then 'Picking Dinámico'
WHEN 'MV' then 'Movimientos'
WHEN 'PA' then 'Entradas'
WHEN 'RC' then 'Recepción'
WHEN 'PK' then 'Picking'
WHEN 'RP' then 'Reposición'
ELSE '--'
END 
)as Tarea,
isnull(PD.orderkey,'--') as Pedido,
isnull(LTT.LOTTABLE05,'') as Fecha_Vencimiento,
isnull(ADJ.NOTES,'') as ComentarioAjuste
FROM WMWHSE51.ITRN i
RIGHT JOIN WMWHSE51.SKU s on s.sku =  i.sku
RIGHT JOIN WMWHSE51.PACk p on p.packkey = i.packkey
LEFT JOIN WMWHSE51.RECEIPTDETAIL RD on i.TOID = RD.TOID or I.FROMID = RD.TOID
LEFT JOIN WMWHSE51.PICKDETAIL PD on i.TOID = PD.ID or i.FROMID = PD.id
LEFT JOIN WMWHSE51.TASKDETAIL TD on i.sourcekey = TD.sourcekey
LEFT JOIN WMWHSE51.vITLotxLocxId_Lottables LTT on i.lot =  LTT.lot
LEFT JOIN WMWHSE51.ADJUSTMENTDETAIL ADJ on i.ITRNKEY = ADJ.ITRNKEY
WHERE s.STORERKEY like '%1770142%'


select * from WMWHSE51.SKU s where s.sku like '%1012847%'