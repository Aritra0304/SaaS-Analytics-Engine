select
    customer_id,
    contract_type,
    monthly_charges,
    churn_status
from {{ ref('int_customer_subscriptions') }}