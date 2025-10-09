### `docs/db/README.md`

```markdown
# National DRG – Data Model (Core, Reference & Analytics)

This pack contains:
- **Core ERD** for episodes, diagnoses/procedures, DRG assignment, tariff results, submissions, appeals.
- **Integration ERD** for API/SFTP batch tracking and validation (HIS/SMRP/MyGDX).
- **Reference ERD** for code-sets (ICD, procedures), DRG weights, base rates, outlier policies.
- **Analytics Star Schema** for national reporting (KKM) and hospital dashboards.

All diagrams are GitHub-safe Mermaid and reflect the tender’s cloud/microservices/AI objectives on MyGovCloud@CFA and the required API/SFTP integrations with SMRP/MyGDX/HIS.
```

---

### `docs/db/erd_core.md`

````markdown
# Core Operational ERD

```mermaid
erDiagram
  TENANT {
    string tenant_id PK
    string name
    string code
    string type        "KKM|PRIVATE"
    string state
    datetime created_at
  }

  CASE_EPISODE {
    string episode_id PK
    string tenant_id FK
    string mrn
    string patient_hash         "no PII"
    string admission_type       "outpatient|daycare|inpatient"
    datetime admission_dt
    datetime discharge_dt
    int los
    string source_system        "HIS|SMRP|MANUAL"
    string status               "submitted|grouped|tariffed|rejected|appeal_pending"
    datetime created_at
  }

  EPISODE_DIAGNOSIS {
    string episode_id FK
    int seq_no
    string icd_code
    string dx_type             "principal|secondary"
  }

  EPISODE_PROCEDURE {
    string episode_id FK
    int seq_no
    string proc_code
    date  proc_date
  }

  DRG_ASSIGNMENT {
    string episode_id FK
    string drg_code
    string drg_version
    string severity            "A|B|C"
    decimal weight
    string grouper_version
    datetime grouped_at
  }

  TARIFF_RESULT {
    string episode_id FK
    string drg_code
    string base_rate_id FK
    decimal weight
    decimal outlier_adjustment
    decimal computed_tariff
    string  currency
    datetime computed_at
  }

  APPEAL {
    string appeal_id PK
    string episode_id FK
    string status           "open|in_review|approved|rejected"
    string reason
    string created_by
    datetime created_at
    datetime resolved_at
  }

  USERS {
    string user_id PK
    string username
    string display_name
    string email
    string status
  }

  ROLE {
    string role_id PK
    string name
  }

  MEMBERSHIP {
    string user_id FK
    string tenant_id FK
    string role_id FK
  }

  AUDIT_LOG {
    string audit_id PK
    string tenant_id FK
    string actor_id
    string action
    string resource_type
    string resource_id
    datetime ts
  }

  TENANT ||--o{ CASE_EPISODE : "has"
  CASE_EPISODE ||--o{ EPISODE_DIAGNOSIS : "has"
  CASE_EPISODE ||--o{ EPISODE_PROCEDURE : "has"
  CASE_EPISODE ||--|| DRG_ASSIGNMENT : "results in"
  CASE_EPISODE ||--|| TARIFF_RESULT : "yields"
  CASE_EPISODE ||--o{ APPEAL : "may have"
  USERS ||--o{ MEMBERSHIP : "has"
  ROLE  ||--o{ MEMBERSHIP : "grants"
  TENANT ||--o{ MEMBERSHIP : "scopes"
  TENANT ||--o{ AUDIT_LOG : "writes"
````

````

---

### `docs/db/erd_integration.md`
```markdown
# Integration & Validation ERD (API/SFTP with HIS, SMRP, MyGDX)

