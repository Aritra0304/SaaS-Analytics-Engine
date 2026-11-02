
  create or replace   view SAAS_DB.ANALYTICS_STAGING.stg_telco_plans
  
  
  
  
  as (
    with source as (
    select * from SAAS_DB.RAW.telco_data_raw
)
select
    customerID                                          as customer_id,
    Contract                                            as contract_type,
    InternetService                                     as internet_service,
    IFF(PhoneService   = 'Yes', TRUE, FALSE)            as has_phone_service,
    IFF(MultipleLines  = 'Yes', TRUE, FALSE)            as has_multiple_lines,
    OnlineSecurity                                      as online_security,
    IFF(OnlineBackup   = 'Yes', TRUE, FALSE)            as has_online_backup,
    IFF(DeviceProtection = 'Yes', TRUE, FALSE)          as has_device_protection,
    IFF(TechSupport    = 'Yes', TRUE, FALSE)            as has_tech_support,
    StreamingTV                                         as streaming_tv,
    IFF(StreamingMovies = 'Yes', TRUE, FALSE)           as has_streaming_movies
from source
  );

