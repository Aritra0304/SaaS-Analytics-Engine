
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select customerID
from SAAS_DB.RAW.telco_data_raw
where customerID is null



  
  
      
    ) dbt_internal_test