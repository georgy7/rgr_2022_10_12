-- Convert schema '/home/guest/rgr_2022_10_12/PhoneBook/db/migrations/_source/deploy/1/001-auto.yml' to '/home/guest/rgr_2022_10_12/PhoneBook/db/migrations/_source/deploy/2/001-auto.yml':;

;
BEGIN;

;
CREATE TABLE "book" (
  "book_id" INTEGER PRIMARY KEY NOT NULL,
  "created" timestamp NOT NULL
);

;

COMMIT;

