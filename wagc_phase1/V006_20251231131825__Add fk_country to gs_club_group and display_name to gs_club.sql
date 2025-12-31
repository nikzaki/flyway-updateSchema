ALTER TABLE gs_club_group add column fk_country varchar(10);
ALTER TABLE gs_club_group ADD CONSTRAINT fk_club_group_ref_country
    FOREIGN KEY (fk_country) REFERENCES gs_country (id) ON UPDATE Cascade ON DELETE Set null;
ALTER TABLE gs_club add column display_name varchar(100);
