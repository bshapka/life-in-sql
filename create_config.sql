-- represents configuration settings for use elsewhere in the app
--
-- Additional Notes:
--
-- While procedural extensions to SQL have variables, pure SQL (or at least the SQLite dialect) does
-- not. However, there are some values that are reused throughout this application. As such, records in this table
-- serve a single points of definition for these reused values. These values are stored as text in this table, and
-- therefore need to be cast to an acceptable type for that particular value. The type to use for these casts is
-- clear through context.
--
create table config (
    key text not null primary key, -- a key/unique identifier for a configuration value
    value text not null            -- a configuration value
);