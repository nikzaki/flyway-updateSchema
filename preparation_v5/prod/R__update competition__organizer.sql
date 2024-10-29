select (select id FROM gs_organizer org where org.fk_club = comp.fk_club) organizer_id,
       comp.id, comp.tournament_name, status, fk_club
FROM gs_competition comp
WHERE fk_organizer is null
order by organizer_id;

update gs_competition comp
SET fk_organizer = (select id FROM gs_organizer org where org.fk_club = comp.fk_club)
WHERE fk_organizer is null;