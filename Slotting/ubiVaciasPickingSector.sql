SELECT 
Loc.loc,
loc.locationtype,
(
CASE loc.status 
WHEN 'OK' THEN 'NO BLOQUEADO'
ELSE 'BLOQUEADO'
END   
)as Estado,
loc.putawayzone
FROM WMWHSE51.loc
LEFT JOIN  WMWHSE51.LOTXLOCXID lot ON loc.loc = lot.loc
WHERE loc.loclevel = 1 
group by Loc.loc, loc.status, loc.putawayzone, loc.locationtype
HAVING SUM(lot.qty) > 0