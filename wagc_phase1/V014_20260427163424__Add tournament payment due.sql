-- Tournament Payment: 14-Apr-2026
ALTER TABLE gs_competition add column payment_due_on datetime;
ALTER TABLE gs_competition add column cancel_on_payment_default char(1) NOT NULL DEFAULT 'N';
ALTER TABLE gs_competition add column cancel_guard_mins smallint NOT NULL DEFAULT 60;
ALTER TABLE gs_competition_player add column payment_warning_sent_at datetime;