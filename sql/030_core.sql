-- === Operational Core (core.*) ===

CREATE TABLE IF NOT EXISTS core.tenant (
  tenant_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name        TEXT NOT NULL,
  code        TEXT UNIQUE,
  type        TEXT NOT NULL CHECK (type IN ('KKM','PRIVATE')),
  state       TEXT,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS core.users (
  user_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  username     TEXT NOT NULL UNIQUE,
  display_name TEXT,
  email        TEXT UNIQUE,
  status       TEXT NOT NULL DEFAULT 'active',
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS core.role (
  role_id  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name     TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS core.membership (
  user_id    UUID NOT NULL REFERENCES core.users(user_id)    ON DELETE CASCADE,
  tenant_id  UUID NOT NULL REFERENCES core.tenant(tenant_id) ON DELETE CASCADE,
  role_id    UUID NOT NULL REFERENCES core.role(role_id)     ON DELETE RESTRICT,
  PRIMARY KEY (user_id, tenant_id, role_id)
);

CREATE TABLE IF NOT EXISTS core.case_episode (
  episode_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       UUID NOT NULL REFERENCES core.tenant(tenant_id) ON DELETE RESTRICT,
  mrn             TEXT,
  patient_hash    TEXT NOT NULL, -- privacy-preserving
  admission_type  TEXT NOT NULL CHECK (admission_type IN ('outpatient','daycare','inpatient')),
  admission_dt    TIMESTAMPTZ,
  discharge_dt    TIMESTAMPTZ,
  los             INTEGER CHECK (los IS NULL OR los >= 0),
  source_system   TEXT NOT NULL CHECK (source_system IN ('HIS','SMRP','MANUAL')),
  status          TEXT NOT NULL CHECK (status IN ('submitted','grouped','tariffed','rejected','appeal_pending')),
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS core.episode_diagnosis (
  episode_id  UUID NOT NULL REFERENCES core.case_episode(episode_id) ON DELETE CASCADE,
  seq_no      INTEGER NOT NULL CHECK (seq_no >= 1),
  icd_code    TEXT NOT NULL REFERENCES ref.icd10(code) ON UPDATE CASCADE,
  dx_type     TEXT NOT NULL CHECK (dx_type IN ('principal','secondary')),
  PRIMARY KEY (episode_id, seq_no)
);

CREATE TABLE IF NOT EXISTS core.episode_procedure (
  episode_id  UUID NOT NULL REFERENCES core.case_episode(episode_id) ON DELETE CASCADE,
  seq_no      INTEGER NOT NULL CHECK (seq_no >= 1),
  proc_code   TEXT NOT NULL REFERENCES ref.proc_code(code) ON UPDATE CASCADE,
  proc_date   DATE,
  PRIMARY KEY (episode_id, seq_no)
);

-- One-to-one with CASE_EPISODE
CREATE TABLE IF NOT EXISTS core.drg_assignment (
  episode_id       UUID PRIMARY KEY REFERENCES core.case_episode(episode_id) ON DELETE CASCADE,
  drg_code         TEXT NOT NULL,
  drg_version      TEXT NOT NULL,
  severity         TEXT CHECK (severity IN ('A','B','C')),
  weight           NUMERIC(10,4) CHECK (weight >= 0),
  grouper_version  TEXT,
  grouped_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  FOREIGN KEY (drg_code, drg_version) REFERENCES ref.drg_master(drg_code, drg_version)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

-- One-to-one with CASE_EPISODE
CREATE TABLE IF NOT EXISTS core.tariff_result (
  episode_id          UUID PRIMARY KEY REFERENCES core.case_episode(episode_id) ON DELETE CASCADE,
  drg_code            TEXT NOT NULL,
  drg_version         TEXT NOT NULL,
  base_rate_id        UUID NOT NULL REFERENCES ref.base_rate(base_rate_id) ON DELETE RESTRICT,
  weight              NUMERIC(10,4) NOT NULL CHECK (weight >= 0),
  outlier_adjustment  NUMERIC(12,2) NOT NULL DEFAULT 0,
  computed_tariff     NUMERIC(14,2) NOT NULL CHECK (computed_tariff >= 0),
  currency            CHAR(3) NOT NULL DEFAULT 'MYR',
  computed_at         TIMESTAMPTZ NOT NULL DEFAULT now(),
  FOREIGN KEY (drg_code, drg_version) REFERENCES ref.drg_master(drg_code, drg_version)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS core.appeal (
  appeal_id    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  episode_id   UUID NOT NULL REFERENCES core.case_episode(episode_id) ON DELETE CASCADE,
  status       TEXT NOT NULL CHECK (status IN ('open','in_review','approved','rejected')),
  reason       TEXT,
  created_by   UUID REFERENCES core.users(user_id),
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  resolved_at  TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS core.audit_log (
  audit_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id      UUID NOT NULL REFERENCES core.tenant(tenant_id) ON DELETE CASCADE,
  actor_id       UUID,
  action         TEXT NOT NULL,
  resource_type  TEXT NOT NULL,
  resource_id    TEXT,
  ts             TIMESTAMPTZ NOT NULL DEFAULT now()
);
