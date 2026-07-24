-- 11-Jan-2026: Competition Team Round for Scramble Match
ALTER TABLE gs_competition_team ADD COLUMN handicap smallint;
ALTER TABLE gs_competition_team_round ADD COLUMN handicap smallint;
ALTER TABLE gs_competition_team_round ADD COLUMN status char(1) default 'C' NOT NULL CHECK ( status in ('I', 'W','C') );

CREATE TABLE gs_competition_team_round_score (
    id                   bigint(20) NOT NULL AUTO_INCREMENT,
    round_no             smallint(6) NOT NULL,
    fk_competition_team  bigint(20) NOT NULL,
    fk_competition_match int(10),
    fk_team_category     int(10),
    which_nine           smallint(6),
    course_hole_no       smallint(6) NOT NULL,
    game_hole_no         smallint(6) NOT NULL,
    hole_par             smallint(6) NOT NULL,
    hole_index           smallint(6) NOT NULL,
    gross_score          smallint(6),
    net_score            smallint(6),
    points               smallint(6),
    tee_shot_player_id   int(10),
    CONSTRAINT pk_competition_team_round_score
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;
ALTER TABLE gs_competition_team_round_score ADD CONSTRAINT fk_comp_team_round_score_ref_catg FOREIGN KEY (fk_team_category) REFERENCES gs_team_category (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_competition_team_round_score ADD CONSTRAINT fK_comp_team_round_score_ref_match FOREIGN KEY (fk_competition_match) REFERENCES gs_competition_match (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_competition_team_round_score ADD CONSTRAINT fk_comp_team_round_score_ref_team FOREIGN KEY (fk_competition_team) REFERENCES gs_competition_team (id) ON UPDATE Cascade ON DELETE Cascade;
