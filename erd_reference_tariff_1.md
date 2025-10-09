```mermaid
erDiagram
  ICD10 { string code string title date effective_from date effective_to }
  PROC_CODE { string code string title date effective_from date effective_to }

  DRG_MASTER { string drg_code string drg_version string title }
  DRG_WEIGHT { string drg_code string drg_version string severity decimal weight }
  OUTLIER_POLICY { string policy_id string drg_version int los_lower int los_upper decimal cost_threshold_low decimal cost_threshold_high }

  BASE_RATE { string base_rate_id string payer_type string facility_class date effective_from date effective_to decimal rate }

  EPISODE_DIAGNOSIS { string episode_id string icd_code }
  EPISODE_PROCEDURE { string episode_id string proc_code }
  DRG_ASSIGNMENT { string episode_id string drg_code string drg_version }
  TARIFF_RESULT  { string episode_id string drg_code string base_rate_id }

  %% Relationships
  DRG_MASTER ||--o{ DRG_WEIGHT : has
  DRG_MASTER ||--o{ OUTLIER_POLICY : policy
  DRG_ASSIGNMENT }o--|| DRG_MASTER : references
  TARIFF_RESULT }o--|| BASE_RATE : applies
  EPISODE_DIAGNOSIS }o--|| ICD10 : uses
  EPISODE_PROCEDURE }o--|| PROC_CODE : uses
