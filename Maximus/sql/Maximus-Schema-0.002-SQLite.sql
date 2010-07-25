-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Sun Jul 25 15:35:50 2010
-- 

BEGIN TRANSACTION;

--
-- Table: scm
--
DROP TABLE scm;

CREATE TABLE scm (
  id INTEGER PRIMARY KEY NOT NULL,
  user_id integer NOT NULL,
  software varchar(15) NOT NULL,
  repo_url varchar(255) NOT NULL,
  settings text NOT NULL,
  revision varchar(45)
);

CREATE INDEX scm_idx_user_id ON scm (user_id);

--
-- Table: dbix_class_schema_versions
--
DROP TABLE dbix_class_schema_versions;

CREATE TABLE dbix_class_schema_versions (
  version varchar(10) NOT NULL,
  installed varchar(20) NOT NULL,
  PRIMARY KEY (version)
);

--
-- Table: role
--
DROP TABLE role;

CREATE TABLE role (
  id INTEGER PRIMARY KEY NOT NULL,
  role varchar(25) NOT NULL
);

CREATE UNIQUE INDEX Index_2 ON role (role);

--
-- Table: session
--
DROP TABLE session;

CREATE TABLE session (
  id char(72) NOT NULL,
  session_data text,
  expires integer,
  PRIMARY KEY (id)
);

--
-- Table: user
--
DROP TABLE user;

CREATE TABLE user (
  id INTEGER PRIMARY KEY NOT NULL,
  username varchar(45) NOT NULL,
  password varchar(40) NOT NULL,
  email varchar(45) NOT NULL
);

CREATE UNIQUE INDEX Index_202 ON user (username);

--
-- Table: modscope
--
DROP TABLE modscope;

CREATE TABLE modscope (
  id INTEGER PRIMARY KEY NOT NULL,
  user_id integer NOT NULL,
  name varchar(45) NOT NULL
);

CREATE INDEX modscope_idx_user_id ON modscope (user_id);

CREATE UNIQUE INDEX uniq_name ON modscope (name);

--
-- Table: user_role
--
DROP TABLE user_role;

CREATE TABLE user_role (
  user_id integer NOT NULL,
  role_id integer NOT NULL,
  PRIMARY KEY (user_id, role_id)
);

CREATE INDEX user_role_idx_role_id ON user_role (role_id);

CREATE INDEX user_role_idx_user_id ON user_role (user_id);

--
-- Table: module
--
DROP TABLE module;

CREATE TABLE module (
  id INTEGER PRIMARY KEY NOT NULL,
  scm_id integer,
  modscope_id integer NOT NULL,
  name varchar(45) NOT NULL,
  desc varchar(255) NOT NULL
);

CREATE INDEX module_idx_modscope_id ON module (modscope_id);

CREATE INDEX module_idx_scm_id ON module (scm_id);

CREATE UNIQUE INDEX Index_3 ON module (modscope_id, name);

--
-- Table: module_version
--
DROP TABLE module_version;

CREATE TABLE module_version (
  id INTEGER PRIMARY KEY NOT NULL,
  module_id integer NOT NULL,
  version varchar(10) NOT NULL,
  remote_location varchar(255),
  archive longblob
);

CREATE INDEX module_version_idx_module_id ON module_version (module_id);

CREATE UNIQUE INDEX Index_302 ON module_version (module_id, version);

--
-- Table: module_dependency
--
DROP TABLE module_dependency;

CREATE TABLE module_dependency (
  id INTEGER PRIMARY KEY NOT NULL,
  module_version_id integer NOT NULL,
  modscope varchar(45) NOT NULL,
  modname varchar(45) NOT NULL
);

CREATE INDEX module_dependency_idx_module_version_id ON module_dependency (module_version_id);

CREATE UNIQUE INDEX Index_303 ON module_dependency (module_version_id, modscope, modname);

COMMIT;
