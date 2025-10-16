# Appendix 3 – Integration Flow Interpretation

```mermaid
flowchart LR
  %% Actors
  Hospital[Hospital HIS and Users]
  KKM[KKM HQ Users]
  DRG[(National DRG System MyGovCloud CFA)]
  SMRP[(SMRP Patient Data Warehouse)]
  MyGDX[(MyGDX Government Data Exchange)]

  %% Secure Channels
  Hospital -->|HTTPS or SFTP Case Submission| DRG
  KKM -->|HTTPS Web Portal Access| DRG

  %% Internal Links
  DRG -->|Outbound Dataset Export via HTTPS or SFTP| SMRP
  DRG <--> |Backend API Integration via HTTPS| MyGDX

  %% Notes
  note over Hospital,DRG: End users interact only with the DRG System
  note over DRG,SMRP: One way export of grouped or tariffed data
  note over DRG,MyGDX: Backend API exchange only no direct user access
