# 🧾 Responsibility Matrix — QK Prima Scope (AWS-Aligned)

## 🎯 Purpose
Define tasks owned by QK Prima that are NOT covered by:
- AWS (infrastructure & managed services)
- Casemix (DRG application & domain logic)

---

## 🧠 Legend
- 🟩 QK Prima = Full ownership (Platform & Operations)
- 🟨 Shared = AWS tools used, but design/operation owned by QK Prima

---

| No | Domain | Task / Deliverable | Ownership |
|----|--------|--------------------|-----------|
| 1 | Architecture | Define target cloud architecture (on AWS/MyGovCloud) | 🟩 |
| 2 | Environments | Design Dev / UAT / Prod environments & isolation | 🟩 |
| 3 | Deployment | Containerization, runtime configuration, release strategy | 🟩 |
| 4 | CI/CD | Pipeline design, approvals, rollback strategy | 🟩 |
| 5 | Networking | VPC design, routing, ingress/egress controls | 🟨 |
| 6 | Identity | RBAC model, roles/permissions mapping | 🟩 |
| 7 | Secrets | Secret usage patterns, rotation policies | 🟨 |
| 8 | Encryption | Define encryption standards & enforcement | 🟨 |
| 9 | Data Model | Multi-tenant data isolation strategy (if required) | 🟩 |
| 10 | Migration | Data migration planning, mapping, execution, validation | 🟩 |
| 11 | Integration | API/SFTP design, contracts, retries, error handling | 🟩 |
| 12 | Validation | Data quality rules, reconciliation processes | 🟩 |
| 13 | Observability | Metrics, logs, traces, dashboards, alerts | 🟩 |
| 14 | Incidents | Incident response runbooks, escalation matrix | 🟩 |
| 15 | SLA | Define & operate SLA (availability, response, resolution) | 🟩 |
| 16 | DR | DR design (RTO/RPO), failover procedures, drills | 🟨 |
| 17 | Performance | Load testing, capacity planning, tuning | 🟩 |
| 18 | Cost | Cost governance, tagging, budgets, optimization | 🟩 |
| 19 | Security Ops | Vulnerability mgmt, patching strategy, reviews | 🟩 |
| 20 | Audit | Audit trails, compliance evidence, reporting | 🟨 |
| 21 | Release | Change mgmt, release calendar, approvals | 🟩 |
| 22 | Support | L2/L3 support, triage, coordination with Casemix | 🟩 |
| 23 | Documentation | Runbooks, SOPs, architecture & ops docs | 🟩 |

---

## 🎯 Final Statement

> AWS provides the platform.  
> Casemix provides the application.  
> QK Prima ensures the system is **designed, integrated, secured, operated, and governed**.
