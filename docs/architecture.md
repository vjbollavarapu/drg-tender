# 🏥 National DRG System (MyGovCloud@CFA)

*Architecture Overview for Tender Submission & Stakeholder Review*

---

## 1️⃣ **C4 Context Diagram (Level 1)**

Shows how the National DRG System connects to hospitals, KKM, and other government systems.

```mermaid
flowchart LR
    Hospital["Hospital HIS (Doctors, Coders, Finance)"]
    KKM["KKM HQ (Admin, Finance, Analysts)"]
    Insurer["Insurers or Panel Companies"]
    SMRP["SMRP (Patient Data Warehouse)"]
    MyGDX["MyGDX (Gov Data Exchange)"]

    subgraph DRGSystem["National DRG System (MyGovCloud@CFA)"]
        Portal["Web Portal (Hospitals and KKM)"]
        API["REST and SFTP APIs"]
    end

    Hospital -->|Submit Cases via API or SFTP| DRGSystem
    DRGSystem -->|DRG Codes and Tariffs| Hospital
    DRGSystem -->|Funding and Analytics| KKM
    DRGSystem -->|Claims Data| Insurer
    DRGSystem -->|Data Exchange| SMRP
    DRGSystem -->|Inter Agency Data| MyGDX
```

---

## 2️⃣ **C4 Container Diagram (Level 2)**

Zooms inside the National DRG System to show the microservices, integrations, and data stores.

```mermaid
flowchart TB
    subgraph DRGSystem["National DRG System (MyGovCloud@CFA)"]
        LB["Load Balancer + WAF"]

        subgraph K8s["Kubernetes Cluster"]
            Intake["Case Intake Service (FastAPI)"]
            DRG["DRG Grouping Service (FastAPI + Rules)"]
            Tariff["Tariff Engine (FastAPI)"]
            Report["Reporting & Analytics (FastAPI + BI)"]
            Auth["Identity & Access (Keycloak)"]
            AI["AI/ML Service (Python / MLflow)"]
        end

        subgraph Data["Data Layer"]
            DB["PostgreSQL (Transactions)"]
            DWH["ClickHouse (Analytics)"]
            DL["S3 / MinIO (Data Lake)"]
        end
    end

    Hospital["Hospital HIS"] -->|API / SFTP| LB
    SMRP["SMRP"] -->|Batch Data| LB
    MyGDX["MyGDX"] -->|API| LB

    LB --> Intake
    Intake --> DRG
    DRG --> Tariff
    Tariff --> Report
    AI --> Report
    Auth --> Intake
    Auth --> DRG
    Auth --> Tariff
    Auth --> Report

    Intake --> DB
    DRG --> DB
    Tariff --> DB
    Report --> DWH
    DB --> DWH
    DWH --> DL

    Report -->|Dashboards| Hospital
    Report -->|Funding & Analytics| KKM["KKM HQ"]
```

---

## 3️⃣ **Microservices Workflow**

Step-by-step workflow for DRG processing and reporting.

```mermaid
sequenceDiagram
    participant Hospital as Hospital HIS
    participant Intake as Case Intake API (FastAPI)
    participant DRG as DRG Engine
    participant Tariff as Tariff Engine
    participant Report as Reporting Service
    participant AI as AI/ML Service
    participant Finance as Hospital Finance
    participant KKM as KKM HQ

    Hospital->>Intake: 1️⃣ Submit Case Data (ICD, Procedures, Costs)
    Intake->>DRG: 2️⃣ Validate & Forward for Grouping
    DRG->>Tariff: 3️⃣ Assign DRG & Request Tariff
    Tariff->>Report: 4️⃣ Send Calculated Tariff
    AI-->>Report: 5️⃣ Detect Outliers / Auto Coding
    Report-->>Finance: 6️⃣ Return DRG + Tariff Results
    Report-->>KKM: 7️⃣ Aggregate Analytics for Funding
```

---

## 4️⃣ **Responsibilities (RACI Matrix)**

| **Task**                        | **Vendor**    | **Hospital**  | **KKM**        |
| ------------------------------- | ------------- | ------------- | -------------- |
| Build DRG system (engine, APIs) | ✅ Responsible | 🔹 Informed   | 🔹 Accountable |
| Provide API documentation       | ✅ Responsible | 🔹 Consulted  | 🔹 Accountable |
| Integrate HIS with DRG system   | 🔹 Consulted  | ✅ Responsible | 🔹 Accountable |
| Upload case data                | 🔹 Informed   | ✅ Responsible | 🔹 Accountable |
| Run DRG grouping + tariffs      | ✅ Responsible | 🔹 Informed   | 🔹 Accountable |
| National monitoring & funding   | 🔹 Informed   | 🔹 Informed   | ✅ Responsible  |
| Analytics & reporting           | 🔹 Consulted  | 🔹 Informed   | ✅ Responsible  |
| Security & compliance oversight | ✅ Responsible | 🔹 Informed   | 🔹 Accountable |

---

## 📘 Summary

* **Hospitals** submit case data and receive DRG results.
* **KKM** monitors, analyses, and allocates funding fairly.
* **Vendor** builds, secures, and maintains the national system.
* Architecture uses **FastAPI microservices**, **Kubernetes**, and **MyGovCloud@CFA** for scalability, compliance, and interoperability with **SMRP** and **MyGDX**.
