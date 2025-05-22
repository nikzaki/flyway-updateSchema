-- Add partner to Bill.

alter table gs_bill add column fk_partner varchar(30);
ALTER TABLE gs_bill ADD CONSTRAINT fk_bill_ref_partner
    FOREIGN KEY (fk_partner) REFERENCES gs_discount_company (id) ON UPDATE Cascade ON DELETE Restrict;
-- Stay And Play Payment Terms and Refund Policy
alter table gs_stay_and_play_package add column payment_terms mediumtext;
alter table gs_stay_and_play_package add column refund_policy mediumtext;

-- Stay And Play Request Payment Status
alter table gs_stay_and_play_request add column payment_status char(1) NOT NULL DEFAULT 'U';

-- Stay And Play Payment
CREATE TABLE gs_stay_and_play_payment (
    id                            int(10) NOT NULL AUTO_INCREMENT,
    fk_stay_play_request          bigint(20) NOT NULL,
    fk_bill                       bigint(20) NOT NULL,
    amount_paid                   decimal(19, 2) DEFAULT 0.0,
    fk_paying_player              bigint(20),
    paid_by_name                  varchar(255),
    paid_by_email                 varchar(255),
    paid_by_phone                 varchar(30),
    fk_payment_captured_by        int(10),
    fk_player_account_transaction bigint(20),
    fk_transaction                varchar(36),
    CONSTRAINT pk_stay_and_play_payment
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;
ALTER TABLE gs_stay_and_play_payment ADD CONSTRAINT fk_stay_paly_pmt_ref_bill FOREIGN KEY (fk_bill) REFERENCES gs_bill (bill_id) ON UPDATE Cascade ON DELETE Restrict;
ALTER TABLE gs_stay_and_play_payment ADD CONSTRAINT fk_stay_play_pmt_ref_auth FOREIGN KEY (fk_payment_captured_by) REFERENCES gs_authentication (id) ON UPDATE Cascade ON DELETE Set null;
ALTER TABLE gs_stay_and_play_payment ADD CONSTRAINT fk_stay_play_pmt_ref_club_trxn FOREIGN KEY (fk_transaction) REFERENCES gs_club_transaction (id) ON UPDATE Cascade ON DELETE Set null;
ALTER TABLE gs_stay_and_play_payment ADD CONSTRAINT fk_stay_play_pmt_ref_player FOREIGN KEY (fk_paying_player) REFERENCES gs_player (id) ON UPDATE Cascade ON DELETE Restrict;
ALTER TABLE gs_stay_and_play_payment ADD CONSTRAINT fk_stay_play_pmt_ref_plt_act_trxn FOREIGN KEY (fk_player_account_transaction) REFERENCES gs_player_club_acct_trxn (id) ON UPDATE Cascade ON DELETE Restrict;
ALTER TABLE gs_stay_and_play_payment ADD CONSTRAINT fk_stay_play_pmt_ref_req FOREIGN KEY (fk_stay_play_request) REFERENCES gs_stay_and_play_request (id) ON UPDATE Cascade ON DELETE Restrict;