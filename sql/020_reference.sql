-- === Reference & Tariff Parameters (ref.*) ===

CREATE TABLE IF NOT EXISTS ref.icd10 (
  code            TEXT PRIMARY KEY,
  title           TEXT NOT NULL,
  effective_from  DATE,
  effective_to    DATE
);

CREATE TABLE IF NOT EXISTS ref.proc_code (
  code            TEXT PRIMARY KEY,
  title           TEXT NOT NULL,
  effective_from  DATE,
  effective_to    DATE
);

-- Support DRG versions explicitly (code+version as composite key)
CREATE TABLE IF NOT EXISTS ref.drg_master (
  drg_code     TEXT NOT NULL,
  drg_version  TEXT NOT NULL,
  title        TEXT NOT NULL,
  PRIMARY KEY (drg_code, drg_version)
);

CREATE TABLE IF NOT EXISTS ref.drg_weight (
  drg_code     TEXT NOT NULL,
  drg_version  TEXT NOT NULL,
  severity     TEXT NOT NULL CHECK (severity IN ('A','B','C')),
  weight       NUMERIC(10,4) NOT NULL CHECK (weight >= 0),
  PRIMARY KEY (drg_code, drg_version, severity),
  FOREIGN KEY (drg_code, drg_version) REFERENCES ref.drg_master(drg_code, drg_version)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS ref.base_rate (
  base_rate_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  payer_type       TEXT NOT NULL CHECK (payer_type IN ('KKM','PRIVATE')),
  facility_class   TEXT NOT NULL CHECK (facility_class IN ('A','B','C','DAYCARE','OPD')),
  effective_from   DATE NOT NULL,
  effective_to     DATE,
  rate             NUMERIC(14,2) NOT NULL CHECK (rate >= 0)
);

CREATE TABLE IF NOT EXISTS ref.outlier_policy (
  policy_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  drg_version          TEXT NOT NULL,
  los_lower            INTEGER NOT NULL CHECK (los_lower >= 0),
  los_upper            INTEGER NOT NULL CHECK (los_upper >= los_lower),
  cost_threshold_low   NUMERIC(14,2) NOT NULL CHECK (cost_threshold_low >= 0),
  cost_threshold_high  NUMERIC(14,2) NOT NULL CHECK (cost_threshold_high >= cost_threshold_low)
);
