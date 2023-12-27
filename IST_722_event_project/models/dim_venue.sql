with stg_venue as (
    select * from {{ source('events_projectdb','venues')}}
)
select  
    {{ dbt_utils.generate_surrogate_key(['stg_venue.venue_id'])}} as venuekey,
    venue_id as venueid,
    venue_name as venuename,
    venue_capacity as venuecapacity,
    venue_street_address as venueaddress
from stg_venue