-- A query to calculate the number of churns per month from the user monthly churns fact table
SELECT 
    year_month, -- The month and year grouping for churn data
    partner_name,
    count(*) as nr_churns -- The total number of churns that occurred in each year_month
FROM {{ ref('int_retention_monthly_partner_churns_list') }} lcu -- Reference to the user monthly churns fact table in the DBT project
WHERE partner_marketplace = 'Service'
GROUP BY year_month, partner_name -- Grouping the data by year_month to aggregate churns
ORDER BY year_month DESC -- Ordering the results from the most recent month to the oldest