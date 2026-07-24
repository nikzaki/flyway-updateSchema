
-- Club Changes
-- OK
ALTER TABLE gs_club ADD COLUMN club_group_main char(1) NOT NULL DEFAULT 'N';

-- Order-related changes 30-Jan-2026
-- OK
ALTER TABLE gs_order ADD COLUMN fk_order_club bigint;
ALTER TABLE gs_order ADD COLUMN fk_currency char(3);
ALTER TABLE gs_order ADD COLUMN invoice_name varchar(100);
ALTER TABLE gs_order ADD CONSTRAINT fk_order_ref_cust_club FOREIGN KEY (fk_order_club) REFERENCES gs_club (id) ON UPDATE Cascade ON DELETE Restrict;
ALTER TABLE gs_order ADD CONSTRAINT fk_order_ref_currency FOREIGN KEY (fk_currency) REFERENCES gs_currency (currency_code) ON UPDATE Cascade ON DELETE Restrict;

ALTER TABLE gs_product_package ADD COLUMN consolidated_price char(1) NOT NULL DEFAULT 'N';
ALTER TABLE gs_product_package ADD COLUMN package_price decimal(19,2);

-- OK
CREATE TABLE gs_product_category (
    id           int(10) NOT NULL AUTO_INCREMENT,
    name         varchar(100) NOT NULL,
    description  mediumtext,
    fk_club      bigint(20) NOT NULL,
    fnb_category char(1) DEFAULT 'N' NOT NULL,
    CONSTRAINT pk_price_component_category
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;
-- OK
CREATE TABLE gs_product_group (
    id                    int(10) NOT NULL AUTO_INCREMENT,
    name                  varchar(100) NOT NULL,
    description           mediumtext,
    image                 varchar(1024),
    fk_club               bigint(20) NOT NULL,
    fk_product_category int(10) NOT NULL,
    tags                  varchar(2000),
    CONSTRAINT pk_price_component_group
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;
ALTER TABLE gs_product_category ADD CONSTRAINT fk_comp_category_ref_club FOREIGN KEY (fk_club) REFERENCES gs_club (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_product_group ADD CONSTRAINT fk_price_comp_grp_ref_catg FOREIGN KEY (fk_product_category) REFERENCES gs_product_category (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_product_group ADD CONSTRAINT fk_price_comp_grp_ref_club FOREIGN KEY (fk_club) REFERENCES gs_club (id) ON UPDATE Cascade ON DELETE Cascade;

ALTER TABLE gs_tee_time_price_component ADD COLUMN fk_product_group INT;
ALTER TABLE gs_tee_time_price_component ADD CONSTRAINT fk_pricing_comp_ref_group FOREIGN KEY (fk_product_group) REFERENCES gs_product_group (id) ON UPDATE Cascade ON DELETE Set null;
ALTER TABLE gs_tee_time_price_component ADD COLUMN tags varchar(2000);





CREATE TABLE gs_order_draft (
    id                     int(10) NOT NULL AUTO_INCREMENT,
    name                   varchar(100) NOT NULL,
    description            mediumtext,
    generated_invoice_name varchar(100),
    fk_club                bigint(20) NOT NULL,
    CONSTRAINT pk_order_draft
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;
CREATE TABLE gs_order_draft_item (
    id                int(10) NOT NULL AUTO_INCREMENT,
    fk_draft_order    int(10) NOT NULL,
    dynamic_quantity  char(1) DEFAULT 'N' NOT NULL,
    quantity          smallint(6) DEFAULT 1,
    fk_component_club bigint(20) NOT NULL,
    fk_component      varchar(10) NOT NULL,
    CONSTRAINT pk_order_draft_item
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;
ALTER TABLE gs_order_draft ADD CONSTRAINT fk_draft_order_ref_club FOREIGN KEY (fk_club) REFERENCES gs_club (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_order_draft_item ADD CONSTRAINT fk_order_draft_item_ref_comp FOREIGN KEY (fk_component_club, fk_component) REFERENCES gs_tee_time_price_component (fk_club, id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_order_draft_item ADD CONSTRAINT fk_order_draft_item_ref_draft_order FOREIGN KEY (fk_draft_order) REFERENCES gs_order_draft (id) ON UPDATE Cascade ON DELETE Cascade;



ALTER TABLE gs_user_role ADD COLUMN clubs_allowed varchar(2048);



-- 17-Feb-2026: Invoice Setup
ALTER TABLE gs_club_customer add column for_invoice_group char(1) DEFAULT  'N' NOT NULL;

CREATE TABLE gs_league_season_participating_club (
    id                    int(10) NOT NULL AUTO_INCREMENT,
    fk_league_season      int(10) NOT NULL,
    fk_participating_club bigint(20) NOT NULL,
    CONSTRAINT gs_league_season_participating_club
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;
CREATE TABLE gs_tournament_invoice (
    id               bigint(20) NOT NULL AUTO_INCREMENT,
    fk_league_season int(10),
    fk_competition   bigint(20),
    fk_invoice_setup int(10),
    fk_player        bigint(20),
    fk_club          bigint(20),
    fk_order         bigint(20) NOT NULL,
    fk_invoice_group int(10),
    fk_stream        int(10),
    CONSTRAINT gs_tournament_invoice
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;
CREATE TABLE gs_tournament_invoice_group (
    id               int(10) NOT NULL AUTO_INCREMENT,
    fk_club          bigint(20) NOT NULL,
    fk_club_customer varchar(30) NOT NULL,
    fk_league_season int(10),
    member_club_ids  varchar(2048),
    CONSTRAINT pk_tournament_invoice_group
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;
CREATE TABLE gs_tournament_invoice_setup (
    id                           int(10) NOT NULL AUTO_INCREMENT,
    invoice_name                 varchar(100) NOT NULL,
    fk_league_season             int(10),
    fk_competition               bigint(20),
    fk_stream                    int(10),
    generate_for_each_player     char(1) DEFAULT 'N' NOT NULL,
    generate_for_each_guest      char(1) DEFAULT 'N' NOT NULL,
    include_player_count_item    char(1) DEFAULT 'N' NOT NULL,
    fk_player_count_product_club bigint(20),
    fk_player_count_product      varchar(10),
    include_guest_count_item     char(1) DEFAULT 'N' NOT NULL,
    fk_guest_count_product_club  bigint(20),
    fk_guest_count_product       varchar(10),
    fk_order_draft               int(10),
    fk_currency                  char(3),
    invoice_setup_association    mediumtext,
    CONSTRAINT pk_tournament_invoice_setup
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;
ALTER TABLE gs_tournament_invoice_setup ADD CONSTRAINT fk_tournament_inv_setup_ref_comp FOREIGN KEY (fk_competition) REFERENCES gs_competition (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_tournament_invoice_setup ADD CONSTRAINT fk_tournament_inv_setup_ref_curr FOREIGN KEY (fk_currency) REFERENCES gs_currency (currency_code) ON UPDATE Cascade ON DELETE Set null;
ALTER TABLE gs_tournament_invoice_setup ADD CONSTRAINT fk_tournament_inv_setup_ref_guest_cnt_prd FOREIGN KEY (fk_guest_count_product_club, fk_guest_count_product) REFERENCES gs_tee_time_price_component (fk_club, id) ON UPDATE Cascade ON DELETE Restrict;
ALTER TABLE gs_tournament_invoice_setup ADD CONSTRAINT fk_tournament_inv_setup_ref_league_season FOREIGN KEY (fk_league_season) REFERENCES gs_league_season (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_tournament_invoice_setup ADD CONSTRAINT fk_tournament_inv_setup_ref_plr_cnt_prd FOREIGN KEY (fk_player_count_product_club, fk_player_count_product) REFERENCES gs_tee_time_price_component (fk_club, id) ON UPDATE Cascade ON DELETE Restrict;
ALTER TABLE gs_tournament_invoice_setup ADD CONSTRAINT fk_tournament_inv_setup_ref_stream FOREIGN KEY (fk_stream) REFERENCES gs_competition_stream (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_tournament_invoice_setup ADD CONSTRAINT fk_tournament_inv_setup_reg_ord_draft FOREIGN KEY (fk_order_draft) REFERENCES gs_order_draft (id) ON UPDATE Cascade ON DELETE Restrict;


ALTER TABLE gs_league_season_participating_club ADD CONSTRAINT fk_season_participating_club_ref_club FOREIGN KEY (fk_participating_club) REFERENCES gs_club (id) ON UPDATE Cascade ON DELETE Restrict;
ALTER TABLE gs_league_season_participating_club ADD CONSTRAINT fk_season_participating_club_ref_season FOREIGN KEY (fk_league_season) REFERENCES gs_league_season (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_tournament_invoice_group ADD CONSTRAINT fk_tournament_inv_grp_ref_club_cust FOREIGN KEY (fk_club, fk_club_customer) REFERENCES gs_club_customer (fk_club, customer_code) ON UPDATE Cascade ON DELETE Restrict;
ALTER TABLE gs_tournament_invoice_group ADD CONSTRAINT fk_tournament_inv_grp_ref_league_season FOREIGN KEY (fk_league_season) REFERENCES gs_league_season (id) ON UPDATE Cascade ON DELETE Restrict;

ALTER TABLE gs_tournament_invoice ADD CONSTRAINT fk_tournament_inv_ref_comp FOREIGN KEY (fk_competition) REFERENCES gs_competition (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_tournament_invoice ADD CONSTRAINT fk_tournament_inv_ref_cust_club FOREIGN KEY (fk_club) REFERENCES gs_club (id) ON UPDATE Cascade ON DELETE Set null;
ALTER TABLE gs_tournament_invoice ADD CONSTRAINT fk_tournament_inv_ref_inv_grp FOREIGN KEY (fk_invoice_group) REFERENCES gs_tournament_invoice_group (id) ON UPDATE Cascade ON DELETE Restrict;
ALTER TABLE gs_tournament_invoice ADD CONSTRAINT fk_tournament_inv_ref_league_season FOREIGN KEY (fk_league_season) REFERENCES gs_league_season (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_tournament_invoice ADD CONSTRAINT fk_tournament_inv_ref_order FOREIGN KEY (fk_order) REFERENCES gs_order (id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_tournament_invoice ADD CONSTRAINT fk_tournament_inv_ref_player FOREIGN KEY (fk_player) REFERENCES gs_player (id) ON UPDATE Cascade ON DELETE Set null;
ALTER TABLE gs_tournament_invoice ADD CONSTRAINT fk_tournament_inv_ref_setup FOREIGN KEY (fk_invoice_setup) REFERENCES gs_tournament_invoice_setup (id) ON UPDATE Cascade ON DELETE Set null;
ALTER TABLE gs_tournament_invoice ADD CONSTRAINT fk_tournament_inv_ref_stream FOREIGN KEY (fk_stream) REFERENCES gs_competition_stream (id);

-- 24-Feb-2026
ALTER TABLE gs_club ADD COLUMN fk_default_currency char(3);
ALTER TABLE gs_club ADD CONSTRAINT fk_club_ref_curr FOREIGN KEY (fk_default_currency) REFERENCES gs_currency (currency_code) ON UPDATE Cascade ON DELETE Set null;

# ALTER TABLE gs_tournament_invoice_setup add column fk_currency char(3);
# ALTER TABLE gs_tournament_invoice_setup ADD CONSTRAINT fk_tournament_inv_setup_ref_curr FOREIGN KEY (fk_currency) REFERENCES gs_currency (currency_code) ON UPDATE Cascade ON DELETE Set null;

-- 25-Feb-2026
CREATE TABLE gs_product_price (
    id                    int(10) NOT NULL AUTO_INCREMENT,
    fk_club               bigint(20),
    fk_component          varchar(10),
    start_date            date NOT NULL,
    end_date              date NOT NULL,
    unit_price            decimal(19, 2) DEFAULT 0.0 NOT NULL,
    multi_currency_prices mediumtext,
    fk_product_package    int(10),
    CONSTRAINT pk_order_component_price
        PRIMARY KEY (id)) ENGINE=InnoDB CHARACTER SET UTF8;
ALTER TABLE gs_product_price ADD CONSTRAINT fk_ord_comp_price_ref_comp FOREIGN KEY (fk_club, fk_component) REFERENCES gs_tee_time_price_component (fk_club, id) ON UPDATE Cascade ON DELETE Cascade;
ALTER TABLE gs_product_price ADD CONSTRAINT fk_prod_price_hist_ref_pkg FOREIGN KEY (fk_product_package) REFERENCES gs_product_package (id) ON UPDATE Cascade ON DELETE Cascade;

CREATE OR REPLACE VIEW gv_product_with_current_price AS
    SELECT club.club_name,
           concat(prod.fk_club, '-', prod.id) product_key,
           prod.*, prod_price.start_date, prod_price.end_date, prod_price.unit_price, prod_price.multi_currency_prices
    FROM gs_tee_time_price_component prod
             JOIN gs_club club ON club.id = prod.fk_club
             LEFT JOIN gs_product_price prod_price ON prod.id = prod_price.fk_component AND prod_price.start_date <= CURDATE() AND prod_price.end_date >= CURDATE();

ALTER TABLE gs_order_item ADD COLUMN fk_product_package int;
ALTER TABLE gs_order_item ADD CONSTRAINT fk_order_item_ref_pkg FOREIGN KEY (fk_product_package) REFERENCES gs_product_package (id) ON UPDATE Cascade ON DELETE Restrict;

ALTER TABLE gs_club ADD COLUMN supported_currencies varchar(255);

ALTER TABLE gs_product_package ADD COLUMN fk_tax_profile_club bigint (20);
ALTER TABLE gs_product_package ADD COLUMN fk_tax_profile varchar(30);
ALTER TABLE gs_product_package ADD CONSTRAINT fk_prod_pkg_ref_tax_profile FOREIGN KEY (fk_tax_profile_club, fk_tax_profile) REFERENCES gs_tax_profile (fk_club, id) ON UPDATE Cascade ON DELETE Set null;


ALTER TABLE gs_order_item ADD COLUMN adhoc_price char(1) DEFAULT 'Y' NOT NULL;

-- 6-Mar-2026
ALTER TABLE gs_order_draft_item MODIFY COLUMN fk_component_club bigint(20) NULL;
ALTER TABLE gs_order_draft_item MODIFY COLUMN fk_component varchar(10) NULL;
ALTER TABLE gs_order_draft_item ADD COLUMN fk_product_package int;
ALTER TABLE gs_order_draft_item ADD CONSTRAINT fk_order_draft_ref_prod_pkg FOREIGN KEY (fk_product_package) REFERENCES gs_product_package (id) ON UPDATE Cascade ON DELETE Cascade;


-- 7 Mar 2026
ALTER TABLE gs_league_roster ADD COLUMN fk_participating_club bigint(20);
ALTER TABLE gs_league_season_guest ADD COLUMN fk_participating_club bigint(20);
ALTER TABLE gs_league_roster ADD CONSTRAINT fk_league_roster_ref_participating_club FOREIGN KEY (fk_participating_club) REFERENCES gs_club (id) ON UPDATE Cascade ON DELETE Set null;
ALTER TABLE gs_league_season_guest ADD CONSTRAINT fk_league_invitee_ref_participating_club FOREIGN KEY (fk_participating_club) REFERENCES gs_club (id) ON UPDATE Cascade ON DELETE Cascade;


ALTER TABLE gs_tournament_invoice_setup ADD COLUMN  repeat_products char(1) DEFAULT 'N' NOT NULL;
ALTER TABLE gs_tournament_invoice_setup ADD COLUMN  repeat_packages char(1) DEFAULT 'N' NOT NULL;

ALTER TABLE gs_order_payment ADD COLUMN payment_doc_proof varchar(1024);

ALTER TABLE gs_club_invoice_stream modify column temporal_prefix_format varchar(30) NULL ;
ALTER TABLE gs_order ADD COLUMN order_or_invoice char(1) DEFAULT 'B' NOT NULL;
ALTER TABLE gs_order ADD COLUMN invoice_date date;
ALTER TABLE gs_club_invoice_stream  ADD COLUMN sequence_length smallint DEFAULT 4 NOT NULL;

ALTER TABLE gs_club ADD COLUMN club_features mediumtext;
ALTER TABLE gs_order_payment ADD COLUMN verified char(1) DEFAULT 'Y' NOT NULL;
ALTER TABLE gs_order_payment ADD COLUMN fk_verified_by int;
ALTER TABLE gs_order_payment ADD CONSTRAINT fk_order_pmt_verification_ref_user FOREIGN KEY (fk_verified_by) REFERENCES gs_authentication (id) ON UPDATE Cascade ON DELETE Set null;


ALTER TABLE gs_order ADD COLUMN unverified_payment decimal(19, 2) DEFAULT 0.0 NOT NULL;

ALTER TABLE gs_order ADD COLUMN sent char(1) DEFAULT 'N' NOT NULL;
ALTER TABLE gs_order ADD COLUMN sent_at datetime;
ALTER TABLE gs_order ADD COLUMN last_updated_at datetime;

ALTER TABLE gs_tournament_invoice ADD COLUMN  regenerate_invoice char(1) DEFAULT 'N' NOT NULL;
ALTER TABLE gs_order_item modify column item_reference varchar(255);

ALTER TABLE gs_tournament_invoice_setup add column payment_terms mediumtext;
ALTER TABLE gs_tournament_invoice_setup add column remarks mediumtext;

ALTER TABLE gs_order add column payment_terms mediumtext;
ALTER TABLE gs_order add column remarks mediumtext;
