-- Convert schema 'sql\Maximus-Schema-0.002-MySQL.sql' to 'Maximus::Schema v0.003':;

BEGIN;

ALTER TABLE modscope DROP FOREIGN KEY modscope_fk_user_id,
                     DROP INDEX modscope_idx_user_id,
                     DROP COLUMN user_id;

ALTER TABLE scm DROP FOREIGN KEY scm_fk_user_id,
                DROP INDEX scm_idx_user_id,
                DROP COLUMN user_id;


COMMIT;

