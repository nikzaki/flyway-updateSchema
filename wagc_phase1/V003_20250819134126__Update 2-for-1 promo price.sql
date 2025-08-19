-- Discount Changes
alter table gs_tee_time_discount add column applies_to_n_players smallint NOT NULL default 1;