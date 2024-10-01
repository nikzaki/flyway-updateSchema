## nik compiled



-- 12-Oct-2023 Partner Organizer
alter table gs_organizer add column fk_partner varchar(30);
ALTER TABLE gs_organizer ADD CONSTRAINT fk_organizer_ref_partner FOREIGN KEY (fk_partner) REFERENCES gs_discount_company (id) ON UPDATE Cascade ON DELETE Set null;


			  
																					  
																																								 
																																			 

-- 2-Nov-2023
alter table gs_player_round add column fk_buggy_assigned bigint;
ALTER TABLE gs_player_round ADD CONSTRAINT fk_player_round_ref_buggy FOREIGN KEY (fk_buggy_assigned) REFERENCES gs_club_buggy (id) ON UPDATE Cascade ON DELETE Restrict;
alter table gs_player_round add column fk_caddie_assigned bigint;
ALTER TABLE gs_club_caddy_assignment ADD CONSTRAINT fk_playerround_ref_caddie FOREIGN KEY (fk_player_round) REFERENCES gs_player_round (id) ON UPDATE Cascade ON DELETE Set null;

-- 9-Nov-2023 : Tournament Changes
ALTER TABLE gs_competition add column maintenance_by_club_allowed char(1) NOT NULL DEFAULT 'Y' CHECK ( maintenance_by_club_allowed IN ('Y', 'N') );
ALTER TABLE gs_competition_player add column use_for_handicap char(1) NOT NULL DEFAULT 'Y' CHECK ( use_for_handicap IN ('Y', 'N') );
CREATE TABLE gs_competition_scorer_setup (
    fk_competition  bigint(20) NOT NULL,
    round_no        smallint(6) DEFAULT 0 NOT NULL,
    scorer_type     varchar(30) DEFAULT 'FLIGHT_MEMBER' NOT NULL,
    scorers         int(10),
    hole_scorer_map mediumtext,
    CONSTRAINT pk_competition_scorer_setup
        PRIMARY KEY (fk_competition,
                     round_no)) ENGINE=InnoDB CHARACTER SET UTF8;
ALTER TABLE gs_competition_scorer_setup ADD CONSTRAINT fk_scorer_setup_ref_comp FOREIGN KEY (fk_competition) REFERENCES gs_competition (id) ON UPDATE Cascade ON DELETE Cascade;


-- 06-Dec-2023 : Online payment implementation for club membership
alter table gs_player_club_acct_trxn add column fk_bill bigint;
ALTER TABLE gs_player_club_acct_trxn ADD CONSTRAINT fk_plr_clb_act_trn_ref_bill FOREIGN KEY (fk_bill) REFERENCES gs_bill (bill_id) ON UPDATE Cascade ON DELETE Restrict;

DROP TABLE IF EXISTS gs_club_member_reminder;
CREATE TABLE gs_club_member_reminder (
    fk_club_membership int(11) NOT NULL,
    reminder_type      varchar(3) NOT NULL,
    last_reminder_on   date NOT NULL,
    reminder_message   mediumtext,
    CONSTRAINT pk_club_member_reminder
        PRIMARY KEY (fk_club_membership,
                     reminder_type)) ENGINE=InnoDB CHARACTER SET UTF8;
ALTER TABLE gs_club_member_reminder ADD CONSTRAINT fk_mem_reminder_ref_mem FOREIGN KEY (fk_club_membership) REFERENCES gs_club_membership (id) ON UPDATE Cascade ON DELETE Cascade;

