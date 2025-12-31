-- Team round and team total fields required
ALTER TABLE gs_competition_team_round add column gross_members_considered smallint;
ALTER TABLE gs_competition_team_round add column net_members_considered smallint;
ALTER TABLE gs_competition_team_round add column point_members_considered smallint;
ALTER TABLE gs_competition_team_round add column positional_members_considered smallint;

ALTER TABLE gs_competition_team_round add column gross_full_filled char(1) DEFAULT 'Y';
ALTER TABLE gs_competition_team_round add column net_full_filled char(1) DEFAULT 'Y';
ALTER TABLE gs_competition_team_round add column point_full_filled char(1) DEFAULT 'Y';
ALTER TABLE gs_competition_team_round add column positional_full_filled char(1) DEFAULT 'Y';


ALTER TABLE gs_competition_team_total add column gross_full_filled char(1) DEFAULT 'Y';
ALTER TABLE gs_competition_team_total add column net_full_filled char(1) DEFAULT 'Y';
ALTER TABLE gs_competition_team_total add column point_full_filled char(1) DEFAULT 'Y';
ALTER TABLE gs_competition_team_total add column positional_full_filled char(1) DEFAULT 'Y';

-- 22-Dec-2025
ALTER TABLE gs_competition add column fk_player_form int(10);
ALTER TABLE gs_competition ADD CONSTRAINT fk_comp_player_ref_dynaform FOREIGN KEY (fk_player_form) REFERENCES gs_dynamic_form (id) ON UPDATE Cascade ON DELETE Restrict;