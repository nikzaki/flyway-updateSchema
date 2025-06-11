-- I will execute these in Migration. You keep it for Beta and production deployment.


ALTER TABLE gs_e_invoicing_entity ADD COLUMN client_id varchar(100);
ALTER TABLE gs_e_invoicing_entity ADD COLUMN client_secret varchar(255);

CREATE TABLE gs_e_invoice_tbooking_setup
(
    id             bigint(20) NOT NULL AUTO_INCREMENT,
    booking_id     bigint(20),
    country_id     varchar(10),
    einvoice_setup mediumtext,
    request_type   char(10),
    inv_generated      char(1) DEFAULT 'N' NOT NULL,
    CONSTRAINT pk_e_invoice_tbooking_setup
        PRIMARY KEY (id)
) ENGINE=InnoDB CHARACTER SET UTF8;

CREATE TABLE gs_e_invoice (
    id                      bigint(20) NOT NULL AUTO_INCREMENT,
    internal_number         varchar(100),
    external_number         varchar(100),
    status                  char(1) DEFAULT 'P',
    document_date           date,
    amount                  decimal(19, 2) DEFAULT 0.0,
    document_type           varchar(30) DEFAULT 'I',
    buyer_type              varchar(10),
    buyer_player_id         bigint(20),
    buyer_club_id           bigint(20),
    buyer_partner_id        varchar(30),
    buyer_name              varchar(255),
    buyer_email             varchar(255),
    e_invoice_entity_buyer  mediumtext,
    seller_type             varchar(10),
    seller_name             varchar(255),
    seller_email            varchar(255),
    e_invoice_entity_seller mediumtext,
    error_code              varchar(100),
    error_message           mediumtext,
    fk_country              varchar(10) NOT NULL,
    fk_currency             char(3) NOT NULL,
    supplier_club_id        bigint(20),
    supplier_partner_id     varchar(30),
    original_item_type      varchar(30) DEFAULT 'TBooking',
    original_item_id        varchar(100),
    document                mediumtext,
    CONSTRAINT pk_e_invoice
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;
ALTER TABLE gs_e_invoice ADD CONSTRAINT fk_einvoice_ref_country FOREIGN KEY (fk_country) REFERENCES gs_country (id) ON UPDATE Cascade ON DELETE Restrict;
ALTER TABLE gs_e_invoice ADD CONSTRAINT fk_einvoice_ref_curr FOREIGN KEY (fk_currency) REFERENCES gs_currency (currency_code) ON UPDATE Cascade ON DELETE Restrict;

ALTER TABLE gs_order add column customer_e_invoice_spec mediumtext;
ALTER TABLE gs_tax_profile add column composite_tax char(1) DEFAULT 'N' NOT NULL;
ALTER TABLE gs_tax_profile add column composite_tax_spec mediumtext;