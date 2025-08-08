-- 1-Aug-2025
ALTER table gs_competition_player_addl_info add column created_at datetime default current_timestamp;
ALTER table gs_competition_player_addl_info add column last_updated_at datetime default current_timestamp on update current_timestamp;
ALTER TABLE gs_competition_player_addl_info add column created_by int;
ALTER TABLE gs_competition_player_addl_info add column last_updated_by int;


-- 7-Aug-2025
alter table gs_competition_player_category
    modify from_handicap DECIMAL(5, 1) null;
alter table gs_competition_player_category
    modify to_handicap DECIMAL(5, 1) null;

ALTER TABLE gs_league_season add column  team_event_rules mediumtext;
ALTER TABLE gs_competition_stream add column team_event char(1) default 'N' NOT NULL;
ALTER TABLE gs_competition_stream add column  team_event_rules mediumtext;


CREATE TABLE gs_league_season_team (
    id               int(10) NOT NULL AUTO_INCREMENT,
    fk_league_season int(10) NOT NULL,
    team_name        varchar(100) NOT NULL,
    team_short_name  varchar(10),
    team_logo        varchar(1024),
    team_color       varchar(10),
    fk_stream        int(10),
    CONSTRAINT pk_league_season_team
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;

CREATE TABLE gs_league_season_team_player (
    id                    int(10) NOT NULL AUTO_INCREMENT,
    fk_league_season_team int(10) NOT NULL,
    fk_league_roster      bigint(20) NOT NULL,
    captain               char(1) DEFAULT 'N' NOT NULL,
    CONSTRAINT pk_league_season_team_player
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;
ALTER TABLE gs_league_season_team_player ADD CONSTRAINT fk_league_season_team_player_ref_roster FOREIGN KEY (fk_league_roster) REFERENCES gs_league_roster (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_league_season_team_player ADD CONSTRAINT fk_league_season_team_player_ref_team FOREIGN KEY (fk_league_season_team) REFERENCES gs_league_season_team (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_league_season_team ADD CONSTRAINT fk_league_season_team_ref_season FOREIGN KEY (fk_league_season) REFERENCES gs_league_season (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_league_season_team ADD CONSTRAINT fk_league_season_team_ref_stream FOREIGN KEY (fk_stream) REFERENCES gs_competition_stream (id) ON UPDATE Cascade ON DELETE Cascade;
