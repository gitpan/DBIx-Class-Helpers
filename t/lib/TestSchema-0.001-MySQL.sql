-- 
-- Created by SQL::Translator::Producer::MySQL
-- Created on Sat Jun 28 15:04:17 2014
-- 
SET foreign_key_checks=0;

DROP TABLE IF EXISTS `Gnarly`;

--
-- Table: `Gnarly`
--
CREATE TABLE `Gnarly` (
  `id` integer NOT NULL,
  `name` varchar(255) NOT NULL,
  `literature` text NULL,
  `your_mom` blob NULL,
  PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `HasDateOps`;

--
-- Table: `HasDateOps`
--
CREATE TABLE `HasDateOps` (
  `id` integer NOT NULL,
  `a_date` datetime NOT NULL,
  `b_date` datetime NULL,
  PRIMARY KEY (`id`)
);

SET foreign_key_checks=1;

