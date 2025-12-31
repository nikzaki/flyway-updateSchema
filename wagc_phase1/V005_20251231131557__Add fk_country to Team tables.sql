ALTER TABLE gs_competition_team ADD COLUMN fk_country varchar(10);
ALTER TABLE gs_competition_team ADD CONSTRAINT fk_comp_team_ref_country
    FOREIGN KEY (fk_country) REFERENCES gs_country (id) ON UPDATE Cascade;

ALTER TABLE gs_league_season_team ADD COLUMN fk_country varchar(10);
ALTER TABLE gs_league_season_team ADD CONSTRAINT fk_league_season_team_ref_country
    FOREIGN KEY (fk_country) REFERENCES gs_country (id) ON UPDATE Cascade ON DELETE Set null;
