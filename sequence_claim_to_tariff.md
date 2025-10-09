# Sequence – Claim to Tariff (including Appeal)

```mermaid
sequenceDiagram
    participant HIS as HIS Client
    participant LB as Load Balancer
    participant Auth as OIDC Authorization
    participant Intake as Case Intake API
    participant DB as PostgreSQL
    participant K as Kafka
    participant DRG as DRG Engine
    participant Tariff as Tariff Engine
    participant Reports as Reporting API
    participant HPortal as Hospital Portal
    participant KPortal as KKM Portal
    participant Appeals as Appeals API

    Note over HIS: Submit case (idempotent)
    HIS->>LB: submit case
    LB->>Auth: validate token
    Auth->>Intake: forward request
    Intake->>Intake: validate schema and RBAC
    Intake->>DB: insert case
    Intake->>K: publish case_submitted
    Intake-->>HIS: accepted with case reference

    K-->>DRG: deliver case_submitted
    DRG->>DB: group case and save DRG result
    DRG->>K: publish case_grouped

    K-->>Tariff: deliver case_grouped
    Tariff->>DB: compute tariff and save
    Tariff->>K: publish case_tariffed

    HPortal->>Reports: fetch case status
    Reports->>DB: read case and results
    Reports-->>HPortal: status and amounts

    KPortal->>Reports: national aggregates
    Reports->>DB: read or to DWH
    Reports-->>KPortal: metrics and trends

    Note over HPortal: Optional appeal
    HPortal->>Appeals: open appeal
    Appeals->>DB: record appeal
    Appeals->>DRG: request review
    DRG->>DB: update DRG if changed
    Tariff->>DB: recompute tariff if needed
    Appeals-->>HPortal: appeal outcome
