# National DRG – API E2E Flow (Tender-aligned)

## 1) High-Level E2E Flow (APIs, SFTP, Services, Data, Integrations)

```mermaid
flowchart LR
  %% Actors
  Hospital[Hospital HIS / Integrator]
  KKM[KKM Portal Users]
  SMRP[SMRP]
  MyGDX[MyGDX]

  %% Edge
  LB[Load Balancer and WAF]
  SFTPGW[SFTP Gateway]

  %% Auth
  Auth[OIDC Authorization Server - Keycloak]

  %% API Router
  APIRouter[API Gateway or Ingress and FastAPI Routers]

  %% Microservices
  subgraph SVC[FastAPI Microservices on Kubernetes]
    Intake[Case Intake API]
    DRG[DRG Engine API]
    Tariff[Tariff Engine API]
    Appeals[Appeals API]
    Reports[Reporting API]
    Admin[Admin and Config API]
  end

  %% Async backbone
  Kafka[(Kafka Topics)]
  DL[S3 or MinIO Data Lake]

  %% Data stores
  DB[(PostgreSQL OLTP)]
  DWH[(ClickHouse Analytics)]

  %% Observability
  Obs[Observability - Prometheus, Grafana, Logs, Traces]

  %% Web frontends
  KKMPortal[KKM Web Portal]
  HospPortal[Hospital Web Portal]

  %% Flows
  Hospital -->|REST JSON| LB
  LB --> Auth
  Auth --> APIRouter
  APIRouter --> Intake
  APIRouter --> Reports
  APIRouter --> Appeals
  APIRouter --> Admin

  Intake --> DB
  Intake --> Kafka
  Kafka --> DRG
  DRG --> DB
  DRG --> Tariff
  Tariff --> DB
  Reports --> DWH
  DB --> DWH
  DWH --> Reports

  %% Portals
  KKM --> LB
  LB --> Auth
  Auth --> KKMPortal
  KKMPortal --> Reports

  Hospital --> LB
  LB --> Auth
  Auth --> HospPortal
  HospPortal --> Reports

  %% SFTP path
  Hospital -->|SFTP| SFTPGW
  SFTPGW --> DL
  DL --> Intake
  SFTPGW -. audit .-> DL

  %% Outbound exchanges
  Reports -->|exports or feeds| SMRP
  Reports -->|APIs or feeds| MyGDX

  %% Observability taps
  SVC -. metrics logs traces .-> Obs
  APIRouter -. access logs .-> Obs
```

---

## 2) API Lifecycle for Case Submission (Async, Idempotent)

```mermaid
flowchart TB
  %% Nodes
  Client[HIS Client]
  Edge[Load Balancer and WAF]
  Auth[OIDC Authorization]
  API_Router[FastAPI Router - cases]
  V{Valid}
  IDEMP{Idempotency Key present}
  CheckKey{Key seen before}
  Save1[Insert new case]
  DB[(PostgreSQL OLTP)]
  Kafka[(Kafka topic case_submitted)]
  DRG[DRG Engine]
  Tariff[Tariff Engine]
  E400[HTTP 400 or 422 validation error]
  E208[208 Already Reported]
  R202[HTTP 202 Accepted with location]
  API_Get[FastAPI Router - cases by id]
  R200[HTTP 200 JSON status]

  %% Edges
  Client -->|POST cases JSON| Edge
  Edge --> Auth
  Auth --> API_Router
  API_Router -->|schema and RBAC| V
  V -- No --> E400
  V -- Yes --> IDEMP
  IDEMP -- No --> Save1
  IDEMP -- Yes --> CheckKey
  CheckKey -- Yes --> E208
  CheckKey -- No --> Save1

  Save1 --> DB
  Save1 --> Kafka
  Kafka --> DRG
  DRG -->|group| DB
  DRG --> Tariff
  Tariff -->|compute tariff| DB

  API_Router --> R202
  Client -->|GET case by id| API_Get
  API_Get --> DB --> R200
```

**Notes**

* Use `Idempotency-Key` header to make `POST /cases` safe to retry.
* Prefer async: return `202 Accepted` quickly; clients poll `GET /cases/{id}` (or you can offer webhooks).

---

## 3) Batch Ingestion via SFTP (Validation, Partial Failures, Reconciliation)

```mermaid
flowchart LR
  %% Nodes
  Sender[Hospital HIS]
  GW[SFTP Gateway]
  OBJ[Object Storage Landing]
  Scan[Antivirus and Checksum]
  Parser[Batch Parser]
  Val[Validation Rules]
  Load[Load Episodes]
  Reject[Error Manifest]
  DB[(PostgreSQL)]
  K[(Kafka)]
  StatusAPI[Batch Status API]

  %% Flow
  Sender -->|SFTP PUT| GW
  GW --> OBJ
  OBJ --> Scan
  Scan --> Parser
  Parser --> Val
  Val -->|OK| Load
  Val -->|Errors| Reject
  Load --> DB
  Load --> K
  Reject --> StatusAPI
  DB --> StatusAPI

  %% Optional audit trail
  GW -. audit .-> OBJ
```

**Behavior**

* Accept JSON/CSV manifests.
* Produce an **error manifest** for per-row issues.
* Expose `/batches` API for status and reconciliation.

---

## 4) Reporting/Analytics API Path (Read-only)

