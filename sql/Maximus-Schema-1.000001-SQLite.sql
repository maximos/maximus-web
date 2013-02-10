-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Sun Feb 10 10:34:22 2013
-- 

BEGIN TRANSACTION;

--
-- Table: announcement
--
DROP TABLE announcement;

CREATE TABLE announcement (
  id INTEGER PRIMARY KEY NOT NULL,
  date datetime NOT NULL,
  message text NOT NULL,
  message_type varchar(45) NOT NULL,
  meta_data text
);

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
-- Table: modscope
--
DROP TABLE modscope;

CREATE TABLE modscope (
  id INTEGER PRIMARY KEY NOT NULL,
  name varchar(45) NOT NULL
);

CREATE UNIQUE INDEX uniq_name ON modscope (name);

--
-- Table: role
--
DROP TABLE role;

CREATE TABLE role (
  id INTEGER PRIMARY KEY NOT NULL,
  role varchar(25) NOT NULL
);

CREATE UNIQUE INDEX idx_role_1 ON role (role);

--
-- Table: scm
--
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

CREATE UNIQUE INDEX idx_user_1 ON user (username);

--
-- Table: module
--
DROP TABLE module;

CREATE TABLE module (
  id INTEGER PRIMARY KEY NOT NULL,
  scm_id integer,
  modscope_id integer NOT NULL,
  name varchar(45) NOT NULL,
  desc varchar(255) NOT NULL,
  scm_settings text NOT NULL,
  FOREIGN KEY (modscope_id) REFERENCES modscope(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (scm_id) REFERENCES scm(id) ON DELETE SET NULL ON UPDATE SET NULL
);

CREATE INDEX module_idx_modscope_id ON module (modscope_id);

CREATE INDEX module_idx_scm_id ON module (scm_id);

CREATE UNIQUE INDEX idx_module_1 ON module (modscope_id, name);

--
-- Table: user_role
--
DROP TABLE user_role;

CREATE TABLE user_role (
  user_id integer NOT NULL,
  role_id integer NOT NULL,
  PRIMARY KEY (user_id, role_id),
  FOREIGN KEY (role_id) REFERENCES role(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE INDEX user_role_idx_role_id ON user_role (role_id);

CREATE INDEX user_role_idx_user_id ON user_role (user_id);

--
-- Table: module_version
--
DROP TABLE module_version;

CREATE TABLE module_version (
  id INTEGER PRIMARY KEY NOT NULL,
  module_id integer NOT NULL,
  version varchar(10) NOT NULL,
  remote_location varchar(255),
  archive longblob,
  meta_data text,
  FOREIGN KEY (module_id) REFERENCES module(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE INDEX module_version_idx_module_id ON module_version (module_id);

CREATE UNIQUE INDEX idx_module_version_1 ON module_version (module_id, version);

--
-- Table: module_dependency
--
DROP TABLE module_dependency;

CREATE TABLE module_dependency (
  id INTEGER PRIMARY KEY NOT NULL,
  module_version_id integer NOT NULL,
  modscope varchar(45) NOT NULL,
  modname varchar(45) NOT NULL,
  FOREIGN KEY (module_version_id) REFERENCES module_version(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE INDEX module_dependency_idx_module_version_id ON module_dependency (module_version_id);

CREATE UNIQUE INDEX idx_module_dependency_1 ON module_dependency (module_version_id, modscope, modname);

COMMIT;
