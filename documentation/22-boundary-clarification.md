# 🔍 Boundary Clarification — AWS vs Casemix vs QK Prima

## 🎯 Purpose
Avoid scope confusion and ensure clear ownership.

---

## AWS (MyGovCloud)

Provides:
- Compute, storage, network
- Managed services (DB, cache, etc.)
- Security primitives
- Monitoring tools

Does NOT:
- Design system architecture
- Integrate external systems
- Migrate data
- Operate application SLA

---

## Casemix

Provides:
- DRG grouping engine
- Clinical/business logic
- Application modules
- Reports (functional)

Does NOT:
- Manage cloud deployment
- Handle integrations
- Operate platform
- Manage infrastructure

---

## QK Prima

Responsible for:
- Architecture & environment design
- Integration & data pipelines
- Data migration
- Security implementation
- Monitoring & incident response
- SLA & operations
- DR & performance
- Cost governance

---

## 🎯 Final Statement

> QK Prima is responsible for everything required to make the system **work in production on AWS**.
