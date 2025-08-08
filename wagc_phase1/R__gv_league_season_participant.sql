
-- 29-Jul-2025
create or replace view gv_league_season_participant as
    select lr.id,
           lr.fk_player,
           lr.fk_league_season,
           fk_player_group,
           fk_competition_stream,
           lr.fk_competition_player_category,
           'player' as participation_type,
           ai.additional_info,
           ai.created_at,
           ai.last_updated_at,
           ai.created_by,
           auth_create.name created_by_name,
           ai.last_updated_by,
           auth_update.name updated_by_name
    FROM gs_league_roster lr
             LEFT JOIN gs_competition_player_addl_info ai
                       ON ai.fk_league_season = lr.fk_league_season AND ai.fk_player = lr.fk_player
             LEFT JOIN gs_authentication auth_create
                       ON ai.created_by = auth_create.id
             LEFT JOIN gs_authentication auth_update
                       ON ai.last_updated_by = auth_update.id
    UNION
    SELECT sg.id,
           sg.fk_player,
           sg.fk_league_season,
           fk_player_group,
           null    as fk_competition_stream,
           null    as fk_competition_player_category,
           'guest' as participation_type,
           additional_info,
           ai.created_at,
           ai.last_updated_at,
           ai.created_by,
           auth_create.name created_by_name,
           ai.last_updated_by,
           auth_update.name updated_by_name
    FROM gs_league_season_guest sg
             LEFT JOIN gs_competition_player_addl_info ai
                       ON ai.fk_league_season = sg.fk_league_season AND ai.fk_player = sg.fk_player
             LEFT JOIN gs_authentication auth_create
                       ON ai.created_by = auth_create.id
             LEFT JOIN gs_authentication auth_update
                       ON ai.last_updated_by = auth_update.id;
