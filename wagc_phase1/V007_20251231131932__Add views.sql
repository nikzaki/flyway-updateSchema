
create or replace view gv_tournament as
    SELECT concat_ws('-', 'SCT', comp.id) tournament_key, comp.id tournament_id, tournament_name, 'SCT' tournament_type,
           comp.tournament_image,
           date_start start_date, date_end end_date, timestamp(date_publish, publish_time) publish_on,
           timestamp(date_open, registration_open_time) registration_starts_on, timestamp(date_close, registration_close_time) registration_ends_on,
           fk_organizer,
           comp.is_team_event team_event,
           (CASE
               WHEN comp.status = 'In Progress' THEN 'ONGOING'
               WHEN comp.status = 'Upcoming' THEN 'UPCOMING'
               WHEN comp.status = 'Completed' THEN 'COMPLETED'
               WHEN comp.status = 'Cancelled' THEN 'CANCELLED'
               END) tournament_status,

           (CASE
                WHEN comp.status = 'In Progress' AND date_end < curdate() THEN 'Elapsed-InProgress'
                WHEN comp.status = 'Upcoming' AND date_end < curdate() THEN 'Elapsed-Upcoming'
                WHEN comp.status = 'Upcoming' AND date_start = curdate() THEN 'Upcoming-Today'
                WHEN comp.status = 'Upcoming' AND date_start > curdate() THEN 'Upcoming'
                WHEN comp.status = 'In Progress' AND date_start = curdate() THEN 'InProgress'
                WHEN comp.status = 'Completed' AND date_end = curdate() THEN 'Completed-Today'
                when comp.status = 'Completed' AND date_end < curdate() THEN 'Completed'
                else comp.status
               END)                                                                                                        derived_status,
        comp.status source_status,

        (CASE
            WHEN comp.status = 'In Progress' AND date_end >= curdate() THEN 1
            WHEN comp.status = 'Upcoming' AND date_start = curdate() THEN 2
            WHEN comp.status = 'Completed' AND date_end = curdate() THEN 3
            WHEN comp.status = 'Upcoming' AND date_end >= curdate() THEN 4
            WHEN comp.status = 'Completed' THEN 5
            ELSE 6
               END) sort_order,
        (IF(comp.status <> 'Completed' AND date_end < curdate(), 'Y', 'N'))                                                     is_elapsed,

        (SELECT COALESCE(COUNT(*), 0) FROM gs_competition_player cp WHERE cp.fk_competition = comp.id AND cp.status = 'R') total_registered,

        (SELECT COALESCE(COUNT(*), 0) FROM gs_game_round gr WHERE gr.fk_competition = comp.id) total_rounds,

        (SELECT club_name FROM gs_club clb WHERE clb.id = comp.fk_club) course_names,

        (SELECT fk_country FROM gs_club clb WHERE clb.id = comp.fk_club) country_id,

        (IF((SELECT count(*) FROM gs_game_round gr WHERE gr.fk_competition = comp.id AND gr.is_edited = 'Y') > 0, 'Y', 'N')) is_updated,

        comp.fk_scoring_format scoring_format_id,
        comp.fk_handicap_format handicap_format_id,

       (SELECT group_concat(ls.season_name)
        FROM gs_league_season_competition lsc
                 JOIN gs_league_season ls ON lsc.fk_league_season = ls.id
                 JOIN gs_league l ON ls.fk_league = l.id
                 WHERE lsc.fk_competition = comp.id) league_season_names,

       (IF((SELECT COALESCE(COUNT(*), 0) FROM gs_league_season_competition lsc
                            JOIN gs_league_season ls ON lsc.fk_league_season = ls.id
                            WHERE lsc.fk_competition = comp.id AND ls.nature_of_league <> 'League' ) > 0, 'Y', 'N')) multi_course_round

    FROM gs_competition comp
    LEFT JOIN gs_organizer org ON org.id = comp.fk_organizer
    JOIN gs_club clb ON comp.fk_club = clb.id

