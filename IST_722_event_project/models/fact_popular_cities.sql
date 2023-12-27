with stg_tickets as 
(
    select ticket_event_id, count(ticket_id) as numofticketssold
    from {{source('events_projectdb','tickets')}}
    group by ticket_event_id
),

stg_cities as (
    select zipcode,
    {{ dbt_utils.generate_surrogate_key(['zipcode_city']) }} as citykey 
    from {{source('events_projectdb','zipcodes')}}
    group by citykey,zipcode
),

stg_events as (
    select {{ dbt_utils.generate_surrogate_key(['event_id']) }} as eventkey, 
    * from {{source('events_projectdb','events')}}
),

stg_ratings as (
    select {{ dbt_utils.generate_surrogate_key(['review_id']) }} as ratingkey,
    *
    from {{source('events_projectdb','reviews')}}
),

stg_venues as (
    select {{ dbt_utils.generate_surrogate_key(['venue_id']) }} as venuekey, 
    * from {{source('events_projectdb','venues')}}
)

SELECT c.citykey,e.eventkey,v.venuekey, AVG(r.review_rating) AS avg_rating
FROM stg_ratings r
JOIN stg_events e ON r.review_event_id = e.event_id
JOIN stg_venues v ON e.event_venue_id = v.venue_id
JOIN stg_cities c ON v.venue_zipcode = c.zipcode
GROUP BY c.citykey,e.eventkey,v.venuekey
ORDER BY avg_rating DESC
