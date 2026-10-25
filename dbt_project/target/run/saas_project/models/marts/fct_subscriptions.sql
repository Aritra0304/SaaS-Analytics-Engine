
  
    



create or replace transient  table SAAS_DB.ANALYTICS_ANALYTICS.fct_subscriptions
    
    
    
    
    as (select
    customer_id,
    contract_type,
    monthly_charges,
    churn_status
from SAAS_DB.ANALYTICS.int_customer_subscriptions
    )
;



  