UNION
    SELECT concat_ws('-', 'MCT', ls.id) tournament_key, ls.id tournament_id, season_name tournament_name, 'MCT' tournament_type,
           ls.logo tournament_image,
           start_date, end_date, publish_on,
           registration_starts_on, registration_ends_on,
           l.fk_organizer,
           ls.team_event,
           (CASE
               WHEN ls.status = 'CREATED' THEN 'UPCOMING'
               WHEN ls.status = 'STARTED' THEN 'ONGOING'
               WHEN ls.status = 'SUSPENDED' THEN 'CANCELLED'
               WHEN ls.status = 'CLOSED' THEN 'COMPLETED'
               WHEN ls.status = 'UPDATED' THEN 'COMPLETED'
               END) tournament_status,

           (CASE
               WHEN ls.status = 'STARTED' AND end_date < curdate() THEN 'Elapsed-InProgress'
               WHEN ls.status = 'CREATED' AND end_date < curdate() THEN 'Elapsed-Upcoming'
               WHEN ls.status = 'CREATED' AND start_date = curdate() THEN 'Upcoming-Today'
               WHEN ls.status = 'CREATED' AND (start_date > curdate() OR end_date < curdate() ) THEN 'Upcoming'
               WHEN ls.status = 'STARTED' AND start_date = curdate() THEN 'InProgress'
               WHEN ls.status = 'CLOSED' AND end_date >= curdate() THEN 'Completed-Today'
               when ls.status = 'CLOSED' AND end_date < curdate() THEN 'Completed'
               else ls.status
               END)                                                                               derived_status,

            ls.status source_status,

           (CASE
                WHEN ls.status = 'STARTED' AND end_date >= curdate() THEN 1
                WHEN ls.status = 'CREATED' AND start_date = curdate() THEN 2
                WHEN ls.status = 'CLOSED' AND end_date = curdate() THEN 3
                WHEN ls.status = 'UPDATED' THEN 3
                WHEN ls.status = 'CREATED' AND end_date > curdate() THEN 4
                WHEN ls.status = 'CLOSED' THEN 5
                ELSE 6
               END) sort_order,

        (IF(ls.status <> 'CLOSED' AND ls.status <> 'UPDATED' AND end_date < curdate(), 'Y', 'N')) is_elapsed,

        (SELECT COALESCE(COUNT(*), 0) FROM gs_league_roster lr WHERE lr.fk_league_season = ls.id) total_registered,

        (SELECT COALESCE(COUNT(*), 0) FROM gs_league_season_competition lsc WHERE lsc.fk_league_season = ls.id) total_rounds,

        (SELECT group_concat(club_name) FROM gs_league_season_competition lsc
                                        JOIN gs_competition comp ON lsc.fk_competition = comp.id
                                        JOIN gs_club clb ON comp.fk_club = clb.id
                                        WHERE lsc.fk_league_season = ls.id
                                        ) course_names,
        (SELECT fk_country FROM gs_league_season_competition lsc
                                    JOIN gs_competition comp ON lsc.fk_competition = comp.id
                                    JOIN gs_club clb ON comp.fk_club = clb.id
             WHERE lsc.fk_league_season = ls.id AND lsc.competition_sequence = 1 LIMIT 1) country_id,
        (IF(ls.status = 'UPDATED', 'Y', 'N')) is_updated,
        null scoring_format_id,
        null handicap_format_id,
        null league_season_names,
        'N' multi_course_round
    FROM gs_league_season ls
    JOIN gs_league l ON l.id = ls.fk_league
    JOIN gs_organizer org ON org.id = l.fk_organizer
    WHERE ls.nature_of_league <> 'League';

