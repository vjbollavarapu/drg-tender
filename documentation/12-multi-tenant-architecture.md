# 🏢 Multi-Tenant Architecture — National DRG Platform

## 🎯 Overview

This architecture ensures **strict data isolation** across:

- Hospitals
- States
- Organisations

While using a **shared infrastructure model**.

---

## 🧱 Multi-Tenant Architecture Diagram

```mermaid
flowchart TB

    %% Users
    A[Hospital Users] --> B[API Gateway / App Layer]
    A2[State Admins] --> B
    A3[National Admin] --> B

    %% Application Layer
    B --> C[Application Services]

    %% Tenant Enforcement
    C --> D[Tenant Resolver Middleware]
    D --> E[RBAC + Access Control]

    %% Database Layer
    E --> F[(Multi-Tenant Database)]

    %% Tenant Separation
    F --> F1[Tenant A - Hospital 1]
    F --> F2[Tenant B - Hospital 2]
    F --> F3[Tenant C - State Level]
    F --> F4[Tenant D - National Aggregated]

    %% Cache Layer
    C --> G[Redis Cache - Tenant Scoped]

    %% Storage Layer
    C --> H[Object Storage]
    H --> H1[Hospital Data Buckets]
    H --> H2[State Data Buckets]

    %% Security
    E --> I[Audit Logs]
    E --> J[Encryption Layer]
```

---

## 🔐 Key Principles

### 1. Tenant Isolation
- Each hospital/state acts as a **logical tenant**
- Data is separated using:
  - `tenant_id`
  - Access policies

---

### 2. Role-Based Access (RBAC)

| Role | Access |
|------|--------|
| Hospital User | Own data only |
| State Admin | State-level aggregation |
| National Admin | Full dataset |

---

### 3. Data Protection

- Encryption at rest
- Encryption in transit
- Audit logs for all access

---

## ⚠️ Critical Risk (If Not Implemented)

- Data leakage across hospitals
- Compliance violation
- National-level risk

---

## 🎯 Final Statement

> Multi-tenancy is not optional.  
> It is a **core requirement for national-scale DRG systems**.
