-- 3-Aug-2026
ALTER TABLE gs_competition_player_category MODIFY display_sequence smallint(11) DEFAULT 0;
ALTER TABLE gs_competition_player_category ADD COLUMN fk_tee_box_men bigint;
ALTER TABLE gs_competition_player_category ADD COLUMN fk_tee_box_women bigint;
ALTER TABLE gs_competition_player_category ADD CONSTRAINT fk_comp_category_ref_tbox_men FOREIGN KEY (fk_tee_box_men) REFERENCES gs_tee_box (id) ON UPDATE Cascade ON DELETE Set null;
ALTER TABLE gs_competition_player_category ADD CONSTRAINT fk_comp_category_ref_tbox_women FOREIGN KEY (fk_tee_box_women) REFERENCES gs_tee_box (id) ON UPDATE Cascade ON DELETE Set null;

-- 4-Aug-2026

SET FOREIGN_KEY_CHECKS = 0;
ALTER TABLE gs_league_season_prize
    ADD COLUMN idx_fk_stream INT
        GENERATED ALWAYS AS (COALESCE(fk_stream, -1)) VIRTUAL ,
    ADD COLUMN idx_fk_competition_category BIGINT
        GENERATED ALWAYS AS (COALESCE(fk_competition_category, -1)) VIRTUAL;

SET FOREIGN_KEY_CHECKS = 1;
ALTER TABLE gs_league_season_prize ADD UNIQUE KEY uk_league_prize_composite
    ( fk_league_season, idx_fk_stream, idx_fk_competition_category, novelty_prize, team_prize, score_type, day_no, prize_position );
