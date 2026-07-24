
-- 3-Jul-2025: Dynamic Form
-- CREATE TABLE gs_dynamic_form (
--     id              int(10) NOT NULL AUTO_INCREMENT,
--     name            varchar(100) NOT NULL,
--     public_form     char(1) DEFAULT 'N' NOT NULL,
--     fk_club         bigint(20),
--     fk_partner      varchar(30),
--     description     varchar(1024),
--     form_definition mediumtext,
--     CONSTRAINT pk_dynamic_form
--         PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;
-- ALTER TABLE gs_dynamic_form ADD CONSTRAINT fk_dynaform_ref_club FOREIGN KEY (fk_club) REFERENCES gs_club (id) ON UPDATE Cascade ON DELETE Cascade;
-- ALTER TABLE gs_dynamic_form ADD CONSTRAINT fk_dynaform_ref_partner FOREIGN KEY (fk_partner) REFERENCES gs_discount_company (id) ON UPDATE Cascade ON DELETE Cascade;

-- League & Multi-Round Tournaments
ALTER TABLE gs_league add column nature_of_league varchar(30) NOT NULL default 'League';
ALTER TABLE gs_league_season add column nature_of_league varchar(30) NOT NULL default 'League';
ALTER TABLE gs_league_season add column fk_addl_info_form int (10);
ALTER TABLE gs_league_roster add column fk_handicap_group bigint;
ALTER TABLE gs_league_roster add column fk_player_group bigint;
ALTER TABLE gs_league_roster add column handicap smallint;

    CREATE TABLE gs_competition_player_group (
    id          bigint(20) NOT NULL AUTO_INCREMENT,
    name        varchar(100) NOT NULL,
    group_color varchar(30),
    image       varchar(1024),
    fk_league_season int(10) NOT NULL,
    fk_competition bigint(20),
    display_sequence smallint default 0,
    CONSTRAINT pk_competition_player_group
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;

CREATE TABLE gs_competition_handicap_group (
    id                 bigint(20) NOT NULL AUTO_INCREMENT,
    name               varchar(100) NOT NULL,
    from_handicap      smallint(6),
    to_handicap        smallint(6),
    gender             char(1),
    fk_player_category bigint(20),
    fk_league_season   int(10) NOT NULL,
    fk_player_group    bigint(20),
    for_grouping       char(1),
    display_sequence   int(11),
    from_age           smallint(6),
    to_age             smallint(6),
    CONSTRAINT gs_competition_handicap_group
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;


CREATE TABLE gs_competition_player_addl_info (
    id               bigint(20) NOT NULL AUTO_INCREMENT,
    fk_player        bigint(20),
    fk_competition   bigint(20),
    fk_league_season int(10),
    additional_info  longtext,
    CONSTRAINT pk_competition_player_addl_info
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;


ALTER TABLE gs_league_season ADD CONSTRAINT fk_league_season_ref_dyna_form FOREIGN KEY (fk_addl_info_form) REFERENCES gs_dynamic_form (id) ON UPDATE Cascade ON DELETE Set null;
ALTER TABLE gs_competition_handicap_group ADD CONSTRAINT fk_league_hcp_grp_ref_league_season FOREIGN KEY (fk_league_season) REFERENCES gs_league_season (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_competition_handicap_group ADD CONSTRAINT fk_league_hcp_grp_ref_plr_catg FOREIGN KEY (fk_player_category) REFERENCES gs_player_category (id) ON UPDATE Cascade ON DELETE Set null;
ALTER TABLE gs_competition_handicap_group ADD CONSTRAINT fk_league_hcp_grp_ref_plr_grp FOREIGN KEY (fk_player_group) REFERENCES gs_competition_player_group (id) ON UPDATE Cascade ON DELETE Set null;
ALTER TABLE gs_league_roster ADD CONSTRAINT fk_league_roster_ref_hcp_grp FOREIGN KEY (fk_handicap_group) REFERENCES gs_competition_handicap_group (id) ON UPDATE Cascade ON DELETE Set null;
ALTER TABLE gs_competition_player_addl_info ADD CONSTRAINT fk_comp_plr_info_ref_comp FOREIGN KEY (fk_competition) REFERENCES gs_competition (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_competition_player_addl_info ADD CONSTRAINT fk_comp_plr_info_ref_league_season FOREIGN KEY (fk_league_season) REFERENCES gs_league_season (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_competition_player_addl_info ADD CONSTRAINT fk_comp_plr_info_ref_plr FOREIGN KEY (fk_player) REFERENCES gs_player (id) ON UPDATE Cascade ON DELETE Set null;
ALTER TABLE gs_competition_player_group ADD CONSTRAINT fk_plr_grp_ref_league_season FOREIGN KEY (fk_league_season) REFERENCES gs_league_season (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_competition_player_group ADD CONSTRAINT fk_plr_grp_ref_comp FOREIGN KEY (fk_competition) REFERENCES gs_competition (id) ON UPDATE Cascade ON DELETE Cascade;

-- 10-Jul-2025
ALTER TABLE gs_league_roster add column handicap_index decimal(6,2);
ALTER TABLE gs_league_season add column fk_invitee_addl_form int(10);
CREATE TABLE gs_league_season_guest (
    id               bigint(20) NOT NULL AUTO_INCREMENT,
    fk_league_season int(10) NOT NULL,
    fk_player        bigint(20) NOT NULL,
    fk_player_group  bigint(20),
    CONSTRAINT pk_league_season_invitee
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;


ALTER TABLE gs_league_season_guest ADD CONSTRAINT fk_league_guest_ref_league_season FOREIGN KEY (fk_league_season) REFERENCES gs_league_season (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_league_season_guest ADD CONSTRAINT fk_league_guest_invitee_ref_player FOREIGN KEY (fk_player) REFERENCES gs_player (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_league_season_guest ADD CONSTRAINT fk_league_guest_ref_player_group FOREIGN KEY (fk_player_group) REFERENCES gs_competition_player_group (id) ON UPDATE Cascade ON DELETE Set null;

ALTER TABLE gs_league_season ADD CONSTRAINT fk_league_season_ref_invitee_form FOREIGN KEY (fk_invitee_addl_form) REFERENCES gs_dynamic_form (id) ON UPDATE Cascade ON DELETE Restrict;

-- 11-Jul-2025
ALTER TABLE gs_league_season add column logo varchar(255);
ALTER TABLE gs_league_season add column publish_on datetime;
ALTER TABLE gs_league_season add column allow_registration char(1) default 'Y';
ALTER TABLE gs_league_season add column allow_registration_for char(1) default 'O';
ALTER TABLE gs_league_season add column registration_starts_on datetime;
ALTER TABLE gs_league_season add column registration_ends_on datetime;
ALTER TABLE gs_league_season add column fk_invitee_set bigint;
ALTER TABLE gs_league_season add column description mediumtext;
ALTER TABLE gs_league_season add column terms_and_conditions mediumtext;

ALTER TABLE gs_league_season ADD CONSTRAINT fk_league_season_ref_invitee_set FOREIGN KEY (fk_invitee_set) REFERENCES gs_organizer_invitee_list_set (id) ON UPDATE Cascade ON DELETE Set null;

-- 14-Jul-2025
CREATE TABLE gs_competition_stream (
    id               int(10) NOT NULL AUTO_INCREMENT,
    name             varchar(100) NOT NULL,
    default_stream   char(1) NOT NULL DEFAULT 'N',
    fk_league_season int(10),
    description      mediumtext,
    fk_competition   bigint(20),
    CONSTRAINT pk_competition_player_type
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;
CREATE TABLE gs_league_competition_content (
    id               int(10) NOT NULL AUTO_INCREMENT,
    event_id         varchar(30) NOT NULL,
    event_title      varchar(255) NOT NULL,
    event_details    mediumtext,
    fk_league_season int(10),
    fk_competition   bigint(20),
    player_type      char(1) DEFAULT 'B',
    CONSTRAINT pk_league_competition_schedule
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;
ALTER TABLE gs_competition_stream ADD CONSTRAINT fk_comp_stream_ref_league_season FOREIGN KEY (fk_league_season) REFERENCES gs_league_season (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_competition_stream ADD CONSTRAINT fk_comp_stream_ref_comp FOREIGN KEY (fk_competition) REFERENCES gs_competition (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_league_competition_content ADD CONSTRAINT fk_comp_content_ref_comp FOREIGN KEY (fk_competition) REFERENCES gs_competition (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_league_competition_content ADD CONSTRAINT fk_comp_content_ref_league_season FOREIGN KEY (fk_league_season) REFERENCES gs_league_season (id) ON UPDATE Cascade ON DELETE Cascade;

ALTER TABLE gs_competition_handicap_group add column  fk_competition_stream int(10);
ALTER TABLE gs_competition_handicap_group ADD CONSTRAINT fk_league_hcp_group_ref_plr_type FOREIGN KEY (fk_competition_stream) REFERENCES gs_competition_stream (id) ON UPDATE Cascade ON DELETE Restrict;


-- 15-Jul-2025
ALTER TABLE gs_league_roster DROP FOREIGN KEY fk_league_roster_ref_hcp_grp;
rename table gs_competition_handicap_group to gs_competition_player_category;
alter table gs_league_roster
    change fk_handicap_group fk_competition_player_category bigint null;
ALTER TABLE gs_league_roster ADD CONSTRAINT fk_league_roster_ref_comp_catg FOREIGN KEY (fk_competition_player_category) REFERENCES gs_competition_player_category (id) ON UPDATE Cascade ON DELETE Set null;

ALTER TABLE gs_league_roster add column fk_competition_stream int(10);
ALTER TABLE gs_league_roster ADD CONSTRAINT fk_league_roster_ref_stream FOREIGN KEY (fk_competition_stream) REFERENCES gs_competition_stream (id) ON UPDATE Cascade ON DELETE Set null;

ALTER TABLE gs_competition_player_category add column fixed_category char(1) NOT NULL DEFAULT 'N';

-- 17-Jul-2025
ALTER TABLE gs_league_season add column  team_event char(1) default 'N' NOT NULL;
