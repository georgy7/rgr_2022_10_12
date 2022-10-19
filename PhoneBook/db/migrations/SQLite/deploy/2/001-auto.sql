--
-- Created by SQL::Translator::Producer::SQLite
-- Created on Wed Oct 19 01:47:21 2022
--

;
BEGIN TRANSACTION;
--
-- Table: "book"
--
CREATE TABLE "book" (
  "book_id" INTEGER PRIMARY KEY NOT NULL,
  "created" timestamp NOT NULL
);
COMMIT;
