-- A customer with monthly_charges > 0 must have at least one active service:
-- either a phone service or an internet service (not 'No').
-- A row with charges but no active service is a billing data anomaly.
-- Returns ZERO rows if data is clean; any rows = test FAILS.
select
    customer_id,
    monthly_charges,
    has_phone_service,
    internet_service
from {{ ref('int_customer_subscriptions') }}
where monthly_charges > 0
  and has_phone_service = FALSE
  and internet_service  = 'No'
