alter table gs_e_invoicing_entity add column std_industrial_code varchar(10);
alter table gs_club add column fk_e_invoice int(10);
alter table gs_discount_company add column fk_e_invoice int(10);
ALTER TABLE gs_club ADD CONSTRAINT fk_club_ref_e_invoice FOREIGN KEY (fk_e_invoice) REFERENCES gs_e_invoicing_entity (id) ON UPDATE Cascade ON DELETE Set null;
ALTER TABLE gs_discount_company ADD CONSTRAINT fk_partner_ref_e_invoice FOREIGN KEY (fk_e_invoice) REFERENCES gs_e_invoicing_entity (id) ON UPDATE Cascade ON DELETE Set null;