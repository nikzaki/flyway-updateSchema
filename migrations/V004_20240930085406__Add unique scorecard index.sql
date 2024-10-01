-- 22-Nov-2023: Unique Scorecard Index
delete sc1 FROM gs_scorecard sc1
                    INNER JOIN gs_scorecard sc2
WHERE sc1.id < sc2.id
  AND sc1.fk_player_round = sc2.fk_player_round AND sc1.fk_game_course = sc2.fk_game_course AND sc1.fk_course_hole = sc2.fk_course_hole;
CREATE UNIQUE INDEX IDX_gs_scorecard
    ON gs_scorecard (fk_player_round, fk_game_course, fk_course_hole);