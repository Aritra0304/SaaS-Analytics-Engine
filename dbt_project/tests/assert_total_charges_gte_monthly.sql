-- For any customer with tenure > 1 month, their total_charges should be
-- at least equal to their monthly_charges (you can't pay less in total than
-- your most recent monthly bill).
-- Customers with tenure = 0 or 1 are excluded as total_charges may be NULL
-- or equal to monthly_charges by design (first partial billing period).
-- Returns ZERO rows if data is clean; any rows = test FAILS.
select
    customer_id,
    tenure_months,
    monthly_charges,
    total_charges
from {{ ref('int_customer_subscriptions') }}
where tenure_months > 1
  and total_charges is not null
  and total_charges < monthly_charges
