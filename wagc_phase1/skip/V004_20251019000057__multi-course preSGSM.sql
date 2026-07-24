
-- 25-Aug-2025: Multi-Day Rounds
alter table gs_game_round add column no_of_days smallint not null default 1;
alter table gs_round_session add column session_date date;

-- 25-Aug-2025 Competition Version
alter table gs_competition add column version smallint not null default 1;
alter table gs_competition add column multi_course_round char(1) default 'N';

-- 27-Aug-2025 Competition Play Distribution
ALTER TABLE gs_league_season add column play_distribution mediumtext;


-- 11-Sep-2025: Standard Competition Changes required.
alter table gs_competition add column player_category_by char(1) default 'H' NOT NULL;

# alter table gs_competition_player_category add column for_grouping char(1) default 'Y' NOT NULL;

-- Make player category optional.
alter table gs_competition_category modify fk_category bigint null;

-- Additional Fields
alter table gs_competition_category add column from_handicap decimal(5,1) null;
alter table gs_competition_category add column to_handicap decimal(5,1) null;
alter table gs_competition_category add column for_grouping char(1) default 'Y';
alter table gs_competition_category add column from_age smallint;
alter table gs_competition_category add column to_age smallint;
# alter table gs_competition_category add column handicap_or_idx char(1) default 'I' NOT NULL;
alter table gs_competition_category add name varchar(100);
alter table gs_competition_category add column gender char(1);
ALTER table gs_competition_category add column fk_stream int;
-- Competition Player Introduce Stream and Player Groups
ALTER TABLE gs_competition_player add column fk_stream int;
ALTER TABLE gs_competition_player add column fk_player_group bigint;
ALTER TABLE gs_competition_player add column fk_competition_category bigint;
ALTER TABLE gs_competition_player ADD CONSTRAINT fk_comp_player_ref_stream FOREIGN KEY (fk_stream) REFERENCES gs_competition_stream (id) ON UPDATE Cascade ON DELETE Set null;
ALTER TABLE gs_competition_player ADD CONSTRAINT fk_comp_player_ref_player_group FOREIGN KEY (fk_player_group) REFERENCES gs_competition_player_group (id) ON UPDATE Cascade ON DELETE Set null;
ALTER TABLE gs_competition_player ADD CONSTRAINT fk_comp_player_ref_comp_catg FOREIGN KEY (fk_competition_category) REFERENCES gs_competition_category (id) ON UPDATE Cascade ON DELETE Set null;
ALTER TABLE gs_competition_category ADD CONSTRAINT fk_comp_catg_ref_stream FOREIGN KEY (fk_stream) REFERENCES gs_competition_stream (id) ON UPDATE Cascade ON DELETE Cascade;

-- 14-Sep-2025: League Season Competition Changes
alter table gs_league_season_competition add column ignore_for_league_total char(1) default 'N' NOT NULL;
alter table gs_league_season_competition add column part_of_final char(1) default 'N' NOT NULL;
alter table gs_league_season_competition add column flight_generation_rule mediumtext;

-- 15-Sep-2025: Competition Player Session


ALTER TABLE gs_competition_player_group modify fk_league_season int null;
UPDATE gs_competition_player_category set for_grouping = 'Y' WHERE for_grouping is null;
ALTER TABLE gs_competition_player_category modify for_grouping char(1) default 'Y' NOT NULL;

-- 17-Sep-2025
create or replace view gv_player_round AS
    select comp.id competition_id,
           gr.id round_id, gr.round_no,
           pr.id player_round_id,
           cp.id competition_player_id, cp.fk_player player_id,
           cp.fk_stream stream_id, cp.fk_competition_category category_id, cp.fk_player_group group_id,
           rs.id round_session_id, rs.session_date, rs.start_time session_time,
           team.id team_id, team.team_name,
           tp.is_captain
    FROM gs_player_round pr
             JOIN gs_game_round gr ON pr.fk_game_round = gr.id
             JOIN gs_competition comp ON gr.fk_competition = comp.id
             JOIN gs_competition_player cp ON cp.fk_player = pr.fk_player AND cp.fk_competition = comp.id
             LEFT OUTER JOIN gs_player_session ps ON ps.fk_competition_player = cp.id
             LEFT OUTER JOIN gs_round_session rs ON ps.fk_round_session = rs.id AND rs.fk_game_round = gr.id
             LEFT OUTER JOIN gs_team_player tp ON cp.id = tp.fk_competition_player
             LEFT OUTER JOIN gs_competition_team team ON tp.fk_competition_team = team.id AND team.fk_competition = comp.id;

