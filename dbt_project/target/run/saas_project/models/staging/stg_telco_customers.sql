
  create or replace   view SAAS_DB.ANALYTICS_STAGING.stg_telco_customers
  
  
  
  
  as (
    with source as (
    select * from SAAS_DB.RAW.telco_data_raw
)
select
    customerID                              as customer_id,
    gender,
    -- SeniorCitizen is stored as INT (0/1); cast to BOOLEAN for type safety
    IFF(SeniorCitizen = 1, TRUE, FALSE)     as is_senior,
    -- Partner / Dependents are stored as VARCHAR 'Yes'/'No'; cast to BOOLEAN
    IFF(Partner = 'Yes', TRUE, FALSE)       as has_partner,
    IFF(Dependents = 'Yes', TRUE, FALSE)    as has_dependents,
    tenure                                  as tenure_months
from source
  );