```mermaid
erDiagram
  BATCH_SUBMISSION {
    string batch_id PK
    string tenant_id FK
    string channel         "API|SFTP"
    string partner         "HIS|SMRP|MyGDX"
    string file_name
    string checksum
    string status          "received|validated|loaded|failed"
    datetime received_at
  }

  BATCH_ITEM {
    string batch_id FK
    string episode_id FK
    string validation_status  "ok|warn|error"
    int    error_count
  }

  VALIDATION_ERROR {
    string id PK
    string batch_id FK
    string episode_id FK
    string field
    string code
    string message
  }

  INTEGRATION_LOG {
    string id PK
    string direction       "inbound|outbound"
    string partner         "HIS|SMRP|MyGDX"
    string transport       "API|SFTP"
    string ref_id
    string status
    datetime ts
  }

  TENANT ||--o{ BATCH_SUBMISSION : "sends"
  BATCH_SUBMISSION ||--o{ BATCH_ITEM : "contains"
  BATCH_ITEM ||--o{ VALIDATION_ERROR : "records"
  CASE_EPISODE ||--o{ BATCH_ITEM : "arrived in"
  TENANT ||--o{ INTEGRATION_LOG : "tracks"
````

*Why this exists*: the tender requires integration paths using **API & SFTP** with **SMRP** and **MyGDX** as well as hospital HIS; this schema tracks batches, per-record validation, and transport logs. 

````

---

### `docs/db/erd_reference_tariff.md`
```markdown
# Reference, Tariff & Grouping Parameters ERD

```mermaid
erDiagram
  ICD10 {
    string code PK
    string title
    date   effective_from
    date   effective_to
  }

  PROC_CODE {
    string code PK
    string title
    date   effective_from
    date   effective_to
  }

  DRG_MASTER {
    string drg_code PK
    string title
    string drg_version
  }

  DRG_WEIGHT {
    string drg_code FK
    string drg_version
    string severity        "A|B|C"
    decimal weight
  }

  BASE_RATE {
    string base_rate_id PK
    string payer_type     "KKM|PRIVATE"
    string facility_class "A|B|C|DAYCARE|OPD"
    date   effective_from
    date   effective_to
    decimal rate
  }

  OUTLIER_POLICY {
    string policy_id PK
    string drg_version
    int    los_lower
    int    los_upper
    decimal cost_threshold_low
    decimal cost_threshold_high
  }

  DRG_ASSIGNMENT ||--o{ DRG_WEIGHT : "uses"
  TARIFF_RESULT  ||--|| BASE_RATE  : "applies"
  DRG_MASTER     ||--o{ DRG_WEIGHT : "defines"
  EPISODE_DIAGNOSIS ||--|| ICD10 : "codes from"
  EPISODE_PROCEDURE ||--|| PROC_CODE : "codes from"
````

*Why this exists*: the tender highlights algorithmic DRG grouping and **tariff publication/calculation**; these tables parameterize the grouper and compute tariffs reproducibly. 

````

---

### `docs/db/warehouse_star_schema.md`
```markdown
# Analytics Warehouse – Star Schema (for KKM & Hospital BI)

```mermaid
erDiagram
  FACT_EPISODE {
    string fact_id PK
    string episode_id
    string date_key_adm
    string date_key_disc
    string hospital_key
    string drg_key
    string adm_type_key
    decimal weight
    int los
    boolean outlier_flag
    decimal tariff_amount
  }

  DIM_DATE {
    string date_key PK
    date   calendar_date
    int    year
    int    month
    int    day
  }

  DIM_HOSPITAL {
    string hospital_key PK
    string tenant_id
    string name
    string state
    string type         "KKM|PRIVATE"
  }

  DIM_DRG {
    string drg_key PK
    string drg_code
    string drg_version
    string severity
    string title
  }

  DIM_ADMISSION_TYPE {
    string adm_type_key PK
    string admission_type  "outpatient|daycare|inpatient"
  }

  FACT_EPISODE }o--|| DIM_DATE : "adm by"
  FACT_EPISODE }o--|| DIM_DATE : "disc by"
  FACT_EPISODE }o--|| DIM_HOSPITAL : "at"
  FACT_EPISODE }o--|| DIM_DRG : "assigned"
  FACT_EPISODE }o--|| DIM_ADMISSION_TYPE : "classified"
````

*Why this exists*: supports national dashboards, funding analytics, and hospital-level reporting called for in the tender. 

Awesome — here’s a **drop-in SQL DDL pack** (PostgreSQL) that matches the ERDs I gave you. It’s GitHub-ready and split by schemas. Paste these files into your repo and run them in order.

---

### `sql/000_extensions.sql`

```sql
-- UUID + crypto helpers
CREATE EXTENSION IF NOT EXISTS pgcrypto;
```

---

### `sql/010_schemas.sql`

```sql
-- Logical separation
CREATE SCHEMA IF NOT EXISTS ref;   -- reference/code sets & tariffs
CREATE SCHEMA IF NOT EXISTS core;  -- operational DRG data
CREATE SCHEMA IF NOT EXISTS integ; -- API/SFTP integration tracking
CREATE SCHEMA IF NOT EXISTS wh;    -- analytics warehouse
```

---

### `sql/020_reference.sql`

```sql
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
```

---

### `sql/030_core.sql`

```sql
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
```

---

### `sql/040_integration.sql`

```sql
-- === Integration tracking (integ.*) ===

