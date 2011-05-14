-- Convert schema 'sql\Maximus-Schema-0.004-SQLite.sql' to 'sql\Maximus-Schema-0.005-SQLite.sql':;

BEGIN;

ALTER TABLE announcement ADD COLUMN message_type varchar(45) NOT NULL;

ALTER TABLE announcement ADD COLUMN meta_data text;


COMMIT;

