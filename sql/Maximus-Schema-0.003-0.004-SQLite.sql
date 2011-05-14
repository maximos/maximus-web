-- Convert schema 'sql\Maximus-Schema-0.003-SQLite.sql' to 'sql\Maximus-Schema-0.004-SQLite.sql':;

BEGIN;

CREATE TABLE announcement (
  id INTEGER PRIMARY KEY NOT NULL,
  date datetime NOT NULL,
  message text NOT NULL
);


COMMIT;

