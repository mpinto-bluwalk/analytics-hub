SELECT
    a.year_month,
    agent_name,
    AVG(first_reply_time) first_reply_time,
    COUNT(*) nr_tickets
FROM {{ ref('util_calendar') }} a
LEFT JOIN {{ ref('fct_tickets') }} b ON a.date = CAST(b.create_date AS DATE)
WHERE agent_team = 'Customer Service'
GROUP BY year_month, agent_name
ORDER BY year_month DESC