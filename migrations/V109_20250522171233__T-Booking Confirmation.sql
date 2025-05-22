-- T-Booking Confirmation

alter table gs_tee_time_booking_options add column confirmation_required char(1) default 'N';
alter table gs_tee_time_booking_options add column fk_agreement_partner varchar(30);
ALTER TABLE gs_tee_time_booking_options ADD CONSTRAINT fk_tbooking_agmt_partner_ref_parner FOREIGN KEY (fk_agreement_partner) REFERENCES gs_discount_company (id) ON UPDATE Cascade ON DELETE Restrict;


alter table gs_tee_time_booking add column booking_confirmation_status char(1) default 'C';
alter table gs_tee_time_booking add column fk_booking_confirmed_by int(10);
alter table gs_tee_time_booking add column fk_booking_rejected_by int(10);
alter table gs_tee_time_booking add column fk_agreement_partner varchar(30);
ALTER TABLE gs_tee_time_booking ADD CONSTRAINT fk_tbooking_agmt_partner_ref_partner FOREIGN KEY (fk_agreement_partner) REFERENCES gs_discount_company (id) ON UPDATE Cascade ON DELETE Restrict;

ALTER TABLE gs_tee_time_booking ADD CONSTRAINT fk_tbooking_confirm_ref_auth FOREIGN KEY (fk_booking_confirmed_by) REFERENCES gs_authentication (id) ON UPDATE Cascade ON DELETE Set null;
ALTER TABLE gs_tee_time_booking ADD CONSTRAINT fk_tbooking_rej_ref_auth FOREIGN KEY (fk_booking_rejected_by) REFERENCES gs_authentication (id) ON UPDATE Cascade ON DELETE Set null;