-- 20-Sep-2025 : League Season/ Multi-course Tournament Finalization
CREATE TABLE gs_league_season_ocb (
    id               int(10) NOT NULL AUTO_INCREMENT,
    fk_league_season int(10) NOT NULL,
    fk_stream        int(10),
    team_ocb         char(1) DEFAULT 'N' NOT NULL,
    score_type       char(1) DEFAULT 'A' NOT NULL,
    sequence         smallint(6) NOT NULL,
    ocb_type         varchar(30),
    ocb_parameters   mediumtext,
    CONSTRAINT gs_league_ocb
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;
ALTER TABLE gs_league_season_ocb ADD CONSTRAINT fk_league_season_ocb_ref_league_season FOREIGN KEY (fk_league_season) REFERENCES gs_league_season (id);
ALTER TABLE gs_league_season_ocb ADD CONSTRAINT fk_league_season_ocb_ref_stream FOREIGN KEY (fk_stream) REFERENCES gs_competition_stream (id) ON UPDATE Cascade ON DELETE Restrict;

CREATE TABLE gs_league_season_sponsor (
    id                   bigint(20) NOT NULL AUTO_INCREMENT,
    fk_league_season     int(10) NOT NULL,
    sponsorship          mediumtext,
    sponsorship_image    mediumtext,
    display_position     varchar(30),
    start_date           date,
    end_date             date,
    priority             smallint(6) DEFAULT 1 NOT NULL,
    display_sequence     smallint(6),
    active               char(1) DEFAULT 'N' NOT NULL,
    fk_organizer_sponsor bigint(20),
    sponsor_name         varchar(100) NOT NULL,
    website_url          varchar(1024),
    click_count          int(10) DEFAULT 0 NOT NULL,
    CONSTRAINT pk_league_season_sponsor
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;
ALTER TABLE gs_league_season_sponsor ADD CONSTRAINT fk_league_season_sponsor_ref_season FOREIGN KEY (fk_league_season) REFERENCES gs_league_season (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_league_season_sponsor ADD CONSTRAINT fk_league_season_sponsor_ref_sponsor FOREIGN KEY (fk_organizer_sponsor) REFERENCES gs_sponsor (id) ON UPDATE Cascade ON DELETE Set null;

CREATE TABLE gs_league_season_team_totals (
    id                         bigint(20) NOT NULL AUTO_INCREMENT,
    fk_league_season_team      int(10) NOT NULL,
    total_gross                int(10) DEFAULT 0 NOT NULL,
    total_net                  int(10) NOT NULL,
    total_stableford_points    int(10) NOT NULL,
    total_prize_money          decimal(19, 2) DEFAULT 0.0 NOT NULL,
    total_positional_points    decimal(19, 2) DEFAULT 0.0,
    gross_position             smallint(6) NOT NULL,
    net_position               smallint(6) NOT NULL,
    stableford_points_position smallint(6) NOT NULL,
    gross_ocb                  mediumtext,
    net_ocb                    mediumtext,
    points_ocb                 mediumtext,
    CONSTRAINT pk_league_season_team_totals
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;
ALTER TABLE gs_league_season_team_totals ADD CONSTRAINT fk_league_season_team_tot_ref_team FOREIGN KEY (fk_league_season_team) REFERENCES gs_league_season_team (id) ON UPDATE Cascade ON DELETE Cascade;

-- Competition Team
alter table gs_competition_team modify column on_count_back char(1) default 'N';
alter table gs_competition_team modify column on_count_back_stat varchar(1024);
alter table gs_competition_team modify column on_count_back_gross char(1) default 'N';
alter table gs_competition_team modify column on_count_back_gross_stat varchar(1024);

alter table gs_competition_team add column team_position_points int(10);
alter table gs_competition_team add column on_count_back_points char(1) default 'N' NOT NULL;
alter table gs_competition_team add column on_count_back_points_stat varchar(1024);

-- League Player Totals
alter table gs_league_player_totals add column gross_ocb varchar(1024);
alter table gs_league_player_totals add column net_ocb varchar(1024);
alter table gs_league_player_totals add column points_ocb varchar(1024);



-- 23-Sep-2025: Additional Fields in Player Round & Competition Players for position and OCB
alter table gs_player_round add column player_position_net int;
alter table gs_player_round add column on_count_back_net char(1) DEFAULT 'N';
alter table gs_player_round add column on_count_back_net_stat varchar(1024);


alter table gs_competition_player add column player_position_net int;
alter table gs_competition_player add column on_count_back_net char(1) DEFAULT 'N';
alter table gs_competition_player add column on_count_back_net_stat varchar(1024);
alter table gs_competition_player add column player_position_points int;
alter table gs_competition_player add column on_count_back_points char(1) DEFAULT 'N';
alter table gs_competition_player add column on_count_back_points_stat varchar(1024);

-- 23-Sep-2025: Team Category Changes
CREATE TABLE gs_team_category (
    id               int(10) NOT NULL AUTO_INCREMENT,
    name             varchar(100) NOT NULL,
    main_score_type  char(1) DEFAULT 'G',
    max_size         smallint(6) DEFAULT 0,
    best_of          smallint(6),
    fk_league_season int(10),
    fk_competition   bigint(20),
    CONSTRAINT gs_team_category
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;
ALTER TABLE gs_team_category ADD CONSTRAINT fk_team_category_ref_competition FOREIGN KEY (fk_competition) REFERENCES gs_competition (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_team_category ADD CONSTRAINT fk_team_category_ref_league_season FOREIGN KEY (fk_league_season) REFERENCES gs_league_season (id) ON UPDATE Cascade ON DELETE Cascade;

ALTER TABLE gs_team_player add column fk_team_category int(10);
ALTER TABLE gs_team_player ADD CONSTRAINT fk_team_category FOREIGN KEY (fk_team_category) REFERENCES gs_team_category (id) ON UPDATE Cascade ON DELETE Set null;

ALTER TABLE gs_league_season_team_player add column fk_team_category int(10);
ALTER TABLE gs_league_season_team_player ADD CONSTRAINT fk_team_player_ref_team_category FOREIGN KEY (fk_team_category) REFERENCES gs_team_category (id) ON UPDATE Cascade ON DELETE Set null;


create or replace view gv_competition_player_session AS
    select comp.id competition_id,  cp.id competition_player, cp.fk_player, gr.id round_id, gr.round_no,
           rs.id round_session,
           rs.session_date, rs.start_time,
           tp.is_captain, tp.fk_team_category, team.id team_id, team.team_name
    FROM gs_competition_player cp
             JOIN gs_competition comp ON cp.fk_competition = comp.id
             LEFT JOIN gs_game_round gr ON gr.fk_competition = comp.id AND round_no = 1
             LEFT JOIN gs_player_session ps ON cp.id = ps.fk_competition_player
             LEFT JOIN gs_round_session rs ON ps.fk_round_session = rs.id
             LEFT JOIN gs_team_player tp ON cp.id = tp.fk_competition_player
             LEFT JOIN gs_competition_team team ON tp.fk_competition_team = team.id AND team.fk_competition = comp.id;

-- 22-Sep-2022: Competition Player Flight View
create or replace view gv_competition_player_flight AS
    select comp.id competition_id,
           gr.id round_id, gr.round_no,
           cp.id competition_player_id, cp.fk_player player_id,
           pr.id player_round_id, ifnull(pr.score_net, 0) total_net, ifnull(pr.score_gross, 0) total_gross, ifnull(pr.total_points, 0) total_points,
           pr.starting_hole, pr.start_time, pr.flight_no, pr.flight_sequence,
           cp.fk_stream stream_id, cp.fk_competition_category category_id, cp.fk_player_group group_id,
           rs.id round_session_id, rs.session_date, rs.start_time session_time,
           team.id team_id, team.team_name,
           tp.is_captain, tp.fk_team_category
    FROM  gs_competition_player cp
              JOIN gs_competition comp ON cp.fk_competition = comp.id
              JOIN gs_game_round gr ON gr.fk_competition = comp.id
              LEFT JOIN gs_player_round pr ON cp.fk_player = pr.fk_player AND pr.fk_game_round = gr.id
              LEFT OUTER JOIN gs_player_session ps ON ps.fk_competition_player = cp.id
              LEFT OUTER JOIN gs_round_session rs ON ps.fk_round_session = rs.id AND rs.fk_game_round = gr.id
              LEFT OUTER JOIN gs_team_player tp ON cp.id = tp.fk_competition_player
              LEFT OUTER JOIN gs_competition_team team ON tp.fk_competition_team = team.id AND team.fk_competition = comp.id;

-- 24-Sep-2025
alter table gs_competition_team add column league_season_team_id int;

alter table gs_competition_team_round add column fk_team_category int(10);
alter table gs_competition_team_round add column total_stableford_points decimal(10, 2) default 0.0;
alter table gs_competition_team_round add column total_points_awarded decimal(10, 2) default 0.0;
alter table gs_competition_team_round add column points_awarded_based_on char(1) default 'G' NOT NULL;
alter table gs_competition_team_round add column gross_position smallint;
alter table gs_competition_team_round add column gross_ocb char(1) default 'N' NOT NULL;
alter table gs_competition_team_round add column gross_ocb_details mediumtext;
alter table gs_competition_team_round add column net_position smallint;
alter table gs_competition_team_round add column net_ocb char(1) default 'N' NOT NULL;
alter table gs_competition_team_round add column net_ocb_details mediumtext;
alter table gs_competition_team_round add column stableford_point_position smallint;
alter table gs_competition_team_round add column stableford_point_ocb char(1) default 'N' NOT NULL;
alter table gs_competition_team_round add column stableford_point_ocb_details mediumtext;
ALTER TABLE gs_competition_team_round ADD CONSTRAINT fk_team_round_tot_ref_team_catg FOREIGN KEY (fk_team_category) REFERENCES gs_team_category (id) ON UPDATE Cascade ON DELETE Cascade;


CREATE TABLE gs_competition_team_total (
    id                           int(10) NOT NULL AUTO_INCREMENT,
    fk_competition_team          bigint(20) NOT NULL,
    fk_team_category             int(10),
    total_gross                  int(10) DEFAULT 0,
    total_net                    int(10) DEFAULT 0,
    total_stableford_points      decimal(10, 2),
    total_points_awarded         decimal(10, 2) DEFAULT 0,
    points_awarded_based_on      char(1) DEFAULT 'G',
    gross_position               smallint(6),
    gross_ocb                    char(1) DEFAULT 'N' NOT NULL,
    gross_ocb_details            mediumtext,
    net_position                 smallint(6),
    net_ocb                      char(1) DEFAULT 'N' NOT NULL,
    net_ocb_details              mediumtext,
    stableford_point_position    smallint(6),
    stableford_point_ocb         char(1) DEFAULT 'N' NOT NULL,
    stableford_point_ocb_details mediumtext,
    CONSTRAINT pk_competition_team_total
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;
ALTER TABLE gs_competition_team_total ADD CONSTRAINT fk_comp_team_total_ref_comp_team FOREIGN KEY (fk_competition_team) REFERENCES gs_competition_team (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_competition_team_total ADD CONSTRAINT fk_comp_team_total_ref_team_catg FOREIGN KEY (fk_team_category) REFERENCES gs_team_category (id) ON UPDATE Cascade ON DELETE Cascade;

ALTER TABLE gs_competition_team add column fk_stream int(10);
ALTER TABLE gs_competition_team ADD CONSTRAINT fk_comp_team_ref_stream FOREIGN KEY (fk_stream) REFERENCES gs_competition_stream (id) ON UPDATE Cascade ON DELETE SET NULL ;

-- 26-Sep-2025
CREATE TABLE gs_competition_tie_breaker (
    id             int(10) NOT NULL AUTO_INCREMENT,
    fk_competition bigint(20) NOT NULL,
    round_no       smallint(6),
    fk_stream      int(10),
    team_ocb       char(1) DEFAULT 'N' NOT NULL,
    score_type     char(1) DEFAULT 'A' NOT NULL,
    sequence       smallint(6) NOT NULL,
    ocb_type       varchar(30),
    ocb_parameters mediumtext,
    CONSTRAINT pk_competition_tie_breaker
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;
ALTER TABLE gs_competition_tie_breaker ADD CONSTRAINT fk_comp_tie_breaker_ref_comp FOREIGN KEY (fk_competition) REFERENCES gs_competition (id) ON UPDATE Cascade;
ALTER TABLE gs_competition_tie_breaker ADD CONSTRAINT fK_comp_tie_breaker_ref_stream FOREIGN KEY (fk_stream) REFERENCES gs_competition_stream (id) ON UPDATE Cascade ON DELETE Cascade;

-- 3-Oct-2025
ALTER TABLE gs_competition_prize add column fk_competition_category bigint(20);
ALTER TABLE gs_competition_prize ADD CONSTRAINT fk_prize_comp_catg FOREIGN KEY (fk_competition_category) REFERENCES gs_competition_category (id) ON UPDATE Cascade ON DELETE Cascade;

-- 4-Oct-2025
ALTER TABLE gs_competition_prize add column fk_stream int;
ALTER TABLE gs_competition_prize ADD CONSTRAINT fk_comp_prize_ref_stream FOREIGN KEY (fk_stream) REFERENCES gs_competition_stream (id) ON UPDATE Cascade ON DELETE Cascade;

-- 5-Oct-2025
CREATE TABLE gs_league_season_tie_breaker (
    id               int(10) NOT NULL AUTO_INCREMENT,
    fk_league_season int(10) NOT NULL,
    fk_stream        int(10),
    team_ocb         char(1) DEFAULT 'N' NOT NULL,
    score_type       char(1) DEFAULT 'A' NOT NULL,
    sequence         smallint(6) NOT NULL,
    ocb_type         varchar(30),
    ocb_parameters   mediumtext,
    CONSTRAINT pk_league_season_tie_breaker
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;
ALTER TABLE gs_league_season_tie_breaker ADD CONSTRAINT fk_tie_breaker_ref_league_season FOREIGN KEY (fk_league_season) REFERENCES gs_league_season (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_league_season_tie_breaker ADD CONSTRAINT fk_tie_breaker_ref_stream FOREIGN KEY (fk_stream) REFERENCES gs_competition_stream (id) ON UPDATE Cascade ON DELETE Cascade;

-- 6-Oct-2025
alter table gs_league_season_team_totals add column fk_team_category int;
ALTER TABLE gs_league_season_team_totals ADD CONSTRAINT fk_leagie_season_total_ref_team_category FOREIGN KEY (fk_team_category) REFERENCES gs_team_category (id) ON UPDATE Cascade ON DELETE Cascade;

alter table gs_league_season_team_totals add column positional_point_position smallint;
alter table gs_league_season_team_totals add column positional_points_ocb mediumtext;

-- 7-Oct-2025
ALTER TABLE gs_league_player_totals add column positional_ocb mediumtext;

-- 9-Oct-2025
create or replace view gv_league_player_totals AS
    select concat('',lpt.id, '-', lpct.id) player_total_id, lpt.fk_league_season, lpt.id league_player_totals,
           lr.fk_competition_stream stream_id, lr.fk_competition_player_category,
           lr.fk_player_group,
           p.id player_id, p.player_name,
           lpct.id league_competition_player_totals,
           lsc.competition_sequence,
           c.id competition_id, c.tournament_name,
           lpt.gross_position, lpt.net_position, lpt.stableford_points_position, lpt.positional_position, lpt.prize_money_position,
           lpt.total_gross, lpt.total_net, lpt.total_stableford_points, lpt.total_positional_points, lpt.total_prize_money,
           st.name stream_name, lstp.fk_league_season_team
    FROM gs_league_player_totals lpt
             JOIN gs_league_roster lr ON lr.fk_player = lpt.fk_player AND lr.fk_league_season = lpt.fk_league_season

             JOIN gs_player p ON p.id = lpt.fk_player
             JOIN gs_league_competition_player_totals lpct
                  ON lpct.fk_player = lpt.fk_player AND lpct.fk_league_season = lpt.fk_league_season
             JOIN gs_competition c ON c.id = lpct.fk_competition
             JOIN gs_league_season_competition lsc ON lsc.fk_competition = c.id AND lsc.fk_league_season = lpt.fk_league_season
             LEFT JOIN gs_competition_stream st ON st.id = lr.fk_competition_stream
             LEFT JOIN gs_league_season_team_player lstp ON lstp.fk_league_roster = lr.id;

-- 10-Oct-2025
alter table gs_competition_team_round add column positional_point_position smallint;
alter table gs_competition_team_round add column positional_point_ocb char(1) default 'N';
alter table gs_competition_team_round add column positional_point_ocb_details mediumtext;

alter table gs_competition_team_total add column positional_point_position smallint;
alter table gs_competition_team_total add column positional_point_ocb char(1) default 'N';
alter table gs_competition_team_total add column positional_point_ocb_details mediumtext;

-- 11-OCT-2025
alter table gs_league_season_tie_breaker add column round_numbers varchar(100);
alter table gs_competition_tie_breaker add column round_numbers varchar(100);

-- 13-OCT-2025
alter table gs_competition_tie_breaker add column score_to_use char(1);
alter table gs_league_season_tie_breaker add column score_to_use char(1);

-- 15-OCT-2025
alter table gs_league_roster add column tag_number varchar(30);
alter table gs_league_roster add column locker_number varchar(30);
alter table gs_league_season_guest add column tag_number varchar(30);
alter table gs_league_season_guest add column locker_number varchar(30);
alter table gs_competition_player add column tag_number varchar(30);
alter table gs_competition_player add column locker_number varchar(30);
