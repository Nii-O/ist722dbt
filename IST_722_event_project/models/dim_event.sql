with stg_events as (
    select* from {{ source('events_projectdb','events')}}
)
select  
    {{ dbt_utils.generate_surrogate_key(['stg_events.event_id'])}} as eventkey,
    event_id as eventid,
    event_name as eventname,
    event_type as eventtype,
    event_date as eventdate,
    event_description as eventdescription
from stg_events