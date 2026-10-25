
    
    

with all_values as (

    select
        gender as value_field,
        count(*) as n_records

    from SAAS_DB.ANALYTICS_STAGING.stg_telco_customers
    group by gender

)

select *
from all_values
where value_field not in (
    'Female','Male'
)


