flowchart TB

%% =======================
%% STYLES
%% =======================
classDef govt fill:#FF6B6B,color:#fff,stroke:#333,stroke-width:2px;
classDef casemix fill:#4ECDC4,color:#fff,stroke:#333,stroke-width:2px;
classDef qkprima fill:#1A73E8,color:#fff,stroke:#333,stroke-width:2px;
classDef radmik fill:#9B59B6,color:#fff,stroke:#333,stroke-width:2px;
classDef aws fill:#F39C12,color:#fff,stroke:#333,stroke-width:2px;

%% =======================
%% NODES
%% =======================

Govt["Government / KKM<br>Policy, Compliance, Acceptance"]
Casemix["Casemix<br>DRG Logic & Domain"]
QKPrima["QK Prima<br>Prime System Integrator"]
Radmik["Radmik<br>AWS MSP"]
AWS["AWS Cloud<br>Infrastructure Layer"]

%% =======================
%% APPLICATION LAYER
%% =======================

subgraph Application Layer
    DRG["DRG System<br>(Grouper, Costing, Output)"]
    AI["AI / Intelligence Layer"]
    Helpdesk["Helpdesk Module"]
end

%% =======================
%% INTEGRATION LAYER
%% =======================

subgraph Integration Layer
    Integration["System Integration<br>(Hospitals, MyGDX, Govt APIs)"]
    Migration["Data Migration<br>(MyCMX → DRG)"]
end

%% =======================
%% CLOUD LAYER
%% =======================

subgraph Cloud Layer
    Infra["Compute / Storage / DB"]
    Security["Security & Monitoring"]
    DR["Backup & Disaster Recovery"]
end

%% =======================
%% RELATIONSHIPS
%% =======================

Govt -->|Policy / Approval| QKPrima
Govt -->|Oversight| Casemix
Govt -->|Compliance| QKPrima

Casemix -->|DRG Logic| DRG
Casemix -->|Validation Rules| DRG

QKPrima -->|Owns Delivery| DRG
QKPrima -->|Owns Integration| Integration
QKPrima -->|Owns Migration| Migration
QKPrima -->|Owns Governance| AI
QKPrima -->|Owns Support (App)| Helpdesk

Radmik -->|Runs Infra| Infra
Radmik -->|Monitoring| Security
Radmik -->|DR/Backup| DR

AWS -->|Provides Platform| Infra
AWS -->|Cloud Services| Security

%% Cross-layer links
DRG --> Integration
Integration --> Infra
Migration --> Infra

%% =======================
%% CLASS ASSIGNMENT
%% =======================

class Govt govt;
class Casemix casemix;
class QKPrima qkprima;
class Radmik radmik;
class AWS aws;
