-- 
-- Created by SQL::Translator::Producer::MySQL
-- Created on Fri Aug 20 10:23:23 2010
-- 
SET foreign_key_checks=0;

DROP TABLE IF EXISTS `dbix_class_schema_versions`;

--
-- Table: `dbix_class_schema_versions`
--
CREATE TABLE `dbix_class_schema_versions` (
  `version` varchar(10) NOT NULL,
  `installed` varchar(20) NOT NULL,
  PRIMARY KEY (`version`)
);

DROP TABLE IF EXISTS `role`;

--
-- Table: `role`
--
CREATE TABLE `role` (
  `id` integer unsigned NOT NULL auto_increment,
  `role` varchar(25) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE `Index_2` (`role`)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `session`;

--
-- Table: `session`
--
CREATE TABLE `session` (
  `id` char(72) NOT NULL,
  `session_data` text,
  `expires` integer unsigned,
  PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `user`;

--
-- Table: `user`
--
CREATE TABLE `user` (
  `id` integer unsigned NOT NULL auto_increment,
  `username` varchar(45) NOT NULL,
  `password` varchar(40) NOT NULL,
  `email` varchar(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE `Index_2` (`username`)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `modscope`;

--
-- Table: `modscope`
--
CREATE TABLE `modscope` (
  `id` integer unsigned NOT NULL auto_increment,
  `user_id` integer unsigned NOT NULL,
  `name` varchar(45) NOT NULL,
  INDEX `modscope_idx_user_id` (`user_id`),
  PRIMARY KEY (`id`),
  UNIQUE `uniq_name` (`name`),
  CONSTRAINT `modscope_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `scm`;

--
-- Table: `scm`
--
CREATE TABLE `scm` (
  `id` integer unsigned NOT NULL auto_increment,
  `user_id` integer unsigned NOT NULL,
  `software` varchar(15) NOT NULL,
  `repo_url` varchar(255) NOT NULL,
  `settings` text NOT NULL,
  `revision` varchar(45),
  `auto_discover_request` datetime,
  `auto_discover_response` text,
  INDEX `scm_idx_user_id` (`user_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `scm_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `user_role`;

--
-- Table: `user_role`
--
CREATE TABLE `user_role` (
  `user_id` integer unsigned NOT NULL,
  `role_id` integer unsigned NOT NULL,
  INDEX `user_role_idx_role_id` (`role_id`),
  INDEX `user_role_idx_user_id` (`user_id`),
  PRIMARY KEY (`user_id`, `role_id`),
  CONSTRAINT `user_role_fk_role_id` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `user_role_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `module`;

--
-- Table: `module`
--
CREATE TABLE `module` (
  `id` integer unsigned NOT NULL auto_increment,
  `scm_id` integer unsigned,
  `modscope_id` integer unsigned NOT NULL,
  `name` varchar(45) NOT NULL,
  `desc` varchar(255) NOT NULL,
  `scm_settings` text NOT NULL,
  INDEX `module_idx_modscope_id` (`modscope_id`),
  INDEX `module_idx_scm_id` (`scm_id`),
  PRIMARY KEY (`id`),
  UNIQUE `Index_3` (`modscope_id`, `name`),
  CONSTRAINT `module_fk_modscope_id` FOREIGN KEY (`modscope_id`) REFERENCES `modscope` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `module_fk_scm_id` FOREIGN KEY (`scm_id`) REFERENCES `scm` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `module_version`;

--
-- Table: `module_version`
--
CREATE TABLE `module_version` (
  `id` integer unsigned NOT NULL auto_increment,
  `module_id` integer unsigned NOT NULL,
  `version` varchar(10) NOT NULL,
  `remote_location` varchar(255),
  `archive` longblob,
  INDEX `module_version_idx_module_id` (`module_id`),
  PRIMARY KEY (`id`),
  UNIQUE `Index_3` (`module_id`, `version`),
  CONSTRAINT `module_version_fk_module_id` FOREIGN KEY (`module_id`) REFERENCES `module` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `module_dependency`;

--
-- Table: `module_dependency`
--
CREATE TABLE `module_dependency` (
  `id` integer unsigned NOT NULL auto_increment,
  `module_version_id` integer unsigned NOT NULL,
  `modscope` varchar(45) NOT NULL,
  `modname` varchar(45) NOT NULL,
  INDEX `module_dependency_idx_module_version_id` (`module_version_id`),
  PRIMARY KEY (`id`),
  UNIQUE `Index_3` (`module_version_id`, `modscope`, `modname`),
  CONSTRAINT `module_dependency_fk_module_version_id` FOREIGN KEY (`module_version_id`) REFERENCES `module_version` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

SET foreign_key_checks=1;

