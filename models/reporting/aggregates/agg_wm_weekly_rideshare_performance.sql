select 
    c.yearWeek statement,
    up.contact_id,
    up.user_id,
    u.location user_location,
    u.name user_name,
    u.email user_email,
    SUM(online_minutes) online_minutes,
    ROUND(SUM(up.online_minutes/60),0) online_hours,
    SUM(up.trip_minutes) trip_minutes,
    SUM(up.working_minutes) working_minutes
    SUM(up.nr_trips) nr_trips,
    ROUND(SUM(up.acceptance_rate * up.nr_trips)/sum(up.nr_trips), 2) acceptance_rate,
    ROUND(SUM(up.cancellation_rate * up.nr_trips)/sum(up.nr_trips), 2) cancellation_rate,
    ROUND(SUM(up.rating * up.nr_trips)/sum(up.nr_trips), 2) rating,
    SUM(up.trip_distance) trip_distance,
    SUM(up.net_earnings) net_earnings
from {{ ref('fct_user_rideshare_performance') }} up
left join {{ ref('dim_users') }} u on up.user_id = u.user_id
left join {{ ref('util_calendar') }} c on c.date = up.date
group by statement, contact_id, user_id, location, name