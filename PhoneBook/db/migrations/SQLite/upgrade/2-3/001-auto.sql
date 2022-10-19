-- Convert schema '/home/guest/rgr_2022_10_12/PhoneBook/db/migrations/_source/deploy/2/001-auto.yml' to '/home/guest/rgr_2022_10_12/PhoneBook/db/migrations/_source/deploy/3/001-auto.yml':;

;
BEGIN;

;
CREATE TABLE "book_record" (
  "book_record_id" INTEGER PRIMARY KEY NOT NULL,
  "book_id" integer NOT NULL,
  "name" varchar NOT NULL,
  "phone" varchar(20) NOT NULL,
  FOREIGN KEY ("book_id") REFERENCES "book"("book_id") ON UPDATE CASCADE
);

;
CREATE INDEX "book_record_idx_book_id" ON "book_record" ("book_id");

;

COMMIT;

