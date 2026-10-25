
  
    



create or replace transient  table SAAS_DB.ANALYTICS_ANALYTICS.dim_customers
    
    
    
    
    as (select
    customer_id,
    gender,
    is_senior
from SAAS_DB.ANALYTICS.int_customer_subscriptions
    )
;



  