-- Convert schema 'sql\Maximus-Schema-0.001-SQLite.sql' to 'sql\Maximus-Schema-0.002-SQLite.sql':;

BEGIN;

CREATE TABLE scm (
  id INTEGER PRIMARY KEY NOT NULL,
  user_id integer NOT NULL,
  software varchar(15) NOT NULL,
  repo_url varchar(255) NOT NULL,
  settings text NOT NULL
);

CREATE INDEX scm_idx_user_id ON scm (user_id);

CREATE TEMPORARY TABLE module_temp_alter (
  id INTEGER PRIMARY KEY NOT NULL,
  scm_id integer,
  modscope_id integer NOT NULL,
  name varchar(45) NOT NULL,
  desc varchar(255) NOT NULL
);

INSERT INTO module_temp_alter SELECT id, scm_id, modscope_id, name, desc FROM module;

DROP TABLE module;

CREATE TABLE module (
  id INTEGER PRIMARY KEY NOT NULL,
  scm_id integer,
  modscope_id integer NOT NULL,
  name varchar(45) NOT NULL,
  desc varchar(255) NOT NULL
);

CREATE INDEX module_idx_modscope_id03 ON module (modscope_id);

CREATE INDEX module_idx_scm_id03 ON module (scm_id);

CREATE UNIQUE INDEX Index_305 ON module (modscope_id, name);

INSERT INTO module SELECT id, scm_id, modscope_id, name, desc FROM module_temp_alter;

DROP TABLE module_temp_alter;


COMMIT;

