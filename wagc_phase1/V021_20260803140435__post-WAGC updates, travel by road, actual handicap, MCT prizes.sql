
-- 29-Jul-2026
ALTER TABLE gs_tournament_player_travel_info ADD COLUMN arrival_by_road char(1) default 'N' NOT NULL;
ALTER TABLE gs_tournament_player_travel_info ADD COLUMN departure_by_road char(1) default 'N' NOT NULL;

-- 31-Jul-2026
ALTER TABLE gs_competition_player ADD COLUMN actual_handicap INT(10);
ALTER TABLE gs_competition_player ADD COLUMN actual_handicap_index decimal(6,1);

DROP TABLE IF EXISTS  gs_league_season_prize;
CREATE TABLE gs_league_season_prize (
    id                      int(10) NOT NULL AUTO_INCREMENT,
    fk_league_season        int(10) NOT NULL,
    novelty_prize           char(1) DEFAULT 'N' NOT NULL,
    team_prize              char(1) DEFAULT 'N' NOT NULL,
    score_type              char(1) DEFAULT 'N',
    day_no                  smallint(6),
    fk_stream               int(10),
    fk_competition_category bigint(20),
    prize_name              varchar(100) NOT NULL,
    prize_position          smallint(6) NOT NULL,
    monetary_value          decimal(19, 2) DEFAULT 0.0 NOT NULL,
    description             mediumtext,
    fk_league_roster        bigint(20),
    fk_league_season_team    int(10),
    remarks                 mediumtext,
    CONSTRAINT pk_league_season_prize
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;
ALTER TABLE gs_league_season_prize ADD CONSTRAINT fk_league_season_prize_ref_category FOREIGN KEY (fk_competition_category) REFERENCES gs_competition_player_category (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_league_season_prize ADD CONSTRAINT fk_league_season_prize_ref_league_season FOREIGN KEY (fk_league_season) REFERENCES gs_league_season (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_league_season_prize ADD CONSTRAINT fk_league_season_prize_ref_roster FOREIGN KEY (fk_league_roster) REFERENCES gs_league_roster (id) ON UPDATE Cascade ON DELETE Restrict;
ALTER TABLE gs_league_season_prize ADD CONSTRAINT fk_league_season_prize_ref_stream FOREIGN KEY (fk_stream) REFERENCES gs_competition_stream (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_league_season_prize ADD CONSTRAINT fk_league_season_prize_ref_team FOREIGN KEY (fk_league_season_team) REFERENCES gs_league_season_team (id) ON UPDATE Cascade ON DELETE Restrict;
