-- fct_churn_risk: scores each customer as High / Medium / Low churn risk
-- based on contract type, tenure, add-on stickiness, and internet service tier.
--
-- Scoring logic (additive, 0–6 points):
--   contract_type   : Month-to-month = +2 | One year = +1 | Two year = +0
--   tenure_months   : < 12            = +2 | 12–24    = +1 | > 24    = +0
--   addon_count     : 0               = +2 | 1–2      = +1 | >= 3   = +0
-- Risk band         : 5–6 = High | 3–4 = Medium | 0–2 = Low

with base as (
    select
        customer_id,
        contract_type,
        tenure_months,
        addon_count,
        internet_service,
        churn_status,

        -- contract risk score
        CASE contract_type
            WHEN 'Month-to-month' THEN 2
            WHEN 'One year'       THEN 1
            ELSE                       0
        END                                         as contract_risk_score,

        -- tenure risk score
        CASE
            WHEN tenure_months < 12              THEN 2
            WHEN tenure_months BETWEEN 12 AND 24 THEN 1
            ELSE                                      0
        END                                         as tenure_risk_score,

        -- stickiness risk score (fewer add-ons = more at risk)
        CASE
            WHEN addon_count = 0              THEN 2
            WHEN addon_count BETWEEN 1 AND 2  THEN 1
            ELSE                                   0
        END                                         as stickiness_risk_score

    from {{ ref('int_customer_subscriptions') }}
)

select
    customer_id,
    contract_type,
    tenure_months,
    addon_count,
    internet_service,
    churn_status,
    contract_risk_score,
    tenure_risk_score,
    stickiness_risk_score,
    (contract_risk_score + tenure_risk_score + stickiness_risk_score)   as total_risk_score,

    CASE
        WHEN (contract_risk_score + tenure_risk_score + stickiness_risk_score) >= 5 THEN 'High'
        WHEN (contract_risk_score + tenure_risk_score + stickiness_risk_score) >= 3 THEN 'Medium'
        ELSE                                                                              'Low'
    END                                                                 as churn_risk_band

from base
