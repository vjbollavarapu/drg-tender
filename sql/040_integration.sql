-- === Integration tracking (integ.*) ===

CREATE TABLE IF NOT EXISTS integ.batch_submission (
  batch_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id    UUID NOT NULL REFERENCES core.tenant(tenant_id) ON DELETE RESTRICT,
  channel      TEXT NOT NULL CHECK (channel IN ('API','SFTP')),
  partner      TEXT NOT NULL CHECK (partner IN ('HIS','SMRP','MyGDX')),
  file_name    TEXT,
  checksum     TEXT,
  status       TEXT NOT NULL CHECK (status IN ('received','validated','loaded','failed')),
  received_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS integ.batch_item (
  batch_id           UUID NOT NULL REFERENCES integ.batch_submission(batch_id) ON DELETE CASCADE,
  episode_id         UUID NOT NULL REFERENCES core.case_episode(episode_id)   ON DELETE CASCADE,
  validation_status  TEXT NOT NULL CHECK (validation_status IN ('ok','warn','error')),
  error_count        INTEGER NOT NULL DEFAULT 0 CHECK (error_count >= 0),
  PRIMARY KEY (batch_id, episode_id)
);

CREATE TABLE IF NOT EXISTS integ.validation_error (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  batch_id    UUID NOT NULL REFERENCES integ.batch_submission(batch_id) ON DELETE CASCADE,
  episode_id  UUID REFERENCES core.case_episode(episode_id)             ON DELETE CASCADE,
  field       TEXT NOT NULL,
  code        TEXT NOT NULL,
  message     TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS integ.integration_log (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id   UUID NOT NULL REFERENCES core.tenant(tenant_id) ON DELETE RESTRICT,
  direction   TEXT NOT NULL CHECK (direction IN ('inbound','outbound')),
  partner     TEXT NOT NULL CHECK (partner IN ('HIS','SMRP','MyGDX')),
  transport   TEXT NOT NULL CHECK (transport IN ('API','SFTP')),
  ref_id      TEXT,
  status      TEXT NOT NULL,
  ts          TIMESTAMPTZ NOT NULL DEFAULT now()
);
