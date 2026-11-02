with source as (
    select * from {{ source('raw', 'telco_data_raw') }}
)
select
    customerID                                          as customer_id,
    IFF(PaperlessBilling = 'Yes', TRUE, FALSE)          as has_paperless_billing,
    PaymentMethod                                       as payment_method
from source
