# 🏗️ Platform Architecture — Responsibility View (AWS / Casemix / QK Prima)

## 🎯 Overview
Architecture is hosted on **MyGovCloud (AWS-backed)**.  
This diagram highlights **responsibility boundaries**.

---

## 🧱 Architecture (Mermaid)

```mermaid
flowchart TB

    %% Users
    U[Users / Hospitals] --> EDGE[Edge / DNS / CDN]

    %% App
    EDGE --> APP[Application Services]

    %% Data
    APP --> DB[(Database)]
    APP --> OBJ[Object Storage]
    APP --> CACHE[Cache]

    %% Integration
    APP --> INT[Integration Layer]
    INT --> EXT1[SMRP]
    INT --> EXT2[MyGDX]
    INT --> EXT3[Hospital Systems]

    %% Observability
    APP --> OBS[Monitoring / Logging / Alerts]

    %% AWS Layer
    subgraph AWS["AWS / MyGovCloud (Infrastructure & Managed Services)"]
        EDGE
        APP
        DB
        OBJ
        CACHE
        OBS
    end

    %% Casemix Layer
    subgraph CASEMIX["Casemix (Application & DRG Logic)"]
        APP
    end

    %% QK Prima Layer
    subgraph QKP["QK Prima (Platform & Operations)"]
        INT
        OBS
    end
```

---

## 🧠 Responsibility Summary

| Layer | Owner |
|------|------|
| Infrastructure (compute, storage, network) | AWS / MyGovCloud |
| Application (DRG logic, modules) | Casemix |
| Platform (integration, ops, governance) | QK Prima |

---

## 🎯 Final Statement

> The platform layer connects, governs, and operates the system on AWS.
