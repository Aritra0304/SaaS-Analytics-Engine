with source as (
    select * from {{ source('raw', 'telco_data_raw') }}
)
select
    customerID                          as customer_id,
    Contract                            as contract_type,
    InternetService                     as internet_service,
    -- Missing aliases added to follow snake_case convention
    OnlineSecurity                      as online_security,
    StreamingTV                         as streaming_tv
from source