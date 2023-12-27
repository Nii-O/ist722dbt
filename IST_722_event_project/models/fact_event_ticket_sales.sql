with stg_tickets as 
(
    select ticket_event_id, count(ticket_id) as numofticketssold
    from {{source('events_projectdb','tickets')}}
    group by ticket_event_id
),

stg_events as (
    select {{ dbt_utils.generate_surrogate_key(['event_id']) }} as eventkey,
    * from {{source('events_projectdb','events')}}
),

stg_venues as (
    select {{ dbt_utils.generate_surrogate_key(['venue_id']) }} as venuekey,
    * from {{source('events_projectdb','venues')}}
)

select  
    e.eventkey, v.venuekey, t.numofticketssold
from stg_tickets t
    join stg_events e on e.event_id = t.ticket_event_id
    join stg_venues v on v.venue_id = e.event_venue_id