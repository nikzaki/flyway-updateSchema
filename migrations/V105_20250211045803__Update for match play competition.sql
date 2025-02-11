-- 8-Jan-2024 : Match Play And Team


ALTER TABLE gs_competition add column match_play char(1) DEFAULT 'N' NOT NULL;
ALTER TABLE gs_competition add column tournament_settings mediumtext;

-- 09-Jan-2025 : Fixing the existing Team and competition team tables
alter table gs_team modify column fk_club bigint null ;
alter table gs_team modify column team_logo varchar(1024);
alter table gs_team modify column fk_player_captain bigint null;
alter table gs_team add column fk_organizer bigint;

alter table gs_team_member add column id bigint;
alter table gs_team_member add column active char(1) NOT NULL DEFAULT 'Y';
set @rn = 0;
update gs_team_member set id = (@rn := @rn + 1) where id is null order by fk_team, fk_player;
alter table gs_team_member
    drop foreign key gs_player_gs_team_member_fk;

alter table gs_team_member
    drop foreign key gs_team_gs_team_member_fk;
alter table gs_team_member
    drop primary key;
alter table gs_team_member
    add primary key (id);

ALTER TABLE gs_team_member ADD CONSTRAINT gs_team_gs_team_member_fk FOREIGN KEY (fk_team) REFERENCES gs_team (id) ON UPDATE cascade ON DELETE cascade ;
ALTER TABLE gs_team_member ADD CONSTRAINT gs_player_gs_team_member_fk FOREIGN KEY (fk_player) REFERENCES gs_player (id) ON UPDATE cascade ON DELETE cascade ;
ALTER TABLE gs_team ADD CONSTRAINT fk_team_ref_org FOREIGN KEY (fk_organizer) REFERENCES gs_organizer (id) ON UPDATE Cascade ON DELETE Set null;

-- 10-Jan-2025: Competition Team And Match Play
ALTER TABLE gs_competition_team modify column fk_team bigint null;
ALTER TABLE gs_competition_team add column team_name varchar(100);
ALTER TABLE gs_competition_team add column team_logo varchar(1024);
ALTER TABLE gs_competition_team add column team_color varchar(10);
ALTER TABLE gs_competition_team add column team_short_name varchar(10);
ALTER TABLE gs_competition_team add column total_match_points decimal(10, 2);

ALTER TABLE gs_competition_team DROP FOREIGN KEY gs_team_gs_competition_team_fk;
ALTER TABLE gs_competition_team ADD CONSTRAINT gs_team_gs_competition_team_fk FOREIGN KEY (fk_team) REFERENCES gs_team (id) ON UPDATE Cascade ON DELETE SET NULL;


CREATE TABLE gs_competition_match (
    id             int(10) NOT NULL AUTO_INCREMENT,
    fk_competition bigint(20) NOT NULL,
    round_no       int(10) NOT NULL,
    match_date     date,
    start_time     time,
    start_hole_no  smallint(6),
    status         char(1) DEFAULT 'P' NOT NULL,
    match_settings mediumtext,
    CONSTRAINT gs_competition_match
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;
CREATE TABLE gs_competition_match_participant (
    id                    bigint(20) NOT NULL AUTO_INCREMENT,
    fk_competition_match  int(10) NOT NULL,
    fk_team_player bigint(20) NOT NULL,
    name                  varchar(100),
    captain               char(1) DEFAULT 'N' NOT NULL,
    actual_handicap       smallint(6),
    effective_handicap    int(10),
    CONSTRAINT pk_competition_match_participant
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;
CREATE TABLE gs_competition_match_score (
    id                        bigint(20) NOT NULL AUTO_INCREMENT,
    fk_competition_match      int(10) NOT NULL,
    fk_competition_match_team int(10) NOT NULL,
    team_name                 varchar(100),
    hole_no                   smallint(6),
    effective_gross           smallint(6),
    effective_net             smallint(6),
    result                    char(1) DEFAULT 'N' NOT NULL,
    match_play_point          decimal(5, 2),
    CONSTRAINT pk_competition_match_score
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;
CREATE TABLE gs_competition_match_team (
    id                      int(10) NOT NULL AUTO_INCREMENT,
    fk_competition_match    int(10) NOT NULL,
    team_name               varchar(100),
    effective_gross         smallint(6) DEFAULT 0,
    effective_net           smallint(6) DEFAULT 0,
    total_match_play_points decimal(5, 2) DEFAULT 0,
    result                  char(1) DEFAULT 'N' NOT NULL,
    match_point_awarded     decimal(5, 2) DEFAULT 0,
    fk_competition_team     bigint(20) NOT NULL,
    CONSTRAINT pk_competition_match_team
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;

CREATE TABLE gs_competition_team_round (
    id                      bigint(20) NOT NULL AUTO_INCREMENT,
    team_name               varchar(100),
    total_match_play_points decimal(10, 2) DEFAULT 0.0,
    total_gross             smallint(6),
    total_net               smallint(6),
    fk_competition_team     bigint(20) NOT NULL,
    round_no                smallint(6) NOT NULL,
    CONSTRAINT pk_competition_team_round
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;

ALTER TABLE gs_competition_match_participant ADD CONSTRAINT fk_comp_match_plr_ref_match FOREIGN KEY (fk_competition_match) REFERENCES gs_competition_match (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_competition_match ADD CONSTRAINT fk_comp_match_ref_comp FOREIGN KEY (fk_competition) REFERENCES gs_competition (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_competition_match_score ADD CONSTRAINT fk_comp_match_score_ref_match FOREIGN KEY (fk_competition_match) REFERENCES gs_competition_match (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_competition_match_score ADD CONSTRAINT fk_comp_match_score_ref_match_team FOREIGN KEY (fk_competition_match_team) REFERENCES gs_competition_match_team (id) ON UPDATE Cascade ON DELETE Restrict;
ALTER TABLE gs_competition_match_team ADD CONSTRAINT fk_comp_match_team_ref_comp_match FOREIGN KEY (fk_competition_match) REFERENCES gs_competition_match (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_competition_match_team ADD CONSTRAINT fk_comp_match_team_ref_comp_team FOREIGN KEY (fk_competition_team) REFERENCES gs_competition_team (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_competition_match_participant ADD CONSTRAINT fk_comp_match_plr_ref_team_plr FOREIGN KEY (fk_team_player) REFERENCES gs_team_player (id) ON UPDATE Cascade ON DELETE Restrict;

ALTER TABLE gs_competition_team_round ADD CONSTRAINT fk_comp_team_round_ref_comp_team FOREIGN KEY (fk_competition_team) REFERENCES gs_competition_team (id) ON UPDATE Cascade ON DELETE Cascade;

-- 30-Jan-2025
ALTER TABLE gs_competition_match_participant add column scorer char(1) NOT NULL DEFAULT 'N';
