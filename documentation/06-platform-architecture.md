# 🏗️ Hybrid Platform Architecture — DRG System

## 🎯 Overview

This architecture represents a **hybrid cloud model**:

- MyGovCloud (AWS-backed infrastructure)
- Platform layer managed by QK Prima
- Application layer provided by Casemix

---

## 🧱 High-Level Architecture

```mermaid
flowchart TB
    A[End Users / Hospitals] --> B[Cloudflare Edge Layer]

    B --> C[Application Layer - Cloud Run / Containers]

    C --> D[PostgreSQL Database]
    C --> E[Redis Cache]
    C --> F[Object Storage]

    C --> G[Integration Layer]
    G --> G1[SMRP]
    G --> G2[MyGDX]
    G --> G3[Hospital Systems]

    C --> H[Monitoring & Logging]
    H --> H1[Metrics]
    H --> H2[Logs]
    H --> H3[Alerts]

    C --> I[AWS / MyGovCloud Infrastructure]
    I --> I1[Compute]
    I --> I2[Storage]
    I --> I3[Network]
```

---

## 🔄 Data Flow

1. Users access system via Cloudflare  
2. Requests routed to application layer  
3. Application interacts with:
   - Database (PostgreSQL)
   - Cache (Redis)
   - Storage (files, reports)

4. Integration layer handles:
   - SMRP
   - MyGDX
   - External hospital data

---

## 🔐 Security Layers

- Edge: Cloudflare (WAF, DDoS)
- Application: Authentication + RBAC
- Data: Encryption (at rest & in transit)

---

## ⚙️ Deployment Flow

- Code → GitHub
- CI/CD → GitHub Actions / Cloud Build
- Deployment → Cloud Run / Containers
- Runtime → Auto-scaled services

---

## 🎯 Key Design Principles

- No duplication of services
- Cloud-native architecture
- Multi-tenant readiness
- High availability
- Observability-first design

---

## 🧠 Responsibility View

| Layer | Owner |
|------|------|
| Infrastructure | AWS / MyGovCloud |
| Platform | QK Prima |
| Application | Casemix |

---

## 🚀 Final Statement

> The cloud provides the foundation.  
> The platform ensures the system runs reliably at scale.
