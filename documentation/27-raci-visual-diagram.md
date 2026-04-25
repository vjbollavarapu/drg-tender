# 📊 RACI Visual Diagram — DRG Platform

## 🎯 Overview

This diagram provides a **visual responsibility distribution** across:

- AWS (Infrastructure)
- Casemix (Application)
- QK Prima (Platform & Operations)

---

## 🧱 RACI Diagram

```mermaid
flowchart TB

    subgraph AWS["AWS / MyGovCloud"]
        A1[Infrastructure Provisioning]
        A2[Managed Services]
    end

    subgraph CASEMIX["Casemix"]
        B1[DRG Application]
        B2[Clinical Logic]
    end

    subgraph QKP["QK Prima"]
        C1[Platform Architecture]
        C2[Data Migration]
        C3[Integration]
        C4[Security Implementation]
        C5[Monitoring & Alerts]
        C6[Incident Response]
        C7[SLA Management]
        C8[Disaster Recovery]
        C9[Performance Optimization]
        C10[Cost Governance]
    end

    %% Relationships
    A1 --> C1
    A2 --> C5

    B1 --> C3
    B2 --> C2

    C1 --> C2
    C2 --> C3
    C3 --> C5
    C5 --> C6
    C6 --> C7
    C7 --> C8
```

---

## 🎯 Key Insight

- AWS = Provides infrastructure
- Casemix = Provides application
- QK Prima = Responsible for all platform outcomes

---

## 🚀 Final Statement

> Responsibility is concentrated at the platform layer, ensuring system success.