-- 12-Dec-2023
ALTER TABLE gs_club_membership_charge add column apply_on_renewal char(1) NOT NULL default 'N' CHECK ( apply_on_renewal IN ('Y', 'N') );
ALTER TABLE gs_club_membership add column auto_renew char(1) NOT NULL default 'N' CHECK ( auto_renew IN ('Y', 'N') );
ALTER TABLE gs_club_membership add column auto_renew_before smallint not null default 30;
CREATE TABLE gs_club_mem_renewal_history (
    id                 int(10) NOT NULL AUTO_INCREMENT,
    renewed_on         date,
    prev_expiry_date   date,
    new_expiry_date    date,
    fk_club_membership int(11) NOT NULL,
    fk_renewed_by      int(10),
    CONSTRAINT pk_club_mem_renewal_history
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;
ALTER TABLE gs_club_mem_renewal_history ADD CONSTRAINT fk_mem_renewal_ref_auth FOREIGN KEY (fk_renewed_by) REFERENCES gs_authentication (id) ON UPDATE Cascade ON DELETE Restrict;
ALTER TABLE gs_club_mem_renewal_history ADD CONSTRAINT fk_renewal_ref_membership FOREIGN KEY (fk_club_membership) REFERENCES gs_club_membership (id) ON UPDATE Cascade ON DELETE Cascade;

-- Club Membership Billing
ALTER TABLE gs_club_membership_option add column billing_enabled char(1) NOT NULL DEFAULT 'Y';

-- Round Session 22 Dec 2023
alter table gs_round_session add  allow_join_session char(1) default 'Y' not null check ( allow_join_session in ('Y', 'N') );

-- Fixed Categories
ALTER TABLE gs_competition_category add column fixed_category char(1) default 'N' NOT NULL check ( fixed_category in ('Y', 'N') );



###

###mysql

ALTER TABLE gs_booking_agent_transaction add column fk_booking_agent_statement int(10);
ALTER TABLE gs_booking_agent_transaction add column payment_remaining_distribution decimal(19, 2) DEFAULT 0.0;

CREATE TABLE gs_booking_agent_pmt_distribution (
    id                         int(10) NOT NULL AUTO_INCREMENT,
    fk_payment_transaction     bigint(20) NOT NULL,
    fk_booking_agent_statement int(10) NOT NULL,
    amount_paid                decimal(19, 2) DEFAULT 0.0,
    CONSTRAINT pk_booking_agent_pmt_distribution
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;

CREATE TABLE gs_booking_agent_statement (
    id                  int(10) NOT NULL AUTO_INCREMENT,
    statement_date      date,
    transactions_until  date,
    opening_balance     decimal(19, 2) DEFAULT 0.0,
    total_debit         decimal(19, 2) DEFAULT 0.0,
    total_credits       decimal(19, 2) DEFAULT 0.0,
    total_payments      decimal(19, 2) DEFAULT 0.0,
    closing_balance     decimal(19, 2) DEFAULT 0.0,
    outstanding_balance decimal(19, 2) DEFAULT 0.0,
    payment_made        decimal(19, 2) DEFAULT 0.0,
    fk_club             bigint(20) NOT NULL,
    fk_booking_agent    varchar(30) NOT NULL,
    CONSTRAINT pk_booking_agent_statement
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;
ALTER TABLE gs_booking_agent_statement ADD CONSTRAINT fk_bagent_stmt_ref_club FOREIGN KEY (fk_club) REFERENCES gs_club (id) ON UPDATE Cascade ON DELETE Restrict;
ALTER TABLE gs_booking_agent_statement ADD CONSTRAINT fk_bagent_stmt_ref_partner FOREIGN KEY (fk_booking_agent) REFERENCES gs_discount_company (id);
ALTER TABLE gs_booking_agent_pmt_distribution ADD CONSTRAINT fk_pmt_dist_ref_bagent_stmt FOREIGN KEY (fk_booking_agent_statement) REFERENCES gs_booking_agent_statement (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_booking_agent_pmt_distribution ADD CONSTRAINT fk_pmt_dist_ref_bagent_trxn FOREIGN KEY (fk_payment_transaction) REFERENCES gs_booking_agent_transaction (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_booking_agent_transaction ADD CONSTRAINT fk_bagent_trxn_ref_bagent_stmt FOREIGN KEY (fk_booking_agent_statement) REFERENCES gs_booking_agent_statement (id) ON UPDATE Cascade ON DELETE Set null;
###

###mysql
-- 21 May 2024
ALTER TABLE gs_booking_agent_statement add column status char(1) NOT NULL DEFAULT 'G' CHECK ( status IN ('G', 'A', 'C') );
ALTER TABLE gs_booking_agent_statement add column approved_on date;
ALTER TABLE gs_booking_agent_statement add column statement_reference varchar(30);

###

###mysql
-- 11 June 2024
DROP TABLE IF EXISTS gs_club_pos_payment;
DROP TABLE IF EXISTS gs_club_pos_sale;
DROP TABLE IF EXISTS gs_club_pos_sale_trxn_mapping;
DROP TABLE IF EXISTS gs_club_pos_sales_import;
CREATE TABLE gs_club_pos_sale (
    id                       bigint(20) NOT NULL AUTO_INCREMENT,
    sales_date               date NOT NULL,
    sales_time               datetime NULL,
    bill_no                  varchar(100),
    product_category         varchar(30) DEFAULT '"Default"' NOT NULL,
    remarks                  varchar(255),
    gross_amount             decimal(19, 2) DEFAULT 0.0 NOT NULL,
    discount_amount          decimal(19, 2) DEFAULT 0.0 NOT NULL,
    tax_applied              decimal(19, 2) DEFAULT 0.0 NOT NULL,
    net_amount               decimal(19, 2) DEFAULT 0.0 NOT NULL,
    sales_mode               varchar(30) DEFAULT 'CASH',
    fk_club                  bigint(20) NOT NULL,
    fk_pos                   int(10),
    pos_code                 varchar(30),
    cashier_id               varchar(30),
    sales_source             varchar(100),
    service_charge           decimal(19, 2) DEFAULT 0.0,
    adjusted_amount          decimal(19, 2) DEFAULT 0.0,
    amount_payable           decimal(19, 2) DEFAULT 0.0,
    synced_to_financial      char(1) DEFAULT 'N' NOT NULL,
    financial_sync_reference varchar(100),
    financial_sync_at        datetime NULL,
    membership_number        varchar(30),
    fk_player                bigint(20),
    email                    varchar(255),
    fk_import_instance       int(10),
    CONSTRAINT pk_club_pos_sale
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;
CREATE TABLE gs_club_pos_sale_trxn_mapping (
    id                  int(10) NOT NULL AUTO_INCREMENT,
    fk_club             bigint(20) NOT NULL,
    product_category    varchar(30) NOT NULL,
    sales_mode          varchar(30),
    fk_transaction_type varchar(30) NOT NULL,
    CONSTRAINT pk_club_pos_sale_trxn_mapping
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;
CREATE TABLE gs_club_pos_sales_import (
    id             int(10) NOT NULL AUTO_INCREMENT,
    imported_at    datetime NOT NULL,
    imported_from  varchar(30),
    total_imported int(10) DEFAULT 0 NOT NULL,
    total_success  int(10) DEFAULT 0 NOT NULL,
    total_error    int(10) DEFAULT 0 NOT NULL,
    fk_club        bigint(20) NOT NULL,
    fk_imported_by int(10),
    CONSTRAINT pk_club_pos_sales_import
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;
CREATE TABLE gs_club_pos_payment (
    fk_club_sale        bigint(20) NOT NULL,
    sequence            smallint(6) NOT NULL,
    payment_code        varchar(30) DEFAULT 'CASH',
    payment_reference   varchar(30),
    payment_amount      decimal(19, 2) DEFAULT 0.0 NOT NULL,
    local_amount        decimal(19, 2) DEFAULT 0.0 NOT NULL,
    payment_currency    varchar(5),
    exchange_rate       decimal(19, 2) DEFAULT 0.0 NOT NULL,
    tip_amount          decimal(19, 2) DEFAULT 0.0 NOT NULL,
    local_tip_amount    decimal(19, 2) DEFAULT 0.0 NOT NULL,
    change_amount       decimal(19, 2) DEFAULT 0.0,
    local_change_amount decimal(19, 2) DEFAULT 0.0,
    card_name           varchar(255),
    commission_rate     decimal(19, 2) DEFAULT 0.0,
    commission          decimal(19, 2) DEFAULT 0.0,
    CONSTRAINT pk_club_pos_payment
        PRIMARY KEY (fk_club_sale,
                     sequence)) ENGINE=InnoDB CHARACTER SET UTF8;

ALTER TABLE gs_club_pos_payment ADD CONSTRAINT fk_sales_pmt_ref_sales FOREIGN KEY (fk_club_sale) REFERENCES gs_club_pos_sale (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_club_pos_sales_import ADD CONSTRAINT fk_pos_sale_imp_ref_auth FOREIGN KEY (fk_imported_by) REFERENCES gs_authentication (id) ON UPDATE Cascade ON DELETE Set null;
ALTER TABLE gs_club_pos_sales_import ADD CONSTRAINT fk_pos_sale_imp_ref_club FOREIGN KEY (fk_club) REFERENCES gs_club (id) ON UPDATE Cascade ON DELETE Restrict;
ALTER TABLE gs_club_pos_sale_trxn_mapping ADD CONSTRAINT fk_pos_sale_trxn_map_ref_clb FOREIGN KEY (fk_club) REFERENCES gs_club (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_club_pos_sale_trxn_mapping ADD CONSTRAINT fk_pos_sale_trxn_map_ref_trxn_type FOREIGN KEY (fk_transaction_type) REFERENCES gs_transaction_type (id) ON UPDATE Cascade ON DELETE Restrict;
ALTER TABLE gs_club_pos_sale ADD CONSTRAINT fk_sales_ref_club FOREIGN KEY (fk_club) REFERENCES gs_club (id) ON UPDATE Cascade ON DELETE Restrict;
ALTER TABLE gs_club_pos_sale ADD CONSTRAINT fk_sales_ref_imp_inst FOREIGN KEY (fk_import_instance) REFERENCES gs_club_pos_sales_import (id) ON UPDATE Cascade ON DELETE Restrict;
ALTER TABLE gs_club_pos_sale ADD CONSTRAINT fk_sales_ref_pos FOREIGN KEY (fk_pos) REFERENCES gs_club_pos (id) ON UPDATE Cascade ON DELETE Set null;
ALTER TABLE gs_club_pos_sale ADD CONSTRAINT fk_sales_ref_player FOREIGN KEY (fk_player) REFERENCES gs_player (id) ON UPDATE Cascade ON DELETE Restrict;

						 
ALTER TABLE gs_club_pos_sales_import add column imported_file_name varchar(255);
ALTER TABLE gs_club_pos_sales_import add column file_url varchar(1024);

###


###mysql
-- 11 June 2024
ALTER TABLE gs_club_pos_sale add column fk_player_account_trxn bigint(20);
ALTER TABLE gs_club_pos_sale ADD CONSTRAINT fk_sales_ref_plr_act_trxn FOREIGN KEY (fk_player_account_trxn) REFERENCES gs_player_club_acct_trxn (id) ON UPDATE Cascade ON DELETE Set null;
###

###mysql
-- 12 June 2024
	  
CREATE TABLE gs_club_pos_imp_message (
  fk_club_pos_imp int(10) NOT NULL,
  row_index       int(10) NOT NULL,
  message_type    char(1) DEFAULT 'E' NOT NULL,
  message         mediumtext,
  CONSTRAINT pk_club_pos_imp_message
    PRIMARY KEY (fk_club_pos_imp,
  row_index)) ENGINE=InnoDB CHARACTER SET UTF8;
ALTER TABLE gs_club_pos_imp_message ADD CONSTRAINT fk_pos_sales_imp_msg_ref_imp FOREIGN KEY (fk_club_pos_imp) REFERENCES gs_club_pos_sales_import (id) ON UPDATE Cascade ON DELETE Cascade;

###

###mysql
-- 14 June 2024
ALTER TABLE gs_club_pos_sale_trxn_mapping add column fk_club_outlet int(10);
ALTER TABLE gs_club_pos_sale add column financial_sync_message mediumtext;
ALTER TABLE gs_club_pos_sale_trxn_mapping ADD CONSTRAINT fk_pos_sale_trxn_map_ref_outlet FOREIGN KEY (fk_club_outlet) REFERENCES gs_club_outlet (id) ON UPDATE Cascade ON DELETE Cascade;
###

###mysql
-- 16 June 2024
alter table gs_club_outlet add column fk_transaction_type varchar(30);
ALTER TABLE gs_club_outlet ADD CONSTRAINT fk_club_outlet_ref_trxn_type FOREIGN KEY (fk_transaction_type) REFERENCES gs_transaction_type (id) ON UPDATE Cascade ON DELETE Set null;
-- Already Executed in migration
###

###mysql
-- 18 June 2024
alter table gs_club_pos_sales_import add column is_reversed char(1) NOT NULL DEFAULT 'N';
alter table gs_club_pos_sales_import add column reversed_on date;
alter table gs_club_pos_sales_import add column fk_reversed_by int(10);
ALTER TABLE gs_club_pos_sales_import ADD CONSTRAINT fk_pos_sale_imp_ref_rev_auth FOREIGN KEY (fk_reversed_by) REFERENCES gs_authentication (id) ON UPDATE Cascade ON DELETE Set null;
###

###mysql
-- 18 June 2024
ALTER TABLE gs_club_membership add column income_tax_number varchar(50);
ALTER TABLE gs_club_membership add column phone_number varchar(30);

###

###mysql
-- 19 June 2024
alter table gs_league add column league_type varchar(10);
alter table gs_league add column league_image varchar(1024);
###

###mysql
-- 19 June 2024
alter table gs_league_season add column best_of smallint not null default 0;
###

###mysql
-- 19 July 2024
alter table gs_tee_time_booking_player add column  exclude_from_agent_commission char(1) NOT NULL DEFAULT 'N';
alter table gs_booking_agent_club_setting add column commission_components mediumtext;
###

###mysql
-- 24 July 2024
ALTER TABLE gs_competition add column wait_list_size smallint default 0 not null;
ALTER TABLE gs_competition add column wait_list_rules mediumtext;
CREATE TABLE gs_competition_wait_list (
    id                       bigint(20) NOT NULL AUTO_INCREMENT,
    fk_player                bigint(20) NOT NULL,
    wait_listed_on           datetime NOT NULL,
    status                   char(1) DEFAULT 'W' NOT NULL,
    registered_on            datetime NULL,
    automatically_registered char(1) DEFAULT 'N' NOT NULL,
    fk_registered_by         int(10),
    fk_competition           bigint(20) NOT NULL,
    CONSTRAINT pk_competition_wait_list
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;
ALTER TABLE gs_competition_wait_list ADD CONSTRAINT fk_comp_wait_listed_player_ref_auth FOREIGN KEY (fk_registered_by) REFERENCES gs_authentication (id) ON UPDATE Cascade ON DELETE Restrict;
ALTER TABLE gs_competition_wait_list ADD CONSTRAINT fk_comp_wait_listed_player_ref_comp FOREIGN KEY (fk_competition) REFERENCES gs_competition (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_competition_wait_list ADD CONSTRAINT fk_comp_wait_listed_player_ref_player FOREIGN KEY (fk_player) REFERENCES gs_player (id) ON UPDATE Cascade ON DELETE Cascade;
###

###mysql
-- 24 July 2024
-- alter table gs_tee_time_booking_playeradd column exclude_from_agent_commission char(1)NOT NULL DEFAULT 'N';  
-- alter table gs_booking_agent_club_settingadd column commission_components mediumtext;
-- sidenote for future reference : this exclude_from_agent_commission DDL took about 7 minutes
###

  
	  
																							  
																											 
																				  
   

###mysql
-- 1st August 2024
-- GSV Competition Status
create or replace view gsv_competition_status as
    select `c`.`id`                                                                                                    AS `id`,
           `c`.`fk_club`                                                                                               AS `fk_club`,
           `c`.`fk_organizer`                                                                                          AS `fk_organizer`,
           `c`.`tournament_name`                                                                                       AS `tournament_name`,
           `c`.`tournament_image`                                                                                      AS `tournament_image`,
           `c`.`date_open`                                                                                             AS `date_open`,
           `c`.`date_close`                                                                                            AS `date_close`,
           `c`.`date_start`                                                                                            AS `date_start`,
           `c`.`date_end`                                                                                              AS `date_end`,
           `c`.`date_publish`                                                                                          AS `date_publish`,
           `s`.`name`                                                                                                  AS `scoring_format`,
           ifnull(`c`.`max_player`, 0)                                                                                 AS `total_available`,
           (select count(0)
            from `gs_competition_player`
            where (`gs_competition_player`.`fk_competition` = `c`.`id` and `gs_competition_player`.`status` IN ('R',
                                                                                                                'X'))) AS `total_registered`,
           `c`.`status`                                                                                                AS `competition_status`,
           `c`.`competition_type`                                                                                      AS `competition_type`,
           'Open'                                                                                                      AS `registration_status`,
           1                                                                                                           AS `sort_order`,
           (`c`.`date_start` - curdate())                                                                              AS `date_order`,
           `c`.`tournament_description`                                                                                AS `tournament_description`,
           `c`.`tournament_fee`                                                                                        AS `tournament_fee`,
           `c`.`tournament_rules`                                                                                      AS `tournament_rules`,
           `c`.`tournament_prize_total`                                                                                AS `tournament_prize_total`,
           `c`.`allow_gps`                                                                                             AS `allow_gps`,
           `c`.`max_player`                                                                                            AS `max_player`,
           `c`.`max_round`                                                                                             AS `max_round`,
           `c`.`max_hole`                                                                                              AS `max_hole`,
           `c`.`show_leaderboard`                                                                                      AS `show_leaderboard`,
           `c`.`allow_change_scorer`                                                                                   AS `allow_change_scorer`,
           `c`.`is_private`                                                                                            AS `is_private`,
           `c`.`is_team_event`                                                                                         AS `is_team_event`,
           `c`.`wait_list_size`                                                                                        AS `wait_list_size`,
           (select count(0)
            FROM gs_competition_wait_list wl
            WHERE wl.fk_competition = c.id
              AND wl.status = 'W')                                                                                      AS `total_waitlisted`
    from (`gs_competition` `c` left join `gs_scoring_format` `s` on ((`c`.`fk_scoring_format` = `s`.`id`)))
    where ((`c`.`status` = 'In Progress') and (`c`.`date_end` >= curdate()) and (`c`.`date_close` >= curdate()))
    union all
    select `c`.`id`                                                                                                    AS `id`,
           `c`.`fk_club`                                                                                               AS `fk_club`,
           `c`.`fk_organizer`                                                                                          AS `fk_organizer`,
           `c`.`tournament_name`                                                                                       AS `tournament_name`,
           `c`.`tournament_image`                                                                                      AS `tournament_image`,
           `c`.`date_open`                                                                                             AS `date_open`,
           `c`.`date_close`                                                                                            AS `date_close`,
           `c`.`date_start`                                                                                            AS `date_start`,
           `c`.`date_end`                                                                                              AS `date_end`,
           `c`.`date_publish`                                                                                          AS `date_publish`,
           `s`.`name`                                                                                                  AS `scoring_format`,
           ifnull(`c`.`max_player`, 0)                                                                                 AS `total_available`,
           (select count(0)
            from `gs_competition_player`
            where (`gs_competition_player`.`fk_competition` = `c`.`id` and `gs_competition_player`.`status` IN ('R',
                                                                                                                'X'))) AS `total_registered`,
           `c`.`status`                                                                                                AS `competition_status`,
           `c`.`competition_type`                                                                                      AS `competition_type`,
           'Closed'                                                                                                    AS `registration_status`,
           1                                                                                                           AS `sort_order`,
           (`c`.`date_start` - curdate())                                                                              AS `date_order`,
           `c`.`tournament_description`                                                                                AS `tournament_description`,
           `c`.`tournament_fee`                                                                                        AS `tournament_fee`,
           `c`.`tournament_rules`                                                                                      AS `tournament_rules`,
           `c`.`tournament_prize_total`                                                                                AS `tournament_prize_total`,
           `c`.`allow_gps`                                                                                             AS `allow_gps`,
           `c`.`max_player`                                                                                            AS `max_player`,
           `c`.`max_round`                                                                                             AS `max_round`,
           `c`.`max_hole`                                                                                              AS `max_hole`,
           `c`.`show_leaderboard`                                                                                      AS `show_leaderboard`,
           `c`.`allow_change_scorer`                                                                                   AS `allow_change_scorer`,
           `c`.`is_private`                                                                                            AS `is_private`,
           `c`.`is_team_event`                                                                                         AS `is_team_event`,
           `c`.`wait_list_size`                                                                                        AS `wait_list_size`,
           (select count(0)
            FROM gs_competition_wait_list wl
            WHERE wl.fk_competition = c.id
              AND wl.status = 'W')                                                                                      AS `total_waitlisted`
    from (`gs_competition` `c` left join `gs_scoring_format` `s` on ((`c`.`fk_scoring_format` = `s`.`id`)))
    where ((`c`.`status` = 'In Progress') and (`c`.`date_end` >= curdate()) and (`c`.`date_close` < curdate()))
    union all
    select `c`.`id`                                                                                                    AS `id`,
           `c`.`fk_club`                                                                                               AS `fk_club`,
           `c`.`fk_organizer`                                                                                          AS `fk_organizer`,
           `c`.`tournament_name`                                                                                       AS `tournament_name`,
           `c`.`tournament_image`                                                                                      AS `tournament_image`,
           `c`.`date_open`                                                                                             AS `date_open`,
           `c`.`date_close`                                                                                            AS `date_close`,
           `c`.`date_start`                                                                                            AS `date_start`,
           `c`.`date_end`                                                                                              AS `date_end`,
           `c`.`date_publish`                                                                                          AS `date_publish`,
           `s`.`name`                                                                                                  AS `scoring_format`,
           ifnull(`c`.`max_player`, 0)                                                                                 AS `total_available`,
           (select count(0)
            from `gs_competition_player`
            where (`gs_competition_player`.`fk_competition` = `c`.`id` and `gs_competition_player`.`status` IN ('R',
                                                                                                                'X'))) AS `total_registered`,
           `c`.`status`                                                                                                AS `competition_status`,
           `c`.`competition_type`                                                                                      AS `competition_type`,
           'Closed'                                                                                                    AS `registration_status`,
           1                                                                                                           AS `sort_order`,
           (`c`.`date_start` - curdate())                                                                              AS `date_order`,
           `c`.`tournament_description`                                                                                AS `tournament_description`,
           `c`.`tournament_fee`                                                                                        AS `tournament_fee`,
           `c`.`tournament_rules`                                                                                      AS `tournament_rules`,
           `c`.`tournament_prize_total`                                                                                AS `tournament_prize_total`,
           `c`.`allow_gps`                                                                                             AS `allow_gps`,
           `c`.`max_player`                                                                                            AS `max_player`,
           `c`.`max_round`                                                                                             AS `max_round`,
           `c`.`max_hole`                                                                                              AS `max_hole`,
           `c`.`show_leaderboard`                                                                                      AS `show_leaderboard`,
           `c`.`allow_change_scorer`                                                                                   AS `allow_change_scorer`,
           `c`.`is_private`                                                                                            AS `is_private`,
           `c`.`is_team_event`                                                                                         AS `is_team_event`,
           `c`.`wait_list_size`                                                                                        AS `wait_list_size`,
           (select count(0)
            FROM gs_competition_wait_list wl
            WHERE wl.fk_competition = c.id
              AND wl.status = 'W')                                                                                      AS `total_waitlisted`
    from (`gs_competition` `c` left join `gs_scoring_format` `s` on ((`c`.`fk_scoring_format` = `s`.`id`)))
    where ((`c`.`status` = 'In Progress') and (`c`.`date_end` < curdate()) and (`c`.`date_close` < curdate()))
    union all
    select `c`.`id`                                                                                                    AS `id`,
           `c`.`fk_club`                                                                                               AS `fk_club`,
           `c`.`fk_organizer`                                                                                          AS `fk_organizer`,
           `c`.`tournament_name`                                                                                       AS `tournament_name`,
           `c`.`tournament_image`                                                                                      AS `tournament_image`,
           `c`.`date_open`                                                                                             AS `date_open`,
           `c`.`date_close`                                                                                            AS `date_close`,
           `c`.`date_start`                                                                                            AS `date_start`,
           `c`.`date_end`                                                                                              AS `date_end`,
           `c`.`date_publish`                                                                                          AS `date_publish`,
           `s`.`name`                                                                                                  AS `scoring_format`,
           ifnull(`c`.`max_player`, 0)                                                                                 AS `total_available`,
           (select count(0)
            from `gs_competition_player`
            where (`gs_competition_player`.`fk_competition` = `c`.`id` and `gs_competition_player`.`status` IN ('R',
                                                                                                                'X'))) AS `total_registered`,
           `c`.`status`                                                                                                AS `competition_status`,
           `c`.`competition_type`                                                                                      AS `competition_type`,
           'Open'                                                                                                      AS `registration_status`,
           3                                                                                                           AS `sort_order`,
           (`c`.`date_start` - curdate())                                                                              AS `date_order`,
           `c`.`tournament_description`                                                                                AS `tournament_description`,
           `c`.`tournament_fee`                                                                                        AS `tournament_fee`,
           `c`.`tournament_rules`                                                                                      AS `tournament_rules`,
           `c`.`tournament_prize_total`                                                                                AS `tournament_prize_total`,
           `c`.`allow_gps`                                                                                             AS `allow_gps`,
           `c`.`max_player`                                                                                            AS `max_player`,
           `c`.`max_round`                                                                                             AS `max_round`,
           `c`.`max_hole`                                                                                              AS `max_hole`,
           `c`.`show_leaderboard`                                                                                      AS `show_leaderboard`,
           `c`.`allow_change_scorer`                                                                                   AS `allow_change_scorer`,
           `c`.`is_private`                                                                                            AS `is_private`,
           `c`.`is_team_event`                                                                                         AS `is_team_event`,
           `c`.`wait_list_size`                                                                                        AS `wait_list_size`,
           (select count(0)
            FROM gs_competition_wait_list wl
            WHERE wl.fk_competition = c.id
              AND wl.status = 'W')                                                                                      AS `total_waitlisted`
    from (`gs_competition` `c` left join `gs_scoring_format` `s` on ((`c`.`fk_scoring_format` = `s`.`id`)))
    where ((`c`.`status` = 'Upcoming') and (`c`.`date_open` <= curdate()) and (`c`.`date_close` >= curdate()) and
           (`c`.`date_end` >= curdate()))
    union all
    select `c`.`id`                                                                                                    AS `id`,
           `c`.`fk_club`                                                                                               AS `fk_club`,
           `c`.`fk_organizer`                                                                                          AS `fk_organizer`,
           `c`.`tournament_name`                                                                                       AS `tournament_name`,
           `c`.`tournament_image`                                                                                      AS `tournament_image`,
           `c`.`date_open`                                                                                             AS `date_open`,
           `c`.`date_close`                                                                                            AS `date_close`,
           `c`.`date_start`                                                                                            AS `date_start`,
           `c`.`date_end`                                                                                              AS `date_end`,
           `c`.`date_publish`                                                                                          AS `date_publish`,
           `s`.`name`                                                                                                  AS `scoring_format`,
           ifnull(`c`.`max_player`, 0)                                                                                 AS `total_available`,
           (select count(0)
            from `gs_competition_player`
            where (`gs_competition_player`.`fk_competition` = `c`.`id` and `gs_competition_player`.`status` IN ('R',
                                                                                                                'X'))) AS `total_registered`,
           `c`.`status`                                                                                                AS `competition_status`,
           `c`.`competition_type`                                                                                      AS `competition_type`,
           'Not Open Yet'                                                                                              AS `registration_status`,
           3                                                                                                           AS `sort_order`,
           (`c`.`date_start` - curdate())                                                                              AS `date_order`,
           `c`.`tournament_description`                                                                                AS `tournament_description`,
           `c`.`tournament_fee`                                                                                        AS `tournament_fee`,
           `c`.`tournament_rules`                                                                                      AS `tournament_rules`,
           `c`.`tournament_prize_total`                                                                                AS `tournament_prize_total`,
           `c`.`allow_gps`                                                                                             AS `allow_gps`,
           `c`.`max_player`                                                                                            AS `max_player`,
           `c`.`max_round`                                                                                             AS `max_round`,
           `c`.`max_hole`                                                                                              AS `max_hole`,
           `c`.`show_leaderboard`                                                                                      AS `show_leaderboard`,
           `c`.`allow_change_scorer`                                                                                   AS `allow_change_scorer`,
           `c`.`is_private`                                                                                            AS `is_private`,
           `c`.`is_team_event`                                                                                         AS `is_team_event`,
           `c`.`wait_list_size`                                                                                        AS `wait_list_size`,
           (select count(0)
            FROM gs_competition_wait_list wl
            WHERE wl.fk_competition = c.id
              AND wl.status = 'W')                                                                                      AS `total_waitlisted`
    from (`gs_competition` `c` left join `gs_scoring_format` `s` on ((`c`.`fk_scoring_format` = `s`.`id`)))
    where ((`c`.`status` = 'Upcoming') and (`c`.`date_open` > curdate()) and (`c`.`date_close` > curdate()) and
           (`c`.`date_end` >= curdate()))
    union all
    select `c`.`id`                                                                                                    AS `id`,
           `c`.`fk_club`                                                                                               AS `fk_club`,
           `c`.`fk_organizer`                                                                                          AS `fk_organizer`,
           `c`.`tournament_name`                                                                                       AS `tournament_name`,
           `c`.`tournament_image`                                                                                      AS `tournament_image`,
           `c`.`date_open`                                                                                             AS `date_open`,
           `c`.`date_close`                                                                                            AS `date_close`,
           `c`.`date_start`                                                                                            AS `date_start`,
           `c`.`date_end`                                                                                              AS `date_end`,
           `c`.`date_publish`                                                                                          AS `date_publish`,
           `s`.`name`                                                                                                  AS `scoring_format`,
           ifnull(`c`.`max_player`, 0)                                                                                 AS `total_available`,
           (select count(0)
            from `gs_competition_player`
            where (`gs_competition_player`.`fk_competition` = `c`.`id` and `gs_competition_player`.`status` IN ('R',
                                                                                                                'X'))) AS `total_registered`,
           `c`.`status`                                                                                                AS `competition_status`,
           `c`.`competition_type`                                                                                      AS `competition_type`,
           'Closed'                                                                                                    AS `registration_status`,
           3                                                                                                           AS `sort_order`,
           (`c`.`date_start` - curdate())                                                                              AS `date_order`,
           `c`.`tournament_description`                                                                                AS `tournament_description`,
           `c`.`tournament_fee`                                                                                        AS `tournament_fee`,
           `c`.`tournament_rules`                                                                                      AS `tournament_rules`,
           `c`.`tournament_prize_total`                                                                                AS `tournament_prize_total`,
           `c`.`allow_gps`                                                                                             AS `allow_gps`,
           `c`.`max_player`                                                                                            AS `max_player`,
           `c`.`max_round`                                                                                             AS `max_round`,
           `c`.`max_hole`                                                                                              AS `max_hole`,
           `c`.`show_leaderboard`                                                                                      AS `show_leaderboard`,
           `c`.`allow_change_scorer`                                                                                   AS `allow_change_scorer`,
           `c`.`is_private`                                                                                            AS `is_private`,
           `c`.`is_team_event`                                                                                         AS `is_team_event`,
           `c`.`wait_list_size`                                                                                        AS `wait_list_size`,
           (select count(0)
            FROM gs_competition_wait_list wl
            WHERE wl.fk_competition = c.id
              AND wl.status = 'W')                                                                                      AS `total_waitlisted`
    from (`gs_competition` `c` left join `gs_scoring_format` `s` on ((`c`.`fk_scoring_format` = `s`.`id`)))
    where ((`c`.`status` = 'Upcoming') and (`c`.`date_open` < curdate()) and (`c`.`date_close` < curdate()) and
           (`c`.`date_end` >= curdate()))
    union all
    select `c`.`id`                                                                                                    AS `id`,
           `c`.`fk_club`                                                                                               AS `fk_club`,
           `c`.`fk_organizer`                                                                                          AS `fk_organizer`,
           `c`.`tournament_name`                                                                                       AS `tournament_name`,
           `c`.`tournament_image`                                                                                      AS `tournament_image`,
           `c`.`date_open`                                                                                             AS `date_open`,
           `c`.`date_close`                                                                                            AS `date_close`,
           `c`.`date_start`                                                                                            AS `date_start`,
           `c`.`date_end`                                                                                              AS `date_end`,
           `c`.`date_publish`                                                                                          AS `date_publish`,
           `s`.`name`                                                                                                  AS `scoring_format`,
           ifnull(`c`.`max_player`, 0)                                                                                 AS `total_available`,
           (select count(0)
            from `gs_competition_player`
            where (`gs_competition_player`.`fk_competition` = `c`.`id` and `gs_competition_player`.`status` IN ('R',
                                                                                                                'X'))) AS `total_registered`,
           'Elapsed'                                                                                                   AS `competition_status`,
           `c`.`competition_type`                                                                                      AS `competition_type`,
           'Closed'                                                                                                    AS `registration_status`,
           5                                                                                                           AS `sort_order`,
           (curdate() - `c`.`date_start`)                                                                              AS `date_order`,
           `c`.`tournament_description`                                                                                AS `tournament_description`,
           `c`.`tournament_fee`                                                                                        AS `tournament_fee`,
           `c`.`tournament_rules`                                                                                      AS `tournament_rules`,
           `c`.`tournament_prize_total`                                                                                AS `tournament_prize_total`,
           `c`.`allow_gps`                                                                                             AS `allow_gps`,
           `c`.`max_player`                                                                                            AS `max_player`,
           `c`.`max_round`                                                                                             AS `max_round`,
           `c`.`max_hole`                                                                                              AS `max_hole`,
           `c`.`show_leaderboard`                                                                                      AS `show_leaderboard`,
           `c`.`allow_change_scorer`                                                                                   AS `allow_change_scorer`,
           `c`.`is_private`                                                                                            AS `is_private`,
           `c`.`is_team_event`                                                                                         AS `is_team_event`,
           `c`.`wait_list_size`                                                                                        AS `wait_list_size`,
           (select count(0)
            FROM gs_competition_wait_list wl
            WHERE wl.fk_competition = c.id
              AND wl.status = 'W')                                                                                      AS `total_waitlisted`
    from (`gs_competition` `c` left join `gs_scoring_format` `s` on ((`c`.`fk_scoring_format` = `s`.`id`)))
    where ((`c`.`status` = 'Upcoming') and (`c`.`date_start` < curdate()) and (`c`.`date_end` < curdate()))
    union all
    select `c`.`id`                                                                                                    AS `id`,
           `c`.`fk_club`                                                                                               AS `fk_club`,
           `c`.`fk_organizer`                                                                                          AS `fk_organizer`,
           `c`.`tournament_name`                                                                                       AS `tournament_name`,
           `c`.`tournament_image`                                                                                      AS `tournament_image`,
           `c`.`date_open`                                                                                             AS `date_open`,
           `c`.`date_close`                                                                                            AS `date_close`,
           `c`.`date_start`                                                                                            AS `date_start`,
           `c`.`date_end`                                                                                              AS `date_end`,
           `c`.`date_publish`                                                                                          AS `date_publish`,
           `s`.`name`                                                                                                  AS `scoring_format`,
           ifnull(`c`.`max_player`, 0)                                                                                 AS `total_available`,
           (select count(0)
            from `gs_competition_player`
            where (`gs_competition_player`.`fk_competition` = `c`.`id` and `gs_competition_player`.`status` IN ('R',
                                                                                                                'X'))) AS `total_registered`,
           `c`.`status`                                                                                                AS `competition_status`,
           `c`.`competition_type`                                                                                      AS `competition_type`,
           'Closed'                                                                                                    AS `registration_status`,
           5                                                                                                           AS `sort_order`,
           (curdate() - `c`.`date_end`)                                                                                AS `date_order`,
           `c`.`tournament_description`                                                                                AS `tournament_description`,
           `c`.`tournament_fee`                                                                                        AS `tournament_fee`,
           `c`.`tournament_rules`                                                                                      AS `tournament_rules`,
           `c`.`tournament_prize_total`                                                                                AS `tournament_prize_total`,
           `c`.`allow_gps`                                                                                             AS `allow_gps`,
           `c`.`max_player`                                                                                            AS `max_player`,
           `c`.`max_round`                                                                                             AS `max_round`,
           `c`.`max_hole`                                                                                              AS `max_hole`,
           `c`.`show_leaderboard`                                                                                      AS `show_leaderboard`,
           `c`.`allow_change_scorer`                                                                                   AS `allow_change_scorer`,
           `c`.`is_private`                                                                                            AS `is_private`,
           `c`.`is_team_event`                                                                                         AS `is_team_event`,
           `c`.`wait_list_size`                                                                                        AS `wait_list_size`,
           (select count(0)
            FROM gs_competition_wait_list wl
            WHERE wl.fk_competition = c.id
              AND wl.status = 'W')                                                                                      AS `total_waitlisted`
    from (`gs_competition` `c` left join `gs_scoring_format` `s` on ((`c`.`fk_scoring_format` = `s`.`id`)))
    where (`c`.`status` = 'Completed')
    union all
    select `c`.`id`                                                                                                    AS `id`,
           `c`.`fk_club`                                                                                               AS `fk_club`,
           `c`.`fk_organizer`                                                                                          AS `fk_organizer`,
           `c`.`tournament_name`                                                                                       AS `tournament_name`,
           `c`.`tournament_image`                                                                                      AS `tournament_image`,
           `c`.`date_open`                                                                                             AS `date_open`,
           `c`.`date_close`                                                                                            AS `date_close`,
           `c`.`date_start`                                                                                            AS `date_start`,
           `c`.`date_end`                                                                                              AS `date_end`,
           `c`.`date_publish`                                                                                          AS `date_publish`,
           `s`.`name`                                                                                                  AS `scoring_format`,
           ifnull(`c`.`max_player`, 0)                                                                                 AS `total_available`,
           (select count(0)
            from `gs_competition_player`
            where (`gs_competition_player`.`fk_competition` = `c`.`id` and `gs_competition_player`.`status` IN ('R',
                                                                                                                'X'))) AS `total_registered`,
           `c`.`status`                                                                                                AS `competition_status`,
           `c`.`competition_type`                                                                                      AS `competition_type`,
           'Closed'                                                                                                    AS `registration_status`,
           5                                                                                                           AS `sort_order`,
           (curdate() - `c`.`date_start`)                                                                              AS `date_order`,
           `c`.`tournament_description`                                                                                AS `tournament_description`,
           `c`.`tournament_fee`                                                                                        AS `tournament_fee`,
           `c`.`tournament_rules`                                                                                      AS `tournament_rules`,
           `c`.`tournament_prize_total`                                                                                AS `tournament_prize_total`,
           `c`.`allow_gps`                                                                                             AS `allow_gps`,
           `c`.`max_player`                                                                                            AS `max_player`,
           `c`.`max_round`                                                                                             AS `max_round`,
           `c`.`max_hole`                                                                                              AS `max_hole`,
           `c`.`show_leaderboard`                                                                                      AS `show_leaderboard`,
           `c`.`allow_change_scorer`                                                                                   AS `allow_change_scorer`,
           `c`.`is_private`                                                                                            AS `is_private`,
           `c`.`is_team_event`                                                                                         AS `is_team_event`,
           `c`.`wait_list_size`                                                                                        AS `wait_list_size`,
           (select count(0)
            FROM gs_competition_wait_list wl
            WHERE wl.fk_competition = c.id
              AND wl.status = 'W')                                                                                      AS `total_waitlisted`
    from (`gs_competition` `c` left join `gs_scoring_format` `s` on ((`c`.`fk_scoring_format` = `s`.`id`)))
    where (`c`.`status` = 'Cancelled');
###
   

###mysql
-- 5th Aug 2024
-- Stay And Play Changes : 2-Aug-2024
alter table gs_stay_and_play_package add column package_prices mediumtext;
alter table gs_stay_play_pkg_surcharge add column additional_charges mediumtext;

alter table gs_package_stay_option add column premium_charges mediumtext;
alter table gs_package_stay_option add column addl_night_charges mediumtext;
alter table gs_stay_option_surcharge add column additional_charges mediumtext;

alter table gs_package_play_option add column premium_charges mediumtext;
alter table gs_package_play_option add column addl_round_charges_nine mediumtext;
alter table gs_package_play_option add column addl_round_charges_eighteen mediumtext;
alter table gs_play_option_surcharge add column additional_charges mediumtext;
###

###mysql
-- 8th Aug 2024
-- Stay And Play Changes: 6-Aug-2024
alter table gs_stay_and_play_request add column apply_non_local_price char(1) NOT NULL default 'N' CHECK ( apply_non_local_price in ('Y', 'N') );
alter table gs_stay_and_play_package add column  non_local_price  char(1) NOT NULL default 'N' CHECK ( non_local_price in ('Y', 'N') );
alter table gs_stay_and_play_adjustment add column is_tax char(1) NOT NULL default 'N' CHECK ( is_tax in ('Y', 'N') );
###

###mysql
-- 12 Aug 2024
-- League: Order Of Merit
ALTER TABLE gs_league_season add column league_settings mediumtext;
###

###mysql
-- 12 aug 2024
-- alter table gs_league_competition_player_totals
--    change additional_poinrs additional_points smallint default 0 not null;
--alter table gs_league_player_totals
--    change total_additional_poinrs total_additional_points smallint default 0 not null;
###

###mysql
-- 12 Aug 2024
-- There were some issues with column types. This will reset the all new league tables. If you have executed the previous DDLs, then execute full. Otherwise, start from first CREATE

-- ALTER TABLE gs_league_competition_player_totals DROP FOREIGN KEY fk_league_comp_total_ref_comp;
-- ALTER TABLE gs_league_competition_player_totals DROP FOREIGN KEY fk_league_comp_total_ref_league_season;
-- ALTER TABLE gs_league_competition_player_totals DROP FOREIGN KEY fk_league_comp_total_ref_player;
-- ALTER TABLE gs_league_roster DROP FOREIGN KEY fk_league_roster_ref_league_season;
-- ALTER TABLE gs_league_roster DROP FOREIGN KEY fk_league_roster_ref_player;
-- ALTER TABLE gs_league_player_totals DROP FOREIGN KEY fk_league_total_ref_league_season;
-- ALTER TABLE gs_league_player_totals DROP FOREIGN KEY fk_league_total_ref_player;
-- DROP TABLE IF EXISTS gs_league_competition_player_totals;
-- DROP TABLE IF EXISTS gs_league_player_totals;
-- DROP TABLE IF EXISTS gs_league_roster;

CREATE TABLE gs_league_competition_player_totals (
    id                       int(10) NOT NULL AUTO_INCREMENT,
    handicap                 smallint(6),
    total_gross              smallint(6) DEFAULT 0 NOT NULL,
    total_net                smallint(6) NOT NULL,
    total_stableford_points  smallint(6) NOT NULL,
   prize_money              decimal(19, 2) DEFAULT 0.0 NOT NULL,
    leader_board_position    smallint(6),
    positional_points        decimal(19, 2) DEFAULT 0 NOT NULL,
    actual_positional_points decimal(19, 2) DEFAULT 0 NOT NULL,
    participation_points     decimal(19, 2) DEFAULT 0.0,
    additional_points        char(1) DEFAULT 'A',
    fk_league_season         int(10) NOT NULL,
    fk_competition           bigint(20) NOT NULL,
    fk_player                bigint(20) NOT NULL,
    CONSTRAINT pk_league_competition_player_totals
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;
CREATE TABLE gs_league_player_totals (
    id                             bigint(20) NOT NULL AUTO_INCREMENT,
    total_gross                    int(10) DEFAULT 0 NOT NULL,
    total_net                      int(10) NOT NULL,
    total_stableford_points        int(10) NOT NULL,
    total_prize_money              decimal(19, 2) DEFAULT 0.0 NOT NULL,
    total_positional_points        decimal(19, 2) DEFAULT 0.0,
    total_actual_positional_points decimal(19, 2) DEFAULT 0.0,
    total_participation_points     decimal(19, 2) DEFAULT 0.0,
    total_additional_points        decimal(19, 2) DEFAULT 0.0,
    league_position                smallint(6) NOT NULL,
    original_league_position       smallint(6) NOT NULL     ,
    gross_position                 smallint(6) NOT NULL,
    net_position                   smallint(6) NOT NULL,
    stableford_points_position     smallint(6) NOT NULL,
    prize_money_position           smallint(6) DEFAULT 0 NOT NULL,
    fk_league_season               int(10) NOT NULL,
    fk_player                      bigint(20) NOT NULL,
    CONSTRAINT pk_league_player_totals
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;
CREATE TABLE gs_league_roster (
    id               bigint(20) NOT NULL AUTO_INCREMENT,
    fk_player        bigint(20) NOT NULL,
    fk_league_season int(10) NOT NULL,
    new_member       char(1) DEFAULT 'N' NOT NULL,
    CONSTRAINT pk_league_roster
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;
ALTER TABLE gs_league_competition_player_totals ADD CONSTRAINT fk_league_comp_total_ref_comp FOREIGN KEY (fk_competition) REFERENCES gs_competition (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_league_competition_player_totals ADD CONSTRAINT fk_league_comp_total_ref_league_season FOREIGN KEY (fk_league_season) REFERENCES gs_league_season (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_league_competition_player_totals ADD CONSTRAINT fk_league_comp_total_ref_player FOREIGN KEY (fk_player) REFERENCES gs_player (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_league_roster ADD CONSTRAINT fk_league_roster_ref_league_season FOREIGN KEY (fk_league_season) REFERENCES gs_league_season (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_league_roster ADD CONSTRAINT fk_league_roster_ref_player FOREIGN KEY (fk_player) REFERENCES gs_player (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_league_player_totals ADD CONSTRAINT fk_league_total_ref_league_season FOREIGN KEY (fk_league_season) REFERENCES gs_league_season (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_league_player_totals ADD CONSTRAINT fk_league_total_ref_player FOREIGN KEY (fk_player) REFERENCES gs_player (id) ON UPDATE Cascade ON DELETE Cascade;

ALTER TABLE gs_league_player_totals add column  league_totals mediumtext;


###

###mysql
-- 26 Aug 2024
alter table gs_club_membership_option add column allow_edit char(1) NOT NULL DEFAULT 'N';
###

###mysql
-- 2 Sept 2024
alter table gs_league_competition_player_totals add column round_no smallint not null default 1;
###

###mysql
-- 6 Sept 2024
alter table gs_league_player_totals add column positional_position smallint default -1;
alter table gs_league_competition_player_totals add column round_date date;
###

###mysql
-- 17 Sept 2024
	  
CREATE TABLE gs_e_invoicing_entity (
    id                           int(10) NOT NULL AUTO_INCREMENT,
    tax_identification_number    varchar(100) NOT NULL,
    individual                   char(1) DEFAULT 'N' NOT NULL,
    name                         varchar(255),
    business_registration_number varchar(100),
    SST                          varchar(100),
    tourism_number               varchar(100),
    fk_country                   varchar(10) NOT NULL,
    fk_address                   bigint(20),
    mark_for_delete              char(1) NOT NULL DEFAULT 'N',
    CONSTRAINT pk_e_invoicing_info
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;

CREATE UNIQUE INDEX IDX_gs_e_invoicing_entity
    ON gs_e_invoicing_entity (fk_country, tax_identification_number);

ALTER TABLE gs_e_invoicing_entity ADD CONSTRAINT fk_e_invoice_ref_address FOREIGN KEY (fk_address) REFERENCES gs_address (id) ON UPDATE Cascade ON DELETE Set null;
ALTER TABLE gs_e_invoicing_entity ADD CONSTRAINT fk_e_invoice_ref_country FOREIGN KEY (fk_country) REFERENCES gs_country (id) ON UPDATE Cascade ON DELETE Restrict;

ALTER TABLE gs_club_membership add column e_invoice_option char(1) DEFAULT 'N' NOT NULL;
ALTER TABLE gs_club_membership add column fk_e_invoice_entity int(10);
ALTER TABLE gs_club_membership ADD CONSTRAINT fk_club_member_ref_einvoice_entity
    FOREIGN KEY (fk_e_invoice_entity)
    REFERENCES gs_e_invoicing_entity (id) ON UPDATE Cascade ON DELETE Set null;



-- 26-Sep-2024 : Scorecard Changes
alter table gs_scorecard add column which_nine smallint;
alter table gs_scorecard add column course_hole_no smallint;
alter table gs_scorecard add column game_hole_no smallint;

update gs_scorecard  set
                         which_nine = (select which_nine from gs_game_course gc WHERE gc.id = gs_scorecard.fk_game_course),
                         course_hole_no = (select hole_no FROM gs_course_hole ch WHERE ch.id = gs_scorecard.fk_course_hole)
WHERE which_nine is null;

update gs_scorecard set game_hole_no = course_hole_no + (gs_scorecard.which_nine -1 ) * 9
WHERE gs_scorecard.game_hole_no is null;
 -- Find th discrepancy player rounds. Correct them or delete --
select * FROM
    (select pr.*,
            ((SELECT count(*) FROM gs_game_course gc WHERE gc.fk_game_round = pr.fk_game_round) * 9) game_course_hole,
            (select count(*) FROM gs_scorecard sc WHERE sc.fk_player_round = pr.id) scorecard_count
     from gs_player_round pr
     WHERE pr.status IN ('I', 'C')) temp
WHERE scorecard_count > 0 AND game_course_hole <> scorecard_count;

-- Change the unique index
alter table gs_scorecard
    drop key IDX_gs_scorecard;

alter table gs_scorecard
    add constraint IDX_gs_scorecard
        unique (fk_player_round, game_hole_no);

-- 27-Sep-2024: eInvoice for players
ALTER TABLE gs_player add column e_invoice_option char(1) DEFAULT 'N' NOT NULL;
ALTER TABLE gs_player add column fk_e_invoice_entity int(10);
ALTER TABLE gs_player ADD CONSTRAINT fk_player_ref_e_inv_entity FOREIGN KEY (fk_e_invoice_entity) REFERENCES gs_e_invoicing_entity (id) ON UPDATE Cascade ON DELETE Set null;

-- 30-Sep-2024: eInvoice for players
ALTER TABLE gs_player add column fk_e_invoice_company int(10);
ALTER TABLE gs_player ADD CONSTRAINT fk_player_ref_company_einv FOREIGN KEY (fk_e_invoice_company) REFERENCES gs_e_invoicing_entity (id) ON UPDATE Cascade ON DELETE Set null;
ALTER TABLE gs_e_invoicing_entity add column id_type varchar(10);
ALTER TABLE gs_e_invoicing_entity add column id_value varchar(100);