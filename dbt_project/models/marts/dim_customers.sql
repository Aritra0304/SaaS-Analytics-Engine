select
    customer_id,
    gender,
    is_senior
from {{ ref('int_customer_subscriptions') }}