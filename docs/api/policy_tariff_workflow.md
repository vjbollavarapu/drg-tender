# Policy and Tariff Workflow (Stata and TreeAge)

```mermaid
flowchart LR
  subgraph Data["Analytics Data"]
    DWH[(ClickHouse)]
    Ref[Reference Tables]
  end

  subgraph Workbench["Analyst Workbench"]
    Stata[Stata]
    TreeAge[TreeAge]
  end

  AdminAPI[Admin Config API]
  Storage[S3 or Object Storage]
  DRGEngine[DRG Engine]
  TariffEngine[Tariff Engine]

  %% Data export to analysts
  DWH -->|export dataset| Workbench
  Ref -->|code sets| Workbench

  %% Modeling
  Stata -->|weights tables| Storage
  TreeAge -->|policy tables| Storage

  %% Import to system
  Storage -->|upload files| AdminAPI
  AdminAPI -->|validate and write| Ref

  %% Runtime use
  Ref --> DRGEngine
  Ref --> TariffEngine
