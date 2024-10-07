create table gs_api_audit_log_new
(
    id                 bigint auto_increment,
    audit_date_time    datetime         not null,
    user_id            int(10)          null,
    request_url        varchar(1024)    null,
    api_type           varchar(10)      null,
    api_category       varchar(30)      not null,
    api_group          varchar(30)      null,
    api_operation      varchar(100)     not null,
    club_id            int(10)          null,
    partner_id         varchar(30)      null,
    player_id          int(10)          null,
    reference          varchar(100)     null,
    addl_reference1    varchar(100)     null,
    addl_reference2    varchar(100)     null,
    success            char default 'Y' not null,
    path_parameters    mediumtext       null,
    request_parameters mediumtext       null,
    request_body       mediumtext       null,
    request_headers    mediumtext       null,
    response_headers   mediumtext       null,
    response_body      mediumtext       null,
    exception          mediumtext       null,
    audit_date         date,
    primary key (id)
) charset = utf8;
insert into gs_api_audit_log_new select *, null from gs_api_audit_log;

-- Update the audit_date column in new table
update gs_api_audit_log_new set audit_date = date(audit_date_time) where audit_date is null;
-- Now rename the tables and
rename table gs_api_audit_log to gs_api_audit_log_old, gs_api_audit_log_new to gs_api_audit_log;

-- Drop the old table
drop table gs_api_audit_log_old;

-- now create the partitioned table
create table gs_api_audit_log_new
(
    id                 bigint auto_increment,
    audit_date_time    datetime         not null,
    user_id            int(10)          null,
    request_url        varchar(1024)    null,
    api_type           varchar(10)      null,
    api_category       varchar(30)      not null,
    api_group          varchar(30)      null,
    api_operation      varchar(100)     not null,
    club_id            int(10)          null,
    partner_id         varchar(30)      null,
    player_id          int(10)          null,
    reference          varchar(100)     null,
    addl_reference1    varchar(100)     null,
    addl_reference2    varchar(100)     null,
    success            char default 'Y' not null,
    path_parameters    mediumtext       null,
    request_parameters mediumtext       null,
    request_body       mediumtext       null,
    request_headers    mediumtext       null,
    response_headers   mediumtext       null,
    response_body      mediumtext       null,
    exception          mediumtext       null,
    audit_date         date,
    primary key (id)
) charset = utf8
    PARTITION BY RANGE (YEAR(audit_date))
        SUBPARTITION BY HASH (MONTH(audit_date))
        SUBPARTITIONS 12 (
        PARTITION p0 VALUES LESS THAN (2024),
        PARTITION p1 VALUES LESS THAN (2025),
        PARTITION p2 VALUES LESS THAN (2026),
        PARTITION p3 VALUES LESS THAN (2027),
        PARTITION p4 VALUES LESS THAN (2028),
        PARTITION p5 VALUES LESS THAN MAXVALUE
        );
-- Insert the rows into new table
insert into gs_api_audit_log_new select *, null from gs_api_audit_log;

-- Now rename the tables and
rename table gs_api_audit_log to gs_api_audit_log_old, gs_api_audit_log_new to gs_api_audit_log;
