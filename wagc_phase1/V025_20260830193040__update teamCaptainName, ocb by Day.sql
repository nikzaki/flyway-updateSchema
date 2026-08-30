
-- 6-Aug-2026
ALTER TABLE gs_league_season_ocb ADD COLUMN day_no smallint default 0;

-- Daily totals
CREATE TABLE gs_league_season_player_day_total (
    fk_league_roster          bigint(20) NOT NULL,
    day_no                    smallint(6) NOT NULL,
    handicap                  smallint(6),
    play_date                 date,
    competition_id            int(10),
    gross_total               smallint(6),
    net_total                 smallint(6),
    stableford_point_total    smallint(6),
    gross_position            smallint(6),
    net_position              smallint(6),
    stableford_point_position smallint(6),
    gross_ocb                 varchar(1024),
    net_ocb                   varchar(1024),
    stableford_point_ocb      varchar(1024),
    CONSTRAINT pk_league_season_player_day_total
        PRIMARY KEY (fk_league_roster,
                     day_no)) ENGINE=InnoDB CHARACTER SET UTF8;
ALTER TABLE gs_league_season_player_day_total ADD CONSTRAINT fk_league_season_plr_day_totals_ref_roster FOREIGN KEY (fk_league_roster) REFERENCES gs_league_roster (id) ON UPDATE Cascade ON DELETE Cascade;


CREATE TABLE gs_league_season_team_day_total (
    id                         int(10) NOT NULL AUTO_INCREMENT,
    fk_league_season_team      int(10) NOT NULL,
    day_no                     smallint(6) NOT NULL,
    playing_date               date,
    stream_id                  int(10),
    team_category_id           int(10),
    gross_best_of              smallint(6),
    net_best_of                smallint(6),
    stableford_best_of         smallint(6),
    gross_best_full_filled      char(1) DEFAULT 'N' NOT NULL,
    net_best_full_filled        char(1) DEFAULT 'N' NOT NULL,
    stableford_best_full_filled char(1) DEFAULT 'N' NOT NULL,
    gross_total                smallint(6),
    net_total                  smallint(6),
    stableford_point_total     smallint(6),
    gross_position             smallint(6),
    net_position               smallint(6),
    stableford_point_position  smallint(6),
    gross_ocb                  varchar(1024),
    net_ocb                    varchar(1024),
    stableford_point_ocb       varchar(1024),
    idx_team_category_id       int(10) GENERATED ALWAYS AS (COALESCE(team_category_id, -1)) VIRTUAL,
    CONSTRAINT pk_league_season_team_day_total
        PRIMARY KEY (id),
    CONSTRAINT UNQ_league_season_day_total
        UNIQUE (fk_league_season_team, day_no, idx_team_category_id)) ENGINE=InnoDB CHARACTER SET UTF8;
ALTER TABLE gs_league_season_team_day_total ADD CONSTRAINT fk_league_season_day_total_ref_team FOREIGN KEY (fk_league_season_team) REFERENCES gs_league_season_team (id) ON UPDATE Cascade ON DELETE Cascade;


DROP TABLE IF EXISTS gs_league_season_team_day_total;
CREATE TABLE gs_league_season_team_day_total (
    id                          int(10) NOT NULL AUTO_INCREMENT,
    fk_league_season_team       int(10) NOT NULL,
    idx_team_category_id        int(10) GENERATED ALWAYS AS (COALESCE(team_category_id, -1)) VIRTUAL,
    day_no                      smallint(6) NOT NULL,
    playing_date                date,
    team_category_id            int(10),
    gross_best_of               smallint(6),
    net_best_of                 smallint(6),
    stableford_best_of          smallint(6),
    gross_best_full_filled      char(1) DEFAULT 'N' NOT NULL,
    net_best_full_filled        char(1) DEFAULT 'N' NOT NULL,
    stableford_best_full_filled char(1) DEFAULT 'N' NOT NULL,
    gross_total                 smallint(6),
    net_total                   smallint(6),
    stableford_point_total      smallint(6),
    gross_position              smallint(6),
    net_position                smallint(6),
    stableford_point_position   smallint(6),
    gross_ocb                   varchar(1024),
    net_ocb                     varchar(1024),
    stableford_point_ocb        varchar(1024),
    CONSTRAINT pk_league_season_team_day_total
        PRIMARY KEY (id),
    CONSTRAINT UNQ_league_season_day_total
        UNIQUE (fk_league_season_team, idx_team_category_id, day_no)) ENGINE=InnoDB CHARACTER SET UTF8;
ALTER TABLE gs_league_season_team_day_total ADD CONSTRAINT fk_league_season_day_total_ref_team FOREIGN KEY (fk_league_season_team) REFERENCES gs_league_season_team (id) ON UPDATE Cascade ON DELETE Cascade;

-- 21-Aug-2026
ALTER TABLE gs_competition_team ADD COLUMN idx_fk_stream int(10) GENERATED ALWAYS AS (COALESCE(fk_stream, -1)) VIRTUAL;
ALTER TABLE gs_competition_team ADD UNIQUE INDEX UIDX_COMPETITION_TEAM (fk_competition, idx_fk_stream, team_name);
ALTER TABLE gs_team_player ADD UNIQUE INDEX UIDX_TEAM_PLAYER (fk_competition_team, fk_competition_player);

-- 24-Aug-2026
ALTER TABLE gs_league_season_team ADD COLUMN team_captain_name varchar(255);