-- fct_arpu: Average Revenue Per User aggregated by contract type and
-- internet service tier. Provides a high-level pricing health signal.

with base as (
    select
        contract_type,
        internet_service,
        churn_status,
        addon_count,
        monthly_charges,
        arpu_per_tenure_month,

        -- Add-on tier bucket for segmentation
        CASE
            WHEN addon_count = 0             THEN 'No add-ons'
            WHEN addon_count BETWEEN 1 AND 2 THEN 'Light add-ons'
            WHEN addon_count BETWEEN 3 AND 4 THEN 'Medium add-ons'
            ELSE                                  'Heavy add-ons'
        END                                     as addon_tier

    from {{ ref('int_customer_subscriptions') }}
)

select
    contract_type,
    internet_service,
    addon_tier,
    churn_status,
    COUNT(*)                                            as customer_count,
    ROUND(AVG(monthly_charges), 2)                     as avg_monthly_arpu,
    ROUND(MIN(monthly_charges), 2)                     as min_monthly_arpu,
    ROUND(MAX(monthly_charges), 2)                     as max_monthly_arpu,
    ROUND(AVG(arpu_per_tenure_month), 2)               as avg_arpu_per_tenure_month

from base
group by 1, 2, 3, 4
order by contract_type, internet_service, addon_tier
