# Mapping Guide (HIS/SMRP → DRG Submission)

## Required fields (per episode)
- admission_type: "outpatient" | "daycare" | "inpatient"
- patient_hash: irreversible hash (no PII)
- icd_codes: array of ICD-10 codes (principal first)
- procedure_codes: array of valid procedure codes
- admission_dt, discharge_dt (ISO 8601)

## Validation rules (examples)
- day surgery requires at least one procedure code
- inpatient must have LOS >= 1 or discharge_dt > admission_dt
- codes must exist in ref.icd10 / ref.proc_code effective ranges
