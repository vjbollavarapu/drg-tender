-- === Analytics Warehouse (wh.*) ===

-- Dimensional tables
CREATE TABLE IF NOT EXISTS wh.dim_date (
  date_key       INTEGER PRIMARY KEY,     -- e.g., 20251009
  calendar_date  DATE NOT NULL,
  year           INTEGER NOT NULL,
  month          INTEGER NOT NULL,
  day            INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS wh.dim_hospital (
  hospital_key  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     UUID NOT NULL REFERENCES core.tenant(tenant_id) ON DELETE RESTRICT,
  name          TEXT NOT NULL,
  state         TEXT,
  type          TEXT NOT NULL CHECK (type IN ('KKM','PRIVATE'))
);

CREATE TABLE IF NOT EXISTS wh.dim_drg (
  drg_key     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  drg_code    TEXT NOT NULL,
  drg_version TEXT NOT NULL,
  severity    TEXT CHECK (severity IN ('A','B','C')),
  title       TEXT,
  UNIQUE (drg_code, drg_version, severity)
);

CREATE TABLE IF NOT EXISTS wh.dim_admission_type (
  adm_type_key    SMALLINT PRIMARY KEY,
  admission_type  TEXT NOT NULL UNIQUE CHECK (admission_type IN ('outpatient','daycare','inpatient'))
);

-- Fact table
CREATE TABLE IF NOT EXISTS wh.fact_episode (
  fact_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  episode_id      UUID UNIQUE REFERENCES core.case_episode(episode_id) ON DELETE CASCADE,
  date_key_adm    INTEGER NOT NULL REFERENCES wh.dim_date(date_key) ON DELETE RESTRICT,
  date_key_disc   INTEGER REFERENCES wh.dim_date(date_key) ON DELETE RESTRICT,
  hospital_key    UUID NOT NULL REFERENCES wh.dim_hospital(hospital_key) ON DELETE RESTRICT,
  drg_key         UUID REFERENCES wh.dim_drg(drg_key) ON DELETE RESTRICT,
  adm_type_key    SMALLINT NOT NULL REFERENCES wh.dim_admission_type(adm_type_key) ON DELETE RESTRICT,
  weight          NUMERIC(10,4),
  los             INTEGER,
  outlier_flag    BOOLEAN DEFAULT FALSE,
  tariff_amount   NUMERIC(14,2)
);
