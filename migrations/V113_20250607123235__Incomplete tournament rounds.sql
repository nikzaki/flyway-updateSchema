-- Incomplete Tournament Rounds
ALTER TABLE gs_competition_player add column incomplete char(1) DEFAULT 'N';
ALTER TABLE gs_competition_player add column ignored char(1) DEFAULT  'N';

ALTER TABLE gs_game_round add column incomplete_round char(1) DEFAULT 'N';
ALTER TABLE gs_game_round add column cancelled_round char(1) DEFAULT  'N';
ALTER TABLE gs_game_round add column incomplete_round_finalization mediumtext;
ALTER TABLE gs_game_round add column ignore_round char(1) DEFAULT  'N';

ALTER TABLE gs_player_round add column player_position_points smallint;
ALTER TABLE gs_player_round add column on_count_back_points char(1);
ALTER TABLE gs_player_round add column on_count_back_points_stat mediumtext;
ALTER TABLE gs_player_round add column incomplete_round char(1) default 'N';
ALTER TABLE gs_player_round add column player_position_gross_manual smallint;
ALTER TABLE gs_player_round add column player_position_net_manual smallint;
ALTER TABLE gs_player_round add column player_position_points_manual smallint;
ALTER TABLE gs_player_round add column ignored char(1) DEFAULT  'N';

ALTER TABLE gs_scorecard add column filled char(1) default 'N';
ALTER TABLE gs_scorecard add column filled_score smallint;
ALTER TABLE gs_scorecard add column ignored_in_finalization char(1) default 'N';