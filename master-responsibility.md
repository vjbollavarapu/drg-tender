# 🔷 Master Responsibility Matrix — DRG / Casemix on AWS

**Legend:**

* **Primary (P)** = Owns delivery & accountability
* **Supporting (S)** = Executes or assists
* **Oversight (O)** = Governance / approval / audit
* **None (—)** = Not involved

---

## 1. Strategy, Governance & Program Ownership

| Service / Function                             | Govt  | Casemix | QK Prima | Radmik |
| ---------------------------------------------- | ----- | ------- | -------- | ------ |
| National DRG Policy & Direction                | **P** | S       | —        | —      |
| DRG Methodology & Logic                        | O     | **P**   | —        | —      |
| Project Ownership / Prime Contract             | O     | S       | **P**    | —      |
| Program Governance & Steering                  | **P** | S       | **P**    | —      |
| Stakeholder Coordination (Hospitals, Agencies) | **P** | S       | **P**    | —      |
| SLA Definition & Enforcement                   | O     | S       | **P**    | S      |

---

## 2. System Design & Architecture

| Service / Function                              | Govt | Casemix | QK Prima | Radmik |
| ----------------------------------------------- | ---- | ------- | -------- | ------ |
| Overall Solution Architecture                   | O    | S       | **P**    | S      |
| DRG System Functional Design                    | —    | **P**   | S        | —      |
| Integration Architecture (Gov ↔ Hospital ↔ DRG) | O    | S       | **P**    | —      |
| Security Architecture (Policy Level)            | O    | S       | **P**    | S      |
| Cloud Architecture (AWS Design)                 | —    | —       | S        | **P**  |

---

## 3. Application & DRG Platform Layer

| Service / Function                      | Govt | Casemix | QK Prima | Radmik |
| --------------------------------------- | ---- | ------- | -------- | ------ |
| DRG Engine / Casemix Processing         | —    | **P**   | S        | —      |
| Application Features & Enhancements     | —    | **P**   | S        | —      |
| Data Validation & Coding Rules          | O    | **P**   | S        | —      |
| Reporting Logic (Clinical / Financial)  | O    | **P**   | S        | —      |
| AI / Intelligence Layer (if applicable) | —    | S       | **P**    | —      |

---

## 4. Integration & Data Exchange

| Service / Function                    | Govt  | Casemix | QK Prima | Radmik |
| ------------------------------------- | ----- | ------- | -------- | ------ |
| Hospital System Integration           | O     | S       | **P**    | —      |
| Government System Integration         | **P** | S       | **P**    | —      |
| API Management & Orchestration        | —     | —       | **P**    | S      |
| Data Transformation (ETL / Pipelines) | —     | S       | **P**    | S      |
| Data Submission to Govt Systems       | **P** | S       | **P**    | —      |

---

## 5. Cloud Infrastructure (AWS Layer)

| Service / Function                     | Govt | Casemix | QK Prima | Radmik |
| -------------------------------------- | ---- | ------- | -------- | ------ |
| AWS Account & Billing Governance       | O    | —       | S        | **P**  |
| Compute (EC2 / Fargate)                | —    | —       | S        | **P**  |
| Storage (S3 / EBS)                     | —    | —       | S        | **P**  |
| Database (Aurora / Redis)              | —    | —       | S        | **P**  |
| Networking (VPC / Load Balancer / CDN) | —    | —       | S        | **P**  |
| Backup & Disaster Recovery             | O    | —       | S        | **P**  |

---

## 6. Security, Compliance & Audit

| Service / Function                        | Govt  | Casemix | QK Prima | Radmik |
| ----------------------------------------- | ----- | ------- | -------- | ------ |
| Regulatory Compliance (Healthcare / Govt) | **P** | S       | **P**    | —      |
| Security Policy & Governance              | O     | S       | **P**    | S      |
| Threat Detection (GuardDuty, WAF)         | —     | —       | S        | **P**  |
| Identity & Access Control                 | O     | S       | **P**    | S      |
| Audit Logs & Reporting                    | **P** | S       | **P**    | S      |

---

## 7. Operations & Managed Services (MSP Scope)

| Service / Function              | Govt | Casemix | QK Prima | Radmik |
| ------------------------------- | ---- | ------- | -------- | ------ |
| 24×7 Monitoring & Alerting      | —    | —       | S        | **P**  |
| Incident Response (Infra)       | —    | —       | S        | **P**  |
| Incident Response (Application) | —    | S       | **P**    | S      |
| Performance Optimization        | —    | —       | S        | **P**  |
| Cost Optimization               | O    | —       | S        | **P**  |
| Operational Reporting           | O    | —       | S        | **P**  |

---

## 8. Deployment, Testing & Handover

| Service / Function              | Govt  | Casemix | QK Prima | Radmik |
| ------------------------------- | ----- | ------- | -------- | ------ |
| Environment Setup               | —     | —       | S        | **P**  |
| Deployment & Release Management | —     | —       | **P**    | S      |
| User Acceptance Testing (UAT)   | **P** | S       | **P**    | —      |
| Training & Knowledge Transfer   | —     | S       | **P**    | —      |
| Final Handover to Govt          | **P** | S       | **P**    | —      |

---

# 🔷 Executive Summary (Use This in Proposal)

> * **Government** owns policy, compliance, and final acceptance
> * **Casemix** owns DRG logic, clinical models, and processing engine
> * **QK Prima** is the **Prime System Integrator and Delivery Owner**
> * **Radmik** is the **AWS Managed Service Provider (Infrastructure & Operations)**

---

# 🔷 Strategic Outcome

This table ensures:

* No overlap
* No confusion
* No “gap ownership”
* Clear commercial boundaries
* Strong positioning for QK Prima

---

# 🔷 Critical Positioning Insight (For You)

This matrix proves one thing very clearly:

> **MSP (Radmik) is only one layer — QK Prima owns the project outcome**
