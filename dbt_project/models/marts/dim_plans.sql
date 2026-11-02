select
    customer_id,
    contract_type,
    internet_service,
    online_security,
    streaming_tv
from {{ ref('stg_telco_plans') }}
