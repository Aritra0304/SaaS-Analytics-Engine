SaaS Subscription & Churn Analytics Engine

🚀 Project Overview

This project implements a professional-grade Analytics Engineering pipeline designed to transform messy, flat-file subscription data into a highly structured, query-optimized Star Schema.

The goal is to move away from "spreadsheet-style" data management and build a scalable Data Warehouse that allows business stakeholders to track critical SaaS metrics like Monthly Recurring Revenue (MRR) and Customer Churn Rate with high confidence and data integrity.

🏗️ Architecture & Workflow

The project follows an ELT (Extract, Load, Transform) pattern, utilizing an internal Snowflake stage to avoid the overhead of external cloud storage (AWS/GCP).

graph TD
    subgraph "Local Environment (VSCode)"
        A[fa:fa-file-csv Local CSV Files] -->|Python Script| B(fa:fa-code Snowflake Connector)
    end

    subgraph "Snowflake Cloud Data Warehouse"
        B -->|PUT Command| C[fa:fa-cloud Internal Stage]
        C -->|COPY INTO| D[(fa:fa-database RAW Schema: Flat Table)]
        
        subgraph "dbt Transformation Engine"
            D --> E[fa:fa-filter Staging Layer: Cleaning/Casting]
            E --> F[fa:fa-layer-group Intermediate Layer: Joining]
            F --> G[fa:fa-star Marts Layer: Star Schema]
        end
        
        subgraph "Final Structured Data"
            G --> H[(fa:fa-user dim_customers)]
            G --> I[(fa:fa-calendar-alt dim_plans)]
            G --> J[(fa:fa-receipt fct_subscriptions)]
            G --> K[(fa:fa-chart-line fct_monthly_revenue)]
        end
    end

    subgraph "Business Value"
        H & I & J & K --> L{fa:fa-chart-pie BI Dashboard / Analytics}
    end

    %% Styling
    style A fill:#f9f,stroke:#333,stroke-width:2px
    style D fill:#ff9,stroke:#333,stroke-width:2px
    style G fill:#9f9,stroke:#333,stroke-width:2px
    style L fill:#9cf,stroke:#333,stroke-width:4px




🛠️ Tech Stack

Data Warehouse: Snowflake (Cloud Data Platform)
Transformation Tool: dbt Core (Analytics Engineering)
Orchestration/Ingestion: Python (Pandas & Snowflake Connector)
IDE: VSCode
Data Modeling: Star Schema (Dimensions & Facts)

📊 Data Modeling (Star Schema)

To ensure high performance and ease of use for BI tools, the data is modeled into a Star Schema within the ANALYTICS schema:

Dimensions

dim_customers: Contains unique customer demographics (Gender, Seniority, Tenure).
dim_plans: Contains subscription plan details (Contract type, Internet service, Security features).

Facts

fct_subscriptions: The central fact table linking customers to their plans, containing transaction-level metrics.
fct_monthly_revenue: A specialized aggregate fact table for time-series analysis of revenue.

📈 Business Intelligence: Key Metrics

The pipeline is engineered to answer the following mission-critical questions:

Monthly Recurring Revenue (MRR): What is our total predictable revenue per month?
Churn Rate: What percentage of our customer base is canceling their subscriptions?
ARPU (Average Revenue Per User): How much value are we extracting from each customer on average?
Cohort Analysis: How does user retention vary based on their original signup month?

🛡️ Data Quality & Integrity

To ensure "Single Source of Truth" reliability, the project implements a multi-layered testing strategy using dbt tests:

Uniqueness & Nullity: Ensures primary keys (e.g., customer_id) are never duplicated or missing.
Referential Integrity: Uses relationship tests to ensure every record in the Fact table has a corresponding entry in the Dimension tables.

Domain Validation: Uses accepted_values to ensure categorical data (e.g., contract_type) matches business definitions.

Custom Business Logic: Implements singular SQL tests to catch logical errors, such as Total_Charges being less than Monthly_Charges.

🚀 Getting Started

Prerequisites

Snowflake Account with ACCOUNTADMIN or appropriate warehouse permissions.
Python 3.x installed.
dbt-snowflake installed (pip install dbt-snowflake).
Installation & Execution

Clone the repository:
bash

Collapse
Copy
1
2
git clone https://github.com/your-username/saas_churn_project.git
cd saas_churn_project
Set up Environment Variables:
Create a .env file in the root directory and add your Snowflake credentials (refer to .env.example).
Ingest Raw Data:
bash

Collapse
Copy
1
python data_ingestion/ingest_kaggle.py
Run Transformations:
bash

Collapse
Copy
1
2
3
cd dbt_project
dbt run
dbt test
View Documentation:
bash

Collapse
Copy
1
2
dbt docs generate
dbt docs serve
Author: [Your Name]
Project Type: Analytics Engineering / Data Warehousing
