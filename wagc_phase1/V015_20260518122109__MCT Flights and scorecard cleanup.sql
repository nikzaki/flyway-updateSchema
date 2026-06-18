CREATE TABLE gs_league_season_flight (  
    id                    bigint(20) NOT NULL AUTO_INCREMENT,  
    fk_league_season      int(10) NOT NULL,  
    fk_league_season_comp bigint(20) NOT NULL,  
    player_set_name       varchar(255),  
    day_no                smallint(6),  
    flight_no             varchar(30),  
    start_hole            smallint(6),  
    start_time            time,  
    flight_members        mediumtext,  
    CONSTRAINT pk_league_season_flight  
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;  
ALTER TABLE gs_league_season_flight ADD CONSTRAINT fk_mct_flight_ref_lsc FOREIGN KEY (fk_league_season_comp) REFERENCES gs_league_season_competition (id) ON UPDATE Cascade ON DELETE Cascade;  
ALTER TABLE gs_league_season_flight ADD CONSTRAINT fk_mct_flight_ref_mct FOREIGN KEY (fk_league_season) REFERENCES gs_league_season (id) ON UPDATE Cascade ON DELETE Cascade;  
  
CREATE TEMPORARY TABLE IF NOT EXISTS duplicate_round_ids AS (  
    SELECT id  
    FROM gs_player_round  
    WHERE id NOT IN (  
        SELECT MIN(id)  
        FROM gs_player_round  
        GROUP BY fk_game_round, fk_player  
    )  
);  
DELETE FROM gs_scorecard WHERE fk_player_round IN (SELECT id FROM duplicate_round_ids);  
  
DELETE FROM gs_player_round  
WHERE id IN (SELECT id FROM duplicate_round_ids);  
  
-- Clean up  
DROP TEMPORARY TABLE duplicate_round_ids;  
  
-- Create the unique index  
-- ALTER TABLE gs_player_round ADD UNIQUE INDEX UNQ_PLAYER_ROUND (fk_game_round, fk_player);  
  
-- Re-Create scorecard relation with player round and make it cascade  
alter table gs_scorecard  
    drop foreign key fk_gs_scorecard_player_round;  
  
SET foreign_key_checks = 0;  
  
alter table gs_scorecard  
    add constraint fk_gs_scorecard_player_round  
        foreign key (fk_player_round) references gs_player_round (id)  
            on update cascade on delete cascade;  
SET foreign_key_checks = 1;  
  
DELETE FROM gs_scorecard  
WHERE fk_player_round NOT IN (SELECT id FROM gs_player_round);  
  
-- Session Status  
ALTER TABLE gs_round_session ADD COLUMN session_status char(1) DEFAULT 'P' CHECK ( session_status IN ('P', 'I', 'C'));  
-- Update the existing session records  
  
UPDATE gs_round_session rs SET session_status = 'C'  
WHERE EXISTS (SELECT 'X' FROM gs_game_round gr WHERE gr.id = rs.fk_game_round AND gr.status = 'C');  
  
UPDATE gs_round_session rs SET session_status = 'I'  
WHERE EXISTS (SELECT 'X' FROM gs_game_round gr WHERE gr.id = rs.fk_game_round AND gr.status = 'I');