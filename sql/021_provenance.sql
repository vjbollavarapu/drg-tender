CREATE TABLE IF NOT EXISTS ref.model_provenance (
  provenance_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  model_name        TEXT NOT NULL,
  model_version     TEXT NOT NULL,
  dataset_snapshot  TEXT NOT NULL,
  notes             TEXT,
  approved_by       TEXT NOT NULL,
  approved_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Optional: link base_rate and drg_weight to provenance
ALTER TABLE IF EXISTS ref.base_rate
  ADD COLUMN IF NOT EXISTS provenance_id UUID REFERENCES ref.model_provenance(provenance_id);

-- If you want explicit linkage for each severity row:
ALTER TABLE IF EXISTS ref.drg_weight
  ADD COLUMN IF NOT EXISTS provenance_id UUID REFERENCES ref.model_provenance(provenance_id);
