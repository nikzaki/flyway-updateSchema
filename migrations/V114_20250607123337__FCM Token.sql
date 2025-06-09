
-- FCM
CREATE TABLE gs_fcm_token (
    id                bigint(20) NOT NULL AUTO_INCREMENT,
    fcm_token         varchar(255) NOT NULL,
    platform          varchar(10),
    created_ts        datetime NULL,
    last_updated_ts   datetime NULL,
    fk_authentication int(10),
    CONSTRAINT gs_fcm_token
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;
CREATE UNIQUE INDEX IDX_gs_fcm_token
    ON gs_fcm_token (fcm_token);
ALTER TABLE gs_fcm_token ADD CONSTRAINT fk_fcm_token_ref_user FOREIGN KEY (fk_authentication) REFERENCES gs_authentication (id) ON UPDATE Cascade ON DELETE Cascade;

CREATE TABLE gs_fcm_notification (
    id                bigint(20) NOT NULL AUTO_INCREMENT,
    title             varchar(255),
    content           varchar(1024),
    topic             varchar(100),
    created_at        datetime NULL,
    sent              char(1) DEFAULT 'N' NOT NULL,
    notification_sent datetime NULL,
    data              mediumtext,
    target            mediumtext,
    CONSTRAINT pk_fcm_notification
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;
 