-- 11-Jan-2026: View on Competition Team Round Score
CREATE OR REPLACE VIEW gv_competition_team_round_score
AS SELECT c.id tournament_id, c.tournament_name, ct.team_name, ct.team_logo, ct.team_color, ct.handicap team_handicap,
          tc.name as team_category_name, tc.main_score_type,
          cm.match_date, cm.start_time match_start_time,
          p.player_name tee_shot_player_name,
          ctrs.*
   FROM gs_competition_team_round_score ctrs
            JOIN gs_competition_team ct ON ct.id = ctrs.fk_competition_team
            LEFT JOIN gs_team_category tc ON tc.id = ctrs.fk_team_category
            LEFT JOIN gs_competition_match cm ON cm.id = ctrs.fk_competition_match
            LEFT JOIN gs_competition c ON c.id = ct.fk_competition
            LEFT JOIN gs_player p ON p.id = ctrs.tee_shot_player_id;