# 🔄 DRG Data Flow Architecture — National System

## 🎯 Overview

This diagram represents the **end-to-end data lifecycle**:

From hospital systems → DRG processing → national analytics.

---

## 🧱 DRG Data Flow Diagram

```mermaid
flowchart LR

    %% Source Systems
    A[Hospital Systems] --> B[SFTP / API Upload]
    A2[SMRP System] --> B
    A3[MyGDX System] --> B

    %% Ingestion Layer
    B --> C[Data Ingestion Service]

    %% Validation
    C --> D[Validation Layer]
    D --> D1[Schema Validation]
    D --> D2[Data Quality Checks]
    D --> D3[Deduplication]

    %% Staging
    D --> E[Staging Database]

    %% Transformation
    E --> F[Transformation Layer]
    F --> F1[ICD-10 → ICD-11 Mapping]
    F --> F2[Standardization]
    F --> F3[Business Rules]

    %% DRG Processing
    F --> G[DRG Grouping Engine]
    G --> G1[Casemix Logic]

    %% Production DB
    G --> H[Production Database]

    %% Analytics
    H --> I[Reporting Layer]
    I --> I1[Hospital Reports]
    I --> I2[State Reports]
    I --> I3[National Dashboard]

    %% Storage
    H --> J[Object Storage - Reports]

    %% Monitoring
    C --> K[Logging & Monitoring]
    F --> K
    G --> K
```

---

## 🔄 Data Flow Steps

### 1. Data Sources
- Hospital systems
- SMRP
- MyGDX

---

### 2. Ingestion
- API / SFTP
- Batch & real-time

---

### 3. Validation
- Schema checks
- Data completeness
- Deduplication

---

### 4. Staging
- Temporary storage
- Pre-processing

---

### 5. Transformation
- ICD mapping
- Data standardization
- Business rules

---

### 6. DRG Processing
- Casemix grouping engine
- Clinical logic applied

---

### 7. Storage
- Production database
- Object storage for reports

---

### 8. Reporting
- Hospital-level
- State-level
- National-level

---

## ⚠️ Critical Risk Areas

- Data quality issues
- Incorrect ICD mapping
- Integration failures
- Processing delays

---

## 🎯 Strategic Insight

> The DRG system is not just an application.  
> It is a **data pipeline + clinical processing system**.

---

## 🚀 Final Statement

> The success of the DRG platform depends on  
> accurate, validated, and properly processed data —  
> not just infrastructure.
