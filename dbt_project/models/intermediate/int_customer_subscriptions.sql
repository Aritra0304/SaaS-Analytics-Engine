with customers as (select * from {{ ref('stg_telco_customers') }}),
plans     as (select * from {{ ref('stg_telco_plans') }}),
finance   as (select * from {{ ref('stg_telco_finance') }})

select
    c.customer_id,
    c.gender,
    c.is_senior,
    c.tenure_months,
    p.contract_type,
    p.internet_service,
    f.monthly_charges,
    f.total_charges,
    f.churn_status
from customers c
left join plans p    on c.customer_id = p.customer_id
left join finance f  on c.customer_id = f.customer_id