# Responsibility Model

## Overview

This document clarifies ownership boundaries between:

- AWS / MyGovCloud
- Application Provider (Casemix)
- Platform & Operations (QK Prima)

---

## AWS / MyGovCloud

Provides:
- Compute
- Storage
- Networking
- Managed services
- Security tools

Does NOT provide:
- System architecture
- Data migration
- Integration
- SLA enforcement
- Application operations

---

## Casemix (Application Owner)

Responsible for:
- DRG grouping logic
- Clinical workflows
- Functional modules
- Reporting logic

---

## QK Prima (Platform & Operations)

Responsible for:

### Architecture
- System design
- Environment structure
- Deployment model

### Integration
- SMRP
- MyGDX
- External systems

### Data
- Migration
- Transformation
- Validation

### Security
- RBAC
- Encryption
- Audit

### Operations
- Monitoring
- Incident response
- SLA management

---

## Key Statement

AWS provides infrastructure.
The platform team ensures the system works.
