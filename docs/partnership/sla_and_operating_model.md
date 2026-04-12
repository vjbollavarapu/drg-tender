# Service Level Framework
## AWS Cloud Platform Engineering and Operations
## National DRG System Programme

## 1. Service Objective
To ensure the AWS-hosted DRG platform remains secure, supportable, observable, and operationally controlled throughout the 36-month programme lifecycle.

## 2. Service Coverage
This SLA applies to:
- AWS-hosted environments under our responsibility
- platform-level incidents
- deployment pipeline issues
- infrastructure and runtime issues
- platform-related availability degradation
- platform security incidents
- backup and recovery incidents
- cloud monitoring and alerting operations

## 3. Severity Levels

### Severity 1 – Critical
Definition:
- production system unavailable
- major production service outage
- core data ingestion or core transaction path unavailable
- severe security incident requiring immediate action
- inability to process nationally critical workloads

Target Response:
- acknowledge within 30 minutes

Target Engagement:
- active technical engagement immediately upon acknowledgement

Target Update Frequency:
- every 60 minutes until stabilised

### Severity 2 – High
Definition:
- major feature/service degradation in production
- partial outage affecting operational users
- sustained performance issue materially affecting output
- failed deployment with production impact
- backup/recovery concern requiring urgent intervention

Target Response:
- acknowledge within 1 hour

Update Frequency:
- every 2 hours while active

### Severity 3 – Medium
Definition:
- non-critical production issue
- issue in non-production affecting planned delivery
- intermittent failures with workaround available
- monitoring, automation, or operational control issue without critical production outage

Target Response:
- acknowledge within 4 business hours

### Severity 4 – Low
Definition:
- service request
- documentation update
- planned improvement
- advisory support
- non-urgent technical clarification

Target Response:
- acknowledge within 1 business day

## 4. Availability Objective
Recommended production platform target:
- 99.9% monthly platform availability target for in-scope hosted services
Subject to:
- approved maintenance windows
- third-party dependency failures outside our control
- application-level defects outside platform responsibility
- force majeure
- upstream network/provider events beyond our direct control

## 5. Maintenance Windows
Regular planned maintenance may be performed during agreed maintenance windows.
Planned maintenance will:
- be notified in advance
- include rollback readiness
- be logged through change control
- exclude emergency security maintenance where urgent intervention is required

## 6. Incident Management Process
1. Alert or issue is raised
2. Severity is assigned
3. Initial triage begins
4. Technical owner engaged
5. Partner/vendor coordination activated if required
6. Updates issued at defined cadence
7. Service restored or stabilised
8. Root cause analysis conducted for significant incidents
9. Preventive action tracked

## 7. Escalation Model
- Level 1: Operations monitoring and initial triage
- Level 2: Cloud/platform engineer
- Level 3: Lead cloud architect / service lead
- Level 4: Programme management / partner leadership
- Level 5: Executive escalation where stakeholder visibility is required

## 8. Monitoring and Alerting Coverage
Monitoring will cover, where configured and in-scope:
- service uptime
- runtime health
- resource thresholds
- application process health indicators
- job execution failures
- backup status
- certificate validity
- security events / suspicious access indicators
- error rates and latency thresholds

## 9. Reporting
Periodic service reporting will include:
- incident summary
- severity breakdown
- response performance
- platform availability summary
- key operational risks
- change summary
- backup/recovery status
- optimisation recommendations
- security posture summary where applicable

## 10. Exclusions
This SLA does not apply to:
- business logic correctness
- DRG grouping formula outcomes
- externally sourced data quality defects
- functional defects introduced by application code unless directly caused by platform misconfiguration
- government-managed infrastructure not assigned to us
- upstream third-party outages beyond our operational boundary

## 11. Service Governance Meetings
Recommended cadence:
- Weekly technical operations review during active implementation and stabilisation
- Monthly service review during steady-state operations
- Quarterly architecture and optimisation review
