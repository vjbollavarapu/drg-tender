# 🧾 AWS Quote Decision Matrix — Responsibility, Decision & Cost Impact

## 🎯 Legend

- 🟦 AWS = Provides Tool / Infrastructure  
- 🟩 US = Full Responsibility (QK Prima + VCS)  
- 🟨 SHARED = Requires both AWS tools + our implementation  
- 🟥 REMOVE = Not required / redundant  
- 💰💰💰 = High cost impact  
- 💰💰 = Medium cost impact  
- 💰 = Low cost impact  

---

## 📊 Decision Matrix

| No | AWS Service | AWS Role | Our Responsibility | Decision | Cost Impact | Notes |
|----|------------|----------|--------------------|----------|-------------|------|
| 1 | API Gateway | 🟦 Routing | 🟩 API design & integration | 🟨 Keep (Conditional) | 💰 | Only if required |
| 2 | EBS | 🟦 Storage | 🟩 Data lifecycle | 🟨 Reduce | 💰💰 | Avoid heavy usage |
| 3 | AWS DRS | 🟦 Backup | 🟩 DR strategy | 🟨 Keep | 💰💰 | Compliance need |
| 4 | Load Balancer | 🟦 Traffic | 🟩 HA design | 🟨 Reduce | 💰💰 | Can consolidate |
| 5 | EC2 | 🟦 Compute | 🟩 Runtime | 🟥 Replace | 💰💰💰 | Use Cloud Run |
| 6 | S3 | 🟦 Storage | 🟩 Governance | 🟨 Keep/Alt | 💰 | Flexible |
| 7 | Data Transfer | 🟦 Network | 🟩 Pipelines | 🟩 Keep | 💰💰 | Required |
| 8 | Route53 | 🟦 DNS | 🟩 Domain design | 🟥 Replace | 💰 | Use Cloudflare |
| 9 | CloudFront | 🟦 CDN | 🟩 Performance | 🟥 Replace | 💰💰 | Cloudflare covers |
| 10 | WAF | 🟦 Security | 🟩 Policy | 🟥 Replace | 💰💰 | Use Cloudflare |
| 11 | AWS Shield | 🟦 DDoS | 🟨 Strategy | 🟥 Remove | 💰💰💰 | Redundant |
| 12 | Aurora DB | 🟦 DB | 🟩 Data architecture | 🟥 Replace | 💰💰💰 | Use PostgreSQL |
| 13 | ElastiCache | 🟦 Cache | 🟩 Cache logic | 🟨 Replace | 💰💰 | Use Redis |
| 14 | ECS / Fargate | 🟦 Containers | 🟩 Deployment | 🟥 Replace | 💰💰💰 | Duplicate compute |
| 15 | CloudTrail | 🟦 Audit | 🟨 Policy | 🟨 Keep | 💰 | Compliance |
| 16 | CloudWatch | 🟦 Logs | 🟩 Monitoring | 🟨 Reduce | 💰 | Partial use |
| 17 | Security Hub | 🟦 Security | 🟩 Policy | 🟥 Remove | 💰💰 | Not required |
| 18 | GuardDuty | 🟦 Threat | 🟩 Response | 🟥 Remove | 💰💰 | Not required |
| 19 | CloudHSM | 🟦 Encryption | 🟩 Policy | 🟥 Remove | 💰💰💰 | Overkill |
| 20 | AWS Config | 🟦 Tracking | 🟨 Governance | 🟨 Reduce | 💰 | Minimal |
| 21 | Kinesis | 🟦 Streaming | 🟩 Pipelines | 🟥 Remove | 💰💰 | Not required |
| 22 | Secrets Manager | 🟦 Secrets | 🟨 Lifecycle | 🟨 Keep/Alt | 💰 | Optional |
| 23 | CodePipeline | 🟦 CI/CD | 🟩 Release | 🟥 Replace | 💰💰 | Use GitHub |
| 24 | CodeBuild | 🟦 Build | 🟩 Build process | 🟥 Replace | 💰💰 | Already available |
| 25 | AWS Shield Adv | 🟦 DDoS | 🟨 Strategy | 🟥 Remove | 💰💰💰 | Duplicate |
| 26 | AWS Glue | 🟦 ETL | 🟩 Data logic | 🟨 Reduce | 💰💰 | Python alt |
| 27 | Redshift | 🟦 Warehouse | 🟩 Analytics | 🟥 Phase 2 | 💰💰💰 | Not needed now |
| 28 | KMS | 🟦 Key mgmt | 🟨 Policy | 🟨 Keep | 💰 | Required |
| 29 | QuickSight | 🟦 BI | 🟩 Dashboard | 🟨 Optional | 💰💰 | Replaceable |
| 30 | MSP | 🟦 Basic support | 🟩 FULL operations | 🟩 CRITICAL | 💰💰💰 | Your core role |

---

## 🔥 Key Takeaway

> Remove duplication.  
> Keep compliance.  
> Replace where we already have capability.

---

## 🎯 Final Statement

We are aligning architecture to actual system requirements — not over-provisioning.
