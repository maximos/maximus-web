-- 
-- Created by SQL::Translator::Producer::MySQL
-- Created on Sat Mar  6 23:10:43 2010
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

DROP TABLE IF EXISTS `modscope`;

--
-- Table: `modscope`
--
CREATE TABLE `modscope` (
  `id` integer(10) unsigned NOT NULL auto_increment,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`, `name`)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `module`;

--
-- Table: `module`
--
CREATE TABLE `module` (
  `id` integer(10) unsigned NOT NULL auto_increment,
  `modscope_id` integer(10) unsigned NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `desc` VARCHAR(255) NOT NULL,
  `source` VARCHAR(255),
  `source_options` text,
  INDEX module_idx_modscope_id (`modscope_id`),
  PRIMARY KEY (`id`),
  UNIQUE `Index_3` (`modscope_id`, `name`),
  CONSTRAINT `module_fk_modscope_id` FOREIGN KEY (`modscope_id`) REFERENCES `modscope` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `module_version`;

--
-- Table: `module_version`
--
CREATE TABLE `module_version` (
  `id` integer(10) unsigned NOT NULL auto_increment,
  `module_id` integer(10) unsigned NOT NULL,
  `version` VARCHAR(10) NOT NULL,
  `archive_location` VARCHAR(255) NOT NULL,
  INDEX module_version_idx_module_id (`module_id`),
  PRIMARY KEY (`id`),
  UNIQUE `Index_3` (`module_id`, `version`),
  CONSTRAINT `module_version_fk_module_id` FOREIGN KEY (`module_id`) REFERENCES `module` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `module_dependency`;

--
-- Table: `module_dependency`
--
CREATE TABLE `module_dependency` (
  `id` integer(10) unsigned NOT NULL auto_increment,
  `modscope_id` integer(10) unsigned NOT NULL,
  `module_id` integer(10) unsigned NOT NULL,
  `module_version_id` integer(10) unsigned NOT NULL,
  INDEX module_dependency_idx_modscope_id (`modscope_id`),
  INDEX module_dependency_idx_module_id (`module_id`),
  INDEX module_dependency_idx_module_version_id (`module_version_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `module_dependency_fk_modscope_id` FOREIGN KEY (`modscope_id`) REFERENCES `modscope` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `module_dependency_fk_module_id` FOREIGN KEY (`module_id`) REFERENCES `module` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `module_dependency_fk_module_version_id` FOREIGN KEY (`module_version_id`) REFERENCES `module_version` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

SET foreign_key_checks=1;

