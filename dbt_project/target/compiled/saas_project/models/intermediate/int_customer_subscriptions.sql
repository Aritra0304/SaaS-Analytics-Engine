with customers as (select * from SAAS_DB.ANALYTICS_STAGING.stg_telco_customers),
plans     as (select * from SAAS_DB.ANALYTICS_STAGING.stg_telco_plans),
finance   as (select * from SAAS_DB.ANALYTICS_STAGING.stg_telco_finance),
billing   as (select * from SAAS_DB.ANALYTICS_STAGING.stg_telco_billing)

select
    -- ── Identity ─────────────────────────────────────────────────────────────
    c.customer_id,

    -- ── Customer demographics ─────────────────────────────────────────────────
    c.gender,
    c.is_senior,
    c.has_partner,
    c.has_dependents,
    c.tenure_months,

    -- ── Plan & service attributes ─────────────────────────────────────────────
    p.contract_type,
    p.internet_service,
    p.has_phone_service,
    p.has_multiple_lines,
    p.online_security,
    p.has_online_backup,
    p.has_device_protection,
    p.has_tech_support,
    p.streaming_tv,
    p.has_streaming_movies,

    -- ── Billing preferences ───────────────────────────────────────────────────
    b.has_paperless_billing,
    b.payment_method,

    -- ── Financials ────────────────────────────────────────────────────────────
    f.monthly_charges,
    f.total_charges,
    f.churn_status,

    -- ── Derived: add-on count (stickiness proxy) ──────────────────────────────
    -- Each TRUE boolean add-on flag counts as 1; sum = total number of active add-ons
    (
        IFF(p.has_phone_service,      1, 0) +
        IFF(p.has_multiple_lines,     1, 0) +
        IFF(p.has_online_backup,      1, 0) +
        IFF(p.has_device_protection,  1, 0) +
        IFF(p.has_tech_support,       1, 0) +
        IFF(p.streaming_tv = 'Yes',   1, 0) +
        IFF(p.has_streaming_movies,   1, 0)
    )                                                           as addon_count,

    -- ── Derived: normalised ARPU (revenue per month of tenure) ───────────────
    -- NULLIF prevents division-by-zero for brand-new customers (tenure = 0)
    DIV0(f.total_charges, c.tenure_months)                      as arpu_per_tenure_month,

    -- ── Derived: digital engagement flag ─────────────────────────────────────
    IFF(
        b.has_paperless_billing = TRUE
        AND b.payment_method IN (
            'Electronic check',
            'Credit card (automatic)',
            'Bank transfer (automatic)'
        ),
        TRUE, FALSE
    )                                                           as is_digital_native

from customers c
left join plans   p on c.customer_id = p.customer_id
left join finance f on c.customer_id = f.customer_id
left join billing b on c.customer_id = b.customer_id