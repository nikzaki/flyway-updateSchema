
-- 21-Jun-2026
ALTER TABLE gs_tournament_hotel_room_allocation ADD COLUMN checked_in CHAR(1) DEFAULT 'N' NOT NULL CHECK ( checked_in IN ('Y', 'N') );
ALTER TABLE gs_tournament_hotel_room_allocation ADD COLUMN checked_in_at datetime;

-- 26-Jun-2026
ALTER TABLE gs_league_roster ADD COLUMN approved CHAR(1) DEFAULT 'N' NOT NULL CHECK ( approved IN ('Y', 'N') );
ALTER TABLE gs_league_season_guest ADD COLUMN approved CHAR(1) DEFAULT 'N' NOT NULL CHECK ( approved IN ('Y', 'N') );
ALTER TABLE gs_league_season_guest ADD COLUMN guest_type VARCHAR(10) DEFAULT 'GUEST' NOT NULL;

ALTER TABLE gs_league_season_participating_club  ADD COLUMN all_participants_approved CHAR(1) DEFAULT 'N' NOT NULL CHECK ( all_participants_approved IN ('Y', 'N') );
ALTER TABLE gs_league_season_participating_club  ADD COLUMN locked_for_changes CHAR(1) DEFAULT 'N' NOT NULL CHECK ( locked_for_changes IN ('Y', 'N') );


-- Update the league season participant view
create or replace view gv_league_season_participant as
    select lr.id,
           lr.fk_player,
           lr.fk_league_season,
           fk_player_group,
           fk_competition_stream,
           lr.fk_competition_player_category,
           'player' as participation_type,
           ai.additional_info,
           ai.created_at,
           ai.last_updated_at,
           ai.created_by,
           auth_create.name created_by_name,
           ai.last_updated_by,
           auth_update.name updated_by_name,
           lstp.fk_league_season_team fk_team,
           lr.handicap,
           lr.handicap_index,
           lr.fk_participating_club,
           lr.approved,
           'N/A' as guest_type,
           ti.id as fk_travel_info,
           thra.id AS fk_room_allocation
    FROM gs_league_roster lr
             LEFT JOIN gs_league_season_team_player lstp
                       ON lstp.fk_league_roster = lr.id

             LEFT JOIN gs_competition_player_addl_info ai
                       ON ai.fk_league_season = lr.fk_league_season AND ai.fk_player = lr.fk_player
             LEFT JOIN gs_authentication auth_create
                       ON ai.created_by = auth_create.id
             LEFT JOIN gs_authentication auth_update
                       ON ai.last_updated_by = auth_update.id
             LEFT JOIN gs_tournament_player_travel_info ti
                 ON ti.fk_tournament_mct = lr.fk_league_season AND ti.fk_player = lr.fk_player
             LEFT JOIN gs_tournament_hotel_room_allocation thra
                 ON thra.id = ti.fk_hotel_room_allocated


    UNION
    SELECT sg.id,
           sg.fk_player,
           sg.fk_league_season,
           fk_player_group,
           null    as fk_competition_stream,
           null    as fk_competition_player_category,
           'guest' as participation_type,
           additional_info,
           ai.created_at,
           ai.last_updated_at,
           ai.created_by,
           auth_create.name created_by_name,
           ai.last_updated_by,
           auth_update.name updated_by_name,
           null as fk_team,
           null as handicap,
           null as handicap_index,
           sg.fk_participating_club,
           sg.approved,
           sg.guest_type,
           ti.id as fk_travel_info,
           thra.id fk_room_allocation
    FROM gs_league_season_guest sg
             LEFT JOIN gs_competition_player_addl_info ai
                       ON ai.fk_league_season = sg.fk_league_season AND ai.fk_player = sg.fk_player
             LEFT JOIN gs_authentication auth_create
                       ON ai.created_by = auth_create.id
             LEFT JOIN gs_authentication auth_update
                       ON ai.last_updated_by = auth_update.id
             LEFT JOIN gs_tournament_player_travel_info ti
                       ON ti.fk_tournament_mct = sg.fk_league_season AND ti.fk_player = sg.fk_player
             LEFT JOIN gs_tournament_hotel_room_allocation thra
                       ON thra.id = ti.fk_hotel_room_allocated
;


ALTER TABLE gs_league_tournament_qualified_player ADD COLUMN fk_home_club bigint;
ALTER TABLE gs_league_tournament_qualified_player ADD COLUMN golf_course_name varchar(255);
ALTER TABLE gs_league_tournament_qualified_player ADD COLUMN club_address mediumtext;
ALTER TABLE gs_league_tournament_qualified_player ADD COLUMN handicap_index decimal(6, 2);
ALTER TABLE gs_league_tournament_qualified_player ADD COLUMN handicap smallint;

ALTER TABLE gs_hotel_room change column room_specification room_specification mediumtext;
ALTER TABLE gs_tournament_invoice_setup ADD COLUMN include_hotel_charges char(1) DEFAULT  'N' NOT NULL;
ALTER TABLE gs_tournament_invoice_setup ADD COLUMN include_guest_hotel_charges char(1) DEFAULT  'N' NOT NULL;

ALTER TABLE gs_tournament_hotel_room_allocation add column start_date date;
ALTER TABLE gs_tournament_hotel_room_allocation add column end_date date;
ALTER TABLE gs_tournament_hotel_room_allocation add column fk_player_allocated  bigint(20);
ALTER TABLE gs_tournament_hotel_room_allocation
    ADD CONSTRAINT fk_thr_allocation_ref_player
        FOREIGN KEY (fk_player_allocated) REFERENCES gs_player (id) ON UPDATE Cascade ON DELETE Restrict;


ALTER TABLE gs_league_roster add column valid_info char(1) DEFAULT  'Y' NOT NULL;
ALTER TABLE gs_league_roster add column validation_error mediumtext;

ALTER TABLE gs_league_season_guest add column valid_info char(1) DEFAULT  'Y' NOT NULL;
ALTER TABLE gs_league_season_guest add column validation_error mediumtext;

-- Four-Ball Alliance
ALTER TABLE gs_competition_team_round add column hole_scores mediumtext;

alter table gs_league_tournament_qualified_player modify column gross_position smallint(6);
alter table gs_league_tournament_qualified_player modify column net_position smallint(6);
alter table gs_league_tournament_qualified_player modify column stableford_points smallint(6);
alter table gs_league_tournament_qualified_player modify column stableford_position smallint(6);