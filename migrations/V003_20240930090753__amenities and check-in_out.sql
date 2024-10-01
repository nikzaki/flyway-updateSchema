# test update ddl with flyway

###mysql
-- 13-Oct-2023 : Amenities and check-in/check-out
ALTER TABLE gs_hotel add column check_in_time time;
ALTER TABLE gs_hotel add column check_out_time time;
ALTER TABLE gs_hotel add column amenities mediumtext;
ALTER TABLE gs_club add column amenities mediumtext;