-- Convert schema 'sql\Maximus-Schema-0.001-SQLite.sql' to 'sql\Maximus-Schema-0.002-SQLite.sql':;

BEGIN;

CREATE TABLE scm (
  id INTEGER PRIMARY KEY NOT NULL,
  software varchar(15) NOT NULL,
  repo_url varchar(255) NOT NULL,
  settings text NOT NULL,
  revision varchar(45),
  auto_discover_request datetime,
  auto_discover_response text
);

CREATE TEMPORARY TABLE modscope_temp_alter (
  id INTEGER PRIMARY KEY NOT NULL,
  name varchar(45) NOT NULL
);

INSERT INTO modscope_temp_alter SELECT id, name FROM modscope;

DROP TABLE modscope;

CREATE TABLE modscope (
  id INTEGER PRIMARY KEY NOT NULL,
  name varchar(45) NOT NULL
);

CREATE UNIQUE INDEX uniq_name03 ON modscope (name);

INSERT INTO modscope SELECT id, name FROM modscope_temp_alter;

DROP TABLE modscope_temp_alter;

CREATE TEMPORARY TABLE module_temp_alter (
  id INTEGER PRIMARY KEY NOT NULL,
  scm_id integer,
  modscope_id integer NOT NULL,
  name varchar(45) NOT NULL,
  desc varchar(255) NOT NULL,
  scm_settings text NOT NULL
);

INSERT INTO module_temp_alter SELECT id, scm_id, modscope_id, name, desc, scm_settings FROM module;

DROP TABLE module;

CREATE TABLE module (
  id INTEGER PRIMARY KEY NOT NULL,
  scm_id integer,
  modscope_id integer NOT NULL,
  name varchar(45) NOT NULL,
  desc varchar(255) NOT NULL,
  scm_settings text NOT NULL
);

CREATE INDEX module_idx_modscope_id03 ON module (modscope_id);

CREATE INDEX module_idx_scm_id03 ON module (scm_id);

CREATE UNIQUE INDEX Index_305 ON module (modscope_id, name);

INSERT INTO module SELECT id, scm_id, modscope_id, name, desc, scm_settings FROM module_temp_alter;

DROP TABLE module_temp_alter;


COMMIT;

