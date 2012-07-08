-- Convert schema 'sql/Maximus-Schema-1.000000-MySQL.sql' to 'Maximus::Schema v1.000001':;

BEGIN;

ALTER TABLE module DROP FOREIGN KEY module_fk_scm_id;

ALTER TABLE module ADD CONSTRAINT module_fk_scm_id FOREIGN KEY (scm_id) REFERENCES scm (id) ON DELETE SET NULL ON UPDATE SET NULL;

ALTER TABLE module_version ADD COLUMN meta_data text;


COMMIT;

