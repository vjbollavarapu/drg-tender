# 🏗️ Master Architecture — National DRG Platform (AWS-Aligned)

## 🎯 Overview

This diagram represents the **complete DRG platform architecture**, showing:

- Infrastructure (AWS / MyGovCloud)
- Application (Casemix)
- Platform & Operations (QK Prima)

---

## 🧱 Master Architecture Diagram

```mermaid
flowchart TB

    %% ===================== USERS =====================
    U[Users / Hospitals / Admins]

    %% ===================== EDGE =====================
    U --> EDGE[Edge Layer<br/>DNS / CDN / WAF]

    %% ===================== APPLICATION =====================
    EDGE --> APP[Application Layer<br/>DRG System - Casemix]

    %% ===================== PLATFORM (QK PRIMA) =====================
    APP --> INT[Integration Layer]
    INT --> EXT1[SMRP]
    INT --> EXT2[MyGDX]
    INT --> EXT3[Hospital Systems]

    APP --> VALID[Validation Layer]
    VALID --> TRANS[Transformation Layer]
    TRANS --> DRG[DRG Grouping Engine]

    %% ===================== DATA =====================
    DRG --> DB[(Database)]
    DRG --> CACHE[Redis Cache]
    DRG --> OBJ[Object Storage]

    %% ===================== MULTI TENANT =====================
    DB --> T1[Tenant A - Hospital]
    DB --> T2[Tenant B - Hospital]
    DB --> T3[Tenant C - State]
    DB --> T4[Tenant D - National]

    %% ===================== OBSERVABILITY =====================
    APP --> OBS[Monitoring / Logging / Alerts]
    DRG --> OBS
    INT --> OBS

    OBS --> INCIDENT[Incident Response]
    INCIDENT --> SLA[SLA Management]

    %% ===================== SECURITY =====================
    APP --> RBAC[RBAC / Access Control]
    RBAC --> AUDIT[Audit Logs]
    RBAC --> ENC[Encryption]

    %% ===================== DR =====================
    DB --> DRDB[Standby DB / Backup]
    OBJ --> DROBJECT[Replicated Storage]

    %% ===================== AWS =====================
    subgraph AWS["AWS / MyGovCloud (Infrastructure)"]
        EDGE
        APP
        DB
        CACHE
        OBJ
        OBS
    end

    %% ===================== CASEMIX =====================
    subgraph CASEMIX["Casemix (Application Layer)"]
        APP
        DRG
    end

    %% ===================== QK PRIMA =====================
    subgraph QKP["QK Prima (Platform & Operations)"]
        INT
        VALID
        TRANS
        OBS
        INCIDENT
        SLA
        RBAC
    end
```

---

## 🧠 Responsibility Summary

| Layer | Owner |
|------|------|
| Infrastructure | AWS / MyGovCloud |
| Application (DRG logic) | Casemix |
| Platform (integration, ops, governance) | QK Prima |

---

## 🔄 Key Flows

### 1. User Access
Users → Edge → Application

---

### 2. Data Flow
Integration → Validation → Transformation → DRG Engine → Storage

---

### 3. Multi-Tenant
Single platform, logically separated data per:
- Hospital
- State
- National

---

### 4. Observability
All layers feed:
- Logs
- Metrics
- Alerts → Incident → SLA

---

### 5. Security
- RBAC enforced at platform layer
- Encryption at all levels
- Full audit trail

---

### 6. Disaster Recovery
- Database replication
- Object storage replication
- Failover capability

---

## 🎯 Design Principles

- AWS-native deployment
- Clear responsibility separation
- Platform-driven operations
- Data-first architecture
- Compliance-ready
- Scalable to national level

---

## 🚀 Final Statement

> AWS provides the foundation.  
> Casemix provides the DRG system.  
> QK Prima ensures the platform runs securely, reliably, and at national scale.
