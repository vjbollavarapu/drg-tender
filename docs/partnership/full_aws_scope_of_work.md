# Scope of Work
## AWS Cloud Platform Engineering, Security, Reliability and Operations
## National DRG System Programme
## Term: 36 Months

## 1. Scope Summary
This scope covers the end-to-end AWS cloud platform responsibilities required to host, secure, deploy, operate, monitor, support, and continuously improve the National DRG System over the full programme period.

This scope is designed to support the technical intent of the DRG proposal, including:
- seven core modules,
- API and SFTP data ingestion,
- integration with SMRP, MyGDX, and external codification services,
- cloud database layers,
- AI/EIS support workloads,
- Helpdesk/SLA operations,
- security and auditability,
- and production-readiness through UAT, PAT and FAT.

## 2. In-Scope Services

### 2.1 Cloud Architecture and Platform Design
We will define and govern the AWS target architecture, including:
- multi-environment design (Development, SIT, UAT, PAT/Pre-Prod, Production)
- account and environment separation strategy
- network topology and segmentation
- application hosting pattern
- database hosting pattern
- object storage pattern
- logging, monitoring and alerting architecture
- backup and disaster recovery architecture
- secure connectivity patterns for integrations

### 2.2 AWS Environment Provisioning
We will provision and manage the AWS environments required for delivery and operations, including:
- VPC design
- subnet segregation
- route tables
- NAT strategy
- internet egress controls
- security groups
- network ACLs where required
- DNS strategy
- TLS certificate lifecycle
- bastion / privileged access approach if required
- service endpoints / private connectivity design where applicable

### 2.3 Container and Application Runtime Platform
We will implement and operate the AWS runtime for the DRG solution, including:
- container image standards
- registry controls
- orchestration platform selection and management
- runtime scaling policies
- health checks
- deployment topology
- release promotion between environments
- controlled rollback mechanisms

Recommended base pattern:
- ECS/Fargate for streamlined operations unless a justified Kubernetes requirement emerges
- EKS only if platform complexity and team capability materially require it

### 2.4 Database Platform Engineering
In alignment with the proposal’s cloud database architecture, we will support the hosting and operational management of:
- staging database
- production database
- backup / recovery architecture
- analytics / AI-supporting data stores where required

Operational scope includes:
- provisioning support
- parameter tuning support
- backup policy execution
- retention policy support
- encryption controls
- failover readiness
- maintenance window coordination
- recovery testing support

### 2.5 Integration Platform Support
The tender scope includes API, SFTP, MyGDX and WHO codification integration patterns.
Our platform scope includes:
- secure endpoint exposure
- API ingress protection
- SFTP runtime hosting or secure landing approach if hosted within our remit
- scheduling / job execution support
- message protection in transit
- integration observability
- retry / resilience support for technical failures
- technical incident analysis on integration failures

### 2.6 Identity, Access and Security Engineering
The proposal explicitly calls for IAM, RBAC, audit trail, encryption, vulnerability management and national cybersecurity compliance alignment.
Our scope therefore includes:
- AWS IAM design
- least-privilege policy design
- role separation between environments
- admin access governance
- secrets management
- KMS-based encryption design
- encryption at rest and in transit
- certificate governance
- audit logging enablement
- security hardening baselines
- vulnerability remediation coordination at platform layer
- WAF / edge protection pattern where applicable
- access review support
- service account / workload identity controls

### 2.7 DevSecOps and CI/CD
The proposal explicitly includes DevSecOps and CI/CD as part of the SDLC.
Our scope includes:
- build pipeline design
- deployment pipeline design
- release gating
- environment promotion controls
- artefact versioning
- security scanning integration where applicable
- infrastructure-as-code standards where adopted
- release approval workflow
- rollback runbooks
- auditability of releases

### 2.8 Observability, Monitoring and Alerting
We will provide operational observability for the hosted platform, including:
- central logging strategy
- application runtime metrics capture
- infrastructure/service metrics capture
- alert threshold design
- dashboarding
- uptime monitoring
- performance trend analysis
- incident diagnostics support
- environment health reporting

