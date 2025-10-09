# Technology Stack Summary

## 5.1 Platform & Runtime
- Cloud: MyGovCloud@CFA (separate VPCs for DEV / UAT / PROD)
- Orchestration: Kubernetes (managed on CFA if available), NGINX Ingress
- Load Balancer: Cloud LB or HAProxy/NGINX (HA), WAF with OWASP CRS
- Base Images: Ubuntu LTS / Distroless
- Registry: Private (CFA), image signing (Cosign)

## 5.2 Services (Microservices)
- Framework: FastAPI (Python 3.11+)
- Inter-service: REST/JSON; async workers via Kafka
- Core services:
  - case-intake: validation, deduplication, routing
  - drg-engine: grouping rules, severity (versioned rules)
  - tariff-engine: base rate × cost weight, trim/outliers
  - reporting-api: aggregates, CSV/PDF exports
  - admin-config: code sets, weights, rule versions
  - appeals: review/appeal workflow

## 5.3 Integration Layer
- External ingress: REST (OpenAPI 3.1) + SFTP JSON/CSV
- Message bus: Apache Kafka + Schema Registry
- Connectors: HIS (REST/SFTP), SMRP (SFTP batch), MyGDX (REST mTLS + OIDC)

## 5.4 Data Layer
- OLTP: PostgreSQL 15+ (primary/standby, logical replication)
- Analytics: ClickHouse 24.x (partitioned, RBAC)
- Data Lake: S3-compatible (raw, curated parquet)
- ETL/ELT: Airflow + dbt, Great Expectations for tests
- Cache: Redis (code sets, weights)
- Search/Logs: OpenSearch

## 5.5 AI / Advanced Analytics
- Models: scikit-learn / LightGBM (optional PyTorch for NLP)
- Serving: FastAPI sidecars; MLflow registry
- Feature store: Feast
- Use cases: outlier detection, auto-coding, cost trends
- Human-in-the-loop UI; decision logging

## 5.6 Identity, Security, Compliance
- IAM/SSO: Keycloak (OIDC/SAML), tenant RBAC/ABAC
- Policy: OPA (Rego) where needed
- Secrets: Vault + Cloud KMS (envelope)
- Crypto: TLS 1.2/1.3; AES-256 at rest
- Network: private subnets, SGs, mTLS internal
- Audit: immutable logs, DB audit triggers, API logs (retention policy)
- Backups/DR: PostgreSQL PITR, ClickHouse snapshots, cross-AZ replication

## 5.7 Observability & Operations
- Metrics: Prometheus; Grafana dashboards
- Tracing: OpenTelemetry (trace IDs)
- Logs: Loki or OpenSearch (JSON structured)
- Alerts: Alertmanager (SLO-based)
- Helpdesk: ticketing, uptime page, postmortems

## 5.8 CI/CD & Governance
- CI: GitHub Actions / GitLab CI (build, test, SAST, image scan, SBOM)
- CD: Argo CD (GitOps), blue/green or canary
- IaC: Terraform + Helm; policy checks with Conftest
- Releases: semantic versioning; API versioning with deprecation windows

## 5.9 Documentation & Developer Experience
- API: OpenAPI 3.1 (Swagger UI per env)
- Integration kits: Postman, SFTP batch JSON example, ICD/procedure mapping guide
- Runbooks: on-call, backup/restore, DR (RPO/RTO)
- User docs: coder workflow, finance/claims, KKM analytics

## 5.10 Non-Functional Targets
- Availability: ≥ 99.9% core APIs; multi-AZ DB
- Performance: p95 ≤ 300 ms (reads), ≤ 1 s (DRG assign)
- Throughput: sized for national batch + month-end peaks (HPA)
- Security: zero critical vulns; CIS baseline; quarterly pentest
- DR: RPO ≤ 15 min; RTO ≤ 2 hr (documented drills)

## Optional repository layout
