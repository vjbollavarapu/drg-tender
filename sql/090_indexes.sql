-- Helpful indexes for common queries

-- CORE
CREATE INDEX IF NOT EXISTS idx_case_episode_tenant_status
  ON core.case_episode (tenant_id, status);

CREATE INDEX IF NOT EXISTS idx_case_episode_dates
  ON core.case_episode (tenant_id, admission_dt, discharge_dt);

CREATE INDEX IF NOT EXISTS idx_drg_assignment_code
  ON core.drg_assignment (drg_code, severity);

CREATE INDEX IF NOT EXISTS idx_tariff_result_code_time
  ON core.tariff_result (drg_code, computed_at);

CREATE INDEX IF NOT EXISTS idx_audit_tenant_time
  ON core.audit_log (tenant_id, ts);

-- INTEGRATION
CREATE INDEX IF NOT EXISTS idx_batch_submission_tenant_time
  ON integ.batch_submission (tenant_id, received_at);

CREATE INDEX IF NOT EXISTS idx_batch_item_status
  ON integ.batch_item (batch_id, validation_status);