create or replace view gv_tournament_club as
    select concat_ws('-', 'SCT', comp.id) tournament_key, 'SCT' tournament_type, comp.id tournament_id, 1 sequence, fk_club, club_name,
           date_start start_date, date_end end_date
    FROM gs_competition comp JOIN gs_club clb ON comp.fk_club = clb.id
    UNION
    SELECT concat_ws('-', 'MCT', ls.id) tournament_key, 'MCT' tournament_type, ls.id tournament_id, lsc.competition_sequence sequence, fk_club, club_name,
           start_date, end_date
    FROM gs_league_season ls
             JOIN gs_league_season_competition lsc ON ls.id = lsc.fk_league_season
             JOIN gs_competition comp ON comp.id = lsc.fk_competition
             JOIN gs_club clb ON comp.fk_club = clb.id;



create or replace view gv_tournament_player AS
select concat_ws('-', 'SCT', comp.id) tournament_key,
       'SCT' tournament_type,
       comp.id tournament_id,
       cp.fk_player, player_name
FROM gs_competition_player cp
    JOIN gs_player plr ON cp.fk_player = plr.id
    JOIN gs_competition comp ON cp.fk_competition = comp.id
    WHERE cp.status = 'R'

UNION
select concat_ws('-', 'MCT', ls.id) tournament_key,
       'MCT' tournament_type,
       ls.id tournament_id,
       fk_player, player_name
FROM gs_league_roster r
    JOIN gs_player plr ON r.fk_player = plr.id
    JOIN gs_league_season ls ON r.fk_league_season = ls.id;


create or replace view gv_tournament_waitlist AS
    SELECT concat_ws('-', 'SCT', comp.id) tournament_key,
           'SCT' tournament_type,
           comp.id tournament_id,
           wl.fk_player, player_name, wl.status
    FROM gs_competition_wait_list wl
    JOIN gs_competition comp ON wl.fk_competition = comp.id
    JOIN gs_player plr ON wl.fk_player = plr.id
    WHERE wl.status = 'W';

create or replace view gv_user_profile AS
    SELECT auth.id user_id, auth.user_name, auth.name auth_name, auth.email, auth.is_active,
           uf.salutation, uf.first_name, uf.last_name, uf.name profile_name, uf.profile_image,
           uf.gender, uf.date_of_birth, uf.occupation, uf.religion, uf.race,
           uf.married, uf.marriage_date, uf.photo, uf.fk_nationality, uf.share_with_club, uf.share_with_others,
           ua.fk_address, address_name,
           (SELECT id FROM gs_player pl WHERE pl.fk_authentication = auth.id LIMIT 1) player_id,
           (SELECT fk_club FROM  gs_user_role ur WHERE ur.fk_authentication = auth.id AND fk_role = 'ROLE_CLUB') club_id,
           (SELECT fk_club_group FROM  gs_user_role ur WHERE ur.fk_authentication = auth.id AND fk_role = 'ROLE_CLUB_GROUP')club_group_id,
           (SELECT fk_organizer FROM gs_user_role ur WHERE ur.fk_authentication = auth.id AND fk_role = 'ROLE_ORGANIZER') organizer_id,
           (SELECT fk_partner FROM gs_user_role ur WHERE ur.fk_authentication = auth.id AND fk_role = 'ROLE_PARTNER') partner_id
    FROM gs_authentication auth
             LEFT JOIN gs_user_profile uf ON auth.id = uf.fk_user
             LEFT JOIN gs_user_address ua ON auth.id = ua.fk_user AND ua.default_address = 'Y';

create or replace view gv_user_role as
    SELECT auth.id user_id, auth.user_name, auth.name auth_name, auth.email, auth.is_active,
           ur.fk_role, ur.fk_club, ur.fk_club_group, ur.fk_organizer, ur.fk_partner, ur.default_role
    FROM gs_user_role ur
     JOIN gs_authentication auth ON ur.fk_authentication = auth.id;

create or replace view gv_user_address as
    SELECT auth.id user_id, auth.user_name, auth.name auth_name, auth.email, auth.is_active,
           ua.fk_address, address_name, ua.default_address
    FROM gs_authentication auth
    JOIN gs_user_address ua ON auth.id = ua.fk_user;