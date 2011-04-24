-- Convert schema 'sql\Maximus-Schema-0.002-SQLite.sql' to 'sql\Maximus-Schema-0.003-SQLite.sql':;

BEGIN;

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

CREATE TEMPORARY TABLE scm_temp_alter (
  id INTEGER PRIMARY KEY NOT NULL,
  software varchar(15) NOT NULL,
  repo_url varchar(255) NOT NULL,
  settings text NOT NULL,
  revision varchar(45),
  auto_discover_request datetime,
  auto_discover_response text
);

INSERT INTO scm_temp_alter SELECT id, software, repo_url, settings, revision, auto_discover_request, auto_discover_response FROM scm;

DROP TABLE scm;

CREATE TABLE scm (
  id INTEGER PRIMARY KEY NOT NULL,
  software varchar(15) NOT NULL,
  repo_url varchar(255) NOT NULL,
  settings text NOT NULL,
  revision varchar(45),
  auto_discover_request datetime,
  auto_discover_response text
);

INSERT INTO scm SELECT id, software, repo_url, settings, revision, auto_discover_request, auto_discover_response FROM scm_temp_alter;

DROP TABLE scm_temp_alter;


COMMIT;

