-- 
-- Created by SQL::Translator::Producer::PostgreSQL
-- Created on Tue Nov 25 19:16:43 2014
-- 
--
-- Table: Gnarly.
--
DROP TABLE "Gnarly" CASCADE;
CREATE TABLE "Gnarly" (
  "id" integer NOT NULL,
  "name" character varying NOT NULL,
  "literature" text,
  "your_mom" bytea,
  PRIMARY KEY ("id")
);

--
-- Table: HasDateOps.
--
DROP TABLE "HasDateOps" CASCADE;
CREATE TABLE "HasDateOps" (
  "id" integer NOT NULL,
  "a_date" timestamp NOT NULL,
  "b_date" timestamp,
  PRIMARY KEY ("id")
);

