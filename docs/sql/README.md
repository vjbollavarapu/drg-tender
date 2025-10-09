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
