-- Convert schema 'sql\Maximus-Schema-0.001-MySQL.sql' to 'Maximus::Schema v0.002':;

BEGIN;

SET foreign_key_checks=0;

CREATE TABLE `scm` (
  id integer unsigned NOT NULL auto_increment,
  software varchar(15) NOT NULL,
  repo_url varchar(255) NOT NULL,
  settings text NOT NULL,
  revision varchar(45),
  auto_discover_request datetime,
  auto_discover_response text,
  PRIMARY KEY (id)
) ENGINE=InnoDB;

SET foreign_key_checks=1;

ALTER TABLE modscope DROP FOREIGN KEY modscope_fk_user_id,
                     DROP INDEX modscope_idx_user_id,
                     DROP COLUMN user_id;

ALTER TABLE module DROP COLUMN source,
                   DROP COLUMN source_type,
                   DROP COLUMN source_options,
                   ADD COLUMN scm_id integer unsigned,
                   ADD COLUMN scm_settings text NOT NULL,
                   ADD INDEX module_idx_scm_id (scm_id),
                   ADD CONSTRAINT module_fk_scm_id FOREIGN KEY (scm_id) REFERENCES scm (id) ON DELETE CASCADE ON UPDATE CASCADE;


COMMIT;

