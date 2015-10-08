-- Mark plantings that are over 3 years old, that have at least three checks,
-- and were checked at least once in the last year as having had their initial
-- checks done.
update 
plantings
set initial_checks_received = true
where id in 
(select 
  p.id
  from 
  plantings as p, maintenance_records as mr 
  where 
  p.planted_on < now() - '3 years'::interval 
  and p.last_maintenance_date > now() - '1 year'::interval 
  and p.id = mr.planting_id 
  group by 
  p.id 
  having 
  count(mr.id) >= 3);
