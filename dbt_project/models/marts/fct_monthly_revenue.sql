select
    customer_id,
    tenure_months,
    monthly_charges,
    total_charges,
    -- Derive estimated monthly revenue: for churned customers total_charges
    -- is the actual lifetime value; for active customers we use monthly_charges
    -- as the recurring revenue signal per customer per month.
    monthly_charges                                         as monthly_revenue,
    IFF(churn_status = 'Yes', total_charges, NULL)          as lifetime_revenue_at_churn
from {{ ref('int_customer_subscriptions') }}
