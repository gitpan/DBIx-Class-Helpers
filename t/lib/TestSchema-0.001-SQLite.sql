-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Mon May 26 19:33:03 2014
-- 

BEGIN TRANSACTION;

--
-- Table: Bloaty
--
CREATE TABLE Bloaty (
  id INTEGER PRIMARY KEY NOT NULL,
  name varchar NOT NULL,
  literature text,
  your_mom blob
);

--
-- Table: Gnarly
--
CREATE TABLE Gnarly (
  id INTEGER PRIMARY KEY NOT NULL,
  name varchar NOT NULL,
  literature text,
  your_mom blob
);

--
-- Table: HasDateOps
--
CREATE TABLE HasDateOps (
  id INTEGER PRIMARY KEY NOT NULL,
  a_date datetime NOT NULL,
  b_date datetime
);

--
-- Table: Station
--
CREATE TABLE Station (
  id INTEGER PRIMARY KEY NOT NULL,
  name varchar NOT NULL
);

--
-- Table: Bar
--
CREATE TABLE Bar (
  id INTEGER PRIMARY KEY NOT NULL,
  foo_id integer NOT NULL,
  FOREIGN KEY (foo_id) REFERENCES Foo(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE INDEX Bar_idx_foo_id ON Bar (foo_id);

--
-- Table: Foo
--
CREATE TABLE Foo (
  id INTEGER PRIMARY KEY NOT NULL,
  bar_id integer NOT NULL,
  FOREIGN KEY (bar_id) REFERENCES Bar(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE INDEX Foo_idx_bar_id ON Foo (bar_id);

--
-- Table: Foo_Bar
--
CREATE TABLE Foo_Bar (
  foo_id integer NOT NULL,
  bar_id integer(12) NOT NULL,
  PRIMARY KEY (foo_id, bar_id),
  FOREIGN KEY (bar_id) REFERENCES Bar(id),
  FOREIGN KEY (foo_id) REFERENCES Foo(id)
);

CREATE INDEX Foo_Bar_idx_bar_id ON Foo_Bar (bar_id);

CREATE INDEX Foo_Bar_idx_foo_id ON Foo_Bar (foo_id);

--
-- Table: Gnarly_Station
--
CREATE TABLE Gnarly_Station (
  gnarly_id int NOT NULL,
  station_id int NOT NULL,
  PRIMARY KEY (gnarly_id, station_id),
  FOREIGN KEY (gnarly_id) REFERENCES Gnarly(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (station_id) REFERENCES Station(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE INDEX Gnarly_Station_idx_gnarly_id ON Gnarly_Station (gnarly_id);

CREATE INDEX Gnarly_Station_idx_station_id ON Gnarly_Station (station_id);

COMMIT;