CREATE TABLE IF NOT EXISTS integ.batch_submission (
  batch_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id    UUID NOT NULL REFERENCES core.tenant(tenant_id) ON DELETE RESTRICT,
  channel      TEXT NOT NULL CHECK (channel IN ('API','SFTP')),
  partner      TEXT NOT NULL CHECK (partner IN ('HIS','SMRP','MyGDX')),
  file_name    TEXT,
  checksum     TEXT,
  status       TEXT NOT NULL CHECK (status IN ('received','validated','loaded','failed')),
  received_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS integ.batch_item (
  batch_id           UUID NOT NULL REFERENCES integ.batch_submission(batch_id) ON DELETE CASCADE,
  episode_id         UUID NOT NULL REFERENCES core.case_episode(episode_id)   ON DELETE CASCADE,
  validation_status  TEXT NOT NULL CHECK (validation_status IN ('ok','warn','error')),
  error_count        INTEGER NOT NULL DEFAULT 0 CHECK (error_count >= 0),
  PRIMARY KEY (batch_id, episode_id)
);

CREATE TABLE IF NOT EXISTS integ.validation_error (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  batch_id    UUID NOT NULL REFERENCES integ.batch_submission(batch_id) ON DELETE CASCADE,
  episode_id  UUID REFERENCES core.case_episode(episode_id)             ON DELETE CASCADE,
  field       TEXT NOT NULL,
  code        TEXT NOT NULL,
  message     TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS integ.integration_log (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id   UUID NOT NULL REFERENCES core.tenant(tenant_id) ON DELETE RESTRICT,
  direction   TEXT NOT NULL CHECK (direction IN ('inbound','outbound')),
  partner     TEXT NOT NULL CHECK (partner IN ('HIS','SMRP','MyGDX')),
  transport   TEXT NOT NULL CHECK (transport IN ('API','SFTP')),
  ref_id      TEXT,
  status      TEXT NOT NULL,
  ts          TIMESTAMPTZ NOT NULL DEFAULT now()
);
```

---

### `sql/050_warehouse.sql`

```sql
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
```

---

### `sql/090_indexes.sql`

```sql
-- Helpful indexes for common queries

-- CORE
CREATE INDEX IF NOT EXISTS idx_case_episode_tenant_status
  ON core.case_episode (tenant_id, status);

CREATE INDEX IF NOT EXISTS idx_case_episode_dates
  ON core.case_episode (tenant_id, admission_dt, discharge_dt);

CREATE INDEX IF NOT EXISTS idx_drg_assignment_code
  ON core.drg_assignment (drg_code, severity);

CREATE INDEX IF NOT EXISTS idx_tariff_result_code_time
  ON core.tariff_result (drg_code, computed_at);

CREATE INDEX IF NOT EXISTS idx_audit_tenant_time
  ON core.audit_log (tenant_id, ts);

-- INTEGRATION
CREATE INDEX IF NOT EXISTS idx_batch_submission_tenant_time
  ON integ.batch_submission (tenant_id, received_at);

CREATE INDEX IF NOT EXISTS idx_batch_item_status
  ON integ.batch_item (batch_id, validation_status);
```

---

### `sql/099_seed_minimal.sql`

```sql
-- Minimal seeds for dev/testing

-- Roles
INSERT INTO core.role (name) VALUES
  ('hospital_coder'), ('hospital_finance'), ('hospital_admin'),
  ('kkm_admin'), ('kkm_analyst')
ON CONFLICT DO NOTHING;

-- Admission type dimension
INSERT INTO wh.dim_admission_type (adm_type_key, admission_type) VALUES
  (1,'outpatient'), (2,'daycare'), (3,'inpatient')
ON CONFLICT DO NOTHING;

-- Example DRG master + weight
INSERT INTO ref.drg_master (drg_code, drg_version, title) VALUES
  ('DRG001','v1','Example DRG 001')
ON CONFLICT DO NOTHING;

INSERT INTO ref.drg_weight (drg_code, drg_version, severity, weight) VALUES
  ('DRG001','v1','A',0.9000),
  ('DRG001','v1','B',1.1000),
  ('DRG001','v1','C',1.3000)
ON CONFLICT DO NOTHING;

-- Example base rate (OPD)
INSERT INTO ref.base_rate (payer_type, facility_class, effective_from, rate)
VALUES ('KKM','OPD', CURRENT_DATE, 1200.00)
ON CONFLICT DO NOTHING;

-- A small date dimension seed (today)
INSERT INTO wh.dim_date (date_key, calendar_date, year, month, day)
VALUES (
  CAST(to_char(CURRENT_DATE,'YYYYMMDD') AS INTEGER),
  CURRENT_DATE,
  EXTRACT(YEAR FROM CURRENT_DATE)::INT,
  EXTRACT(MONTH FROM CURRENT_DATE)::INT,
  EXTRACT(DAY FROM CURRENT_DATE)::INT
)
ON CONFLICT DO NOTHING;
```

---

### (Optional) `docs/db/sftp-batch-example.json`

```json
{
  "batch_id": "BATCH-2025-10-09-0001",
  "tenant_code": "HOSP-A",
  "channel": "SFTP",
  "partner": "HIS",
  "episodes": [
    {
      "client_episode_id": "E-001",
      "mrn": "MRN-778899",
      "patient_hash": "p_7e1f9a...",
      "admission_type": "daycare",
      "admission_dt": "2025-09-28T09:30:00Z",
      "discharge_dt": "2025-09-28T15:20:00Z",
      "icd_codes": ["J18.9"],
      "procedure_codes": ["45.13"],
      "los": 1,
      "source_system": "HIS"
    }
  ],
  "checksum": "sha256:abc123..."
}
```

---

### (Optional) `docs/db/mapping-guide.md`

```markdown
# Mapping Guide (HIS/SMRP → DRG Submission)

## Required fields (per episode)
- admission_type: "outpatient" | "daycare" | "inpatient"
- patient_hash: irreversible hash (no PII)
- icd_codes: array of ICD-10 codes (principal first)
- procedure_codes: array of valid procedure codes
- admission_dt, discharge_dt (ISO 8601)

## Validation rules (examples)
- day surgery requires at least one procedure code
- inpatient must have LOS >= 1 or discharge_dt > admission_dt
- codes must exist in ref.icd10 / ref.proc_code effective ranges
```

---

## How to run (local dev)

```bash
psql "$DB_URL" -f sql/000_extensions.sql
psql "$DB_URL" -f sql/010_schemas.sql
psql "$DB_URL" -f sql/020_reference.sql
psql "$DB_URL" -f sql/030_core.sql
psql "$DB_URL" -f sql/040_integration.sql
psql "$DB_URL" -f sql/050_warehouse.sql
psql "$DB_URL" -f sql/090_indexes.sql
psql "$DB_URL" -f sql/099_seed_minimal.sql
```

# 1) Web layer

* **Django “views” ≠ FastAPI.** In FastAPI you write **path operations/routers** (functions) instead of MVC views.
* So you do **not** need Django-style views when moving to FastAPI.

# 2) Database layer

* **SQL views/materialized views are framework-agnostic.** They’re still great for:

  * **Stable read contracts** for BI/portals (hide joins/logic behind a view).
  * **Performance** (use **materialized views** + indexes for heavy aggregations).
  * **Security** (grant read on a view; hide raw tables/PII).
* Use them for **reports, dashboards, exports**, while OLTP writes hit the base tables.

## When to use which

* **Plain VIEW**: lightweight convenience, always fresh, no storage.
* **MATERIALIZED VIEW**: precomputed aggregates (daily/weekly), **needs refresh** (cron/Airflow/dbt).

---

## Minimal examples you can drop in

### A. Postgres VIEW (flatten episode + DRG + tariff)

```sql
CREATE OR REPLACE VIEW core.v_episode_drg AS
SELECT
  e.episode_id,
  e.tenant_id,
  e.admission_type,
  e.admission_dt,
  e.discharge_dt,
  e.status,
  d.drg_code,
  d.severity,
  t.computed_tariff,
  t.currency,
  t.computed_at
FROM core.case_episode e
JOIN core.drg_assignment d USING (episode_id)
JOIN core.tariff_result  t USING (episode_id);
```

### B. Postgres MATERIALIZED VIEW (daily totals per DRG)

```sql
CREATE MATERIALIZED VIEW wh.mv_tariff_daily AS
SELECT
  date_trunc('day', t.computed_at)::date AS day,
  e.tenant_id,
  d.drg_code,
  COUNT(*)                        AS cases,
  SUM(t.computed_tariff)          AS total_tariff,
  AVG(t.computed_tariff)          AS avg_tariff
FROM core.case_episode e
JOIN core.drg_assignment d USING (episode_id)
JOIN core.tariff_result  t USING (episode_id)
GROUP BY 1,2,3;

CREATE INDEX IF NOT EXISTS ix_mv_tariff_daily
  ON wh.mv_tariff_daily (day, tenant_id, drg_code);
-- Refresh policy (pick one):
-- REFRESH MATERIALIZED VIEW CONCURRENTLY wh.mv_tariff_daily;
```

---

## FastAPI: expose those views as read endpoints

```python
# app/routers/reports.py
from datetime import date
from typing import List, Optional
from fastapi import APIRouter, Depends, Query
from pydantic import BaseModel
from sqlalchemy import text
from .deps import get_session  # your SQLAlchemy session dependency

router = APIRouter(prefix="/reports", tags=["reports"])

class EpisodeDRG(BaseModel):
    episode_id: str
    tenant_id: str
    admission_type: str
    admission_dt: Optional[str]
    discharge_dt: Optional[str]
    status: str
    drg_code: str
    severity: Optional[str]
    computed_tariff: float
    currency: str
    computed_at: Optional[str]

@router.get("/episodes", response_model=List[EpisodeDRG])
def list_episodes(
    tenant_id: str = Query(...),
    start: Optional[date] = Query(None),
    end: Optional[date] = Query(None),
    db = Depends(get_session),
):
    sql = """
    SELECT episode_id, tenant_id, admission_type, admission_dt, discharge_dt,
           status, drg_code, severity, computed_tariff, currency, computed_at
    FROM core.v_episode_drg
    WHERE tenant_id = :tenant_id
      AND (:start::date IS NULL OR admission_dt::date >= :start::date)
      AND (:end::date   IS NULL OR admission_dt::date <= :end::date)
    ORDER BY admission_dt DESC
    LIMIT 1000
    """
    rows = db.execute(text(sql), {"tenant_id": tenant_id, "start": start, "end": end}).mappings().all()
    return rows
```

### Aggregates endpoint (materialized view)

```python
@router.get("/daily-tariffs")
def daily_tariffs(
    tenant_id: Optional[str] = None,
    start: Optional[date] = None,
    end: Optional[date] = None,
    db = Depends(get_session),
):
    sql = """
    SELECT day, tenant_id, drg_code, cases, total_tariff, avg_tariff
    FROM wh.mv_tariff_daily
    WHERE (:tenant_id IS NULL OR tenant_id = :tenant_id)
      AND (:start::date IS NULL OR day >= :start::date)
      AND (:end::date   IS NULL OR day <= :end::date)
    ORDER BY day DESC
    """
    return db.execute(text(sql), {"tenant_id": tenant_id, "start": start, "end": end}).mappings().all()
```

---

## Best practices (quick checklist)

* **Treat views as contracts** for your portal/BI; evolve them with additive columns.
* **Use materialized views** for heavy, repeated analytics; **schedule REFRESH** (Airflow/dbt/CronJob).
* **Index materialized views** on common filters (date, tenant, drg_code).
* **Separate OLTP vs analytics**: keep heavy queries off the primary; use a read replica or warehouse (ClickHouse).
* **Cache hot queries** with Redis (keyed by tenant + date range).
* **RBAC at SQL**: grant SELECT on views to a read-only role; keep base tables restricted.

**Bottom line:**

* **No Django views needed** in FastAPI.
* **Yes, keep (SQL) views/materialized views** to make reporting fast, clean, and safe.
