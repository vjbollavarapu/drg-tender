
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
