SELECT
    year_month,
    ROUND(sum(amount_recovered),2) amount_recovered
FROM {{ ref('fct_user_financial_debt_collection') }}
GROUP BY year_month
ORDER BY year_month DESC