-- 11-Mar-2025

CREATE TABLE gs_competition_match_group (
    id            int(10) NOT NULL AUTO_INCREMENT,
    name          varchar(100) NOT NULL,
    description   mediumtext,
    gender        char(1) DEFAULT 'A',
    fk_game_round bigint(20) NOT NULL,
    CONSTRAINT pk_competition_match_group
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;
ALTER TABLE gs_competition_match_group ADD CONSTRAINT fk_match_group_ref_game_round FOREIGN KEY (fk_game_round) REFERENCES gs_game_round (id) ON UPDATE Cascade ON DELETE Cascade;

ALTER TABLE gs_competition_match add column fk_match_group int(10);
ALTER TABLE gs_competition_match ADD CONSTRAINT fk_comp_match_ref_match_group FOREIGN KEY (fk_match_group) REFERENCES gs_competition_match_group (id) ON UPDATE Cascade ON DELETE Set null;