with stg_requests as (
    select* from {{ source('events_projectdb','requests')}}
)
select  
    {{ dbt_utils.generate_surrogate_key(['stg_requests.request_id'])}} as requestkey,
    request_id as requestid,
    request_event_name as requesteventname,
    request_date as requestdate,
    request_number_of_days as requestdays,
    request_estimated_attendance as requestattendance,
    request_event_type as requesteventtype,
    request_description as requestdescription,
    request_status as requeststatus,
    request_made_by_id as requestmadebyid,
    request_submitted_to_id as requestsubmittedtoid,
    request_venue_id as requestvenueid
from stg_requests