### 2.9 Reliability Engineering and Operations
We will provide reliability-oriented engineering and operational controls, including:
- service availability monitoring
- incident triage and coordination
- root cause analysis support
- production change governance
- release assurance
- performance bottleneck analysis
- scaling tuning
- resilience improvement recommendations
- known error tracking
- operations readiness reviews

### 2.10 Backup, Recovery and Disaster Recovery
In support of the proposal’s emphasis on PITR, backup database, high availability and disaster recovery, our scope includes:
- backup scheduling oversight
- snapshot policy management
- retention management
- restoration validation
- recovery runbooks
- database recovery testing support
- file/object recovery support
- DR readiness reviews
- RTO/RPO alignment support
- failover planning support

### 2.11 Helpdesk and Service Operations Support
The tender includes a Helpdesk module with SLA, status tracking, escalation, auditability and operational reporting.
Our platform scope includes:
- cloud/platform incident intake and classification support
- technical escalation support
- incident severity handling workflow
- change window coordination
- maintenance event communication support
- service reporting inputs
- operational KPI support
- post-incident review support

### 2.12 Performance and Capacity Management
We will provide:
- baseline performance benchmarking
- capacity trend observation
- burst/load readiness planning
- autoscaling configuration support
- database capacity planning support
- storage growth tracking
- optimisation recommendations across runtime, network and database layers

### 2.13 Cloud Governance and Cost Control
We will provide cloud governance controls including:
- environment tagging standards
- change traceability
- cost visibility and reporting
- rightsizing recommendations
- waste reduction review
- reserved / savings strategy review where appropriate
- budget threshold alerting if requested

### 2.14 Documentation and Operational Runbooks
We will maintain platform-level technical documentation including:
- architecture overview
- environment inventory
- deployment process
- backup and recovery runbooks
- incident response runbooks
- access control documentation
- monitoring and alert catalogue
- technical handover and continuity documentation

## 3. Delivery Phases

### Phase 1: Foundation and Architecture
- target AWS architecture
- environment design
- security baseline
- runtime design
- CI/CD design
- monitoring baseline
- backup/recovery baseline

### Phase 2: Build and Implementation Support
- environment provisioning
- deployment enablement
- platform integration support
- security hardening
- non-production operations support
- performance baseline tuning

### Phase 3: Testing and Readiness
- UAT environment readiness
- PAT environment readiness
- FAT support readiness
- release control and defect deployment support
- operational documentation finalisation
- DR and backup validation

### Phase 4: Go-Live and Stabilisation
- go-live support
- incident management
- performance observation
- rapid remediation support
- controlled release stabilisation

### Phase 5: BAU Operations and Optimisation
- continuous operations support
- monitoring and reporting
- patching / maintenance coordination
- security review cadence
- cost and capacity review
- resilience improvement
- service continuity support

## 4. Out of Scope
Unless specifically agreed in writing, the following are out of scope:
- functional defects in DRG logic
- clinical coding rules correctness
- reimbursement formula design
- patient data source quality issues originating from external systems
- business-user training on DRG domain workflows
- functional UAT script ownership
- application feature development outside platform-impacting activities
- third-party vendor licensing fees
- AWS consumption charges
- third-party security audit fees
- government cloud tenancy or services not assigned to our responsibility

## 5. Dependencies
This scope depends on:
- timely access to source code / artefacts
- timely access to the application partner’s technical team
- agreed release process
- clarity on hosting boundaries between AWS and any government-managed infrastructure
- agreed support matrix and escalation paths
- timely stakeholder decisions on connectivity, environments and compliance constraints

## 6. Deliverables
Key deliverables include:
- AWS target architecture
- environment build standards
- security baseline and access model
- CI/CD pipeline configuration
- monitoring and alerting baseline
- backup and recovery runbooks
- incident and change management workflows
- operational dashboards
- monthly / periodic service reporting
- optimisation recommendations log
