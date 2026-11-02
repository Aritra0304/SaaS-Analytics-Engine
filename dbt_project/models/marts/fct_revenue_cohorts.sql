-- fct_revenue_cohorts: aggregates MRR and customer counts by tenure cohort,
-- contract type, and churn status — enables cohort-level revenue analysis.

with base as (
    select
        customer_id,
        tenure_months,
        contract_type,
        internet_service,
        monthly_charges,
        total_charges,
        churn_status,

        -- Bucket customers into tenure cohorts
        CASE
            WHEN tenure_months BETWEEN 0  AND 12 THEN '0–12 months'
            WHEN tenure_months BETWEEN 13 AND 24 THEN '13–24 months'
            WHEN tenure_months BETWEEN 25 AND 48 THEN '25–48 months'
            ELSE                                      '48+ months'
        END                                     as tenure_cohort,

        -- Order key for sorting cohorts correctly in BI tools
        CASE
            WHEN tenure_months BETWEEN 0  AND 12 THEN 1
            WHEN tenure_months BETWEEN 13 AND 24 THEN 2
            WHEN tenure_months BETWEEN 25 AND 48 THEN 3
            ELSE                                      4
        END                                     as tenure_cohort_order

    from {{ ref('int_customer_subscriptions') }}
)

select
    tenure_cohort,
    tenure_cohort_order,
    contract_type,
    internet_service,
    churn_status,
    COUNT(customer_id)                          as customer_count,
    ROUND(SUM(monthly_charges), 2)              as total_mrr,
    ROUND(AVG(monthly_charges), 2)              as avg_monthly_charges,
    ROUND(SUM(total_charges), 2)                as total_lifetime_revenue,
    ROUND(AVG(total_charges), 2)                as avg_lifetime_revenue

from base
group by 1, 2, 3, 4, 5
order by tenure_cohort_order, contract_type, churn_status
