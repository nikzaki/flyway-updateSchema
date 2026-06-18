
-- Handicap Verification for multi-course tournament  
ALTER TABLE gs_league_roster ADD COLUMN handicap_verified char(1) DEFAULT 'Y';  
ALTER TABLE gs_league_roster ADD COLUMN handicap_documents mediumtext;  
ALTER TABLE gs_league_roster ADD COLUMN handicap_verified_manually char(1) DEFAULT 'N';  
ALTER TABLE gs_league_roster ADD COLUMN fk_handicap_verified_by int;  
ALTER TABLE gs_league_roster  
    ADD CONSTRAINT fk_roster_ref_auth FOREIGN KEY (fk_handicap_verified_by) REFERENCES gs_authentication (id) ON UPDATE Cascade ON DELETE SET NULL ;  
  
  
-- Championship & Qualifiers  
CREATE TABLE gs_league_championship (  
    id                        int(10) NOT NULL AUTO_INCREMENT,  
    name                      varchar(100) NOT NULL,  
    start_date                date,  
    end_date                  date,  
    fk_organizer              bigint(20) NOT NULL,  
    fk_championship_final_mct int(10),  
    fk_championship_final_sct bigint(20),  
    member_clubs_only         character(1) NOT NULL DEFAULT 'Y',  
    CONSTRAINT pk_league_championship  
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;  
CREATE TABLE gs_league_regional_qualifiers (  
    id                     int(10) NOT NULL AUTO_INCREMENT,  
    fk_league_championship int(10) NOT NULL,  
    name                   varchar(100) NOT NULL,  
    start_date             date,  
    end_date               date,  
    fk_organizer           bigint(20) NOT NULL,  
    fk_participating_club  bigint(20),  
    max_qualifications     smallint(6) NOT NULL,  
    total_qualified        smallint(6) DEFAULT 0 NOT NULL,  
    CONSTRAINT pk_league_regional_championship  
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;  
CREATE TABLE gs_league_regional_tournament (  
    id                     int(10) NOT NULL AUTO_INCREMENT,  
    fk_regional_qualifier  int(10) NOT NULL,  
    name                   varchar(100) NOT NULL,  
    conducted_by_mygolf    char(1) DEFAULT 'Y' NOT NULL,  
    regional_final         char(1) DEFAULT 'N' NOT NULL,  
    qualification_based_on char(1) DEFAULT 'N',  
    fk_tournament_sct      bigint(20),  
    fk_tournament_mct      int(10),  
    golf_course_name       varchar(255),  
    club_address           mediumtext,  
    fk_club                bigint(20),  
    start_date             date,  
    end_date               date,  
    completed              char(1) DEFAULT 'N' NOT NULL,  
    max_qualification      smallint(6) NOT NULL,  
    total_qualified        smallint(6) DEFAULT 0 NOT NULL,  
    CONSTRAINT pk_league_regional_tournament  
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;  
CREATE TABLE gs_league_tournament_qualified_player (  
    id                            int(10) NOT NULL AUTO_INCREMENT,  
    player_name                   varchar(100),  
    player_email                  varchar(255),  
    player_phone                  varchar(30),  
    fk_player                     bigint(20),  
    fk_league_regional_tournament int(10) NOT NULL,  
    region_final_qualifier        char(1) DEFAULT 'N' NOT NULL,  
    gross_score                   smallint(6) NOT NULL,  
    gross_position                smallint(6) NOT NULL,  
    net_score                     smallint(6) NOT NULL,  
    net_position                  smallint(6) NOT NULL,  
    stableford_points             smallint(6),  
    stableford_position           smallint(6) NOT NULL,  
    CONSTRAINT pk_league_tournament_qualified_player  
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;  
ALTER TABLE gs_league_championship ADD CONSTRAINT fk_league_championship_ref_mct_final FOREIGN KEY (fk_championship_final_mct) REFERENCES gs_league_season (id) ON UPDATE Cascade ON DELETE Set null;  
ALTER TABLE gs_league_championship ADD CONSTRAINT fk_league_championship_ref_org FOREIGN KEY (fk_organizer) REFERENCES gs_organizer (id) ON UPDATE Cascade ON DELETE Restrict;  
ALTER TABLE gs_league_championship ADD CONSTRAINT fk_league_championship_ref_sct_final FOREIGN KEY (fk_championship_final_sct) REFERENCES gs_competition (id) ON UPDATE Cascade ON DELETE Set null;  
ALTER TABLE gs_league_regional_tournament ADD CONSTRAINT fk_league_regional_tournament_ref_club FOREIGN KEY (fk_club) REFERENCES gs_club (id) ON UPDATE Cascade ON DELETE Restrict;  
ALTER TABLE gs_league_regional_tournament ADD CONSTRAINT fk_league_regional_tournament_ref_mct FOREIGN KEY (fk_tournament_mct) REFERENCES gs_league_season (id) ON UPDATE Cascade ON DELETE Cascade;  
ALTER TABLE gs_league_regional_tournament ADD CONSTRAINT fk_league_regional_tournament_ref_reg_qualifier FOREIGN KEY (fk_regional_qualifier) REFERENCES gs_league_regional_qualifiers (id) ON UPDATE Cascade ON DELETE Cascade;  
ALTER TABLE gs_league_regional_tournament ADD CONSTRAINT fk_league_regional_tournament_ref_sct FOREIGN KEY (fk_tournament_sct) REFERENCES gs_competition (id) ON UPDATE Cascade ON DELETE Cascade;  
ALTER TABLE gs_league_tournament_qualified_player ADD CONSTRAINT fk_reg_tournament_qualified_player_ref_player FOREIGN KEY (fk_player) REFERENCES gs_player (id) ON UPDATE Cascade ON DELETE Cascade;  
ALTER TABLE gs_league_tournament_qualified_player ADD CONSTRAINT fk_reg_tournament_qualified_plr_ref_reg_tournament FOREIGN KEY (fk_league_regional_tournament) REFERENCES gs_league_regional_tournament (id) ON UPDATE Cascade ON DELETE Cascade;  
ALTER TABLE gs_league_regional_qualifiers ADD CONSTRAINT fk_regional_championship_ref_league_championship FOREIGN KEY (fk_league_championship) REFERENCES gs_league_championship (id) ON UPDATE Cascade ON DELETE Cascade;  
ALTER TABLE gs_league_regional_qualifiers ADD CONSTRAINT fk_regional_qualifier_ref_org FOREIGN KEY (fk_organizer) REFERENCES gs_organizer (id) ON UPDATE Cascade ON DELETE Restrict;  
ALTER TABLE gs_league_regional_qualifiers ADD CONSTRAINT fk_regional_qualifier_ref_participating_club FOREIGN KEY (fk_participating_club) REFERENCES gs_club (id) ON UPDATE Cascade ON DELETE Set null;  
  
-- Tournament Accommodations  
CREATE TABLE gs_tournament_hotel (  
    id                int(10) NOT NULL AUTO_INCREMENT,  
    available_online  char(1) DEFAULT 'Y' NOT NULL,  
    start_date        date,  
    end_date          date,  
    fk_tournament_mct int(10),  
    fk_tournament_sct bigint(20),  
    fk_hotel          int(10) NOT NULL,  
    CONSTRAINT pk_tournament_hotel  
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;  
CREATE TABLE gs_tournament_hotel_room (  
    id                   int(10) NOT NULL AUTO_INCREMENT,  
    fk_tournament_hotel  int(10) NOT NULL,  
    fk_hotel_room        int(10) NOT NULL,  
    total_assigned_rooms smallint(6) NOT NULL,  
    total_rooms_reserved smallint(6),  
    total_allocated      smallint(6),  
    allow_sharing        char(1) DEFAULT 'N' NOT NULL,  
    min_occupancy        smallint(6),  
    max_occupancy        smallint(6),  
    start_date           date,  
    end_date             date,  
    is_upgrade           char(1) DEFAULT 'N' NOT NULL,  
    additional_charge_definition mediumtext,  
    CONSTRAINT pk_tournament_hotel_room  
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;  
ALTER TABLE gs_tournament_hotel ADD CONSTRAINT fk_tournament_hotel_ref_hotel FOREIGN KEY (fk_hotel) REFERENCES gs_hotel (id) ON UPDATE Cascade ON DELETE Restrict;  
ALTER TABLE gs_tournament_hotel ADD CONSTRAINT fk_tournament_hotel_ref_mct FOREIGN KEY (fk_tournament_mct) REFERENCES gs_league_season (id) ON UPDATE Cascade ON DELETE Cascade;  
ALTER TABLE gs_tournament_hotel ADD CONSTRAINT fk_tournament_hotel_ref_sct FOREIGN KEY (fk_tournament_sct) REFERENCES gs_competition (id) ON UPDATE Cascade ON DELETE Cascade;  
ALTER TABLE gs_tournament_hotel_room ADD CONSTRAINT fk_tournament_hotel_room_ref_hotel_room FOREIGN KEY (fk_hotel_room) REFERENCES gs_hotel_room (id) ON UPDATE Cascade ON DELETE Restrict;  
ALTER TABLE gs_tournament_hotel_room ADD CONSTRAINT fk_tournament_hotel_room_ref_tournament_hotel FOREIGN KEY (fk_tournament_hotel) REFERENCES gs_tournament_hotel (id) ON UPDATE Cascade ON DELETE Cascade;  
  
-- Travel Plans & Room Allocation  
CREATE TABLE gs_tournament_hotel_room_allocation (  
    id                      int(10) NOT NULL AUTO_INCREMENT,  
    fk_tournament_room      int(10) NOT NULL,  
    room_number             varchar(30),  
    fk_allocated_by         int(10),  
    allocated_at            datetime NULL,  
    allocated_from_reserved char(1) DEFAULT 'N' NOT NULL,  
    CONSTRAINT pk_tournament_hotel_room_allocation  
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;  
CREATE TABLE gs_tournament_player_travel_info (  
    id                        int(10) NOT NULL AUTO_INCREMENT,  
    fk_tournament_mct         int(10),  
    fk_tournament_sct         bigint(20),  
    fk_player                 bigint(20) NOT NULL,  
    passport_number           varchar(100),  
    passport_expiry           date,  
    fk_passport_country       varchar(10),  
    passport_images           mediumtext,  
    arrival_date              date,  
    arrival_time              time,  
    arriving_airport          varchar(255),  
    arriving_flight_number    varchar(30),  
    departure_date            date,  
    departure_time            time,  
    departing_airport         varchar(255),  
    departing_flight_number   varchar(255),  
    food_preference           mediumtext,  
    emergency_contact_details mediumtext,  
    insurance_name            varchar(100),  
    insurance_number          varchar(30),  
    insurance_copy            varchar(255),  
    fk_hotel_room_allocated   int(10),  
    CONSTRAINT pk_tournament_player_travel_info  
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;  
ALTER TABLE gs_tournament_hotel_room_allocation ADD CONSTRAINT fk_thr_allocation_ref_thr FOREIGN KEY (fk_tournament_room) REFERENCES gs_tournament_hotel_room (id) ON UPDATE Cascade ON DELETE Cascade;  
ALTER TABLE gs_tournament_hotel_room_allocation ADD CONSTRAINT fk_thr_allocation_ref_user FOREIGN KEY (fk_allocated_by) REFERENCES gs_authentication (id) ON UPDATE Cascade ON DELETE Restrict;  
ALTER TABLE gs_tournament_player_travel_info ADD CONSTRAINT fk_tournament_travel_ref_country FOREIGN KEY (fk_passport_country) REFERENCES gs_country (id) ON UPDATE Cascade ON DELETE Restrict;  
ALTER TABLE gs_tournament_player_travel_info ADD CONSTRAINT fk_tournament_travel_ref_mct FOREIGN KEY (fk_tournament_mct) REFERENCES gs_league_season (id) ON UPDATE Cascade ON DELETE Cascade;  
ALTER TABLE gs_tournament_player_travel_info ADD CONSTRAINT fk_tournament_travel_ref_player FOREIGN KEY (fk_player) REFERENCES gs_player (id) ON UPDATE Cascade ON DELETE Restrict;  
ALTER TABLE gs_tournament_player_travel_info ADD CONSTRAINT fk_tournament_travel_ref_room_allocation FOREIGN KEY (fk_hotel_room_allocated) REFERENCES gs_tournament_hotel_room_allocation (id) ON UPDATE Cascade ON DELETE Set null;  
ALTER TABLE gs_tournament_player_travel_info ADD CONSTRAINT fk_tournament_travel_ref_sct FOREIGN KEY (fk_tournament_sct) REFERENCES gs_competition (id) ON UPDATE Cascade ON DELETE Cascade;  
  
-- Updated transaction type view  
create or replace view gv_club_transaction_type as  
    select concat_ws('_', club.id, tt.id) trxn_type_key,  club.id club_id, club_name,  
           tt.id transaction_type_id, tt.name transaction_type_name, tt.debit_or_credit, tt.description,  
           if(tt.fk_club is null, 'Y', 'N') system_transaction_type, tt.used_for,  
           ttcm.club_transaction_type,  
           ttcm.debit_account_code, ttcm.credit_account_code,  
           tt.fk_transaction_group, gs_transaction_group.name transaction_group_name  
    FROM gs_transaction_type tt  
             LEFT JOIN gs_club club ON club.id = tt.fk_club  
             LEFT JOIN gs_transaction_group ON gs_transaction_group.id = tt.fk_transaction_group  
             LEFT JOIN gs_transaction_type_club_map ttcm ON ttcm.fk_transaction_type = tt.id AND ttcm.fk_club = club.id;  
  
  
-- Updated Tournament View  
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
                WHERE lsc.fk_competition = comp.id AND ls.nature_of_league <> 'League' ) > 0, 'Y', 'N')) multi_course_round,  
           -- Regional Tournament  
           (IF((SELECT COALESCE(COUNT(*), 0)  
                FROM gs_league_regional_tournament rt  
                WHERE rt.fk_tournament_sct = comp.id) > 0, 'Y', 'N'))                     regional_tournament,  
           (IF((SELECT COALESCE(COUNT(*), 0)  
                FROM gs_league_regional_tournament rt  
                WHERE rt.fk_tournament_sct = comp.id AND rt.regional_final = 'Y') > 0, 'Y', 'N'))                     regional_final  
  
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
           'N' multi_course_round,  
           -- Regional Tournament  
           (IF((SELECT COALESCE(COUNT(*), 0)  
                FROM gs_league_regional_tournament rt  
                WHERE rt.fk_tournament_sct = ls.id) > 0, 'Y', 'N')) regional_tournament,  
           (IF((SELECT COALESCE(COUNT(*), 0)  
                FROM gs_league_regional_tournament rt  
                WHERE rt.fk_tournament_sct = ls.id AND rt.regional_final = 'Y') > 0, 'Y', 'N')) regional_final  
    FROM gs_league_season ls  
             JOIN gs_league l ON l.id = ls.fk_league  
             JOIN gs_organizer org ON org.id = l.fk_organizer  
    WHERE ls.nature_of_league <> 'League';