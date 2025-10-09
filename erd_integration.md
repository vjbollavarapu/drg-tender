
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
