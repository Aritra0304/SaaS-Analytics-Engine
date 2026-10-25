-- This checks that no customer has a negative tenure, which is logically impossible.
-- tenure = 0 is valid (new customers in their first month).
-- Returns ZERO rows if data is clean; any rows = test FAILS.
select
    customer_id,
    tenure_months,
    churn_status
from {{ ref('int_customer_subscriptions') }}
where tenure_months < 0