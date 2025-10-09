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
