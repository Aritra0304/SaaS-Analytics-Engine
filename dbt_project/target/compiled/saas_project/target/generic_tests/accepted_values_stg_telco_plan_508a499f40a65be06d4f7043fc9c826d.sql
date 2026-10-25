
    
    

with all_values as (

    select
        contract_type as value_field,
        count(*) as n_records

    from SAAS_DB.ANALYTICS_STAGING.stg_telco_plans
    group by contract_type

)

select *
from all_values
where value_field not in (
    'Month-to-month','One year','Two year'
)


