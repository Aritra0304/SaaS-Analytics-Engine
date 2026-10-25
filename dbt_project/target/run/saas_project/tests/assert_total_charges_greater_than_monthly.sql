
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  -- This test should return ZERO rows.
-- If it returns any rows, the test FAILS.
-- Fixed: monthly_amount / total_amount renamed to monthly_charges / total_charges
select
    customer_id,
    monthly_charges,
    total_charges
from SAAS_DB.ANALYTICS.int_customer_subscriptions
where total_charges < monthly_charges
  
  
      
    ) dbt_internal_test