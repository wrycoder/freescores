CREATE TABLE IF NOT EXISTS "schema_migrations" ("version" varchar NOT NULL PRIMARY KEY);
CREATE TABLE IF NOT EXISTS "ar_internal_metadata" ("key" varchar NOT NULL PRIMARY KEY, "value" varchar, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE TABLE IF NOT EXISTS "genres" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar, "vocal" boolean, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE IF NOT EXISTS "parts" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "work_id" integer DEFAULT NULL, "instrument_id" integer DEFAULT NULL, "quantity" integer DEFAULT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_882d2f82fc"
FOREIGN KEY ("work_id")
  REFERENCES "works" ("id")
, CONSTRAINT "fk_rails_f07f39fce3"
FOREIGN KEY ("instrument_id")
  REFERENCES "instruments" ("id")
);
CREATE INDEX "index_parts_on_work_id" ON "parts" ("work_id");
CREATE INDEX "index_parts_on_instrument_id" ON "parts" ("instrument_id");
CREATE TABLE IF NOT EXISTS "instruments" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar DEFAULT NULL, "rank" integer DEFAULT NULL, "family" varchar DEFAULT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE INDEX "index_instruments_on_rank" ON "instruments" ("rank");
CREATE TABLE IF NOT EXISTS "liner_notes" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "note" text, "work_id" integer);
CREATE INDEX "index_liner_notes_on_work_id" ON "liner_notes" ("work_id");
CREATE TABLE IF NOT EXISTS "works" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "title" varchar DEFAULT NULL, "composed_in" integer DEFAULT NULL, "revised_in" integer DEFAULT NULL, "genre_id" integer DEFAULT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, "lyricist" varchar DEFAULT NULL, "ascap" boolean DEFAULT NULL, CONSTRAINT "fk_rails_a1441ff0e0"
FOREIGN KEY ("genre_id")
  REFERENCES "genres" ("id")
);
CREATE UNIQUE INDEX "index_works_on_title" ON "works" ("title");
CREATE TABLE IF NOT EXISTS "recordings" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "file_name" varchar, "label" varchar, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, "work_id" integer);
CREATE INDEX "index_recordings_on_work_id" ON "recordings" ("work_id");
CREATE TABLE IF NOT EXISTS "scores" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "file_name" varchar, "label" varchar, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, "work_id" integer);
CREATE INDEX "index_scores_on_work_id" ON "scores" ("work_id");
INSERT INTO "schema_migrations" (version) VALUES
('20250211142926'),
('20250206105011'),
('20250205154319'),
('20250131144421'),
('20250129125443'),
('20250129125141'),
('20250129123953'),
('20250128164642'),
('20250128163418'),
('20250128163317'),
('20250128145506'),
('20250128145334'),
('20250127202643'),
('20250127202117');

