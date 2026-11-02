-- dim_customer_profile: extended customer dimension that adds billing
-- preferences and household attributes for richer BI segmentation.

select
    customer_id,
    gender,
    is_senior,
    has_partner,
    has_dependents,
    tenure_months,
    payment_method,
    has_paperless_billing,
    is_digital_native,

    -- Household complexity flag: partner OR dependents present
    IFF(has_partner OR has_dependents, TRUE, FALSE)     as has_household,

    -- Tenure band for easier BI grouping
    CASE
        WHEN tenure_months BETWEEN 0  AND 12 THEN 'New'
        WHEN tenure_months BETWEEN 13 AND 24 THEN 'Developing'
        WHEN tenure_months BETWEEN 25 AND 48 THEN 'Established'
        ELSE                                      'Loyal'
    END                                               as customer_lifecycle_stage

from {{ ref('int_customer_subscriptions') }}
