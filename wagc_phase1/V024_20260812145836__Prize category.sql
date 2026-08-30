
CREATE TABLE gs_competition_prize_category (
    id               int(10) NOT NULL AUTO_INCREMENT,
    name             varchar(100) NOT NULL,
    description      mediumtext,
    dynamic_category char(1) DEFAULT 'N' NOT NULL,
    fk_stream        int(10),
    from_age         smallint(6),
    to_age           smallint(6),
    gender           char(1) DEFAULT 'A',
    fk_league_season int(10),
    fk_competition   bigint(20),
    CONSTRAINT pk_competition_prize_category
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;
ALTER TABLE gs_competition_prize_category ADD CONSTRAINT fk_prize_category_ref_competition FOREIGN KEY (fk_competition) REFERENCES gs_competition (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_competition_prize_category ADD CONSTRAINT fk_prize_category_ref_league_season FOREIGN KEY (fk_league_season) REFERENCES gs_league_season (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_competition_prize_category ADD CONSTRAINT fk_prize_category_ref_stream FOREIGN KEY (fk_stream) REFERENCES gs_competition_stream (id) ON UPDATE Cascade ON DELETE Cascade;

ALTER TABLE gs_league_season_prize add column fk_prize_category int;
ALTER TABLE gs_league_season_prize
    ADD COLUMN idx_fk_prize_category INT
        GENERATED ALWAYS AS (COALESCE(fk_prize_category, -1)) VIRTUAL;

SET FOREIGN_KEY_CHECKS = 0;

-- 1. Create a temporary index so the Foreign Key stays satisfied
CREATE INDEX idx_temp_fk_league_season
    ON gs_league_season_prize (fk_league_season);

-- 2. Drop the old unique index
ALTER TABLE gs_league_season_prize
    DROP INDEX uk_league_prize_composite;

-- 3. Add the new expanded unique index
-- (Fixing syntax: Use 'ADD UNIQUE INDEX' instead of 'ADD CONSTRAINT UNIQUE INDEX')
ALTER TABLE gs_league_season_prize
    ADD UNIQUE INDEX uk_league_prize_composite (
                                                fk_league_season,
                                                idx_fk_stream,
                                                idx_fk_competition_category,
                                                idx_fk_prize_category,
                                                novelty_prize,
                                                team_prize,
                                                score_type,
                                                day_no,
                                                prize_position
        );

-- 4. Drop the temporary index (the new composite index now covers fk_league_season)
ALTER TABLE gs_league_season_prize
    DROP INDEX idx_temp_fk_league_season;

SET FOREIGN_KEY_CHECKS = 1;

-- Sponsor
ALTER TABLE gs_league_season_sponsor MODIFY COLUMN display_position mediumtext;


