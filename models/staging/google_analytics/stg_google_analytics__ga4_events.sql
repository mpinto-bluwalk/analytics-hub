{{ config(
    materialized='incremental',
    unique_key=['event_name', 'event_timestamp', 'user_pseudo_id'],
    partition_by={
        'field': 'event_date'
    }
) }}

SELECT
    *
FROM
    {{ ref('stg_google_analytics__ga4_events_t') }}
WHERE event_date BETWEEN '20220925' AND '20240604'

{% if is_incremental() %}
WHERE
    event_timestamp > (SELECT MAX(event_timestamp) FROM {{ this }})
{% endif %}