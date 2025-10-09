-- Minimal seeds for dev/testing

-- Roles
INSERT INTO core.role (name) VALUES
  ('hospital_coder'), ('hospital_finance'), ('hospital_admin'),
  ('kkm_admin'), ('kkm_analyst')
ON CONFLICT DO NOTHING;

-- Admission type dimension
INSERT INTO wh.dim_admission_type (adm_type_key, admission_type) VALUES
  (1,'outpatient'), (2,'daycare'), (3,'inpatient')
ON CONFLICT DO NOTHING;

-- Example DRG master + weight
INSERT INTO ref.drg_master (drg_code, drg_version, title) VALUES
  ('DRG001','v1','Example DRG 001')
ON CONFLICT DO NOTHING;

INSERT INTO ref.drg_weight (drg_code, drg_version, severity, weight) VALUES
  ('DRG001','v1','A',0.9000),
  ('DRG001','v1','B',1.1000),
  ('DRG001','v1','C',1.3000)
ON CONFLICT DO NOTHING;

-- Example base rate (OPD)
INSERT INTO ref.base_rate (payer_type, facility_class, effective_from, rate)
VALUES ('KKM','OPD', CURRENT_DATE, 1200.00)
ON CONFLICT DO NOTHING;

-- A small date dimension seed (today)
INSERT INTO wh.dim_date (date_key, calendar_date, year, month, day)
VALUES (
  CAST(to_char(CURRENT_DATE,'YYYYMMDD') AS INTEGER),
  CURRENT_DATE,
  EXTRACT(YEAR FROM CURRENT_DATE)::INT,
  EXTRACT(MONTH FROM CURRENT_DATE)::INT,
  EXTRACT(DAY FROM CURRENT_DATE)::INT
)
ON CONFLICT DO NOTHING;
