-- Player APP Visit
CREATE TABLE gs_player_app_visit (
    fk_player      bigint(20) NOT NULL,
    app_version    varchar(10) NOT NULL,
    first_visit_at datetime NOT NULL,
    CONSTRAINT pk_player_app_visit
        PRIMARY KEY (fk_player,
                     app_version)) ENGINE=InnoDB CHARACTER SET UTF8;
ALTER TABLE gs_player_app_visit ADD CONSTRAINT fk_player_app_visit_ref_player FOREIGN KEY (fk_player) REFERENCES gs_player (id) ON UPDATE Cascade ON DELETE Cascade;