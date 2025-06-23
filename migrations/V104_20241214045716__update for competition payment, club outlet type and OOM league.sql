
-- 4-Dec-2024 Competition Payment
alter table gs_competition add column tournament_fee_org_member decimal(19, 2);
alter table gs_competition add column tournament_fee_club_member decimal(19, 2);
alter table gs_competition add column fk_currency char(3);
ALTER TABLE gs_competition ADD CONSTRAINT fk_comp_ref_curr FOREIGN KEY (fk_currency) REFERENCES gs_currency (currency_code) ON UPDATE Cascade ON DELETE Set null;

alter table gs_competition_player
    add column payment_status char(1) default 'U' not null CHECK (payment_status IN ('U', 'P', 'F'));
alter table gs_competition_player add column golf_club_membership varchar(100);
alter table gs_competition_player add column fee_payable decimal(19, 2) default 0.0;
alter table gs_competition_player add column fk_payment_captured_by int(11);
ALTER TABLE gs_competition_player ADD CONSTRAINT fk_comp_player_ref_pmt_user FOREIGN KEY (fk_payment_captured_by) REFERENCES gs_authentication (id) ON UPDATE Cascade ON DELETE Set null;

ALTER TABLE gs_competition_player add column fee_type_selected varchar(10) NOT NULL default 'auto';

-- 5-Dec-2024

-- Outlet/Facilities
CREATE TABLE gs_club_outlet_type (
    name        varchar(30) NOT NULL,
    description mediumtext,
    booking_prefix      varchar(10) NOT NULL,
    pricing varchar(50),
    CONSTRAINT pk_club_outlet_type PRIMARY KEY (name)) ENGINE=InnoDB CHARACTER SET UTF8;

alter table gs_club add column club_outlet_types mediumtext;

CREATE TABLE gs_club_outlet_type_user (
    id                int(10) NOT NULL AUTO_INCREMENT,
    fk_authentication int(10) NOT NULL,
    fk_outlet_type    varchar(30) NOT NULL,
    fk_club           bigint(20) NOT NULL,
    CONSTRAINT pk_outlet_type_user
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;
ALTER TABLE gs_club_outlet_type_user ADD CONSTRAINT fk_outlet_type_usr_ref_club FOREIGN KEY (fk_club) REFERENCES gs_club (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_club_outlet_type_user ADD CONSTRAINT fk_outlet_type_usr_ref_outlet_type FOREIGN KEY (fk_outlet_type) REFERENCES gs_club_outlet_type (name) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_club_outlet_type_user ADD CONSTRAINT fk_outlet_type_usr_ref_user FOREIGN KEY (fk_authentication) REFERENCES gs_authentication (id) ON UPDATE Cascade ON DELETE Cascade;

-- Order Of Merit League
alter table gs_league_competition_player_totals modify additional_points decimal(19, 2);
alter table gs_league_competition_player_totals add column incomplete_round char(1) not null default 'N' CHECK ( incomplete_round IN ('Y', 'N') );
alter table gs_league_competition_player_totals add column manual_edit char(1) not null default 'N' CHECK ( manual_edit IN ('Y', 'N') );
alter table gs_league_competition_player_totals add column original_positional_points decimal(19, 2);
alter table gs_league_competition_player_totals add column player_type varchar(10);
alter table gs_league_competition_player_totals add column remarks mediumtext;

alter table gs_league_roster add column  member_from date;
# alter table gs_league_roster add column  new_player_until date;
alter table gs_league_roster add column  regular_member_after smallint;

-- 12-Dec-2024
alter table gs_competition add column publish_time time;