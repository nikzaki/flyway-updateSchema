-- #The OCB Details in player round and competition player needed to expanded. I have done this in Production because it wasn’t allowing finalization. Please make sure that, these are executed in other databases

--  

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