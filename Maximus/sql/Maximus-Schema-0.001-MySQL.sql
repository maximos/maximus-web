-- 
-- Created by SQL::Translator::Producer::MySQL
-- Created on Mon Mar 15 21:22:01 2010
-- 
SET foreign_key_checks=0;

DROP TABLE IF EXISTS `dbix_class_schema_versions`;

--
-- Table: `dbix_class_schema_versions`
--
CREATE TABLE `dbix_class_schema_versions` (
  `version` VARCHAR(10) NOT NULL,
  `installed` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`version`)
);

DROP TABLE IF EXISTS `role`;

--
-- Table: `role`
--
CREATE TABLE `role` (
  `id` integer(10) unsigned NOT NULL auto_increment,
  `role` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE `Index_2` (`role`)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `session`;

--
-- Table: `session`
--
CREATE TABLE `session` (
  `id` CHAR(72) NOT NULL,
  `session_data` text,
  `expires` integer(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `user`;

--
-- Table: `user`
--
CREATE TABLE `user` (
  `id` integer(10) unsigned NOT NULL auto_increment,
  `username` VARCHAR(45) NOT NULL,
  `password` VARCHAR(40) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE `Index_2` (`username`)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `user_role`;

--
-- Table: `user_role`
--
CREATE TABLE `user_role` (
  `user_id` integer(10) unsigned NOT NULL,
  `role_id` integer(10) unsigned NOT NULL,
  INDEX user_role_idx_role_id (`role_id`),
  INDEX user_role_idx_user_id (`user_id`),
  PRIMARY KEY (`user_id`, `role_id`),
  CONSTRAINT `user_role_fk_role_id` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `user_role_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

SET foreign_key_checks=1;

