-- Teams Of Participating Clubs
ALTER TABLE gs_league_season_team ADD COLUMN fk_participating_club INT(10);
ALTER TABLE gs_league_season_team ADD CONSTRAINT fk_league_season_team_ref_part_club
    FOREIGN KEY (fk_participating_club) REFERENCES gs_league_season_participating_club (id) ON UPDATE Cascade ON DELETE Set null;

ALTER TABLE gs_league_roster ADD COLUMN day_wise_settings mediumtext;
ALTER TABLE gs_competition_player ADD COLUMN round_wise_settings mediumtext;