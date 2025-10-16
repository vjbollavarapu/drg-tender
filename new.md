# Appendix 3 – Integration Flow Interpretation

```mermaid
flowchart LR
  %% Actors
  Hospital[Hospital HIS / Users]
  KKM[KKM HQ Users]
  DRG[(National DRG System\n(MyGovCloud@CFA))]
  SMRP[(SMRP – Patient Data Warehouse)]
  MyGDX[(MyGDX – Gov Data Exchange)]

  %% Secure channels
  Hospital -->|HTTPS / SFTP\nCase Submission| DRG
  KKM -->|HTTPS\nWeb Portal Access| DRG

  %% Internal system-to-system links
  DRG -->|Outbound Dataset Export\n(HTTPS / SFTP)| SMRP
  DRG <--> |Backend API Integration\n(HTTPS)| MyGDX

  %% Notes
  note over Hospital,DRG: End users interact only with the DRG System
  note over DRG,SMRP: One-way export of grouped/tariffed data
  note over DRG,MyGDX: Backend API exchange – no direct user access
