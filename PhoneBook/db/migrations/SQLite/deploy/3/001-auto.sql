--
-- Created by SQL::Translator::Producer::SQLite
-- Created on Wed Oct 19 05:30:52 2022
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
--
-- Table: "book_record"
--
CREATE TABLE "book_record" (
  "book_record_id" INTEGER PRIMARY KEY NOT NULL,
  "book_id" integer NOT NULL,
  "name" varchar NOT NULL,
  "phone" varchar(20) NOT NULL,
  FOREIGN KEY ("book_id") REFERENCES "book"("book_id") ON UPDATE CASCADE
);
CREATE INDEX "book_record_idx_book_id" ON "book_record" ("book_id");
COMMIT;
