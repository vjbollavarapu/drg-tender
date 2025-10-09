erDiagram
  %% Minimal stubs so relationships resolve
  TENANT {
    string tenant_id
  }
  CASE_EPISODE {
    string episode_id
  }

  BATCH_SUBMISSION {
    string batch_id
    string tenant_id
    string channel          "API or SFTP"
    string partner          "HIS / SMRP / MyGDX"
    string file_name
    string checksum
    string status           "received | validated | loaded | failed"
    datetime received_at
  }

  BATCH_ITEM {
    string batch_id
    string episode_id
    string validation_status "ok | warn | error"
    int    error_count
  }

  VALIDATION_ERROR {
    string id
    string batch_id
    string episode_id
    string field
    string code
    string message
  }

  INTEGRATION_LOG {
    string id
    string tenant_id
    string direction        "inbound | outbound"
    string partner          "HIS / SMRP / MyGDX"
    string transport        "API | SFTP"
    string ref_id
    string status
    datetime ts
  }

  TENANT ||--o{ BATCH_SUBMISSION : sends
  BATCH_SUBMISSION ||--o{ BATCH_ITEM : contains
  BATCH_ITEM ||--o{ VALIDATION_ERROR : records
  CASE_EPISODE ||--o{ BATCH_ITEM : arrived_in
  TENANT ||--o{ INTEGRATION_LOG : tracks
