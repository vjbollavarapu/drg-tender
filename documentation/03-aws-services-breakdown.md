# AWS Services Breakdown — Platform Responsibility View

## 🎯 Purpose
Clarify how AWS services are used within the DRG platform and what responsibilities remain with QK Prima.

---

## 🧱 Principle

> AWS provides infrastructure and managed services.  
> QK Prima is responsible for configuring, integrating, and operating these services to meet system requirements.

---

## Service Categories

### Compute (EC2 / ECS / Fargate)
Provides:
- Application runtime environment

QK Prima Responsibilities:
- Deployment configuration
- Scaling policies
- Runtime performance tuning

---

### Storage (S3 / EBS)
Provides:
- Data storage capability

QK Prima Responsibilities:
- Data structure design
- Lifecycle policies
- Backup configuration

---

### Database (Aurora / RDS)
Provides:
- Managed database services

QK Prima Responsibilities:
- Schema design
- Query optimization
- Data integrity

---

### Security (IAM / WAF / KMS)
Provides:
- Security primitives

QK Prima Responsibilities:
- RBAC implementation
- Policy enforcement
- Key management strategy

---

### Monitoring (CloudWatch / CloudTrail)
Provides:
- Logging and metrics

QK Prima Responsibilities:
- Alert configuration
- Dashboard creation
- Incident response workflows

---

## 🎯 Final Statement

> AWS services are fully utilized.  
> QK Prima ensures they are correctly configured, governed, and operated.
