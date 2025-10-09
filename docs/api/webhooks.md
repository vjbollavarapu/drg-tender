# Webhooks (Optional Callbacks)

This document defines how the National DRG System can **notify client systems** (HIS, billing, data lakes) when important events occur, instead of polling.

## 1. Overview

- **Transport:** HTTPS `POST` with JSON body  
- **Security:** HMAC-SHA256 signature + timestamp, per-subscriber shared secret  
- **Success criteria:** Subscriber returns **2xx** within **5s**  
- **Retries:** Exponential backoff, max attempts configurable (default 6)  
- **Idempotency:** Every delivery has a unique `delivery_id`; every event has an `event_id`  
- **Versioning:** `spec_version: "1.0"` in each payload

---

## 2. Events

| Event name        | When it fires                                 |
|-------------------|-----------------------------------------------|
| `case_submitted`  | Intake accepted a case (async processing)     |
| `case_grouped`    | DRG Engine assigned a DRG                     |
| `case_tariffed`   | Tariff Engine computed a tariff               |
| `appeal_updated`  | Appeal opened, reviewed, approved, or rejected|

---

## 3. Delivery

**HTTP Method:** `POST`  
**Headers (required):**
- `Content-Type: application/json`
- `X-Webhook-Event: <event_name>`
- `X-Webhook-Delivery-Id: <uuid>`
- `X-Webhook-Timestamp: <unix-epoch-seconds>`
- `X-Webhook-Signature: sha256=<hex(hmac_sha256(secret, timestamp + '.' + body))>`

**Body (JSON):**
```json
{
  "spec_version": "1.0",
  "event_id": "e_01HF…",
  "event_name": "case_tariffed",
  "occurred_at": "2025-10-09T03:22:41Z",
  "tenant_id": "hospa",
  "data": {
    "case_id": "c_01HF…",
    "drg_code": "DRG001",
    "severity": "B",
    "weight": 1.1,
    "base_rate_id": "br_7c9…",
    "computed_tariff": 4620.50,
    "currency": "MYR",
    "computed_at": "2025-10-09T03:22:41Z",
    "status": "tariffed"
  }
}
