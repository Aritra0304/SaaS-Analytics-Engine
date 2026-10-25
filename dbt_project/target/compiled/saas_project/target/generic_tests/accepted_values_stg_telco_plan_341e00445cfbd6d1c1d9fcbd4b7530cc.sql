
    
    

with all_values as (

    select
        internet_service as value_field,
        count(*) as n_records

    from SAAS_DB.ANALYTICS_STAGING.stg_telco_plans
    group by internet_service

)

select *
from all_values
where value_field not in (
    'DSL','Fiber optic','No'
)


