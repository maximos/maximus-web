-- 
-- Created by SQL::Translator::Producer::PostgreSQL
-- Created on Fri Feb  8 17:42:13 2013
-- 
--
-- Table: announcement
--
DROP TABLE "announcement" CASCADE;
CREATE TABLE "announcement" (
  "id" serial NOT NULL,
  "date" timestamp NOT NULL,
  "message" text NOT NULL,
  "message_type" character varying(45) NOT NULL,
  "meta_data" text,
  PRIMARY KEY ("id")
);

--
-- Table: dbix_class_schema_versions
--
DROP TABLE "dbix_class_schema_versions" CASCADE;
CREATE TABLE "dbix_class_schema_versions" (
  "version" character varying(10) NOT NULL,
  "installed" character varying(20) NOT NULL,
  PRIMARY KEY ("version")
);

--
-- Table: modscope
--
DROP TABLE "modscope" CASCADE;
CREATE TABLE "modscope" (
  "id" serial NOT NULL,
  "name" character varying(45) NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "uniq_name" UNIQUE ("name")
);

--
-- Table: role
--
DROP TABLE "role" CASCADE;
CREATE TABLE "role" (
  "id" serial NOT NULL,
  "role" character varying(25) NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "Index_2" UNIQUE ("role")
);

--
-- Table: scm
--
DROP TABLE "scm" CASCADE;
CREATE TABLE "scm" (
  "id" serial NOT NULL,
  "software" character varying(15) NOT NULL,
  "repo_url" character varying(255) NOT NULL,
  "settings" text NOT NULL,
  "revision" character varying(45),
  "auto_discover_request" timestamp,
  "auto_discover_response" text,
  PRIMARY KEY ("id")
);

--
-- Table: session
--
DROP TABLE "session" CASCADE;
CREATE TABLE "session" (
  "id" character(72) NOT NULL,
  "session_data" text,
  "expires" integer,
  PRIMARY KEY ("id")
);

--
-- Table: user
--
DROP TABLE "user" CASCADE;
CREATE TABLE "user" (
  "id" serial NOT NULL,
  "username" character varying(45) NOT NULL,
  "password" character varying(40) NOT NULL,
  "email" character varying(45) NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "Index_2" UNIQUE ("username")
);

--
-- Table: module
--
DROP TABLE "module" CASCADE;
CREATE TABLE "module" (
  "id" serial NOT NULL,
  "scm_id" integer,
  "modscope_id" integer NOT NULL,
  "name" character varying(45) NOT NULL,
  "desc" character varying(255) NOT NULL,
  "scm_settings" text NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "Index_3" UNIQUE ("modscope_id", "name")
);
CREATE INDEX "module_idx_modscope_id" on "module" ("modscope_id");
CREATE INDEX "module_idx_scm_id" on "module" ("scm_id");

--
-- Table: user_role
--
DROP TABLE "user_role" CASCADE;
CREATE TABLE "user_role" (
  "user_id" integer NOT NULL,
  "role_id" integer NOT NULL,
  PRIMARY KEY ("user_id", "role_id")
);
CREATE INDEX "user_role_idx_role_id" on "user_role" ("role_id");
CREATE INDEX "user_role_idx_user_id" on "user_role" ("user_id");

--
-- Table: module_version
--
DROP TABLE "module_version" CASCADE;
CREATE TABLE "module_version" (
  "id" serial NOT NULL,
  "module_id" integer NOT NULL,
  "version" character varying(10) NOT NULL,
  "remote_location" character varying(255),
  "archive" bytea,
  "meta_data" text,
  PRIMARY KEY ("id"),
  CONSTRAINT "Index_3" UNIQUE ("module_id", "version")
);
CREATE INDEX "module_version_idx_module_id" on "module_version" ("module_id");

--
-- Table: module_dependency
--
DROP TABLE "module_dependency" CASCADE;
CREATE TABLE "module_dependency" (
  "id" serial NOT NULL,
  "module_version_id" integer NOT NULL,
  "modscope" character varying(45) NOT NULL,
  "modname" character varying(45) NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "Index_3" UNIQUE ("module_version_id", "modscope", "modname")
);
CREATE INDEX "module_dependency_idx_module_version_id" on "module_dependency" ("module_version_id");

--
-- Foreign Key Definitions
--

ALTER TABLE "module" ADD CONSTRAINT "module_fk_modscope_id" FOREIGN KEY ("modscope_id")
  REFERENCES "modscope" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "module" ADD CONSTRAINT "module_fk_scm_id" FOREIGN KEY ("scm_id")
  REFERENCES "scm" ("id") ON DELETE SET NULL ON UPDATE SET NULL DEFERRABLE;

ALTER TABLE "user_role" ADD CONSTRAINT "user_role_fk_role_id" FOREIGN KEY ("role_id")
  REFERENCES "role" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "user_role" ADD CONSTRAINT "user_role_fk_user_id" FOREIGN KEY ("user_id")
  REFERENCES "user" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "module_version" ADD CONSTRAINT "module_version_fk_module_id" FOREIGN KEY ("module_id")
  REFERENCES "module" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "module_dependency" ADD CONSTRAINT "module_dependency_fk_module_version_id" FOREIGN KEY ("module_version_id")
  REFERENCES "module_version" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

