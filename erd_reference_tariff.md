
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
