# National DRG – API & Diagrams

## Diagrams (Mermaid)
- High-level E2E API Flow: [`api-flowchart.md`](../api-flowchart.md#1-high-level-e2e-flow-apis-sftp-services-data-integrations)
- Case Submission (async, idempotent): [`api-flowchart.md`](../api-flowchart.md#2-api-lifecycle-for-case-submission-async-idempotent)
- Batch Ingestion via SFTP: [`api-flowchart.md`](../api-flowchart.md#3-batch-ingestion-via-sftp-validation-partial-failures-reconciliation)
- Reporting / Analytics path: [`api-flowchart.md`](../api-flowchart.md#4-reportinganalytics-api-path-read-only)
- Error handling / Rate limits / Retries: [`api-flowchart.md`](../api-flowchart.md#5-error-handling-rate-limits-retries)
- System Health: [`api-flowchart.md`](../api-flowchart.md#system-health--e2e-view)

## Sequences & Contracts
- Claim → DRG → Tariff (+Appeal) sequence: [`sequence_claim_to_tariff.md`](./sequence_claim_to_tariff.md)
- OpenAPI spec (v1): [`openapi.yaml`](./openapi.yaml)
  - Liveness: `GET /healthz`
  - Readiness: `GET /readiness`
  - Cases: `POST /cases`, `GET /cases/{case_id}`
  - DRG/Tariff lookups: `GET /drg/{case_id}`, `GET /tariffs/{case_id}`
  - Batches: `GET /batches/{batch_id}`
  - Reports: `/reports/*`
- Optional webhooks: [`webhooks.md`](./webhooks.md)

## Notes
- Keep Mermaid labels simple (letters, numbers, spaces). Avoid `/ : ( ) - { }` in edge labels.
- View in GitHub “Preview file” (not Raw). Hard refresh if cache sticks.
