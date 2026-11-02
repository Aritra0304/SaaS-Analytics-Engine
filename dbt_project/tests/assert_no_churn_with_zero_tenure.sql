-- A customer cannot have churned in their very first month (tenure = 0).
-- tenure = 0 means they haven't completed a single billing cycle yet,
-- so a churn flag at that point is a data quality error.
-- Returns ZERO rows if data is clean; any rows = test FAILS.
select
    customer_id,
    tenure_months,
    churn_status
from {{ ref('int_customer_subscriptions') }}
where churn_status = 'Yes'
  and tenure_months = 0
