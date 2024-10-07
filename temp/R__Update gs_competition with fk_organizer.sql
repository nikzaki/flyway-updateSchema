update gs_competition comp
SET fk_organizer = (select id FROM gs_organizer org where org.fk_club = comp.fk_club)
WHERE fk_organizer is null;


select (select id FROM gs_organizer org where org.fk_club = comp.fk_club) organizer_id,
       comp.id, comp.tournament_name, comp.status, fk_club, club.club_name
FROM gs_competition comp
inner join gs_club club on comp.fk_club = club.id
WHERE fk_organizer is null
order by organizer_id;