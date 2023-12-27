with stg_requests as (
    select request_venue_id,
    count(request_id) as numofapprovedrequests 
    from {{source('events_projectdb','requests')}}
    where request_status='approved'
    group by request_venue_id

),
stg_venue as (
    select {{ dbt_utils.generate_surrogate_key(['venue_id']) }} as venuekey,
    * 
    from {{source('events_projectdb','venues')}}
)
select v.venuekey, r.numofapprovedrequests 
from stg_requests r
    join stg_venue v on v.venue_id = r.request_venue_id