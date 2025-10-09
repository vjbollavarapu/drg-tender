-- Logical separation
CREATE SCHEMA IF NOT EXISTS ref;   -- reference/code sets & tariffs
CREATE SCHEMA IF NOT EXISTS core;  -- operational DRG data
CREATE SCHEMA IF NOT EXISTS integ; -- API/SFTP integration tracking
CREATE SCHEMA IF NOT EXISTS wh;    -- analytics warehouse
