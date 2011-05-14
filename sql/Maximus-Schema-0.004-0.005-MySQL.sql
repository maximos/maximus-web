-- Convert schema 'sql\Maximus-Schema-0.004-MySQL.sql' to 'Maximus::Schema v0.005':;

BEGIN;

ALTER TABLE announcement ADD COLUMN message_type varchar(45) NOT NULL,
                         ADD COLUMN meta_data text;


COMMIT;

