-- -- 25-Oct-2024 - Increase the size of OCB Result
-- alter table gs_player_round
--     modify on_count_back_stat varchar(1024) null;

-- alter table gs_player_round
--     modify on_count_back_gross_stat varchar(1024) null;

-- alter table gs_player_round
--     modify ct_count_back_stat varchar(1024) null;

-- alter table gs_player_round
--     modify ct_count_back_gross_stat varchar(1024) null;

-- alter table gs_competition_player
--     modify on_count_back_stat varchar(1024) null;

-- alter table gs_competition_player
--     modify on_count_back_gross_stat varchar(1024) null;

-- alter table gs_competition_player
--     modify ct_count_back_stat varchar(1024) null;

-- alter table gs_competition_player
--     modify ct_count_back_gross_stat varchar(1024) null;


-- -- 28-OCT-2024 DONE
-- -- alter table gs_game_round add column locked char(1) DEFAULT 'Y' NOT NULL;
-- -- alter table gs_game_round add column cut_off_rules mediumtext;
-- -- alter table gs_game_round add column flight_generation_rules mediumtext;
-- -- alter table gs_competition add column statistics mediumtext;
-- -- alter table gs_competition_player add column group_name varchar(255);

-- -- 8-Nov-2024
-- alter table gs_competition add column first_round_start_time time;
-- alter table gs_competition add column registration_open_time time;
-- alter table gs_competition add column registration_close_time time;

-- -- 18-Oct-204
-- alter table gs_league_player_totals add column prev_totals mediumtext;

-- -- 29-Nov-2024
-- alter table gs_handicap_calculation add index idx_hidx_calc_date(fk_player, fk_handicap_system, handicap_index_date);
-- alter table gs_handicap_round add index idx_hround_1(fk_handicap_calculation, fk_player_round);
-- alter table gs_player_handicap_index add index idx_pidx_1(fk_player, fk_handicap_system, handicap_index_date);

 