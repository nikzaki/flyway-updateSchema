
-- Stay And Play Refund
alter table gs_refund_instance add column fk_stay_and_play_request bigint(20);
alter table gs_refund_instance add column refund_status char(1) DEFAULT 'C' CHECK ( refund_status IN ('P', 'I', 'C'));
ALTER TABLE gs_refund_instance ADD CONSTRAINT fk_refund_instance_ref_stay_play_req FOREIGN KEY (fk_stay_and_play_request) REFERENCES gs_stay_and_play_request (id) ON UPDATE Cascade ON DELETE Restrict;