```mermaid
flowchart LR
  User[Portal User]
  LB[Load Balancer]
  Auth[OIDC Authorization]
  ReportsAPI[Reporting API]
  DWH[(ClickHouse)]
  Views[DB Read Views]
  DB[(PostgreSQL)]

  User -->|GET reports| LB
  LB --> Auth
  Auth --> ReportsAPI
  ReportsAPI --> DWH
  ReportsAPI --> Views
  Views --> DB
  DWH --> ReportsAPI
  ReportsAPI -->|CSV or JSON| User
```

**Notes**

* Heavy queries hit **ClickHouse**; OLTP read views are optional for light lookups.
* Add pagination, date filters, and tenant scoping.

---

## 5) Error Handling, Rate Limits, Retries

```mermaid
flowchart TB
  Client[Client Request]
  WAF[WAF and Rate Limit]
  H{Within quota}
  E429[429 Too Many Requests]
  Retry[Retry After header]
  Svc[Service Handler]
  OK[2xx Success]
  C4xx[4xx Client Error]
  S5xx[5xx Server Error]
  Backoff[Client retries with backoff]

  Client --> WAF
  WAF --> H
  H -- No --> E429
  E429 --> Retry
  H -- Yes --> Svc
  Svc --> OK
  Svc --> C4xx
  Svc --> S5xx
  S5xx --> Backoff
```

---

## 6) Recommended API Surface (to wire later)

**Case Intake**

* `POST /cases` 202 Accepted (async), headers: `Authorization`, `Idempotency-Key`
* `GET /cases/{id}`
* `GET /cases?tenant_id&status&from&to&page&page_size`

**DRG/Tariff lookups**

* `GET /drg/{case_id}`
* `GET /tariffs/{case_id}`
* `GET /tariffs?drg_code&effective_date`

**Batches (SFTP companion APIs)**

* `GET /batches/{id}`
* `GET /batches/{id}/errors`
* `POST /batches/reconcile` (optional acknowledgement)

**Reports**

* `GET /reports/daily-tariffs?tenant_id&start&end&format=csv`
* `GET /reports/drg-mix?tenant_id&start&end`
* `GET /reports/system-health`

**Admin/Reference (read-mostly)**

* `GET /ref/icd10?code=...`
* `GET /ref/proc?code=...`
* `GET /ref/drg-weights?drg_code&version`
* `GET /ref/base-rate?facility_class&effective_date`

---

## 7) Security and Contract Notes (short)

* **AuthN/Z**: OIDC bearer tokens (Keycloak). Service-to-service can use mTLS.
* **Tenancy**: scope every read to `tenant_id` unless KKM role.
* **Idempotency**: require `Idempotency-Key` on all POSTs that create resources.
* **Validation**: strict JSON schema; reject unknown fields; provide error manifest for batches.
* **Versioning**: prefix `/v1/*`; avoid breaking changes; deprecate gracefully.
* **Observability**: correlation IDs on every request; structured logs; traces across LB→API→services.


```mermaid
flowchart LR
  Mon[External Monitor]
  LB[Load Balancer]
  HealthAPI[System Health API]
  Agg[Health Aggregator]

  subgraph SVC[Services]
    Intake[Case Intake]
    DRG[DRG Engine]
    Tariff[Tariff Engine]
    Reports[Reporting]
    Appeals[Appeals]
    Admin[Admin Config]
  end

  DB[(PostgreSQL)]
  DWH[(ClickHouse)]
  Kafka[(Kafka)]
  S3[S3 or MinIO]
  Keycloak[Keycloak OIDC]
  Obs[Observability Stack]

  Mon -->|GET health| LB --> HealthAPI --> Agg
  Agg -->|probe liveness| Intake
  Agg -->|probe liveness| DRG
  Agg -->|probe liveness| Tariff
  Agg -->|probe liveness| Reports
  Agg -->|probe liveness| Appeals
  Agg -->|probe liveness| Admin

  Agg -->|probe readiness| DB
  Agg -->|probe readiness| DWH
  Agg -->|probe readiness| Kafka
  Agg -->|probe readiness| S3
  Agg -->|probe readiness| Keycloak

  HealthAPI -. metrics .-> Obs
  SVC -. logs traces .-> Obs

```

```mermaid
flowchart LR
  User[Portal User]
  LB[Load Balancer]
  Auth[OIDC Authorization]
  ReportsAPI[Reporting API]
  DWH[(ClickHouse)]
  Views[DB Read Views]
  DB[(PostgreSQL)]

  User -->|GET reports| LB
  LB --> Auth
  Auth --> ReportsAPI
  ReportsAPI --> DWH
  ReportsAPI --> Views
  Views --> DB
  DWH --> ReportsAPI
  ReportsAPI -->|CSV or JSON| User

```

```markdown
## Analyst Extracts and Publication Loop

```mermaid
## Analyst Extracts and Publication Loop

```mermaid
flowchart LR
  DWH[(ClickHouse)]
  Stata[Stata]
  TreeAge[TreeAge]
  AdminAPI[Admin Config API]
  REF[Reference Tables]
  Engines[DRG and Tariff Engines]

  DWH -->|dataset export| Stata
  DWH -->|dataset export| TreeAge
  Stata -->|weights output| AdminAPI
  TreeAge -->|policy output| AdminAPI
  AdminAPI -->|validate and publish| REF
  REF --> Engines
