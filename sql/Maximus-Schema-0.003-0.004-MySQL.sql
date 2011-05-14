-- Convert schema 'sql\Maximus-Schema-0.003-MySQL.sql' to 'Maximus::Schema v0.004':;

BEGIN;

SET foreign_key_checks=0;

CREATE TABLE `announcement` (
  `id` integer unsigned NOT NULL auto_increment,
  `date` datetime NOT NULL,
  `message` text NOT NULL,
  PRIMARY KEY (`id`)
);

SET foreign_key_checks=1;


COMMIT;

