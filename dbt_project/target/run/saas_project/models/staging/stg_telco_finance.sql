
  create or replace   view SAAS_DB.ANALYTICS_STAGING.stg_telco_finance
  
  
  
  
  as (
    with source as (
    select * from SAAS_DB.RAW.telco_data_raw
)
select
    customerID                              as customer_id,
    MonthlyCharges                          as monthly_charges,
    -- TotalCharges is VARCHAR in the raw source (contains blank strings for new customers);
    -- TRY_CAST handles those gracefully by returning NULL instead of raising an error
    TRY_CAST(TotalCharges as FLOAT)         as total_charges,
    Churn                                   as churn_status
from source
  );

